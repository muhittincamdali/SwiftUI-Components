import SwiftUI

/// A custom alert dialog
public struct AlertDialog: View {
    let title: String
    let message: String
    let icon: String?
    let iconColor: Color
    let primaryButton: AlertButton?
    let secondaryButton: AlertButton?
    let style: AlertStyle
    
    public struct AlertButton {
        let title: String
        let style: ButtonStyle
        let action: () -> Void
        
        public enum ButtonStyle {
            case primary
            case secondary
            case destructive
        }
        
        public init(_ title: String, style: ButtonStyle = .primary, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
    
    public enum AlertStyle {
        case standard
        case success
        case warning
        case error
        case info
    }
    
    public init(
        title: String,
        message: String,
        icon: String? = nil,
        iconColor: Color = .accentColor,
        primaryButton: AlertButton? = nil,
        secondaryButton: AlertButton? = nil,
        style: AlertStyle = .standard
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        self.style = style
    }
    
    private var styleIcon: String {
        switch style {
        case .standard: return icon ?? "questionmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    private var styleColor: Color {
        switch style {
        case .standard: return iconColor
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .info: return .blue
        }
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(styleColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: styleIcon)
                    .font(.system(size: 28))
                    .foregroundColor(styleColor)
            }
            
            // Title & Message
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Buttons
            VStack(spacing: 10) {
                if let primary = primaryButton {
                    Button(action: primary.action) {
                        Text(primary.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(buttonForeground(for: primary.style))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(buttonBackground(for: primary.style))
                            .cornerRadius(10)
                    }
                }
                
                if let secondary = secondaryButton {
                    Button(action: secondary.action) {
                        Text(secondary.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(buttonForeground(for: secondary.style))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(buttonBackground(for: secondary.style))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 40)
    }
    
    private func buttonForeground(for style: AlertButton.ButtonStyle) -> Color {
        switch style {
        case .primary: return .white
        case .secondary: return .primary
        case .destructive: return .white
        }
    }
    
    private func buttonBackground(for style: AlertButton.ButtonStyle) -> Color {
        switch style {
        case .primary: return styleColor
        case .secondary: return Color(.systemGray5)
        case .destructive: return .red
        }
    }
}

/// A confirmation dialog
public struct ConfirmationDialog: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    public init(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.isDestructive = isDestructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text(cancelTitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                
                Button(action: onConfirm) {
                    Text(confirmTitle)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isDestructive ? Color.red : Color.accentColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 32)
    }
}

/// An input dialog
public struct InputDialog: View {
    let title: String
    let message: String?
    let placeholder: String
    @Binding var text: String
    let onSubmit: (String) -> Void
    let onCancel: () -> Void
    
    public init(
        title: String,
        message: String? = nil,
        placeholder: String = "",
        text: Binding<String>,
        onSubmit: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.placeholder = placeholder
        self._text = text
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                
                if let message = message {
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                
                Button {
                    onSubmit(text)
                } label: {
                    Text("Submit")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
                .disabled(text.isEmpty)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 32)
    }
}

#Preview("Alert Dialogs") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 32) {
            AlertDialog(
                title: "Success!",
                message: "Your changes have been saved successfully.",
                primaryButton: .init("Continue") {},
                style: .success
            )
            
            ConfirmationDialog(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                confirmTitle: "Delete",
                isDestructive: true,
                onConfirm: {},
                onCancel: {}
            )
        }
    }
}
