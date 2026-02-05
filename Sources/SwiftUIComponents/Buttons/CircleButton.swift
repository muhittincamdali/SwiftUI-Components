import SwiftUI

/// A circular button with icon
public struct CircleButton: View {
    let icon: String
    let action: () -> Void
    let size: CircleSize
    let style: CircleStyle
    let badge: Int?
    
    @State private var isPressed = false
    
    public enum CircleSize {
        case small
        case medium
        case large
        case extraLarge
        
        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 56
            case .extraLarge: return 72
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            case .extraLarge: return 32
            }
        }
    }
    
    public enum CircleStyle {
        case filled(Color)
        case outlined(Color)
        case soft(Color)
        case glass
    }
    
    public init(
        icon: String,
        size: CircleSize = .medium,
        style: CircleStyle = .filled(.accentColor),
        badge: Int? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.badge = badge
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))
                    .foregroundColor(foregroundColor)
                    .frame(width: size.dimension, height: size.dimension)
                    .background(background)
                    .clipShape(Circle())
                
                if let badge = badge, badge > 0 {
                    Text(badge > 99 ? "99+" : "\(badge)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Circle().fill(Color.red))
                        .offset(x: 4, y: -4)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(icon)
        .accessibilityAddTraits(.isButton)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined(let color): return color
        case .soft(let color): return color
        case .glass: return .white
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled(let color):
            Circle().fill(color)
        case .outlined(let color):
            Circle().stroke(color, lineWidth: 2)
        case .soft(let color):
            Circle().fill(color.opacity(0.15))
        case .glass:
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
    }
}

/// Back button with customizable appearance
public struct BackButton: View {
    let action: () -> Void
    let style: BackButtonStyle
    
    public enum BackButtonStyle {
        case arrow
        case chevron
        case close
    }
    
    public init(style: BackButtonStyle = .chevron, action: @escaping () -> Void) {
        self.style = style
        self.action = action
    }
    
    private var icon: String {
        switch style {
        case .arrow: return "arrow.left"
        case .chevron: return "chevron.left"
        case .close: return "xmark"
        }
    }
    
    public var body: some View {
        CircleButton(icon: icon, size: .medium, style: .soft(.primary), action: action)
            .accessibilityLabel("Go back")
    }
}

/// Close button for dismissing views
public struct CloseButton: View {
    let action: () -> Void
    let size: CircleButton.CircleSize
    let style: CircleButton.CircleStyle
    
    public init(
        size: CircleButton.CircleSize = .medium,
        style: CircleButton.CircleStyle = .soft(.primary),
        action: @escaping () -> Void
    ) {
        self.size = size
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        CircleButton(icon: "xmark", size: size, style: style, action: action)
            .accessibilityLabel("Close")
    }
}

#Preview("Circle Buttons") {
    VStack(spacing: 24) {
        // Sizes
        HStack(spacing: 16) {
            CircleButton(icon: "plus", size: .small, style: .filled(.blue)) {}
            CircleButton(icon: "plus", size: .medium, style: .filled(.blue)) {}
            CircleButton(icon: "plus", size: .large, style: .filled(.blue)) {}
            CircleButton(icon: "plus", size: .extraLarge, style: .filled(.blue)) {}
        }
        
        // Styles
        HStack(spacing: 16) {
            CircleButton(icon: "heart.fill", style: .filled(.pink)) {}
            CircleButton(icon: "heart.fill", style: .outlined(.pink)) {}
            CircleButton(icon: "heart.fill", style: .soft(.pink)) {}
            CircleButton(icon: "heart.fill", style: .glass) {}
        }
        
        // With badge
        HStack(spacing: 16) {
            CircleButton(icon: "bell.fill", style: .filled(.orange), badge: 3) {}
            CircleButton(icon: "message.fill", style: .filled(.green), badge: 99) {}
            CircleButton(icon: "cart.fill", style: .filled(.purple), badge: 150) {}
        }
        
        // Common buttons
        HStack(spacing: 16) {
            BackButton {}
            BackButton(style: .arrow) {}
            CloseButton {}
        }
    }
    .padding()
}
