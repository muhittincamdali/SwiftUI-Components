import Foundation

/// Screens regular expressions that come from outside the app, such as the `pattern` of a
/// ``FormSchema`` field, for shapes that make a backtracking engine run for seconds or forever.
///
/// Swift's `Regex` backtracks and cannot be interrupted, so a pattern like `(a|a)+` checked
/// against `"aaaa…!"` tries every way of matching the `a`s before it fails and freezes the app.
/// ``isSafe(_:)`` rejects:
///
/// - a group that can repeat and can match the same text in more than one way, because it
///   contains a variable repetition (`a+`, `a?`, `a{1,3}`) or an alternation (`a|b`):
///   `(a+)+`, `(a|a)+`, `(a?a?){5}`. These take exponential time.
/// - patterns whose worst case on a ``maximumInputLength``-character value is estimated above
///   ``maximumEstimatedSteps``, such as `\d+\d+\d+\d+x` or thirty `(a|a)` groups in a row.
///   These take polynomial or exponential time in the number of repetitions.
/// - syntax the screen does not model: `\Q…\E` quoting, `(?#…)` comments, the `x` (extended)
///   option, conditionals, recursion, unbalanced groups and unterminated character classes.
///
/// It does not try to prove that a pattern is fast, so some harmless patterns such as
/// `(cat|dog)+` or `([a-z]+\.)+com` are rejected too.
enum PatternSafety {
    /// Patterns longer than this are rejected outright.
    static let maximumPatternLength = 500

    /// Text longer than this is not matched against a schema pattern; the field reports the
    /// pattern's message instead. The step estimate assumes values of at most this length.
    static let maximumInputLength = 256

    /// The most backtracking steps a pattern may need, by ``estimatedSteps(_:)``, on a value of
    /// ``maximumInputLength`` characters. About a tenth of a second on a current iPhone or Mac.
    static let maximumEstimatedSteps = 5_000_000.0

    /// `true` when `pattern` passes every rule in the type description.
    static func isSafe(_ pattern: String) -> Bool {
        guard pattern.count <= maximumPatternLength,
              let shape = Scanner(Array(pattern)).scan()
        else { return false }
        return estimatedSteps(shape) <= maximumEstimatedSteps
    }

    /// The repetitions and alternations of a pattern that passed the scan.
    struct Shape: Equatable {
        /// One entry per quantifier: the number of repetition counts it allows, or `nil` when it
        /// has no upper limit (`*`, `+`, `{2,}`).
        var quantifierChoices: [Int?] = []
        /// One entry per group, and one for the whole pattern, that contains `|`: its branch count.
        var alternationBranches: [Int] = []
    }

    /// An upper estimate of the steps a failing match takes on a ``maximumInputLength``-character
    /// value: the ways to split the value between the `w` unlimited repetitions,
    /// C(n + w, w), times the choices of every limited repetition and alternation.
    static func estimatedSteps(_ shape: Shape) -> Double {
        let length = Double(maximumInputLength)
        var steps = 1.0
        var unlimited = 0.0
        for choices in shape.quantifierChoices {
            if let choices {
                steps *= Double(min(choices, maximumInputLength + 1))
            } else {
                unlimited += 1
                steps *= (length + unlimited) / unlimited
            }
            if steps > maximumEstimatedSteps { return steps }
        }
        for branches in shape.alternationBranches {
            steps *= Double(branches)
            if steps > maximumEstimatedSteps { return steps }
        }
        return steps
    }
}

// MARK: - Scanner

extension PatternSafety {
    struct Quantifier: Equatable {
        var minimum: Int
        /// `nil` when unlimited.
        var maximum: Int?
        /// The index of the quantifier's last character, including a lazy or possessive suffix.
        var end: Int

        /// More than one repetition count is allowed, so the repeated part can match text of
        /// different lengths.
        var isVariable: Bool { maximum != minimum }

        /// The number of repetition counts allowed, or `nil` when unlimited. Both bounds are at
        /// least zero, so the subtraction cannot overflow; the addition saturates.
        var choices: Int? {
            guard let maximum else { return nil }
            let extra = max(maximum - minimum, 0)
            return extra == .max ? .max : extra + 1
        }
    }

    /// A single left-to-right pass over a pattern.
    struct Scanner {
        let characters: [Character]

        init(_ characters: [Character]) {
            self.characters = characters
        }

        private struct OpenGroup {
            /// The group can match the same text in more than one way.
            var isAmbiguous = false
            var branches = 1
        }

        /// The pattern's shape, or `nil` when it is rejected.
        func scan() -> Shape? {
            var shape = Shape()
            // The whole pattern acts as an outer group that is never repeated.
            var groups = [OpenGroup()]
            // Set right after `)`: whether the group that just closed is ambiguous.
            var closedGroupIsAmbiguous = false
            var index = 0

            while index < characters.count {
                var justClosedAmbiguous = false
                switch characters[index] {
                case "\\":
                    guard let end = endOfEscape(from: index) else { return nil }
                    index = end
                case "[":
                    guard let end = endOfCharacterClass(from: index) else { return nil }
                    index = end
                case "(":
                    guard let end = endOfGroupOpening(from: index) else { return nil }
                    groups.append(OpenGroup())
                    index = end
                case ")":
                    guard groups.count > 1, let group = groups.popLast() else { return nil }
                    if group.branches > 1 { shape.alternationBranches.append(group.branches) }
                    justClosedAmbiguous = group.isAmbiguous
                case "|":
                    groups[groups.count - 1].branches += 1
                    for group in groups.indices { groups[group].isAmbiguous = true }
                case "*", "+", "?", "{":
                    guard let quantifier = quantifier(at: index) else { break } // a literal `{`
                    let repeatsMoreThanOnce = quantifier.maximum.map { $0 > 1 } ?? true
                    if repeatsMoreThanOnce, closedGroupIsAmbiguous { return nil }
                    if quantifier.isVariable {
                        for group in groups.indices { groups[group].isAmbiguous = true }
                    }
                    shape.quantifierChoices.append(quantifier.choices)
                    index = quantifier.end
                default:
                    break
                }
                closedGroupIsAmbiguous = justClosedAmbiguous
                index += 1
            }
            guard groups.count == 1 else { return nil }
            if groups[0].branches > 1 { shape.alternationBranches.append(groups[0].branches) }
            return shape
        }

