import Foundation
import Observation

/// Runs a slow check, such as asking a server whether a user name is free, after the user
/// stops typing, and keeps only the answer for the latest value.
///
/// Call ``validate(_:)`` from `task(id:)` so SwiftUI cancels the previous check whenever the
/// value changes:
///
/// ```swift
/// @State private var availability = AsyncValidation<String> { name in
///     try await api.isAvailable(name) ? .valid : .invalid("This name is taken")
/// }
///
/// TextInputField(text: $name)
///     .task(id: name) { await availability.validate(name) }
/// ```
@MainActor
@Observable
public final class AsyncValidation<Value: Sendable> {
    /// Where the latest check is.
    public enum State: Equatable, Sendable {
        /// No check has run since creation or ``AsyncValidation/reset()``.
        case idle
        /// Waiting for the debounce interval to pass or for the check to return.
        case checking
        /// The check accepted the value.
        case valid
        /// The check rejected the value with a message.
        case invalid(String)
        /// The check threw an error other than cancellation, such as a network failure.
        case failed(String)
    }

    /// The state of the most recent call to ``validate(_:)``.
    public private(set) var state: State = .idle

    private let debounce: Duration
    private let check: @Sendable (Value) async throws -> ValidationResult
    private var generation = 0

    /// Creates a validator that waits `debounce` before calling `check`.
    public init(
        debounce: Duration = .milliseconds(400),
        check: @escaping @Sendable (Value) async throws -> ValidationResult
    ) {
        self.debounce = debounce
        self.check = check
    }

    /// `true` when the latest check accepted the value.
    public var isValid: Bool { state == .valid }

    /// The message to show under the field: the rejection or failure message, otherwise `nil`.
    public var message: String? {
        switch state {
        case .invalid(let message), .failed(let message): message
        case .idle, .checking, .valid: nil
        }
    }

    /// Waits for the debounce interval, then checks `value`.
    ///
    /// If the calling task is cancelled, or a newer call starts, before the check returns, the
    /// result is dropped. A cancelled latest call sets the state back to ``State/idle``.
    public func validate(_ value: Value) async {
        generation += 1
        let current = generation
        state = .checking

        let outcome: State
        do {
            if debounce > .zero {
                try await Task.sleep(for: debounce)
            }
            let result = try await check(value)
            try Task.checkCancellation()
            outcome = result.message.map(State.invalid) ?? .valid
        } catch is CancellationError {
            outcome = .idle
        } catch {
            outcome = .failed(error.localizedDescription)
        }

        // A newer call owns the state; this answer is for an outdated value.
        guard current == generation else { return }
        state = outcome
    }

    /// Drops any pending answer and returns to ``State/idle``.
    public func reset() {
        generation += 1
        state = .idle
    }
}
