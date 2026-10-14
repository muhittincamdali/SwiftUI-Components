import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("HighlightedText.matchRanges")
struct HighlightedTextTests {
    private func matched(_ text: String, _ terms: [String], caseSensitive: Bool = false) -> [String] {
        HighlightedText.matchRanges(in: text, terms: terms, caseSensitive: caseSensitive)
            .map { String(text[$0.range]) }
    }

    @Test func findsEveryOccurrence() {
        #expect(matched("swift is swift", ["swift"]) == ["swift", "swift"])
    }

    @Test func respectsCaseSensitivity() {
        #expect(matched("Swift swift", ["swift"]) == ["Swift", "swift"])
        #expect(matched("Swift swift", ["swift"], caseSensitive: true) == ["swift"])
    }

    @Test func ignoresEmptyTerms() {
        #expect(matched("abc", [""]).isEmpty)
    }

    @Test func overlappingMatchesKeepTheEarlierLongerOne() {
        // "SwiftUI" and "UI" overlap; only "SwiftUI" should be highlighted.
        #expect(matched("SwiftUI rocks", ["UI", "SwiftUI"]) == ["SwiftUI"])
    }

    @Test func reportsWhichTermMatched() {
        let result = HighlightedText.matchRanges(in: "red and blue", terms: ["blue", "red"], caseSensitive: false)
        #expect(result.map(\.termIndex) == [1, 0])
    }

    @Test func handlesCharactersThatChangeLengthWhenLowercased() {
        // "İ" lowercases to two scalars; ranges must still index the original string.
        #expect(matched("İstanbul city", ["city"]) == ["city"])
    }
}

@Suite("PhoneInput")
struct PhoneInputTests {
    @Test func appliesPattern() {
        #expect(PhoneInput.format("5551234567", pattern: "(###) ###-####") == "(555) 123-4567")
    }

    @Test func stopsAtLastDigit() {
        #expect(PhoneInput.format("555", pattern: "(###) ###-####") == "(555")
    }

    @Test func appendsDigitsBeyondPattern() {
        #expect(PhoneInput.format("12345", pattern: "##-#") == "12-345")
    }

    @Test func emptyPatternReturnsDigitsOnly() {
        #expect(PhoneInput.format("+90 (532) 000", pattern: "") == "90532000")
    }

    @Test("length check follows E.164 limits", arguments: [
        ("123456", false),
        ("1234567", true),
        ("+1 (555) 123-4567", true),
        ("123456789012345", true),
        ("1234567890123456", false),
    ])
    func validLength(number: String, expected: Bool) {
        #expect(PhoneInput.hasValidLength(number) == expected)
    }
}

@Suite("RatingInput.rating(atX:)")
struct RatingInputTests {
    @Test func fullPrecisionSelectsTouchedSymbol() {
        #expect(RatingInput.rating(atX: 1, symbolWidth: 30, maxRating: 5, precision: .full) == 1)
        #expect(RatingInput.rating(atX: 29, symbolWidth: 30, maxRating: 5, precision: .full) == 1)
        #expect(RatingInput.rating(atX: 31, symbolWidth: 30, maxRating: 5, precision: .full) == 2)
    }

    @Test func halfPrecisionRoundsUpToHalves() {
        #expect(RatingInput.rating(atX: 10, symbolWidth: 30, maxRating: 5, precision: .half) == 0.5)
        #expect(RatingInput.rating(atX: 20, symbolWidth: 30, maxRating: 5, precision: .half) == 1)
    }

    @Test func exactPrecisionIsLinear() {
        #expect(RatingInput.rating(atX: 15, symbolWidth: 30, maxRating: 5, precision: .exact) == 0.5)
    }

    @Test func clampsToRange() {
        #expect(RatingInput.rating(atX: -20, symbolWidth: 30, maxRating: 5, precision: .full) == 0)
        #expect(RatingInput.rating(atX: 500, symbolWidth: 30, maxRating: 5, precision: .full) == 5)
        #expect(RatingInput.rating(atX: 10, symbolWidth: 0, maxRating: 5, precision: .full) == 0)
    }
}

@Suite("Badge.countLabel")
struct BadgeTests {
    @Test func formatsCounts() {
        #expect(Badge.countLabel(0, maxCount: 99) == nil)
        #expect(Badge.countLabel(-3, maxCount: 99) == nil)
        #expect(Badge.countLabel(7, maxCount: 99) == "7")
        #expect(Badge.countLabel(99, maxCount: 99) == "99")
        #expect(Badge.countLabel(150, maxCount: 99) == "99+")
    }
}
