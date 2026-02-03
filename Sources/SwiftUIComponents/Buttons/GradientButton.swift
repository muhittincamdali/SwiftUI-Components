import SwiftUI

/// A button with customizable gradient backgrounds and animated effects.
///
/// `GradientButton` supports linear, radial, and angular gradients with
/// optional shimmer and glow effects.
///
/// ```swift
/// GradientButton("Get Premium", gradient: .linearGradient(
///     colors: [.purple, .blue],
///     startPoint: .leading,
///     endPoint: .trailing
/// )) {
///     upgradeToPremium()
/// }
/// ```
public struct GradientButton: View {
    // MARK: - Types
    
    /// The type of gradient to apply.
    public enum GradientType {
        case linear(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint)
        case radial(colors: [Color], center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
        case angular(colors: [Color], center: UnitPoint, angle: Angle)
        case conic(colors: [Color], center: UnitPoint)
        
        /// Preset gradient styles.
        public static let sunrise = GradientType.linear(
            colors: [.orange, .pink, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let ocean = GradientType.linear(
            colors: [.cyan, .blue, .indigo],
            startPoint: .top,
            endPoint: .bottom
        )
        
        public static let forest = GradientType.linear(
            colors: [.green, .mint, .teal],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        public static let fire = GradientType.linear(
            colors: [.yellow, .orange, .red],
            startPoint: .top,
            endPoint: .bottom
        )
        
        public static let midnight = GradientType.linear(
            colors: [.indigo, .purple, .black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Properties
    
    private let title: String
    private let gradient: GradientType
    private let foregroundColor: Color
    private let cornerRadius: CGFloat
    private let height: CGFloat
    private let font: Font
    private let hasGlow: Bool
    private let hasShimmer: Bool
    private let hasShadow: Bool
    private let icon: Image?
    private let action: () -> Void
    
    @State private var shimmerPhase: CGFloat = -1.0
    @State private var isPressed: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new gradient button.
    /// - Parameters:
    ///   - title: The button title.
    ///   - gradient: The gradient type to apply.
    ///   - foregroundColor: Text and icon color. Defaults to `.white`.
    ///   - cornerRadius: Corner radius. Defaults to `14`.
    ///   - height: Button height. Defaults to `54`.
    ///   - font: Title font. Defaults to `.headline`.
    ///   - hasGlow: Whether to show glow effect. Defaults to `false`.
    ///   - hasShimmer: Whether to show shimmer animation. Defaults to `false`.
    ///   - hasShadow: Whether to show shadow. Defaults to `true`.
    ///   - icon: Optional icon image. Defaults to `nil`.
    ///   - action: The action to perform.
    public init(
        _ title: String,
        gradient: GradientType,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 14,
        height: CGFloat = 54,
        font: Font = .headline,
        hasGlow: Bool = false,
        hasShimmer: Bool = false,
        hasShadow: Bool = true,
        icon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.gradient = gradient
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.font = font
        self.hasGlow = hasGlow
        self.hasShimmer = hasShimmer
        self.hasShadow = hasShadow
        self.icon = icon
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                gradientBackground
                
                if hasShimmer {
                    shimmerOverlay
                }
                
                HStack(spacing: 10) {
                    if let icon {
                        icon
                            .imageScale(.medium)
                    }
                    
                    Text(title)
                        .font(font)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: hasShadow ? shadowColor.opacity(0.4) : .clear,
                radius: hasShadow ? 8 : 0,
                x: 0,
                y: 4
            )
            .overlay(glowOverlay)
        }
        .buttonStyle(GradientButtonStyle())
        .onAppear {
            if hasShimmer {
                withAnimation(
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
                ) {
                    shimmerPhase = 1.0
                }
            }
        }
    }
    
    // MARK: - Gradient Background
    
    @ViewBuilder
    private var gradientBackground: some View {
        switch gradient {
        case .linear(let colors, let startPoint, let endPoint):
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        case .radial(let colors, let center, let startRadius, let endRadius):
            RadialGradient(colors: colors, center: center, startRadius: startRadius, endRadius: endRadius)
        case .angular(let colors, let center, let angle):
            AngularGradient(colors: colors, center: center, angle: angle)
        case .conic(let colors, let center):
            AngularGradient(colors: colors + [colors.first ?? .clear], center: center)
        }
    }
    
    // MARK: - Shimmer Overlay
    
    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .white.opacity(0.3), location: 0.45),
                    .init(color: .white.opacity(0.5), location: 0.5),
                    .init(color: .white.opacity(0.3), location: 0.55),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 0.5)
            .offset(x: shimmerPhase * geometry.size.width * 1.5)
            .rotationEffect(.degrees(20))
        }
        .allowsHitTesting(false)
    }
    
    // MARK: - Glow Overlay
    
    @ViewBuilder
    private var glowOverlay: some View {
        if hasGlow {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(glowColor.opacity(0.6), lineWidth: 2)
                .blur(radius: 4)
        }
    }
    
    // MARK: - Colors
    
    private var shadowColor: Color {
        switch gradient {
        case .linear(let colors, _, _),
             .radial(let colors, _, _, _),
             .angular(let colors, _, _),
             .conic(let colors, _):
            return colors.last ?? .black
        }
    }
    
    private var glowColor: Color {
        switch gradient {
        case .linear(let colors, _, _),
             .radial(let colors, _, _, _),
             .angular(let colors, _, _),
             .conic(let colors, _):
            return colors.first ?? .white
        }
    }
}

// MARK: - Button Style

/// Custom button style with press animation for gradient buttons.
private struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Convenience Initializers

extension GradientButton {
    /// Creates a gradient button with preset gradient.
    public init(
        _ title: String,
        preset: GradientType,
        icon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.init(title, gradient: preset, icon: icon, action: action)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 20) {
        GradientButton("Sunrise", gradient: .sunrise) { }
        
        GradientButton("Ocean", gradient: .ocean, hasShimmer: true) { }
        
        GradientButton("Forest", gradient: .forest, hasGlow: true) { }
        
        GradientButton(
            "Premium",
            gradient: .linear(
                colors: [.purple, .pink, .orange],
                startPoint: .leading,
                endPoint: .trailing
            ),
            hasShimmer: true,
            hasGlow: true,
            icon: Image(systemName: "crown.fill")
        ) { }
        
        GradientButton(
            "Fire",
            gradient: .fire,
            icon: Image(systemName: "flame.fill")
        ) { }
    }
    .padding()
}
#endif
