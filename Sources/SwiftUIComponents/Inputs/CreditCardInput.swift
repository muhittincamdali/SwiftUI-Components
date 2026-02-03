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
    public enum CardType: String, CaseIterable {
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
        
        var cvvLength: Int {
            switch self {
            case .amex: return 4
            default: return 3
            }
        }
        
        var numberLength: Int {
            switch self {
            case .amex: return 15
            case .dinersClub: return 14
            default: return 16
            }
        }
        
        static func detect(from number: String) -> CardType {
            let digits = number.filter { $0.isNumber }
            
            if digits.hasPrefix("4") {
                return .visa
            } else if digits.hasPrefix("5") && digits.count >= 2 {
                let secondDigit = digits[digits.index(digits.startIndex, offsetBy: 1)]
                if "12345".contains(secondDigit) {
                    return .mastercard
                }
            } else if digits.hasPrefix("34") || digits.hasPrefix("37") {
                return .amex
            } else if digits.hasPrefix("6011") || digits.hasPrefix("65") {
                return .discover
            } else if digits.hasPrefix("36") || digits.hasPrefix("38") {
                return .dinersClub
            } else if digits.hasPrefix("35") {
                return .jcb
            }
            
            return .unknown
        }
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
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .number)
                    .onChange(of: cardNumber) { _, newValue in
                        cardNumber = formatCardNumber(newValue)
                        cardType = CardType.detect(from: newValue)
                    }
                
                Text(cardType.icon)
                    .font(.title2)
            }
            .padding()
            .background(Color(.systemGray6))
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
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .expiry)
                .onChange(of: expiryDate) { _, newValue in
                    expiryDate = formatExpiry(newValue)
                }
                .padding()
                .background(Color(.systemGray6))
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
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .cvv)
                .onChange(of: cvv) { _, newValue in
                    cvv = String(newValue.filter { $0.isNumber }.prefix(cardType.cvvLength))
                }
                .padding()
                .background(Color(.systemGray6))
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
            
            TextField("John Doe", text: $cardholderName)
                .textContentType(.name)
                .autocapitalization(.words)
                .focused($focusedField, equals: .name)
                .padding()
                .background(Color(.systemGray6))
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
    
    private func formatCardNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        var result = ""
        
        for (index, char) in digits.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            result.append(char)
        }
        
        return String(result.prefix(19)) // 16 digits + 3 spaces
    }
    
    private func formatExpiry(_ expiry: String) -> String {
        let digits = expiry.filter { $0.isNumber }
        
        if digits.count >= 2 {
            return String(digits.prefix(2)) + "/" + String(digits.dropFirst(2).prefix(2))
        }
        
        return String(digits.prefix(4))
    }
    
    private func formatDisplayNumber(_ number: String) -> String {
        let formatted = formatCardNumber(number)
        let padding = String(repeating: "•", count: max(0, 19 - formatted.count))
        return formatted + padding
    }
    
    // MARK: - Validation
    
    private func validateAll() {
        // Validate card number
        let numberDigits = cardNumber.filter { $0.isNumber }
        if numberDigits.isEmpty {
            numberValidation = .idle
        } else if numberDigits.count == cardType.numberLength && luhnCheck(numberDigits) {
            numberValidation = .valid
        } else if numberDigits.count >= cardType.numberLength {
            numberValidation = .invalid("Invalid card number")
        } else {
            numberValidation = .idle
        }
        
        // Validate expiry
        let expiryDigits = expiryDate.filter { $0.isNumber }
        if expiryDigits.isEmpty {
            expiryValidation = .idle
        } else if expiryDigits.count == 4 {
            if let month = Int(String(expiryDigits.prefix(2))),
               let year = Int(String(expiryDigits.suffix(2))),
               month >= 1 && month <= 12 {
                let currentYear = Calendar.current.component(.year, from: Date()) % 100
                let currentMonth = Calendar.current.component(.month, from: Date())
                
                if year > currentYear || (year == currentYear && month >= currentMonth) {
                    expiryValidation = .valid
                } else {
                    expiryValidation = .invalid("Card expired")
                }
            } else {
                expiryValidation = .invalid("Invalid date")
            }
        } else {
            expiryValidation = .idle
        }
        
        // Validate CVV
        if cvv.isEmpty {
            cvvValidation = .idle
        } else if cvv.count == cardType.cvvLength {
            cvvValidation = .valid
        } else {
            cvvValidation = .idle
        }
        
        // Validate name
        if cardholderName.isEmpty {
            nameValidation = .idle
        } else if cardholderName.count >= 2 {
            nameValidation = .valid
        } else {
            nameValidation = .idle
        }
        
        // Check overall validity
        let isValid = numberValidation == .valid &&
                      expiryValidation == .valid &&
                      cvvValidation == .valid &&
                      nameValidation == .valid
        
        onValidationChange?(isValid)
    }
    
    private func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digits = number.reversed().map { Int(String($0))! }
        
        for (index, digit) in digits.enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        
        return sum % 10 == 0
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
