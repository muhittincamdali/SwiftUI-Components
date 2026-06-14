import Foundation

/// A circuit breaker to prevent cascading failures.
public actor SwiftUIComponentsCircuitBreaker {
    public enum State: Sendable { case closed, open, halfOpen }
    
    private var state: State = .closed
    private var failureCount = 0
    private let threshold = 5
    
    public init() {}
    
    public func execute<T: Sendable>(_ operation: @Sendable () async throws -> T) async throws -> T {
        if state == .open {
            throw CircuitError.circuitOpen
        }
        
        do {
            let result = try await operation()
            if state == .halfOpen { state = .closed }
            failureCount = 0
            return result
        } catch {
            failureCount += 1
            if failureCount >= threshold {
                state = .open
                // Schedule half-open transition
            }
            throw error
        }
    }
}
public enum CircuitError: Error { case circuitOpen }
