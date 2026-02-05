import SwiftUI

/// A button with neumorphic (soft UI) design
public struct NeumorphicButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: NeumorphicStyle
    
    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme
    
    public enum NeumorphicStyle {
        case convex
        case concave
        case flat
    }
    
    public init(
        _ title: String,
        icon: String? = nil,
        style: NeumorphicStyle = .convex,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    private var baseColor: Color {
        colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.92)
    }
    
    private var lightShadow: Color {
        colorScheme == .dark ? Color(white: 0.25) : Color.white
    }
    
    private var darkShadow: Color {
        colorScheme == .dark ? Color.black : Color(white: 0.75)
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primary.opacity(0.8))
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                Group {
                    switch style {
                    case .convex:
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                LinearGradient(
                                    colors: [baseColor.opacity(0.9), baseColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: lightShadow.opacity(0.7), radius: isPressed ? 2 : 8, x: isPressed ? -2 : -8, y: isPressed ? -2 : -8)
                            .shadow(color: darkShadow.opacity(0.5), radius: isPressed ? 2 : 8, x: isPressed ? 2 : 8, y: isPressed ? 2 : 8)
                        
                    case .concave:
                        RoundedRectangle(cornerRadius: 15)
                            .fill(baseColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(darkShadow.opacity(0.3), lineWidth: 2)
                                    .blur(radius: 2)
                                    .offset(x: 2, y: 2)
                                    .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(colors: [.black, .clear], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lightShadow.opacity(0.5), lineWidth: 2)
                                    .blur(radius: 2)
                                    .offset(x: -2, y: -2)
                                    .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(colors: [.clear, .black], startPoint: .topLeading, endPoint: .bottomTrailing)))
                            )
                        
                    case .flat:
                        RoundedRectangle(cornerRadius: 15)
                            .fill(baseColor)
                            .shadow(color: lightShadow.opacity(0.7), radius: 6, x: -6, y: -6)
                            .shadow(color: darkShadow.opacity(0.5), radius: 6, x: 6, y: 6)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) { } onPressingChanged: { pressing in
            isPressed = pressing
        }
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Neumorphic Buttons") {
    ZStack {
        Color(white: 0.92)
            .ignoresSafeArea()
        
        VStack(spacing: 30) {
            NeumorphicButton("Convex", icon: "star.fill", style: .convex) {}
            NeumorphicButton("Concave", icon: "heart.fill", style: .concave) {}
            NeumorphicButton("Flat", icon: "bell.fill", style: .flat) {}
        }
        .padding()
    }
}
