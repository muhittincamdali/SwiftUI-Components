import Foundation

/// The position in a form that is split into steps, and which steps are done.
///
/// `StepFlow` holds no views, so the navigation rules can be tested on their own.
/// ``MultiStepForm`` uses it to drive ``StepsIndicator`` and the Back and Next buttons.
public struct StepFlow: Equatable, Sendable {
    /// The number of steps. Always at least 1.
    public let count: Int

    /// The index of the step on screen, from `0` to `count - 1`.
    public private(set) var current: Int

    /// The indexes of the steps the user has completed with ``advance()``.
    public private(set) var completed: Set<Int> = []

    /// Creates a flow with `count` steps, starting at `current`.
    ///
    /// `count` is raised to 1 and `current` is clamped to the valid range.
    public init(count: Int, current: Int = 0) {
        self.count = max(1, count)
        self.current = min(max(0, current), self.count - 1)
    }

    /// `true` on the first step.
    public var isFirst: Bool { current == 0 }

    /// `true` on the last step.
    public var isLast: Bool { current == count - 1 }

    /// `true` once every step has been completed.
    public var isFinished: Bool { completed.count == count }

    /// The share of completed steps, from 0 to 1.
    public var progress: Double { Double(completed.count) / Double(count) }

    /// Marks the current step as completed and moves to the next one.
    ///
    /// On the last step it only marks the step as completed. Returns `true` when the current
    /// step changed.
    @discardableResult
    public mutating func advance() -> Bool {
        completed.insert(current)
        guard !isLast else { return false }
        current += 1
        return true
    }

    /// Moves to the previous step. Completed steps stay completed.
    @discardableResult
    public mutating func goBack() -> Bool {
        guard !isFirst else { return false }
        current -= 1
        return true
    }

    /// `true` when every step before `index` is completed, so the user may open it directly.
    public func canJump(to index: Int) -> Bool {
        guard (0..<count).contains(index) else { return false }
        return (0..<index).allSatisfy(completed.contains)
    }

    /// Opens step `index` if ``canJump(to:)`` allows it. Returns `true` when it did.
    @discardableResult
    public mutating func jump(to index: Int) -> Bool {
        guard canJump(to: index) else { return false }
        current = index
        return true
    }

    /// Returns to the first step and clears the completed steps.
    public mutating func restart() {
        current = 0
        completed = []
    }
}