        /// The index of an escape's last character. `\x{41}`, `\p{L}` and similar braces belong
        /// to the escape. `nil` for `\Q`, whose quoting would hide syntax from the scan.
        private func endOfEscape(from start: Int) -> Int? {
            let letter = start + 1
            guard letter < characters.count, characters[letter] != "Q" else { return nil }
            let takesBraces = "xpPuNgkoe".contains(characters[letter])
            if takesBraces, letter + 1 < characters.count, characters[letter + 1] == "{" {
                return characters[(letter + 1)...].firstIndex(of: "}")
            }
            return letter
        }

        /// The index of the `]` that closes the class opened at `start`, following nested
        /// classes such as `[a-z--[aeiou]]` and POSIX names such as `[[:digit:]]`.
        private func endOfCharacterClass(from start: Int) -> Int? {
            var depth = 0
            var index = start
            while index < characters.count {
                switch characters[index] {
                case "\\":
                    guard let end = endOfEscape(from: index) else { return nil }
                    index = end
                case "[":
                    if depth > 0, index + 1 < characters.count, characters[index + 1] == ":" {
                        guard let close = posixNameEnd(from: index + 2) else { return nil }
                        index = close
                    } else {
                        depth += 1
                    }
                case "]":
                    depth -= 1
                    if depth == 0 { return index }
                default:
                    break
                }
                index += 1
            }
            return nil
        }

        /// The index of the `]` in the `:]` that ends a POSIX class name.
        private func posixNameEnd(from start: Int) -> Int? {
            var index = start
            while index + 1 < characters.count {
                if characters[index] == ":", characters[index + 1] == "]" { return index + 1 }
                index += 1
            }
            return nil
        }

        /// The index of the last character of a group's opening, such as `(`, `(?:`, `(?<=` or
        /// `(?<name>`. `nil` for syntax the scan does not model.
        private func endOfGroupOpening(from start: Int) -> Int? {
            let next = start + 1
            guard next < characters.count, characters[next] == "?" else { return start }
            let kind = next + 1
            guard kind < characters.count else { return nil }
            switch characters[kind] {
            case ":", "=", "!", ">":
                return kind
            case "<":
                guard kind + 1 < characters.count else { return nil }
                if "=!".contains(characters[kind + 1]) { return kind + 1 }
                return characters[kind...].firstIndex(of: ">")
            case "P":
                guard kind + 1 < characters.count, characters[kind + 1] == "<" else { return nil }
                return characters[kind...].firstIndex(of: ">")
            case "'":
                return characters[(kind + 1)...].firstIndex(of: "'")
            default:
                return endOfOptions(from: kind)
            }
        }

        /// Option groups such as `(?i)` and `(?-i:…)`. Returns the index before the closing `)`
        /// of `(?i)`, so the scan opens and closes an empty group, or the index of the `:`.
        /// `nil` for the `x` option, which turns spaces and `#` into comments.
        private func endOfOptions(from start: Int) -> Int? {
            var index = start
            while index < characters.count {
                let character = characters[index]
                switch character {
                case ")": return index == start ? nil : index - 1
                case ":": return index
                case "x": return nil
                case "-", "^": break
                default:
                    guard character.isASCII, character.isLetter else { return nil }
                }
                index += 1
            }
            return nil
        }

        /// The quantifier starting at `index`, or `nil` when a `{` is a literal brace.
        func quantifier(at index: Int) -> Quantifier? {
            var result: Quantifier
            switch characters[index] {
            case "*": result = Quantifier(minimum: 0, maximum: nil, end: index)
            case "+": result = Quantifier(minimum: 1, maximum: nil, end: index)
            case "?": result = Quantifier(minimum: 0, maximum: 1, end: index)
            default:
                guard let close = characters[index...].firstIndex(of: "}") else { return nil }
                // `Regex` allows spaces, as in `{1, 3}`, and a missing minimum, as in `{,3}`.
                let body = characters[(index + 1)..<close].filter { $0 != " " }
                let parts = body.split(separator: ",", omittingEmptySubsequences: false)
                guard (1...2).contains(parts.count),
                      parts.allSatisfy({ $0.allSatisfy { $0.isASCII && $0.isNumber } }),
                      !parts.allSatisfy(\.isEmpty)
                else { return nil }
                // A count too large for `Int` is treated as having no limit.
                let numbers = parts.map { Int(String($0)) }
                let minimum = numbers[0] ?? 0
                let maximum = parts.count == 1 ? numbers[0] : numbers[1]
                result = Quantifier(minimum: minimum, maximum: maximum, end: close)
            }
            if result.end + 1 < characters.count, "?+".contains(characters[result.end + 1]) {
                result.end += 1
            }
            return result
        }
    }
}
