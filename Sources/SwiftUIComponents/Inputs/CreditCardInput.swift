import SwiftUI

/// A comprehensive credit card input with validation and card type detection.
///
/// `CreditCardInput` provides real-time formatting, card type detection,
/// and field validation for payment forms.
///
/// ```swift
/// CreditCardInput(
///     cardNumber: $cardNumber,
///     expiryDate: $expiry,
///     cvv: $cvv,
///     cardholderName: $name
/// )
/// ```
public struct CreditCardInput: View {
    // MARK: - Types

    /// Detected card type based on number prefix.
    public enum CardType: String, CaseIterable, Sendable {
        case visa
        case mastercard
        case amex
        case discover
        case dinersClub
        case jcb
        case unknown

        var icon: String {
            switch self {
            case .visa: return "💳" // Would use actual brand logos
            case .mastercard: return "💳"
            case .amex: return "💳"
            case .discover: return "💳"
            case .dinersClub: return "💳"
            case .jcb: return "💳"
            case .unknown: return "💳"
            }
        }

        /// Number of security-code digits for this network.
        public var cvvLength: Int {
            switch self {
            case .amex: return 4
            default: return 3
            }
        }

        /// Number of card-number digits for this network.
        public var numberLength: Int {
            switch self {
            case .amex: return 15
            case .dinersClub: return 14
            default: return 16
            }
        }

        /// Digit group sizes used when formatting a number of this type.
        var groupSizes: [Int] {
            switch self {
            case .amex: return [4, 6, 5]
            case .dinersClub: return [4, 6, 4]
            default: return [4, 4, 4, 4]
            }
        }

        /// Detects the card network from the leading digits (IIN range) of `number`.
        public static func detect(from number: String) -> CardType {
            let digits = CreditCardInput.digits(in: number)

            if digits.hasPrefix("4") {
                return .visa
            }
            if digits.hasPrefix("34") || digits.hasPrefix("37") {
                return .amex
            }
            if digits.hasPrefix("6011") || digits.hasPrefix("65") {
                return .discover
            }
            if ["36", "38", "39"].contains(where: digits.hasPrefix)
                || ["300", "301", "302", "303", "304", "305"].contains(where: digits.hasPrefix) {
                return .dinersClub
            }
            if digits.hasPrefix("35") {
                return .jcb
            }
            if let twoDigits = Int(digits.prefix(2)), digits.count >= 2, (51...55).contains(twoDigits) {
                return .mastercard
            }
            if let fourDigits = Int(digits.prefix(4)), digits.count >= 4, (2221...2720).contains(fourDigits) {
                return .mastercard
            }
            return .unknown
        }
    }

    /// Result of checking an expiry date in `MM/YY` form.
    public enum ExpiryCheck: Equatable, Sendable {
        /// Fewer than four digits entered.
        case incomplete
        /// Month is outside 1...12.
        case invalidMonth
        /// The card expired before the current month.
        case expired
        case valid
    }

    /// Validation state for a field.
    public enum ValidationState {
        case idle
        case valid
        case invalid(String)
    }

    // MARK: - Properties

    @Binding private var cardNumber: String
    @Binding private var expiryDate: String
    @Binding private var cvv: String
    @Binding private var cardholderName: String

    private let showCardPreview: Bool
    private let accentColor: Color
    private let errorColor: Color
    private let onValidationChange: ((Bool) -> Void)?

