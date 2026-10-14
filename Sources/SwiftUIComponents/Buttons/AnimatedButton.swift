import SwiftUI

/// A button with various animation effects
public struct AnimatedButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let animation: AnimationType
    let color: Color
    
    @State private var isAnimating = false
    @State private var isPressed = false
    
    public enum AnimationType {
        case bounce
        case shake
        case pulse
        case rotate
        case scale
        case glow
    }
    
    public init(
        _ title: String,
        icon: String? = nil,
        animation: AnimationType = .bounce,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.animation = animation
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button {
            triggerAnimation()
            action()
        } label: {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .shadow(color: isAnimating && animation == .glow ? color.opacity(0.6) : Color.clear, radius: 10)
            )
            .modifier(AnimationModifier(animation: animation, isAnimating: isAnimating))
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
    
    private func triggerAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isAnimating = false
            }
        }
    }
}

struct AnimationModifier: ViewModifier {
    let animation: AnimatedButton.AnimationType
    let isAnimating: Bool
    
    func body(content: Content) -> some View {
        switch animation {
        case .bounce:
            content.offset(y: isAnimating ? -10 : 0)
        case .shake:
            content.offset(x: isAnimating ? -5 : 0)
                .animation(.spring(response: 0.1, dampingFraction: 0.2).repeatCount(5, autoreverses: true), value: isAnimating)
        case .pulse:
            content.scaleEffect(isAnimating ? 1.1 : 1.0)
        case .rotate:
            content.rotationEffect(.degrees(isAnimating ? 360 : 0))
        case .scale:
            content.scaleEffect(isAnimating ? 0.9 : 1.0)
        case .glow:
            content
        }
    }
}

/// Button with ripple effect on tap
public struct RippleButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var ripples: [Ripple] = []
    
    struct Ripple: Identifiable {
        let id = UUID()
        var scale: CGFloat = 0
        var opacity: Double = 0.5
    }
    
    public init(_ title: String, color: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button {
            addRipple()
            action()
        } label: {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(color)
                        
                        ForEach(ripples) { ripple in
                            Circle()
                                .fill(Color.white.opacity(ripple.opacity))
                                .scaleEffect(ripple.scale)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func addRipple() {
        var ripple = Ripple()
        ripples.append(ripple)
        
        withAnimation(.easeOut(duration: 0.6)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].scale = 2.5
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }
}

#Preview("Animated Buttons") {
    VStack(spacing: 20) {
        AnimatedButton("Bounce", icon: "arrow.up", animation: .bounce) {}
        AnimatedButton("Shake", icon: "bell.fill", animation: .shake, color: .orange) {}
        AnimatedButton("Pulse", icon: "heart.fill", animation: .pulse, color: .pink) {}
        AnimatedButton("Rotate", icon: "arrow.clockwise", animation: .rotate, color: .purple) {}
        AnimatedButton("Glow", icon: "sparkles", animation: .glow, color: .yellow) {}
        RippleButton("Ripple Effect", color: .blue) {}
    }
    .padding()
}
