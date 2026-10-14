import SwiftUI

/// The four directions ``SwiftUICore/View/onSwipe(_:minimumDistance:tolerance:perform:)`` reports.
public enum SwipeDirection: String, CaseIterable, Sendable {
    case left, right, up, down

    /// The default VoiceOver action name, such as "Swipe left".
    public var accessibilityName: String {
        "Swipe \(rawValue)"
    }

    /// Returns the direction of a drag, or `nil` when it is too short or too diagonal.
    ///
    /// - Parameters:
    ///   - translation: The drag's translation in points. Positive `height` is downward, as in
    ///     SwiftUI's coordinate space.
    ///   - minimumDistance: The shortest drag, in points, that counts as a swipe.
    ///   - tolerance: How far the drag may point away from the nearest axis. Clamped to 0–45°.
    public static func classify(
        _ translation: CGSize,
        minimumDistance: CGFloat = 50,
        tolerance: Angle = .degrees(30)
    ) -> SwipeDirection? {
        let distance = hypot(translation.width, translation.height)
        guard distance >= max(minimumDistance, .ulpOfOne) else { return nil }

        // Measure the angle counterclockwise from the positive x axis, with up as positive.
        let degrees = atan2(-translation.height, translation.width) * 180 / .pi
        let limit = min(max(tolerance.degrees, 0), 45)
        let axes: [(direction: SwipeDirection, degrees: Double)] = [
            (.right, 0), (.up, 90), (.left, 180), (.left, -180), (.down, -90),
        ]
        return axes.first { abs(degrees - $0.degrees) <= limit }?.direction
    }
}

private struct SwipeModifier: ViewModifier {
    let directions: Set<SwipeDirection>
    let minimumDistance: CGFloat
    let tolerance: Angle
    let addsAccessibilityActions: Bool
    let action: (SwipeDirection) -> Void

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: min(minimumDistance, 20))
                    .onEnded { value in
                        // The predicted end lets a short, fast flick count as a swipe.
                        let translation = farther(value.translation, value.predictedEndTranslation)
                        guard let direction = SwipeDirection.classify(
                            translation,
                            minimumDistance: minimumDistance,
                            tolerance: tolerance
                        ), directions.contains(direction) else { return }
                        action(direction)
                    }
            )
            .accessibilityActions {
                if addsAccessibilityActions {
                    ForEach(SwipeDirection.allCases.filter(directions.contains), id: \.self) { direction in
                        Button(direction.accessibilityName) { action(direction) }
                    }
                }
            }
    }

    private func farther(_ first: CGSize, _ second: CGSize) -> CGSize {
        hypot(second.width, second.height) > hypot(first.width, first.height) ? second : first
    }
}

extension View {
    /// Calls `action` when the user swipes across the view in one of `directions`.
    ///
    /// Each direction is also offered as a named accessibility action ("Swipe left", …), so
    /// VoiceOver and Switch Control users can trigger it without the gesture.
    ///
    /// ```swift
    /// PhotoView(photo)
    ///     .onSwipe([.left, .right]) { direction in
    ///         direction == .left ? showNext() : showPrevious()
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - directions: The directions to report. Other swipes are ignored.
    ///   - minimumDistance: The shortest swipe, in points.
    ///   - tolerance: How far a swipe may point away from the horizontal or vertical axis.
    ///   - action: Called with the direction of each recognized swipe.
    public func onSwipe(
        _ directions: Set<SwipeDirection> = Set(SwipeDirection.allCases),
        minimumDistance: CGFloat = 50,
        tolerance: Angle = .degrees(30),
        perform action: @escaping (SwipeDirection) -> Void
    ) -> some View {
        modifier(SwipeModifier(
            directions: directions,
            minimumDistance: minimumDistance,
            tolerance: tolerance,
            addsAccessibilityActions: true,
            action: action
        ))
    }

    /// Like ``SwiftUICore/View/onSwipe(_:minimumDistance:tolerance:perform:)`` but without the
    /// accessibility actions, for callers that provide their own.
    func onSwipeWithoutAccessibilityActions(
        minimumDistance: CGFloat,
        perform action: @escaping (SwipeDirection) -> Void
    ) -> some View {
        modifier(SwipeModifier(
            directions: Set(SwipeDirection.allCases),
            minimumDistance: minimumDistance,
            tolerance: .degrees(30),
            addsAccessibilityActions: false,
            action: action
        ))
    }
}
