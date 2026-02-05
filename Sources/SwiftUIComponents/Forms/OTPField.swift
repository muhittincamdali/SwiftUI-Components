import SwiftUI

/// An OTP/PIN input field
public struct OTPField: View {
    @Binding var code: String
    let length: Int
    let style: OTPStyle
    let onComplete: ((String) -> Void)?
    
    @FocusState private var isFocused: Bool
    
    public enum OTPStyle {
        case boxes
        case underlined
        case rounded
    }
    
    public init(
        code: Binding<String>,
        length: Int = 6,
        style: OTPStyle = .boxes,
        onComplete: ((String) -> Void)? = nil
    ) {
        self._code = code
        self.length = length
        self.style = style
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            // Hidden text field
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .onChange(of: code) { _, newValue in
                    // Limit to length
                    if newValue.count > length {
                        code = String(newValue.prefix(length))
                    }
                    // Filter non-digits
                    code = code.filter { $0.isNumber }
                    // Trigger completion
                    if code.count == length {
                        onComplete?(code)
                    }
                }
            
            // Visual boxes
            HStack(spacing: style == .underlined ? 16 : 10) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .onTapGesture {
                isFocused = true
            }
        }
        .animation(.easeInOut(duration: 0.15), value: code)
    }
    
    private func digitBox(at index: Int) -> some View {
        let digit = getDigit(at: index)
        let isCurrentIndex = code.count == index && isFocused
        
        return Group {
            switch style {
            case .boxes:
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isCurrentIndex ? Color.accentColor : (digit != nil ? Color.accentColor.opacity(0.5) : Color(.systemGray4)), lineWidth: isCurrentIndex ? 2 : 1)
                        .frame(width: 48, height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                        )
                    
                    if let digit = digit {
                        Text(String(digit))
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    if isCurrentIndex {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 2, height: 24)
                            .opacity(1)
                    }
                }
                
            case .underlined:
                VStack(spacing: 8) {
                    if let digit = digit {
                        Text(String(digit))
                            .font(.system(size: 28, weight: .semibold))
                    } else {
                        Text(" ")
                            .font(.system(size: 28, weight: .semibold))
                    }
                    
                    Rectangle()
                        .fill(isCurrentIndex ? Color.accentColor : (digit != nil ? Color.accentColor.opacity(0.5) : Color(.systemGray4)))
                        .frame(width: 40, height: isCurrentIndex ? 3 : 2)
                }
                
            case .rounded:
                ZStack {
                    Circle()
                        .stroke(isCurrentIndex ? Color.accentColor : (digit != nil ? Color.accentColor.opacity(0.5) : Color(.systemGray4)), lineWidth: isCurrentIndex ? 2 : 1)
                        .frame(width: 52, height: 52)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                        )
                    
                    if let digit = digit {
                        Text(String(digit))
                            .font(.system(size: 22, weight: .semibold))
                    }
                }
            }
        }
    }
    
    private func getDigit(at index: Int) -> Character? {
        guard index < code.count else { return nil }
        return code[code.index(code.startIndex, offsetBy: index)]
    }
}

/// Secure PIN field with dots
public struct SecurePINField: View {
    @Binding var pin: String
    let length: Int
    let onComplete: ((String) -> Void)?
    
    @FocusState private var isFocused: Bool
    
    public init(
        pin: Binding<String>,
        length: Int = 4,
        onComplete: ((String) -> Void)? = nil
    ) {
        self._pin = pin
        self.length = length
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            // Hidden text field
            SecureField("", text: $pin)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .opacity(0)
                .onChange(of: pin) { _, newValue in
                    if newValue.count > length {
                        pin = String(newValue.prefix(length))
                    }
                    pin = pin.filter { $0.isNumber }
                    if pin.count == length {
                        onComplete?(pin)
                    }
                }
            
            // Visual dots
            HStack(spacing: 20) {
                ForEach(0..<length, id: \.self) { index in
                    Circle()
                        .fill(index < pin.count ? Color.accentColor : Color(.systemGray4))
                        .frame(width: 16, height: 16)
                        .scaleEffect(index < pin.count ? 1.0 : 0.8)
                        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: pin.count)
                }
            }
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

/// Number pad for PIN entry
public struct NumberPad: View {
    @Binding var value: String
    let maxLength: Int
    let showBiometric: Bool
    let onBiometric: (() -> Void)?
    
    public init(
        value: Binding<String>,
        maxLength: Int = 6,
        showBiometric: Bool = false,
        onBiometric: (() -> Void)? = nil
    ) {
        self._value = value
        self.maxLength = maxLength
        self.showBiometric = showBiometric
        self.onBiometric = onBiometric
    }
    
    private let numbers = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]
    
    public var body: some View {
        VStack(spacing: 12) {
            ForEach(numbers, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { number in
                        if number.isEmpty {
                            if showBiometric {
                                Button(action: { onBiometric?() }) {
                                    Image(systemName: "faceid")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primary)
                                        .frame(width: 72, height: 72)
                                }
                            } else {
                                Color.clear
                                    .frame(width: 72, height: 72)
                            }
                        } else if number == "⌫" {
                            Button {
                                if !value.isEmpty {
                                    value.removeLast()
                                }
                            } label: {
                                Image(systemName: "delete.left")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primary)
                                    .frame(width: 72, height: 72)
                            }
                        } else {
                            Button {
                                if value.count < maxLength {
                                    value += number
                                }
                            } label: {
                                Text(number)
                                    .font(.system(size: 28, weight: .medium))
                                    .foregroundColor(.primary)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("OTP & PIN Fields") {
    struct PreviewWrapper: View {
        @State private var otp1 = ""
        @State private var otp2 = "123"
        @State private var otp3 = ""
        @State private var pin = ""
        @State private var numPadValue = ""
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Boxes Style")
                            .font(.headline)
                        OTPField(code: $otp1, length: 6, style: .boxes)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Underlined Style")
                            .font(.headline)
                        OTPField(code: $otp2, length: 4, style: .underlined)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Rounded Style")
                            .font(.headline)
                        OTPField(code: $otp3, length: 5, style: .rounded)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 16) {
                        Text("Secure PIN")
                            .font(.headline)
                        SecurePINField(pin: $pin, length: 4)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 16) {
                        Text("Number Pad")
                            .font(.headline)
                        
                        SecurePINField(pin: $numPadValue, length: 6)
                        
                        NumberPad(value: $numPadValue, maxLength: 6, showBiometric: true) {
                            // Biometric action
                        }
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
