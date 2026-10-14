import SwiftUI

/// The rule behind ``SwiftUICore/View/onEdgeSwipe(from:edgeWidth:minimumDistance:accessibilityActionName:perform:)``,
/// exposed so it can be tested and reused.
public enum EdgeSwipe {
    /// Returns `true` when a drag that started at `start` and moved by `translation` began
    /// within `edgeWidth` points of `edge` and travelled at least `minimumDistance` points
    /// away from it.
    ///
    /// Coordinates are in the view's local space, where `.leading` is the side with x = 0.
    public static func recognizes(
        start: CGPoint,
        translation: CGSize,
        in size: CGSize,
        edge: Edge,
        edgeWidth: CGFloat = 24,
        minimumDistance: CGFloat = 60
    ) -> Bool {
        switch edge {
        case .leading:
            start.x <= edgeWidth && translation.width >= minimumDistance
        case .trailing:
            start.x >= size.width - edgeWidth && -translation.width >= minimumDistance
        case .top:
            start.y <= edgeWidth && translation.height >= minimumDistance
        case .bottom:
            start.y >= size.height - edgeWidth && -translation.height >= minimumDistance
        }
    }
}

private struct EdgeSwipeModifier: ViewModifier {
    let edge: Edge
    let edgeWidth: CGFloat
    let minimumDistance: CGFloat
    let accessibilityActionName: String
    let action: () -> Void

    @State private var size: CGSize = .zero
    @State private var didFire = false

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        guard !didFire, EdgeSwipe.recognizes(
                            start: value.startLocation,
                            translation: value.translation,
                            in: size,
                            edge: edge,
                            edgeWidth: edgeWidth,
                            minimumDistance: minimumDistance
                        ) else { return }
                        didFire = true
                        action()
                    }
                    .onEnded { _ in didFire = false }
            )
            .accessibilityAction(named: Text(accessibilityActionName), action)
    }
}

extension View {
    /// Calls `action` once when the user drags in from `edge`, like the system's swipe-to-go-back.
    ///
    /// The action fires as soon as the drag has travelled `minimumDistance`, not when the finger
    /// lifts, and at most once per drag. It is also offered to VoiceOver as a named action.
    ///
    /// ```swift
    /// ArticleView(article)
    ///     .onEdgeSwipe(from: .leading, accessibilityActionName: "Show menu") {
    ///         showsMenu = true
    ///     }
    /// ```
    public func onEdgeSwipe(
        from edge: Edge,
        edgeWidth: CGFloat = 24,
        minimumDistance: CGFloat = 60,
        accessibilityActionName: String,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(EdgeSwipeModifier(
            edge: edge,
            edgeWidth: edgeWidth,
            minimumDistance: minimumDistance,
            accessibilityActionName: accessibilityActionName,
            action: action
        ))
    }
}
