import Foundation
import Testing
@testable import SwiftUIComponents

/// Each slow pattern below takes seconds to hours on its attack value without a time limit,
/// for example `(a|a)+` on 40 `a`s and a `!`. With the limit every check must end quickly.
@Suite("PatternMatcher", .timeLimit(.minutes(1)))
struct PatternMatcherTests {
    static let attack = String(repeating: "a", count: 40) + "!"

    /// Exponential patterns, including escape, class, quoting and option spellings of them.
    @Test("stops catastrophic backtracking and fails the value", arguments: [
        "(a+)+$", "(a|aa)*$", "(\\w+\\s?)*$", "(a|a)+", "(?:a|a)+", "([a]+)+$", "(\\x{61}+)+$",
        "(\\Qa\\E|a)+", "(?x) ( a | a ) + # comment\n", "(?i)(A|a)+", "(a|a\\Qx\\E?)+", "(?<n>a+)+",
    ])
    func stopsCatastrophicPatterns(pattern: String) {
        let (outcome, seconds) = timed { PatternMatcher.wholeMatch(pattern, in: Self.attack) }
        #expect(outcome == .timedOut)
        #expect(seconds < 1)
    }

    /// Polynomial patterns: each extra `\w*` multiplies the work by the input length.
    @Test func stopsPolynomialPatternsOnLongInput() {
        let input = String(repeating: "a", count: PatternMatcher.maximumInputLength)
        let (outcome, seconds) = timed { PatternMatcher.wholeMatch("\\w*\\w*\\w*\\w*z", in: input) }
        #expect(outcome == .timedOut)
        #expect(seconds < 1)
    }

    /// The limit counts UTF-16 code units, the unit the engine runs on, not characters: 250
    /// characters of `a` plus 40 combining accents are 10,250 code units.
    @Test func inputLimitCountsUTF16CodeUnits() {
        let accented = String(repeating: "a" + String(repeating: "\u{301}", count: 40), count: 250)
        #expect(accented.count == 250)
        let (outcome, seconds) = timed { PatternMatcher.wholeMatch("\\w*\\w*\\w*z", in: accented) }
        #expect(outcome == .inputTooLong)
        #expect(seconds < 0.1)

        let limit = PatternMatcher.maximumInputLength
        let emoji = String(repeating: "\u{1F44D}", count: limit / 2) // two code units each
        #expect(PatternMatcher.wholeMatch(".+", in: emoji) == .match)
        #expect(PatternMatcher.wholeMatch(".+", in: emoji + "\u{1F44D}") == .inputTooLong)
    }

    @Test func aPatternStoppedOnceFailsWithoutRunningAgain() {
        let pattern = "(b|b)+(?:once)?"
        let attack = String(repeating: "b", count: 40) + "!"
        #expect(PatternMatcher.wholeMatch(pattern, in: attack) == .timedOut)
        // "b" alone matches at once, so `.timedOut` shows the engine did not run.
        #expect(PatternMatcher.wholeMatch(pattern, in: "b") == .timedOut)
    }

    @Test func aPassedDeadlineStopsWithoutBlamingThePattern() {
        let pattern = "[0-9]+(?:deadline)?"
        #expect(PatternMatcher.wholeMatch(pattern, in: "123", deadline: .now) == .timedOut)
        #expect(PatternMatcher.wholeMatch(pattern, in: "123") == .match)
    }

    @Test("matches the whole text with the engine's own syntax", arguments: [
        ("[A-Z]{3}-[0-9]{3}", "ABC-123"), ("\\d{5}(-\\d{4})?", "12345-6789"), ("(cat|dog)+", "catdog"),
        ("(?i)[a-z0-9_]{3,16}", "Ada_99"), ("\\p{L}+", "Çağrı"), ("a|ab", "ab"), ("(ab)+", "abab"),
    ])
    func matchesCommonPatterns(pattern: String, text: String) {
        #expect(PatternMatcher.wholeMatch(pattern, in: text) == .match)
        #expect(PatternMatcher.wholeMatch(pattern, in: text + "#") == .noMatch)
    }

    /// The pattern must compile on its own, so it cannot close the `\A(?:…)\z` wrapper early.
    /// `\e{…}` is valid for Swift's `Regex` but not for the engine that runs it.
    @Test("rejects patterns the engine does not compile", arguments: [
        "a)|(b", "(", "[a", "a\\", "\\e{(a|a)+}", String(repeating: "a", count: 501),
        String(repeating: "\u{1F44D}", count: 251), // 251 characters, 502 code units
    ])
    func rejectsInvalidPatterns(pattern: String) {
        #expect(!PatternMatcher.isValid(pattern))
        #expect(PatternMatcher.wholeMatch(pattern, in: "a") == .invalidPattern)
    }

