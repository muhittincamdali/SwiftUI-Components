import Foundation

// Values such as a progress fraction, a countdown target or a toast duration come from the
// app. `Int(_:)` and `Duration.seconds(_:)` stop the process on NaN and infinity, so the
// components convert through these instead.

extension Int {
    /// Converts `value` toward zero like `Int(_:)`, but returns 0 for NaN and clamps values
    /// outside `Int`'s range, where `Int(_:)` would trap.
    init(saturating value: Double) {
        if value.isNaN {
            self = 0
        } else if value >= Double(Int.max) {
            self = .max
        } else if value < Double(Int.min) {
            self = .min
        } else {
            self = Int(value)
        }
    }
}

extension Duration {
    /// The longest wait the components schedule, about 31 years: long enough to mean "never".
    static let longestWait = Duration.seconds(1_000_000_000)

    /// `seconds` as a duration for `Task.sleep(for:)`. NaN and negative values become zero and
    /// anything longer than ``longestWait``, including infinity, becomes ``longestWait``.
    static func clampedSeconds(_ seconds: Double) -> Duration {
        guard seconds > 0 else { return .zero } // also catches NaN
        guard seconds < 1_000_000_000 else { return longestWait }
        return .seconds(seconds)
    }
}

/// The most steps a slider range may hold. `Slider` keeps one entry per step, so a step of 1 on
/// `0...1e15` asks for petabytes and a step of 0.01 on `0...1_000_000` uses gigabytes. 10,000
/// steps covers every slider a person can drag to one value.
private let maximumSliderStepCount = 10_000.0

extension ClosedRange where Bound == Double {
    /// `step` when `Slider(value:in:step:)` can use it with this range, otherwise nil.
    ///
    /// SwiftUI's `Slider` stops the process ("max stride must be positive") for a step that is
    /// zero, negative, NaN or infinite, and for one larger than the range, which includes any step
    /// on a range such as `5...5`. A range that is not finite, such as `0...Double.infinity`, also
    /// stops it, and a range of more than 10,000 steps allocates one entry per step until memory
    /// runs out. A slider given nil moves continuously instead.
    func sliderStep(_ step: Double?) -> Double? {
        guard let step, step.isFinite, step > 0 else { return nil }
        let span = upperBound - lowerBound
        guard span.isFinite, step <= span, span / step <= maximumSliderStepCount else { return nil }
        return step
    }
}
