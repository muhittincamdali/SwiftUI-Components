import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("Validators")
struct ValidatorTests {
    @Test("required rejects empty and whitespace-only text", arguments: ["", " ", "\n\t "])
    func requiredRejectsBlank(text: String) {
        #expect(Validator<String>.required().validate(text) == .invalid("This field is required"))
    }

    @Test func requiredAcceptsText() {
        #expect(Validator<String>.required().validate(" a ").isValid)
    }

    @Test("email accepts common addresses", arguments: [
        "ada@example.com", "first.last+tag@sub.example.co.uk", "x@y.io", "",
    ])
    func emailAccepts(address: String) {
        #expect(Validator<String>.email().validate(address).isValid)
    }

    @Test("email rejects malformed addresses", arguments: [
        "ada", "ada@", "@example.com", "ada@example", "ada@@example.com", "ada @example.com",
        "ada@example..com", "ada@.com", "ada@example.com.",
    ])
    func emailRejects(address: String) {
        #expect(Validator<String>.email().validate(address) == .invalid("Enter a valid email address"))
    }

    @Test func urlNeedsHTTPSchemeAndHost() {
        let url = Validator<String>.url()
        #expect(url.validate("https://swift.org/documentation").isValid)
        #expect(url.validate("HTTP://example.com").isValid)
        #expect(url.validate("").isValid)
        #expect(!url.validate("swift.org").isValid)
        #expect(!url.validate("ftp://example.com").isValid)
        #expect(!url.validate("https://").isValid)
        #expect(!url.validate("mailto:ada@example.com").isValid)
    }

    @Test func phoneCountsDigitsAndAllowsSeparators() {
        let phone = Validator<String>.phone()
        #expect(phone.validate("+90 (532) 123-45.67").isValid)
        #expect(phone.validate("5551234").isValid)          // 7 digits
        #expect(phone.validate("123456789012345").isValid)  // 15 digits
        #expect(!phone.validate("555123").isValid)           // 6 digits
        #expect(!phone.validate("1234567890123456").isValid) // 16 digits
        #expect(!phone.validate("555-CALL-NOW").isValid)
        #expect(!phone.validate("++905321234567").isValid)
        #expect(!phone.validate("5551234+").isValid)
    }

    @Test func digitsOnlyAcceptsASCIIDigits() {
        let digits = Validator<String>.digits()
        #expect(digits.validate("0123456789").isValid)
        #expect(digits.validate("").isValid)
        #expect(!digits.validate("12a").isValid)
        #expect(!digits.validate("١٢٣").isValid) // Arabic-Indic digits are not 0–9
        #expect(!digits.validate("-1").isValid)
    }

    @Test func lengthLimitsCountCharactersNotBytes() {
        #expect(Validator<String>.minLength(3).validate("🇹🇷🇯🇵🇰🇷").isValid)
        #expect(Validator<String>.minLength(3).validate("ab") == .invalid("Use at least 3 characters"))
        #expect(Validator<String>.minLength(3).validate("").isValid)
        #expect(Validator<String>.maxLength(2).validate("abc") == .invalid("Use at most 2 characters"))
        #expect(Validator<String>.maxLength(2).validate("é😀").isValid)
    }

    @Test func matchesRequiresAWholeMatch() {
        let zip = Validator<String>.matches("[0-9]{5}", message: "Five digits")
        #expect(zip.validate("34000").isValid)
        #expect(zip.validate("340001") == .invalid("Five digits"))
        #expect(zip.validate("").isValid)
    }

    @Test func invalidPatternRejectsEveryNonEmptyValue() {
        let broken = Validator<String>.matches("([a-z]")
        #expect(!broken.validate("abc").isValid)
        #expect(broken.validate("").isValid)
    }

    @Test func equalsComparesExactly() {
        #expect(Validator<String>.equals("secret").validate("secret").isValid)
        #expect(Validator<String>.equals("secret").validate("Secret") == .invalid("The values don't match"))
    }

    @Test func comparableRanges() {
        #expect(Validator<Int>.range(18...120).validate(18).isValid)
        #expect(Validator<Int>.range(18...120).validate(121) == .invalid("Choose a value from 18 to 120"))
        #expect(Validator<Double>.atLeast(0.5).validate(0.49) == .invalid("Choose 0.5 or more"))
        #expect(Validator<Date>.atMost(.distantFuture).validate(.now).isValid)
    }

    @Test func collectionCounts() {
        #expect(Validator<Set<String>>.notEmpty().validate([]) == .invalid("Choose at least one option"))
        #expect(Validator<[Int]>.count(1...2).validate([1, 2]).isValid)
        #expect(Validator<[Int]>.count(1...2).validate([1, 2, 3]) == .invalid("Choose 1 to 2 options"))
    }

    @Test func andReportsTheFirstFailure() {
        let password: Validator<String> = .required().and(.minLength(8)).and(.matches(".*[0-9].*", message: "Add a digit"))
        #expect(password.validate("") == .invalid("This field is required"))
        #expect(password.validate("abc") == .invalid("Use at least 8 characters"))
        #expect(password.validate("abcdefgh") == .invalid("Add a digit"))
        #expect(password.validate("abcdefg1").isValid)
    }

    @Test func orPassesWhenEitherPasses() {
        let contact: Validator<String> = Validator.email().and(.required())
            .or(Validator.phone().and(.required()), message: "Enter an email or a phone number")
        #expect(contact.validate("ada@example.com").isValid)
        #expect(contact.validate("+1 555 123 4567").isValid)
        #expect(contact.validate("hello") == .invalid("Enter an email or a phone number"))
        #expect(Validator<String>.digits().or(.email()).validate("x") == .invalid("Use digits only"))
    }

    @Test func allOfNothingPasses() {
        #expect(Validator<String>.all([]).validate("anything").isValid)
        #expect(Validator<String>.all([.required(), .email()]).validate("") == .invalid("This field is required"))
    }
}

@Suite("ValidatedValue")
struct ValidatedValueTests {
    @Test func errorStaysHiddenUntilEditedOrValidated() {
        var field = ValidatedValue("", Validator<String>.required())
        #expect(!field.isValid)
        #expect(field.visibleError == nil)

        field.value = "a"
        #expect(field.isEdited)
        #expect(field.visibleError == nil)

        field.value = ""
        #expect(field.visibleError == "This field is required")
    }

    @Test func validateRevealsTheErrorAndReturnsValidity() {
        var field = ValidatedValue("", Validator<String>.email().and(.required()))
        let emptyIsValid = field.validate()
        #expect(emptyIsValid == false)
        #expect(field.isChecked)
        #expect(field.visibleError == "This field is required")

        field.value = "ada@example.com"
        let addressIsValid = field.validate()
        #expect(addressIsValid)
        #expect(field.visibleError == nil)
    }

    @Test func resetHidesTheErrorAgain() {
        var field = ValidatedValue("x", Validator<String>.minLength(3))
        field.value = "ab"
        field.validate()
        field.reset(to: "")
        #expect(field.value == "")
        #expect(!field.isEdited && !field.isChecked)
        #expect(field.visibleError == nil)
    }

    @Test func replacingTheValidatorChangesTheResult() {
        var confirm = ValidatedValue("hunter2", Validator<String>.equals("hunter1"))
        #expect(!confirm.isValid)
        confirm.validator = .equals("hunter2")
        #expect(confirm.isValid)
    }
}
