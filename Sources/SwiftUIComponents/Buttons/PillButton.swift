import SwiftUI

/// A pill-shaped button with various styles
public struct PillButton: View {
    let title: String
    let icon: String?
    let iconPosition: IconPosition
    let action: () -> Void
    let style: PillStyle
    let size: PillSize
    
    @State private var isPressed = false
    
    public enum IconPosition {
        case leading
        case trailing
    }
    
    public enum PillStyle {
        case filled(Color)
        case outlined(Color)
        case gradient([Color])
        case soft(Color)
    }
    
    public enum PillSize {
        case small
        case medium
        case large
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 20
            case .large: return 28
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 10
            case .large: return 14
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 14
            case .large: return 16
            }
        }
    }
    
    public init(
        _ title: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        style: PillStyle = .filled(.accentColor),
        size: PillSize = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.iconPosition = iconPosition
        self.style = style
        self.size = size
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if iconPosition == .leading, let icon = icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .font(.system(size: size.fontSize, weight: .semibold))
                
                if iconPosition == .trailing, let icon = icon {
                    Image(systemName: icon)
                }
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(background)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined(let color): return color
        case .gradient: return .white
        case .soft(let color): return color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled(let color):
            Capsule().fill(color)
        case .outlined(let color):
            Capsule().stroke(color, lineWidth: 1.5)
        case .gradient(let colors):
            Capsule().fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
        case .soft(let color):
            Capsule().fill(color.opacity(0.15))
        }
    }
}

#Preview("Pill Buttons") {
    VStack(spacing: 16) {
        // Size variants
        HStack(spacing: 12) {
            PillButton("Small", size: .small) {}
            PillButton("Medium", size: .medium) {}
            PillButton("Large", size: .large) {}
        }
        
        // Style variants
        PillButton("Filled", icon: "star.fill", style: .filled(.blue)) {}
        PillButton("Outlined", icon: "heart", style: .outlined(.pink)) {}
        PillButton("Gradient", icon: "sparkles", style: .gradient([.purple, .pink])) {}
        PillButton("Soft", icon: "bookmark", style: .soft(.green)) {}
        
        // Icon position
        PillButton("Next", icon: "arrow.right", iconPosition: .trailing, style: .filled(.orange)) {}
    }
    .padding()
}
