import SwiftUI

/// A button styled for destructive actions like delete
public struct DestructiveButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: DestructiveStyle
    
    @State private var isPressed = false
    
    public enum DestructiveStyle {
        case filled
        case outlined
        case text
    }
    
    public init(
        _ title: String,
        icon: String? = "trash",
        style: DestructiveStyle = .filled,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(background)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel("\(title), destructive action")
        .accessibilityAddTraits(.isButton)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined, .text: return .red
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red)
        case .outlined:
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red, lineWidth: 2)
        case .text:
            Color.clear
        }
    }
}

#Preview("Destructive Buttons") {
    VStack(spacing: 20) {
        DestructiveButton("Delete", style: .filled) {}
        DestructiveButton("Remove", style: .outlined) {}
        DestructiveButton("Clear", icon: "xmark", style: .text) {}
    }
    .padding()
}
