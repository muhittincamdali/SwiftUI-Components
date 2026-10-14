import SwiftUI

/// A glassmorphism-styled card with blur and transparency effects.
///
/// `GlassCard` creates a frosted glass appearance using blur and
/// gradient overlays, perfect for modern UI designs.
///
/// ```swift
/// GlassCard {
///     VStack {
///         Text("Glass Effect")
///         Text("Beautiful blur")
///     }
/// }
/// ```
public struct GlassCard<Content: View>: View {
    // MARK: - Types
    
    /// Preset glass styles.
    public enum Style {
        case light
        case dark
        case colorful(Color)
        case frosted
        case crystal
        
        var tintColor: Color {
            switch self {
            case .light: return .white
            case .dark: return .black
            case .colorful(let color): return color
            case .frosted: return .white
            case .crystal: return .clear
            }
        }
        
        var tintOpacity: Double {
            switch self {
            case .light: return 0.2
            case .dark: return 0.3
            case .colorful: return 0.15
            case .frosted: return 0.4
            case .crystal: return 0.1
            }
        }
        
        var blurAmount: CGFloat {
            switch self {
            case .light, .dark: return 10
            case .colorful: return 15
            case .frosted: return 20
            case .crystal: return 8
            }
        }
    }
    
    // MARK: - Properties
    
    private let style: Style
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let borderOpacity: Double
    private let shadowRadius: CGFloat
    private let shadowOpacity: Double
    private let padding: CGFloat
    private let content: () -> Content
    
    // MARK: - Initialization
    
    /// Creates a new glass card.
    /// - Parameters:
    ///   - style: The glass style preset. Defaults to `.light`.
    ///   - cornerRadius: Corner radius. Defaults to `20`.
    ///   - borderWidth: Border width. Defaults to `1`.
    ///   - borderOpacity: Border opacity. Defaults to `0.3`.
    ///   - shadowRadius: Shadow blur radius. Defaults to `10`.
    ///   - shadowOpacity: Shadow opacity. Defaults to `0.1`.
    ///   - padding: Inner padding. Defaults to `20`.
    ///   - content: The card content.
    public init(
        style: Style = .light,
        cornerRadius: CGFloat = 20,
        borderWidth: CGFloat = 1,
        borderOpacity: Double = 0.3,
        shadowRadius: CGFloat = 10,
        shadowOpacity: Double = 0.1,
        padding: CGFloat = 20,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.padding = padding
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        content()
            .padding(padding)
            .background(glassBackground)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(glassBorder)
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 5)
    }
    
    // MARK: - Glass Background
    
    private var glassBackground: some View {
        ZStack {
            // Base blur layer
            Rectangle()
                .fill(.ultraThinMaterial)
            
            // Tint overlay
            Rectangle()
                .fill(style.tintColor.opacity(style.tintOpacity))
            
            // Gradient highlight
            LinearGradient(
                colors: [
                    .white.opacity(0.2),
                    .white.opacity(0.05),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Glass Border
    
    private var glassBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                LinearGradient(
                    colors: [
                        .white.opacity(borderOpacity),
                        .white.opacity(borderOpacity * 0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: borderWidth
            )
    }
}

// MARK: - Glass Card with Noise Texture

/// A glass card with optional noise texture for added realism.
public struct TexturedGlassCard<Content: View>: View {
    private let style: GlassCard<Content>.Style
    private let cornerRadius: CGFloat
    private let noiseOpacity: Double
    private let padding: CGFloat
    private let content: () -> Content
    
    /// Creates a textured glass card.
    public init(
        style: GlassCard<Content>.Style = .light,
        cornerRadius: CGFloat = 20,
        noiseOpacity: Double = 0.03,
        padding: CGFloat = 20,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.noiseOpacity = noiseOpacity
        self.padding = padding
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding(padding)
            .background(
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    NoiseView(opacity: noiseOpacity)
                    
                    LinearGradient(
                        colors: [
                            .white.opacity(0.25),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Noise View

/// A procedural noise texture view.
private struct NoiseView: View {
    let opacity: Double
    
    var body: some View {
        Canvas { context, size in
            for _ in 0..<Int(size.width * size.height * 0.1) {
                let x = CGFloat.random(in: 0..<size.width)
                let y = CGFloat.random(in: 0..<size.height)
                let gray = Double.random(in: 0...1)
                
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                    with: .color(.gray.opacity(gray * opacity))
                )
            }
        }
    }
}

// MARK: - Animated Glass Card

/// A glass card with animated gradient shimmer effect.
public struct AnimatedGlassCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let animationDuration: Double
    private let content: () -> Content
    
    @State private var phase: CGFloat = 0
    
    /// Creates an animated glass card.
    public init(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 20,
        animationDuration: Double = 3.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.animationDuration = animationDuration
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding(padding)
            .background(
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    animatedGradient
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        AngularGradient(
                            colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.1),
                                .white.opacity(0.4)
                            ],
                            center: .center,
                            angle: .degrees(phase * 360)
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .onAppear {
                withAnimation(
                    .linear(duration: animationDuration)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
    
    private var animatedGradient: some View {
        LinearGradient(
            colors: [
                .white.opacity(0.1),
                .white.opacity(0.2),
                .white.opacity(0.1)
            ],
            startPoint: UnitPoint(x: phase - 0.5, y: phase - 0.5),
            endPoint: UnitPoint(x: phase + 0.5, y: phase + 0.5)
        )
    }
}

// MARK: - Glass Card Modifier

/// A modifier that applies glass effect to any view.
public struct GlassModifier: ViewModifier {
    let style: GlassCard<EmptyView>.Style
    let cornerRadius: CGFloat
    
    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(style.tintColor.opacity(style.tintOpacity))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    /// Applies a glass effect to the view.
    public func glassEffect(
        style: GlassCard<EmptyView>.Style = .light,
        cornerRadius: CGFloat = 16
    ) -> some View {
        modifier(GlassModifier(style: style, cornerRadius: cornerRadius))
    }
}

#if DEBUG
#Preview {
    ZStack {
        // Background gradient
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 20) {
            GlassCard(style: .light) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Light Glass")
                        .font(.headline)
                    Text("Beautiful frosted effect")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            GlassCard(style: .dark) {
                Text("Dark Glass Style")
                    .foregroundStyle(.white)
            }
            
            AnimatedGlassCard {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Animated Border")
                }
                .foregroundStyle(.white)
            }
            
            TexturedGlassCard {
                Text("With Noise Texture")
            }
        }
        .padding()
    }
}
#endif
