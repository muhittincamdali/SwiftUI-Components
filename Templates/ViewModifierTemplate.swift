// ViewModifierTemplate.swift
// SwiftUI-Components
//
// Template for creating view modifiers

import SwiftUI

// MARK: - View Modifier

/// A view modifier that applies a custom effect to any view.
///
/// Use the `.customEffect()` modifier to apply this effect:
///
/// ```swift
/// Text("Hello, World!")
///     .customEffect()
/// ```
///
/// ## Customization
///
/// You can customize the effect with parameters:
///
/// ```swift
/// Text("Hello, World!")
///     .customEffect(intensity: 0.8, isAnimated: true)
/// ```
public struct CustomEffectModifier: ViewModifier {
    // MARK: - Properties
    
    /// The intensity of the effect (0.0 to 1.0)
    private let intensity: Double
    
    /// Whether to animate the effect
    private let isAnimated: Bool
    
    /// The duration of the animation
    private let duration: Double
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // MARK: - State
    
    @State private var isActive = false
    
    // MARK: - Initialization
    
    /// Creates a new custom effect modifier.
    ///
    /// - Parameters:
    ///   - intensity: The effect intensity from 0.0 to 1.0. Defaults to 1.0.
    ///   - isAnimated: Whether to animate the effect. Defaults to false.
    ///   - duration: The animation duration in seconds. Defaults to 0.3.
    public init(
        intensity: Double = 1.0,
        isAnimated: Bool = false,
        duration: Double = 0.3
    ) {
        self.intensity = max(0, min(1, intensity))
        self.isAnimated = isAnimated
        self.duration = duration
    }
    
    // MARK: - Body
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                effectOverlay
            }
            .scaleEffect(isActive ? 1.05 : 1.0)
            .animation(effectAnimation, value: isActive)
            .onAppear {
                if isAnimated && !reduceMotion {
                    startAnimation()
                }
            }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var effectOverlay: some View {
        if intensity > 0 {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2 * intensity
                )
                .opacity(0.6 * intensity)
        }
    }
    
    // MARK: - Computed Properties
    
    private var gradientColors: [Color] {
        colorScheme == .dark
            ? [.white.opacity(0.3), .white.opacity(0.1)]
            : [.black.opacity(0.1), .black.opacity(0.05)]
    }
    
    private var effectAnimation: Animation? {
        guard isAnimated && !reduceMotion else { return nil }
        return .easeInOut(duration: duration).repeatForever(autoreverses: true)
    }
    
    // MARK: - Methods
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            isActive = true
        }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a custom effect to the view.
    ///
    /// - Parameters:
    ///   - intensity: The effect intensity from 0.0 to 1.0.
    ///   - isAnimated: Whether to animate the effect.
    ///   - duration: The animation duration.
    /// - Returns: A view with the custom effect applied.
    public func customEffect(
        intensity: Double = 1.0,
        isAnimated: Bool = false,
        duration: Double = 0.3
    ) -> some View {
        modifier(CustomEffectModifier(
            intensity: intensity,
            isAnimated: isAnimated,
            duration: duration
        ))
    }
}

// MARK: - Shimmer Modifier (Example Implementation)

/// A modifier that adds a shimmer loading effect.
public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    let isActive: Bool
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    shimmerOverlay
                }
            }
            .onAppear {
                if isActive {
                    startShimmer()
                }
            }
    }
    
    @ViewBuilder
    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    .white.opacity(0.4),
                    .clear
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width * 2)
            .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
        }
        .mask(content)
    }
    
    private func startShimmer() {
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            phase = 1
        }
    }
}

extension View {
    /// Adds a shimmer loading effect to the view.
    ///
    /// ```swift
    /// Rectangle()
    ///     .shimmer(isActive: isLoading)
    /// ```
    ///
    /// - Parameter isActive: Whether the shimmer effect is active.
    public func shimmer(isActive: Bool) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}

// MARK: - Glow Modifier (Example Implementation)

/// A modifier that adds a glow effect around the view.
public struct GlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let isActive: Bool
    
    @State private var isAnimating = false
    
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: isActive ? color.opacity(isAnimating ? 0.8 : 0.4) : .clear,
                radius: radius
            )
            .animation(
                isActive ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : nil,
                value: isAnimating
            )
            .onAppear {
                if isActive {
                    isAnimating = true
                }
            }
            .onChange(of: isActive) { _, newValue in
                isAnimating = newValue
            }
    }
}

extension View {
    /// Adds a glow effect around the view.
    ///
    /// ```swift
    /// Button("Glow") { }
    ///     .glow(color: .blue, radius: 10)
    /// ```
    ///
    /// - Parameters:
    ///   - color: The glow color.
    ///   - radius: The glow radius.
    ///   - isActive: Whether the glow is active.
    public func glow(
        color: Color = .accentColor,
        radius: CGFloat = 8,
        isActive: Bool = true
    ) -> some View {
        modifier(GlowModifier(color: color, radius: radius, isActive: isActive))
    }
}

// MARK: - Previews

#Preview("Custom Effect") {
    VStack(spacing: 20) {
        Text("Default Effect")
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .customEffect()
        
        Text("Animated Effect")
            .padding()
            .background(Color.purple)
            .cornerRadius(8)
            .customEffect(isAnimated: true)
        
        Text("Low Intensity")
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .customEffect(intensity: 0.3)
    }
    .padding()
}

#Preview("Shimmer") {
    VStack(spacing: 20) {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 100)
            .shimmer(isActive: true)
        
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 20)
            .shimmer(isActive: true)
        
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 20)
            .frame(width: 200)
            .shimmer(isActive: true)
    }
    .padding()
}

#Preview("Glow") {
    VStack(spacing: 20) {
        Text("Blue Glow")
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
            .glow(color: .blue)
        
        Text("Purple Glow")
            .padding()
            .background(Color.purple)
            .cornerRadius(8)
            .foregroundColor(.white)
            .glow(color: .purple, radius: 15)
    }
    .padding()
}