    @Test func validatorMatchesUsesTheSameLimits() {
        let validator = Validator<String>.matches("(a+)+$(?:validator)?", message: "Bad")
        let (result, seconds) = timed { validator.validate(Self.attack) }
        #expect(result.message == "Bad")
        #expect(seconds < 1)
    }

    private func timed<T>(_ work: () -> T) -> (T, Double) {
        let start = ContinuousClock.now
        let value = work()
        let elapsed = ContinuousClock.now - start
        return (value, Double(elapsed.components.seconds) + Double(elapsed.components.attoseconds) / 1e18)
    }
}

@Suite("FormSchema patterns and limits", .timeLimit(.minutes(1)))
struct FormSchemaPatternTests {
    @Test func checkRejectsInvalidPatterns() {
        let invalid = FormSchema(fields: [.init(id: "code", label: "Code", pattern: "(")])
        #expect(throws: FormSchema.SchemaError.invalidPattern("code")) { try invalid.check() }
    }

    /// The escape spelling that an earlier text screen let through: decoding through the public
    /// API must reject it, because the engine does not compile it.
    @Test func decodeRejectsPatternsTheEngineCannotRun() {
        let json = #"{"fields": [{"id": "code", "label": "Code", "pattern": "\\e{(a|a)+}"}]}"#
        #expect(throws: FormSchema.SchemaError.invalidPattern("code")) {
            try FormSchema.decode(from: Data(json.utf8))
        }
    }

    /// A slow pattern that compiles passes `check()`; the time limit bounds it when it runs.
    @Test func checkedSchemaWithASlowPatternStaysFast() throws {
        let json = #"{"fields": [{"id": "code", "label": "Code", "pattern": "(a+)+$(?:schema)?", "patternMessage": "Bad"}]}"#
        let schema = try FormSchema.decode(from: Data(json.utf8))
        let start = ContinuousClock.now
        #expect(schema.errors(in: ["code": .text(PatternMatcherTests.attack)]) == ["code": "Bad"])
        #expect(ContinuousClock.now - start < .seconds(1))
        #expect(schema.errors(in: ["code": .text("")]).isEmpty) // optional and empty
    }

    /// All patterns of one `errors(in:)` call share one budget, so many slow fields cannot add up.
    @Test func manySlowPatternsShareOneTimeBudget() throws {
        let fields = (0..<FormSchema.maximumPatternCount).map { index in
            FormSchema.Field(id: "f\(index)", label: "F", pattern: "(a|a)+(?:budget\(index))?")
        }
        let schema = FormSchema(fields: fields)
        try schema.check()
        let values = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, FormValue.text(PatternMatcherTests.attack)) })
        let start = ContinuousClock.now
        let errors = schema.errors(in: values)
        #expect(ContinuousClock.now - start < .milliseconds(500))
        #expect(errors.count == fields.count)
    }

    @Test func valuesLongerThanTheLimitFailThePattern() {
        let schema = FormSchema(fields: [.init(id: "digits", label: "Digits", pattern: "\\d+")])
        let atLimit = String(repeating: "1", count: PatternMatcher.maximumInputLength)
        #expect(schema.errors(in: ["digits": .text(atLimit)]).isEmpty)
        #expect(schema.errors(in: ["digits": .text(atLimit + "1")]) == ["digits": "Invalid format"])
    }

    @Test func checkEnforcesResourceLimits() {
        let tooMany = FormSchema(fields: (0...FormSchema.maximumFieldCount).map { .init(id: "f\($0)", label: "F") })
        #expect(throws: FormSchema.SchemaError.tooManyFields) { try tooMany.check() }

        let patterns = FormSchema(fields: (0...FormSchema.maximumPatternCount).map {
            .init(id: "f\($0)", label: "F", pattern: "[0-9]+")
        })
        #expect(throws: FormSchema.SchemaError.tooManyPatterns) { try patterns.check() }

        let options = (0...FormSchema.maximumOptionCount).map { "Option \($0)" }
        let choice = FormSchema(fields: [.init(id: "plan", label: "Plan", kind: .choice, options: options)])
        #expect(throws: FormSchema.SchemaError.tooManyOptions("plan")) { try choice.check() }
    }

    @Test func decodeRejectsOversizedJSON() {
        let padding = String(repeating: " ", count: FormSchema.maximumSchemaSize)
        let json = #"{"fields": []}"# + padding
        #expect(throws: FormSchema.SchemaError.schemaTooLarge) { try FormSchema.decode(from: Data(json.utf8)) }
    }
}
