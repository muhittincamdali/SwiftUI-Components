import SwiftUI

/// A styled form field with label and optional helper text
public struct FormField<Content: View>: View {
    let label: String
    let helperText: String?
    let errorMessage: String?
    let isRequired: Bool
    @ViewBuilder let content: () -> Content
    
    public init(
        label: String,
        helperText: String? = nil,
        errorMessage: String? = nil,
        isRequired: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.helperText = helperText
        self.errorMessage = errorMessage
        self.isRequired = isRequired
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            content()
            
            if let error = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(error)
                        .font(.system(size: 12))
                }
                .foregroundColor(.red)
            } else if let helper = helperText {
                Text(helper)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }
}

/// A styled text input field
public struct TextInputField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String?
    let style: InputStyle
    let keyboardType: UIKeyboardType
    @FocusState private var isFocused: Bool
    
    public enum InputStyle {
        case standard
        case outlined
        case filled
        case underlined
    }
    
    public init(
        text: Binding<String>,
        placeholder: String = "",
        icon: String? = nil,
        style: InputStyle = .outlined,
        keyboardType: UIKeyboardType = .default
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.style = style
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(isFocused ? .accentColor : .secondary)
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(background)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .standard:
            Color.clear
        case .outlined:
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.accentColor : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
        case .filled:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .fill(isFocused ? Color.accentColor : Color(.systemGray4))
                    .frame(height: isFocused ? 2 : 1)
            }
        }
    }
}

/// A password input field with visibility toggle
public struct PasswordField: View {
    @Binding var password: String
    let placeholder: String
    @State private var isSecure = true
    @FocusState private var isFocused: Bool
    
    public init(password: Binding<String>, placeholder: String = "Password") {
        self._password = password
        self.placeholder = placeholder
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock")
                .font(.system(size: 16))
                .foregroundColor(isFocused ? .accentColor : .secondary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $password)
                } else {
                    TextField(placeholder, text: $password)
                }
            }
            .font(.system(size: 16))
            .focused($isFocused)
            
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.accentColor : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

/// A text area for multiline input
public struct TextAreaField: View {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    let maxHeight: CGFloat
    @FocusState private var isFocused: Bool
    
    public init(
        text: Binding<String>,
        placeholder: String = "",
        minHeight: CGFloat = 100,
        maxHeight: CGFloat = 200
    ) {
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary.opacity(0.7))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }
            
            TextEditor(text: $text)
                .font(.system(size: 16))
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.accentColor : Color(.systemGray4), lineWidth: isFocused ? 2 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview("Form Fields") {
    ScrollView {
        VStack(spacing: 24) {
            FormField(label: "Email", helperText: "We'll never share your email", isRequired: true) {
                TextInputField(text: .constant(""), placeholder: "Enter email", icon: "envelope", style: .outlined)
            }
            
            FormField(label: "Username", errorMessage: "Username already taken") {
                TextInputField(text: .constant("johndoe"), placeholder: "Enter username", icon: "person", style: .outlined)
            }
            
            FormField(label: "Password", isRequired: true) {
                PasswordField(password: .constant(""))
            }
            
            FormField(label: "Bio") {
                TextAreaField(text: .constant(""), placeholder: "Tell us about yourself...")
            }
            
            Divider().padding(.vertical)
            
            Text("Input Styles")
                .font(.headline)
            
            TextInputField(text: .constant(""), placeholder: "Standard", style: .standard)
            TextInputField(text: .constant(""), placeholder: "Outlined", style: .outlined)
            TextInputField(text: .constant(""), placeholder: "Filled", style: .filled)
            TextInputField(text: .constant(""), placeholder: "Underlined", style: .underlined)
        }
        .padding()
    }
}
