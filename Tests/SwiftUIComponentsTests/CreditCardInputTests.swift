import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("CreditCardInput")
struct CreditCardInputTests {
    typealias CardType = CreditCardInput.CardType

    @Test("detects the network from the IIN prefix", arguments: [
        ("4111 1111 1111 1111", CardType.visa),
        ("5500 0000 0000 0004", .mastercard),
        ("2221 0000 0000 0009", .mastercard),
        ("2720 9999 9999 9996", .mastercard),
        ("3782 822463 10005", .amex),
        ("3400", .amex),
        ("6011 1111 1111 1117", .discover),
        ("6500", .discover),
        ("3056 9309 0259 04", .dinersClub),
        ("3000 0000 0000 04", .dinersClub),
        ("3045", .dinersClub),
        ("3600", .dinersClub),
        ("3800", .dinersClub),
        ("3900", .dinersClub),
        ("3060", .unknown),
        ("3100", .unknown),
        ("3530 1113 3330 0000", .jcb),
        ("2720", .mastercard),
        ("2721", .unknown),
        ("5600", .unknown),
        ("", .unknown),
    ])
    func detectsNetwork(number: String, expected: CardType) {
        #expect(CardType.detect(from: number) == expected)
    }

    @Test func groupsVisaDigitsInFours() {
        #expect(CreditCardInput.formatCardNumber("4111111111111111") == "4111 1111 1111 1111")
    }

    @Test func groupsAmexAsFourSixFive() {
        #expect(CreditCardInput.formatCardNumber("378282246310005") == "3782 822463 10005")
    }

    @Test func dropsDigitsBeyondNetworkLength() {
        #expect(CreditCardInput.formatCardNumber("41111111111111119999") == "4111 1111 1111 1111")
        #expect(CreditCardInput.formatCardNumber("3782822463100059") == "3782 822463 10005")
    }

    @Test func ignoresNonASCIIDigitsAndSymbols() {
        // Full-width digits and vulgar fractions satisfy Character.isNumber but are not card digits.
        #expect(CreditCardInput.formatCardNumber("4１1½1-1") == "4111")
    }

    @Test func formatsPartialInputWithoutTrailingSpace() {
        #expect(CreditCardInput.formatCardNumber("41111") == "4111 1")
        #expect(CreditCardInput.formatCardNumber("") == "")
    }

    @Test("Luhn checksum", arguments: [
        ("4111111111111111", true),
        ("378282246310005", true),
        ("6011111111111117", true),
        ("4111111111111112", false),
        ("", false),
        ("4111 1111 1111 1111", false),
        ("½", false),
    ])
    func luhn(number: String, expected: Bool) {
        #expect(CreditCardInput.isLuhnValid(number) == expected)
    }

    @Test func formatsExpiry() {
        #expect(CreditCardInput.formatExpiry("1") == "1")
        #expect(CreditCardInput.formatExpiry("12") == "12/")
        #expect(CreditCardInput.formatExpiry("1228") == "12/28")
        #expect(CreditCardInput.formatExpiry("12/289") == "12/28")
    }

    @Test func checksExpiryAgainstCurrentMonth() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        let now = try #require(calendar.date(from: DateComponents(year: 2026, month: 10, day: 14)))

        #expect(CreditCardInput.checkExpiry("10/26", now: now, calendar: calendar) == .valid)
        #expect(CreditCardInput.checkExpiry("01/27", now: now, calendar: calendar) == .valid)
        #expect(CreditCardInput.checkExpiry("09/26", now: now, calendar: calendar) == .expired)
        #expect(CreditCardInput.checkExpiry("12/25", now: now, calendar: calendar) == .expired)
        #expect(CreditCardInput.checkExpiry("13/27", now: now, calendar: calendar) == .invalidMonth)
        #expect(CreditCardInput.checkExpiry("00/27", now: now, calendar: calendar) == .invalidMonth)
        #expect(CreditCardInput.checkExpiry("1/2", now: now, calendar: calendar) == .incomplete)
    }

    @Test func networkLengths() {
        #expect(CardType.amex.numberLength == 15)
        #expect(CardType.amex.cvvLength == 4)
        #expect(CardType.dinersClub.numberLength == 14)
        #expect(CardType.visa.numberLength == 16)
        #expect(CardType.visa.cvvLength == 3)
    }
}
