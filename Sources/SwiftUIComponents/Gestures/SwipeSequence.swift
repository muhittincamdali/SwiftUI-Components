import SwiftUI

/// Detects a fixed sequence of swipes, such as up, up, down, down, made within a time limit.
///
/// Feed it every swipe with ``register(_:at:)``; it returns `true` when the most recent swipes
/// complete the sequence. Used by
/// ``SwiftUICore/View/onSwipeSequence(_:within:accessibilityActionName:perform:)``.
public struct SwipeSequenceMatcher: Equatable, Sendable {
    /// The swipes to detect, in order.
    public let sequence: [SwipeDirection]
    /// The longest time, in seconds, from the first to the last swipe of the sequence.
    public let timeLimit: TimeInterval

    private var recent: [Entry] = []

    private struct Entry: Equatable, Sendable {
        let direction: SwipeDirection
        let time: Date
    }

    public init(_ sequence: [SwipeDirection], within timeLimit: TimeInterval = 3) {
        self.sequence = sequence
        self.timeLimit = timeLimit
    }

    /// Records a swipe and returns `true` when it completes the sequence.
    ///
    /// After a match the history is cleared, so the next swipe starts a new attempt. An empty
    /// sequence never matches.
    public mutating func register(_ direction: SwipeDirection, at time: Date = .now) -> Bool {
        guard !sequence.isEmpty else { return false }
        recent.append(Entry(direction: direction, time: time))
        recent = Array(recent.suffix(sequence.count))

        guard recent.map(\.direction) == sequence,
              let first = recent.first,
              time.timeIntervalSince(first.time) <= timeLimit
        else { return false }

        recent.removeAll()
        return true
    }

    /// Forgets the swipes recorded so far.
    public mutating func reset() {
        recent.removeAll()
    }
}

private struct SwipeSequenceModifier: ViewModifier {
    let accessibilityActionName: String?
    let minimumDistance: CGFloat
    let action: () -> Void
    @State var matcher: SwipeSequenceMatcher

    func body(content: Content) -> some View {
        content
            .onSwipeWithoutAccessibilityActions(minimumDistance: minimumDistance) { direction in
                if matcher.register(direction) { action() }
            }
            .accessibilityActions {
                if let accessibilityActionName {
                    Button(accessibilityActionName, action: action)
                }
            }
    }
}

extension View {
    /// Calls `action` when the user swipes `sequence` within `timeLimit` seconds, for example to
    /// open a hidden debug menu.
    ///
    /// ```swift
    /// ContentView()
    ///     .onSwipeSequence([.up, .up, .down, .down]) { showsDebugMenu = true }
    /// ```
    ///
    /// - Parameters:
    ///   - sequence: The directions to swipe, in order.
    ///   - timeLimit: The most seconds from the first to the last swipe of the sequence.
    ///   - accessibilityActionName: When set, the action is also offered to VoiceOver under this
    ///     name.
    ///   - action: Called each time the sequence is completed.
    public func onSwipeSequence(
        _ sequence: [SwipeDirection],
        within timeLimit: TimeInterval = 3,
        accessibilityActionName: String? = nil,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(SwipeSequenceModifier(
            accessibilityActionName: accessibilityActionName,
            minimumDistance: 50,
            action: action,
            matcher: SwipeSequenceMatcher(sequence, within: timeLimit)
        ))
    }
}
