import SwiftUI

/// A view modifier that conditionally applies a transformation.
///
/// Use `conditionalModifier` to avoid breaking the view builder chain
/// when you need to apply modifiers based on a boolean condition.
///
/// ```swift
/// Text("Hello")
///     .conditionalModifier(isHighlighted) { view in
///         view.foregroundStyle(.red).bold()
///     }
/// ```
public struct ConditionalModifier<Transform: View>: ViewModifier {
    // MARK: - Properties

    private let condition: Bool
    private let transform: (Content) -> Transform

    // MARK: - Initialization

    /// Creates a conditional modifier.
    /// - Parameters:
    ///   - condition: The boolean condition.
    ///   - transform: The transformation applied when the condition is `true`.
    public init(condition: Bool, transform: @escaping (Content) -> Transform) {
        self.condition = condition
        self.transform = transform
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        if condition {
            transform(content)
        } else {
            content
        }
    }
}

extension View {
    /// Conditionally applies a view transformation.
    /// - Parameters:
    ///   - condition: The boolean condition to evaluate.
    ///   - transform: The transformation to apply when `condition` is `true`.
    /// - Returns: Either the transformed view or the original view.
    public func conditionalModifier<Transform: View>(
        _ condition: Bool,
        transform: @escaping (Self) -> Transform
    ) -> some View {
        Group {
            if condition {
                transform(self)
            } else {
                self
            }
        }
    }
}
