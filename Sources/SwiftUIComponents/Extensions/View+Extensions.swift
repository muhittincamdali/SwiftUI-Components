import SwiftUI

// MARK: - Visibility

extension View {
    /// Toggles visibility of the view while preserving its layout space.
    /// - Parameter isVisible: Whether the view should be visible.
    /// - Returns: The view with adjusted opacity.
    @ViewBuilder
    public func visible(_ isVisible: Bool) -> some View {
        if isVisible {
            self
        } else {
            self.hidden()
        }
    }
}

// MARK: - Read Size

/// A preference key for reading view sizes.
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    /// Reads the size of the view and reports it through a closure.
    /// - Parameter onChange: Called with the measured size when it changes.
    /// - Returns: The unmodified view with size reading attached.
    public func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

// MARK: - Corner Radius (Specific Corners)

#if canImport(UIKit)
extension View {
    /// Applies a corner radius to specific corners.
    /// - Parameters:
    ///   - radius: The corner radius value.
    ///   - corners: The corners to round.
    /// - Returns: The view with selective corner rounding.
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

/// A shape that rounds specific corners.
struct RoundedCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#endif

// MARK: - On First Appear

extension View {
    /// Performs an action only the first time the view appears.
    /// - Parameter action: The closure to execute on first appearance.
    /// - Returns: The modified view.
    public func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(action: action))
    }
}

/// A modifier that fires its action only on the initial appearance.
struct FirstAppearModifier: ViewModifier {
    let action: () -> Void
    @State private var hasAppeared = false

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
