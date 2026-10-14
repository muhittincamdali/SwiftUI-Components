import Foundation

/// The one place where the package runs a regular expression. ``Validator/matches(_:message:)``
/// and every ``FormSchema`` pattern go through it.
///
/// A backtracking engine can need exponential time on patterns such as `(a|a)+` or `(a+)+$`,
/// and no scan of the pattern text can tell every such pattern apart from a harmless one. So
/// instead of judging the pattern, the matcher bounds the work of the engine that runs it:
///
/// - Patterns are compiled and run by the same engine, `NSRegularExpression` (ICU syntax), so
///   what is accepted is exactly what runs.
/// - Text longer than ``maximumInputLength`` UTF-16 code units, the unit the engine works in,
///   is not matched and fails.
/// - The engine reports progress while it backtracks, and the match is stopped once it runs
///   longer than ``timeLimit`` or past the caller's deadline. A stopped match fails.
/// - A pattern that was stopped once fails every later value without running again, so a slow
///   pattern costs at most one ``timeLimit`` per process.
/// - Compiled patterns are cached, so a pattern is compiled once, not on every check.
enum PatternMatcher {
    /// Patterns longer than this many UTF-16 code units are not compiled.
    static let maximumPatternLength = 500

    /// Text longer than this many UTF-16 code units is not matched; it fails the pattern.
    static let maximumInputLength = 1_000

    /// The longest a single match may run before it is stopped and fails.
    static let timeLimit: Duration = .milliseconds(20)

    /// The result of matching text against a pattern.
    enum Outcome: Equatable {
        /// The whole text matches.
        case match
        /// The engine finished and the whole text does not match.
        case noMatch
        /// The pattern is too long or does not compile.
        case invalidPattern
        /// The text is longer than ``maximumInputLength``.
        case inputTooLong
        /// The match ran past ``timeLimit`` or the deadline, now or on an earlier value.
        case timedOut
    }

    /// `true` when `pattern` is short enough and compiles.
    static func isValid(_ pattern: String) -> Bool {
        cache.entry(for: pattern).regex != nil
    }

    /// Whether the whole of `text` matches `pattern`, stopping at ``timeLimit`` or at
    /// `deadline`, whichever comes first. Once `deadline` has passed the result is
    /// ``Outcome/timedOut`` without compiling the pattern, even if it would not compile.
    static func wholeMatch(
        _ pattern: String,
        in text: String,
        deadline: ContinuousClock.Instant? = nil
    ) -> Outcome {
        let clock = ContinuousClock()
        // A spent budget must not pay for compiling the remaining fields' patterns.
        if let deadline, clock.now >= deadline { return .timedOut }
        let entry = cache.entry(for: pattern)
        guard let regex = entry.regex else { return .invalidPattern }
        guard !entry.hasTimedOut else { return .timedOut }
        let length = text.utf16.count
        guard length <= maximumInputLength else { return .inputTooLong }

        let ownDeadline = clock.now + timeLimit
        let stopAt = deadline.map { min($0, ownDeadline) } ?? ownDeadline
        guard clock.now < stopAt else { return .timedOut }

        var outcome = Outcome.noMatch
        let range = NSRange(location: 0, length: length)
        regex.enumerateMatches(in: text, options: [.reportProgress], range: range) { match, _, stop in
            if let match {
                // The pattern is wrapped in `\A(?:…)\z`; the range check keeps that true even if
                // the pattern text manages to change what the wrapper means.
                outcome = match.range == range ? .match : .noMatch
                stop.pointee = true
            } else if clock.now >= stopAt {
                outcome = .timedOut
                stop.pointee = true
            }
        }
        // A stop at the caller's shared deadline says nothing about this pattern.
        if outcome == .timedOut, clock.now >= ownDeadline { cache.markTimedOut(pattern) }
        return outcome
    }

    static let cache = Cache()

    /// Compiled patterns keyed by pattern text. `NSRegularExpression` is immutable and safe to
    /// share between threads; the lock guards the dictionary.
    final class Cache: @unchecked Sendable {
        struct Entry {
            var regex: NSRegularExpression?
            var hasTimedOut = false
        }

        /// When the cache holds this many patterns it is emptied before the next one is added.
        static let capacity = 256

        private let lock = NSLock()
        private var entries: [String: Entry] = [:]

        func entry(for pattern: String) -> Entry {
            if let entry = lock.withLock({ entries[pattern] }) { return entry }
            let entry = Entry(regex: Self.compile(pattern))
            lock.withLock {
                if entries.count >= Self.capacity { entries.removeAll() }
                entries[pattern] = entry
            }
            return entry
        }

        func markTimedOut(_ pattern: String) {
            lock.withLock { entries[pattern]?.hasTimedOut = true }
        }

        /// Compiles `pattern` so that it must match the whole text. The pattern must compile on
        /// its own too, so text such as `a)|(b` cannot pair up with the wrapper's parentheses.
        private static func compile(_ pattern: String) -> NSRegularExpression? {
            guard pattern.utf16.count <= maximumPatternLength,
                  (try? NSRegularExpression(pattern: pattern)) != nil
            else { return nil }
            return try? NSRegularExpression(pattern: "\\A(?:" + pattern + ")\\z")
        }
    }
}
