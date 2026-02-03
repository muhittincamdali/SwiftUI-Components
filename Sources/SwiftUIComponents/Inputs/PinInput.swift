import SwiftUI

/// A PIN/OTP code input with individual digit boxes.
///
/// `PinInput` provides a secure and intuitive way to enter
/// verification codes with customizable styling.
///
/// ```swift
/// PinInput(code: $verificationCode, length: 6) { completed in
///     verifyCode(completed)
/// }
/// ```
public struct PinInput: View {
    // MARK: - Types
    
    /// Visual style for the PIN boxes.
    public enum BoxStyle {
        case outlined
        case filled
        case underlined
        case rounded
    }
    
    /// The keyboard type for input.
    public enum InputType {
        case numeric
        case alphanumeric
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .numeric: return .numberPad
            case .alphanumeric: return .asciiCapable
            }
        }
    }
    
    // MARK: - Properties
    
    @Binding private var code: String
    private let length: Int
    private let boxStyle: BoxStyle
    private let inputType: InputType
    private let boxSize: CGFloat
    private let spacing: CGFloat
    private let activeColor: Color
    private let inactiveColor: Color
    private let errorColor: Color
    private let textColor: Color
    private let font: Font
    private let isSecure: Bool
    private let secureCharacter: String
    private let showError: Bool
    private let errorMessage: String?
    private let onComplete: ((String) -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var shake: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new PIN input.
    /// - Parameters:
    ///   - code: Binding to the entered code string.
    ///   - length: Number of digits. Defaults to `6`.
    ///   - boxStyle: Visual style for boxes. Defaults to `.outlined`.
    ///   - inputType: Keyboard type. Defaults to `.numeric`.
    ///   - boxSize: Size of each box. Defaults to `50`.
    ///   - spacing: Space between boxes. Defaults to `12`.
    ///   - activeColor: Color when focused. Defaults to `.blue`.
    ///   - inactiveColor: Color when inactive. Defaults to `.gray.opacity(0.3)`.
    ///   - errorColor: Color for error state. Defaults to `.red`.
    ///   - textColor: Digit text color. Defaults to `.primary`.
    ///   - font: Digit font. Defaults to `.title2.bold()`.
    ///   - isSecure: Whether to mask digits. Defaults to `false`.
    ///   - secureCharacter: Character for masked digits. Defaults to `"●"`.
    ///   - showError: Whether to show error state. Defaults to `false`.
    ///   - errorMessage: Optional error message. Defaults to `nil`.
    ///   - onComplete: Callback when all digits entered. Defaults to `nil`.
    public init(
        code: Binding<String>,
        length: Int = 6,
        boxStyle: BoxStyle = .outlined,
        inputType: InputType = .numeric,
        boxSize: CGFloat = 50,
        spacing: CGFloat = 12,
        activeColor: Color = .blue,
        inactiveColor: Color = .gray.opacity(0.3),
        errorColor: Color = .red,
        textColor: Color = .primary,
        font: Font = .title2.bold(),
        isSecure: Bool = false,
        secureCharacter: String = "●",
        showError: Bool = false,
        errorMessage: String? = nil,
        onComplete: ((String) -> Void)? = nil
    ) {
        self._code = code
        self.length = length
        self.boxStyle = boxStyle
        self.inputType = inputType
        self.boxSize = boxSize
        self.spacing = spacing
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.errorColor = errorColor
        self.textColor = textColor
        self.font = font
        self.isSecure = isSecure
        self.secureCharacter = secureCharacter
        self.showError = showError
        self.errorMessage = errorMessage
        self.onComplete = onComplete
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Hidden text field for input
                hiddenTextField
                
                // Visible boxes
                HStack(spacing: spacing) {
                    ForEach(0..<length, id: \.self) { index in
                        pinBox(at: index)
                    }
                }
            }
            .offset(x: shake ? -10 : 0)
            .animation(
                shake ? .default.repeatCount(3, autoreverses: true).speed(6) : .default,
                value: shake
            )
            
            // Error message
            if showError, let message = errorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(errorColor)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Hidden Text Field
    
    private var hiddenTextField: some View {
        TextField("", text: $code)
            .keyboardType(inputType.keyboardType)
            .textContentType(.oneTimeCode)
            .focused($isFocused)
            .frame(width: 1, height: 1)
            .opacity(0.01)
            .onChange(of: code) { _, newValue in
                // Limit to max length
                if newValue.count > length {
                    code = String(newValue.prefix(length))
                }
                
                // Filter based on input type
                if inputType == .numeric {
                    code = newValue.filter { $0.isNumber }
                }
                
                // Check completion
                if code.count == length {
                    onComplete?(code)
                }
            }
            .onAppear {
                isFocused = true
            }
    }
    
    // MARK: - PIN Box
    
    private func pinBox(at index: Int) -> some View {
        let character = characterAt(index)
        let isCurrent = code.count == index
        let isFilled = index < code.count
        
        return ZStack {
            boxBackground(isCurrent: isCurrent, isFilled: isFilled)
            
            if let char = character {
                Text(isSecure ? secureCharacter : String(char))
                    .font(font)
                    .foregroundStyle(textColor)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Cursor for current position
            if isCurrent && isFocused {
                Rectangle()
                    .fill(activeColor)
                    .frame(width: 2, height: boxSize * 0.5)
                    .opacity(cursorOpacity)
            }
        }
        .frame(width: boxSize, height: boxSize)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .animation(.easeInOut(duration: 0.15), value: character != nil)
    }
    
    @State private var cursorOpacity: Double = 1.0
    
    // MARK: - Box Background
    
    @ViewBuilder
    private func boxBackground(isCurrent: Bool, isFilled: Bool) -> some View {
        let borderColor = showError ? errorColor : (isCurrent ? activeColor : inactiveColor)
        let fillColor = showError ? errorColor.opacity(0.1) : (isFilled ? activeColor.opacity(0.1) : Color.clear)
        
        switch boxStyle {
        case .outlined:
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: isCurrent ? 2 : 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(fillColor)
                )
        
        case .filled:
            RoundedRectangle(cornerRadius: 8)
                .fill(isFilled ? activeColor.opacity(0.15) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: isCurrent ? 2 : 0)
                )
        
        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .fill(borderColor)
                    .frame(height: isCurrent ? 2 : 1)
            }
        
        case .rounded:
            Circle()
                .stroke(borderColor, lineWidth: isCurrent ? 2 : 1)
                .background(
                    Circle()
                        .fill(fillColor)
                )
        }
    }
    
    // MARK: - Helpers
    
    private func characterAt(_ index: Int) -> Character? {
        guard index < code.count else { return nil }
        let stringIndex = code.index(code.startIndex, offsetBy: index)
        return code[stringIndex]
    }
    
    /// Triggers the shake animation for error feedback.
    public func triggerShake() {
        shake = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            shake = false
        }
    }
}

