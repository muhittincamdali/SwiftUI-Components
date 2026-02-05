import SwiftUI

/// A ghost/transparent button
public struct GhostButton: View {
    let title: String
    let icon: String?
    let iconPosition: IconPosition
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    public enum IconPosition {
        case leading
        case trailing
    }
    
    public init(
        _ title: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.iconPosition = iconPosition
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if iconPosition == .leading, let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .fontWeight(.medium)
                
                if iconPosition == .trailing, let icon = icon {
                    Image(systemName: icon)
                }
            }
            .foregroundColor(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isPressed ? color.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

/// A link style button
public struct LinkButton: View {
    let title: String
    let icon: String?
    let color: Color
    let showUnderline: Bool
    let action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        color: Color = .accentColor,
        showUnderline: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.showUnderline = showUnderline
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .underline(showUnderline)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(color)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Ghost Buttons") {
    VStack(spacing: 20) {
        GhostButton("Ghost Button", action: {})
        GhostButton("With Icon", icon: "arrow.right", iconPosition: .trailing, action: {})
        GhostButton("Cancel", icon: "xmark", color: .red, action: {})
        
        Divider()
        
        LinkButton("Learn More", icon: "arrow.up.right", action: {})
        LinkButton("Terms of Service", showUnderline: true, action: {})
    }
    .padding()
}
