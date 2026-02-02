import SwiftUI

/// A skeleton loading placeholder with an animated shimmer effect.
///
/// Use `ShimmerView` to indicate content is loading. The shimmer slides
/// across the view in a continuous loop.
///
/// ```swift
/// ShimmerView()
///     .frame(height: 200)
///     .clipShape(RoundedRectangle(cornerRadius: 12))
/// ```
public struct ShimmerView: View {
    // MARK: - Properties

    private let baseColor: Color
    private let highlightColor: Color
    private let speed: Double
    private let angle: Double

    @State private var phase: CGFloat = -1.0

    // MARK: - Initialization

    /// Creates a new shimmer view.
    /// - Parameters:
    ///   - baseColor: The base color of the shimmer. Defaults to a light gray.
    ///   - highlightColor: The highlight sweep color. Defaults to white with low opacity.
    ///   - speed: The animation duration for one sweep cycle. Defaults to `1.5`.
    ///   - angle: The angle of the shimmer in degrees. Defaults to `20`.
    public init(
        baseColor: Color = Color(.systemGray5),
        highlightColor: Color = Color(.systemGray4),
        speed: Double = 1.5,
        angle: Double = 20
    ) {
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.speed = speed
        self.angle = angle
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            baseColor
                .overlay(
                    shimmerGradient(width: geometry.size.width)
                )
                .clipped()
        }
        .onAppear {
            withAnimation(
                .linear(duration: speed)
                .repeatForever(autoreverses: false)
            ) {
                phase = 1.0
            }
        }
    }

    // MARK: - Helpers

    private func shimmerGradient(width: CGFloat) -> some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: highlightColor.opacity(0.6), location: 0.4),
                .init(color: highlightColor, location: 0.5),
                .init(color: highlightColor.opacity(0.6), location: 0.6),
                .init(color: .clear, location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: width * 1.5)
        .rotationEffect(.degrees(angle))
        .offset(x: phase * width * 1.5)
    }
}

// MARK: - Shimmer Modifier

/// A view modifier that adds a shimmer overlay to any view.
public struct ShimmerModifier: ViewModifier {
    private let isActive: Bool

    /// Creates a shimmer modifier.
    /// - Parameter isActive: Whether shimmer is active. Defaults to `true`.
    public init(isActive: Bool = true) {
        self.isActive = isActive
    }

    public func body(content: Content) -> some View {
        if isActive {
            content.overlay(
                ShimmerView()
                    .allowsHitTesting(false)
            )
        } else {
            content
        }
    }
}

extension View {
    /// Adds a shimmer loading effect to the view.
    /// - Parameter isActive: Whether the shimmer is active.
    /// - Returns: The modified view.
    public func shimmer(isActive: Bool = true) -> some View {
        modifier(ShimmerModifier(isActive: isActive))
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        ShimmerView()
            .frame(height: 20)
            .clipShape(Capsule())

        ShimmerView()
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))

        ShimmerView()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
    }
    .padding()
}
#endif
