import SwiftUI

/// Places content on a rounded material background with a hairline border.
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
    /// Applies ``SurfaceModifier`` with the given corner radius.
    func surface(cornerRadius: CGFloat = 16) -> some View {
        modifier(SurfaceModifier(cornerRadius: cornerRadius))
    }
}