// MARK: - PIN Input with Timer

/// PIN input with countdown timer for resend functionality.
public struct TimedPinInput: View {
    @Binding var code: String
    let length: Int
    let resendInterval: Int
    let onComplete: (String) -> Void
    let onResend: () -> Void
    
    @State private var remainingTime: Int
    @State private var timerActive: Bool = true
    
    public init(
        code: Binding<String>,
        length: Int = 6,
        resendInterval: Int = 60,
        onComplete: @escaping (String) -> Void,
        onResend: @escaping () -> Void
    ) {
        self._code = code
        self.length = length
        self.resendInterval = resendInterval
        self._remainingTime = State(initialValue: resendInterval)
        self.onComplete = onComplete
        self.onResend = onResend
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            PinInput(
                code: $code,
                length: length,
                onComplete: onComplete
            )
            
            HStack {
                Text("Didn't receive code?")
                    .foregroundStyle(.secondary)
                
                if timerActive {
                    Text("Resend in \(remainingTime)s")
                        .foregroundStyle(.blue)
                } else {
                    Button("Resend") {
                        onResend()
                        remainingTime = resendInterval
                        timerActive = true
                        startTimer()
                    }
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
                }
            }
            .font(.subheadline)
        }
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timerActive = false
                timer.invalidate()
            }
        }
    }
}

// MARK: - Passcode Input

/// A numeric passcode input, typically for app lock screens.
public struct PasscodeInput: View {
    @Binding var passcode: String
    let length: Int
    let onComplete: (String) -> Void
    
    @State private var showError: Bool = false
    
    public init(
        passcode: Binding<String>,
        length: Int = 4,
        onComplete: @escaping (String) -> Void
    ) {
        self._passcode = passcode
        self.length = length
        self.onComplete = onComplete
    }
    
    public var body: some View {
        VStack(spacing: 40) {
            // Dots indicator
            HStack(spacing: 20) {
                ForEach(0..<length, id: \.self) { index in
                    Circle()
                        .fill(index < passcode.count ? Color.primary : Color(.systemGray4))
                        .frame(width: 16, height: 16)
                        .scaleEffect(index < passcode.count ? 1.0 : 0.8)
                        .animation(.spring(response: 0.2), value: passcode.count)
                }
            }
            .offset(x: showError ? -10 : 0)
            .animation(
                showError ? .default.repeatCount(3, autoreverses: true).speed(6) : .default,
                value: showError
            )
            
            // Numeric keypad
            VStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 24) {
                        ForEach(1...3, id: \.self) { col in
                            let number = row * 3 + col
                            keypadButton(String(number))
                        }
                    }
                }
                
                HStack(spacing: 24) {
                    Color.clear
                        .frame(width: 72, height: 72)
                    
                    keypadButton("0")
                    
                    Button {
                        if !passcode.isEmpty {
                            passcode.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .frame(width: 72, height: 72)
                    }
                }
            }
        }
    }
    
    private func keypadButton(_ digit: String) -> some View {
        Button {
            guard passcode.count < length else { return }
            passcode += digit
            
            if passcode.count == length {
                onComplete(passcode)
            }
        } label: {
            Text(digit)
                .font(.title)
                .fontWeight(.medium)
                .frame(width: 72, height: 72)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    /// Triggers error animation and clears passcode.
    public func triggerError() {
        showError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showError = false
            passcode = ""
        }
    }
}

#if DEBUG
struct PinInputPreview: View {
    @State private var code1 = ""
    @State private var code2 = "123"
    @State private var code3 = ""
    @State private var passcode = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                VStack {
                    Text("Standard PIN")
                        .font(.caption)
                    PinInput(code: $code1, length: 6)
                }
                
                VStack {
                    Text("Secure + Filled Style")
                        .font(.caption)
                    PinInput(
                        code: $code2,
                        length: 4,
                        boxStyle: .filled,
                        isSecure: true
                    )
                }
                
                VStack {
                    Text("Underlined Style")
                        .font(.caption)
                    PinInput(
                        code: $code3,
                        length: 6,
                        boxStyle: .underlined,
                        activeColor: .green
                    )
                }
                
                Divider()
                
                VStack {
                    Text("Passcode Keypad")
                        .font(.caption)
                    PasscodeInput(passcode: $passcode) { _ in }
                }
            }
            .padding()
        }
    }
}

#Preview {
    PinInputPreview()
}
#endif
