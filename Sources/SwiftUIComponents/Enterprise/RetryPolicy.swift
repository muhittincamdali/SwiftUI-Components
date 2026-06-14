import Foundation

/// A resilient retry mechanism with exponential backoff.
public struct SwiftUIComponentsRetryPolicy: Sendable {
    public static func retry<T: Sendable>(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 1.0,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        var currentAttempt = 0
        while true {
            do {
                return try await operation()
            } catch {
                currentAttempt += 1
                if currentAttempt >= maxAttempts {
                    throw error
                }
                let delay = baseDelay * pow(2.0, Double(currentAttempt - 1))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
}