    @State private var cardType: CardType = .unknown
    @State private var numberValidation: ValidationState = .idle
    @State private var expiryValidation: ValidationState = .idle
    @State private var cvvValidation: ValidationState = .idle
    @State private var nameValidation: ValidationState = .idle

    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case number, expiry, cvv, name
    }

    // MARK: - Initialization

    /// Creates a new credit card input.
    public init(
        cardNumber: Binding<String>,
        expiryDate: Binding<String>,
        cvv: Binding<String>,
        cardholderName: Binding<String>,
        showCardPreview: Bool = true,
        accentColor: Color = .blue,
        errorColor: Color = .red,
        onValidationChange: ((Bool) -> Void)? = nil
    ) {
        self._cardNumber = cardNumber
        self._expiryDate = expiryDate
        self._cvv = cvv
        self._cardholderName = cardholderName
        self.showCardPreview = showCardPreview
        self.accentColor = accentColor
        self.errorColor = errorColor
        self.onValidationChange = onValidationChange
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 20) {
            if showCardPreview {
                cardPreviewView
            }

            VStack(spacing: 16) {
                // Card number
                cardNumberField

                // Expiry and CVV row
                HStack(spacing: 12) {
                    expiryField
                    cvvField
                }

                // Cardholder name
                cardholderField
            }
        }
        .onChange(of: cardNumber) { _, _ in validateAll() }
        .onChange(of: expiryDate) { _, _ in validateAll() }
        .onChange(of: cvv) { _, _ in validateAll() }
        .onChange(of: cardholderName) { _, _ in validateAll() }
    }

    // MARK: - Card Preview

    private var cardPreviewView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(cardType.icon)
                        .font(.largeTitle)
                    Spacer()
                    Text(cardType.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                Text(formatDisplayNumber(cardNumber))
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CARDHOLDER")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                        Text(cardholderName.isEmpty ? "YOUR NAME" : cardholderName.uppercased())
                            .font(.caption)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("EXPIRES")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                        Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(20)
        }
        .frame(height: 200)
        .aspectRatio(1.586, contentMode: .fit)
    }

    // MARK: - Card Number Field

    private var cardNumberField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Card Number")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                TextField("1234 5678 9012 3456", text: $cardNumber)
                    .keyboard(.number)
                    .focused($focusedField, equals: .number)
                    .onChange(of: cardNumber) { _, newValue in
                        cardType = CardType.detect(from: newValue)
                        cardNumber = Self.formatCardNumber(newValue)
                    }

                Text(cardType.icon)
                    .font(.title2)
            }
            .padding()
            .background(Color.platformGray6)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(fieldBorder(for: .number, validation: numberValidation))

            if case .invalid(let message) = numberValidation {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(errorColor)
            }
        }
    }

    // MARK: - Expiry Field

    private var expiryField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Expiry Date")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("MM/YY", text: $expiryDate)
                .keyboard(.number)
                .focused($focusedField, equals: .expiry)
                .onChange(of: expiryDate) { _, newValue in
                    expiryDate = Self.formatExpiry(newValue)
                }
                .padding()
                .background(Color.platformGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(fieldBorder(for: .expiry, validation: expiryValidation))

            if case .invalid(let message) = expiryValidation {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(errorColor)
            }
        }
    }

    // MARK: - CVV Field

    private var cvvField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("CVV")
                .font(.caption)
                .foregroundStyle(.secondary)

            SecureField("123", text: $cvv)
                .keyboard(.number)
                .focused($focusedField, equals: .cvv)
                .onChange(of: cvv) { _, newValue in
                    cvv = String(Self.digits(in: newValue).prefix(cardType.cvvLength))
                }
                .padding()
                .background(Color.platformGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(fieldBorder(for: .cvv, validation: cvvValidation))

            if case .invalid(let message) = cvvValidation {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(errorColor)
            }
        }
    }

    // MARK: - Cardholder Field

    private var cardholderField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Cardholder Name")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("Name on card", text: $cardholderName)
                .textContentType(.name)
                .wordCapitalization()
                .focused($focusedField, equals: .name)
                .padding()
                .background(Color.platformGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(fieldBorder(for: .name, validation: nameValidation))

            if case .invalid(let message) = nameValidation {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(errorColor)
            }
        }
    }

    // MARK: - Field Border

    private func fieldBorder(for field: Field, validation: ValidationState) -> some View {
        let color: Color = {
            if focusedField == field {
                return accentColor
            }
            switch validation {
            case .valid: return .green
            case .invalid: return errorColor
            case .idle: return .clear
            }
        }()

        return RoundedRectangle(cornerRadius: 12)
            .stroke(color, lineWidth: focusedField == field ? 2 : 1)
    }

    // MARK: - Formatting

    /// Keeps only ASCII digits, so full-width or other Unicode numerals are ignored.
    nonisolated static func digits(in text: String) -> String {
        String(text.unicodeScalars.filter { ("0"..."9").contains($0) })
    }

    /// Groups the digits of `number` the way the detected network prints them
    /// (4-4-4-4, Amex 4-6-5, Diners 4-6-4) and drops digits beyond the network's length.
    public nonisolated static func formatCardNumber(_ number: String) -> String {
        let type = CardType.detect(from: number)
        var remaining = Substring(digits(in: number).prefix(type.numberLength))
        var groups: [Substring] = []

        for size in type.groupSizes where !remaining.isEmpty {
            groups.append(remaining.prefix(size))
            remaining = remaining.dropFirst(size)
        }
        return groups.joined(separator: " ")
    }

    /// Formats up to four digits as `MM/YY`.
    public nonisolated static func formatExpiry(_ expiry: String) -> String {
        let digits = digits(in: expiry)

        if digits.count >= 2 {
            return String(digits.prefix(2)) + "/" + String(digits.dropFirst(2).prefix(2))
        }
        return digits
    }

    private func formatDisplayNumber(_ number: String) -> String {
        let formatted = Self.formatCardNumber(number)
        let padding = String(repeating: "•", count: max(0, 19 - formatted.count))
        return formatted + padding
    }

    // MARK: - Validation

    /// Checks an `MM/YY` expiry against the month containing `now`.
    public nonisolated static func checkExpiry(
        _ expiry: String,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> ExpiryCheck {
        let digits = digits(in: expiry)
        guard digits.count == 4,
              let month = Int(digits.prefix(2)),
              let year = Int(digits.suffix(2)) else {
            return .incomplete
        }
        guard (1...12).contains(month) else {
            return .invalidMonth
        }

        let currentYear = calendar.component(.year, from: now) % 100
        let currentMonth = calendar.component(.month, from: now)
        if year > currentYear || (year == currentYear && month >= currentMonth) {
            return .valid
        }
        return .expired
    }

    /// Luhn (mod 10) checksum. Returns `false` for empty input or any non-digit character.
    public nonisolated static func isLuhnValid(_ number: String) -> Bool {
        let values = number.compactMap { $0.isASCII ? $0.wholeNumberValue : nil }
        guard !values.isEmpty, values.count == number.count else { return false }

        var sum = 0
        for (index, digit) in values.reversed().enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }

    private func validateAll() {
        let numberDigits = Self.digits(in: cardNumber)
        if numberDigits.isEmpty {
            numberValidation = .idle
        } else if numberDigits.count == cardType.numberLength && Self.isLuhnValid(numberDigits) {
            numberValidation = .valid
        } else if numberDigits.count >= cardType.numberLength {
            numberValidation = .invalid("Invalid card number")
        } else {
            numberValidation = .idle
        }

        switch Self.checkExpiry(expiryDate) {
        case .incomplete: expiryValidation = .idle
        case .invalidMonth: expiryValidation = .invalid("Invalid date")
        case .expired: expiryValidation = .invalid("Card expired")
        case .valid: expiryValidation = .valid
        }

        cvvValidation = cvv.count == cardType.cvvLength ? .valid : .idle
        nameValidation = cardholderName.count >= 2 ? .valid : .idle

        let isValid = numberValidation == .valid &&
                      expiryValidation == .valid &&
                      cvvValidation == .valid &&
                      nameValidation == .valid

        onValidationChange?(isValid)
    }
}

// MARK: - Equatable Conformance

extension CreditCardInput.ValidationState: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.valid, .valid):
            return true
        case (.invalid(let l), .invalid(let r)):
            return l == r
        default:
            return false
        }
    }
}

#if DEBUG
struct CreditCardInputPreview: View {
    @State private var cardNumber = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var isValid = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CreditCardInput(
                    cardNumber: $cardNumber,
                    expiryDate: $expiry,
                    cvv: $cvv,
                    cardholderName: $name,
                    onValidationChange: { isValid = $0 }
                )

                Button("Pay Now") { }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValid ? Color.blue : Color.gray)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(!isValid)
            }
            .padding()
        }
    }
}

#Preview {
    CreditCardInputPreview()
}
#endif
