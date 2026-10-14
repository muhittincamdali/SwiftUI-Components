import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("Code entry")
struct CodeEntryTests {
    @Test func keepsEveryDigitOfAPastedCodeWithSeparators() {
        #expect(CodeEntry.sanitize("123-456", length: 6, allowing: .digits) == "123456")
        #expect(CodeEntry.sanitize("12 34 56 78", length: 6, allowing: .digits) == "123456")
    }

    /// `Character.isNumber` accepts these, but a server that expects 0–9 does not.
    @Test("drops digits and numerals from other scripts", arguments: ["١٢٣٤", "１２３４", "½", "Ⅷ", "²"])
    func dropsNonASCIIDigits(text: String) {
        #expect(CodeEntry.sanitize(text, length: 6, allowing: .digits) == "")
    }

    @Test func lettersAndDigitsDropEverythingElse() {
        #expect(CodeEntry.sanitize("ab-CD é 9🙂", length: 10, allowing: .lettersAndDigits) == "abCD9")
    }

    @Test("a zero or negative length still shows one cell", arguments: [0, -1, Int.min])
    func lengthIsAtLeastOne(length: Int) {
        #expect(CodeEntry.cellCount(length) == 1)
        #expect(CodeEntry.sanitize("987", length: length, allowing: .digits) == "9")
    }
}
