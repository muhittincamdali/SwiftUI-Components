import SwiftUI

/// Main entry point for the SwiftUI Components toolkit.
public enum SwiftUIComponents {
    public static let version = "2.0.0"
}

/// A world-class standard for rounded material surfaces.
public struct SurfaceModifier: ViewModifier {
    public let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat = 16) {
        self.cornerRadius = cornerRadius
    }
    
    public func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
    }
}

public extension View {
    /// Applies a world-class Surface material effect.
    func surface(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(SurfaceModifier(cornerRadius: cornerRadius))
    }
}
