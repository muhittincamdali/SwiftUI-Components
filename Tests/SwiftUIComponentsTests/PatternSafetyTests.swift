import Foundation
import Testing
@testable import SwiftUIComponents

/// Every rejected pattern below was measured to freeze `Regex.wholeMatch` for seconds or longer
/// on a short adversarial value, for example `(a|a)+` on 24 `a`s and a `!`: about 5 seconds.
@Suite("PatternSafety", .timeLimit(.minutes(1)))
struct PatternSafetyTests {
    @Test("rejects repeated groups that can match the same text in several ways", arguments: [
        "(a+)+", "(a|a)+", "(a|aa)*b", "(\\w*)*", "(x{1,3})+", "((ab)+c)*", "(a+){2,8}",
        "(a?a?){5}", "(a+){30}", "(?:a|b)+", "(?<n>a+)+", "((a|a))+", "(a+)+?", "(a|a){,40}",
    ])
    func rejectsAmbiguousRepetition(pattern: String) {
        #expect(!PatternSafety.isSafe(pattern))
    }

    @Test("rejects long chains of open-ended repetitions and alternations", arguments: [
        "\\d+\\d+\\d+\\d+x",
        String(repeating: "(a|a)", count: 30) + "!",
        "a*b*c*d*e*",
        "[a-z]{1,200}[a-z]{1,200}[a-z]{1,200}",
    ])
    func rejectsCostlyChains(pattern: String) {
        #expect(!PatternSafety.isSafe(pattern))
    }

    /// Each of these hides `(a|a)+`-style repetition from a scan that only knows plain syntax.
    @Test("rejects syntax that could hide a repeated group", arguments: [
        "(a|a\\Q)\\E?)+",          // \Q…\E quoting
        "(?x)(a|a # (\n)+",         // the extended option's comments
        "(?#(a|a)+)",               // inline comments
        "(?ix)a",                   // x among other options
        "(a|a[[x])]?)+",            // nested character class closing the group early
        "a)", "(a", "[a", "a\\",   // unbalanced
        String(repeating: "a", count: 501),
    ])
    func rejectsUnmodelledSyntax(pattern: String) {
        #expect(!PatternSafety.isSafe(pattern))
    }

    @Test("accepts the patterns forms usually need", arguments: [
        "[A-Z]{3}-[0-9]{3}", "\\d{5}(-\\d{4})?", "^\\+?\\d{1,3}[- ]?\\(?\\d{3}\\)?[- ]?\\d{3}[- ]?\\d{4}$",
        "[a-z]+@[a-z]+\\.[a-z]{2,}", "(?i)[a-z0-9_]{3,16}", "(?<area>\\d{3})-\\d{4}", "(ab)+",
        "[[:alpha:]]+", "[a-z--[aeiou]]+", "\\p{L}+", "\\x{41}{2}", "(cat|dog)", "a{2}+", "\\{1,2}",
        "(?-i:abc)", "(?=\\d)\\w+", "(?!x)\\w",
    ])
    func acceptsCommonPatterns(pattern: String) throws {
        #expect(PatternSafety.isSafe(pattern))
        _ = try Regex(pattern) // and they really are valid
    }

    @Test func countsTooLargeForIntAreTreatedAsUnlimited() {
        // Neither may trap while computing the number of repetition choices.
        #expect(PatternSafety.isSafe("a{0,9223372036854775807}"))
        #expect(PatternSafety.isSafe("a{99999999999999999999}"))
        #expect(!PatternSafety.isSafe("(a|b){0,9223372036854775807}"))
    }

    @Test func estimateGrowsWithEachOpenEndedRepetition() throws {
        let one = PatternSafety.estimatedSteps(try #require(PatternSafety.Scanner(Array("\\d+x")).scan()))
        let three = PatternSafety.estimatedSteps(try #require(PatternSafety.Scanner(Array("\\d+\\d+\\d+x")).scan()))
        #expect(one == 257) // C(256 + 1, 1)
        #expect(three > 2_800_000 && three < PatternSafety.maximumEstimatedSteps)
    }
}

@Suite("FormSchema patterns", .timeLimit(.minutes(1)))
struct FormSchemaPatternTests {
    @Test func checkRejectsUnsafeAndInvalidPatterns() {
        let unsafe = FormSchema(fields: [.init(id: "code", label: "Code", pattern: "(a|a)+")])
        #expect(throws: FormSchema.SchemaError.unsafePattern("code")) { try unsafe.check() }

        let invalid = FormSchema(fields: [.init(id: "code", label: "Code", pattern: "(")])
        #expect(throws: FormSchema.SchemaError.invalidPattern("code")) { try invalid.check() }
    }

    /// `FormSchema` is `Codable`, so a schema can reach the form without `check()`. Its unsafe
    /// pattern must fail the value instead of running; running it would take minutes.
    @Test func uncheckedUnsafePatternFailsWithoutRunning() throws {
        let json = #"{"fields": [{"id": "code", "label": "Code", "pattern": "(a|a)+", "patternMessage": "Bad"}]}"#
        let schema = try JSONDecoder().decode(FormSchema.self, from: Data(json.utf8))
        let attack = String(repeating: "a", count: 40) + "!"

        #expect(schema.errors(in: ["code": .text(attack)]) == ["code": "Bad"])
        #expect(schema.errors(in: ["code": .text("")]).isEmpty) // optional and empty
    }

    @Test func valuesLongerThanTheLimitFailThePattern() {
        let schema = FormSchema(fields: [.init(id: "digits", label: "Digits", pattern: "\\d+")])
        let atLimit = String(repeating: "1", count: PatternSafety.maximumInputLength)
        #expect(schema.errors(in: ["digits": .text(atLimit)]).isEmpty)
        #expect(schema.errors(in: ["digits": .text(atLimit + "1")]) == ["digits": "Invalid format"])
    }
}
