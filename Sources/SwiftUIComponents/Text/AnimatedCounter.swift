import SwiftUI

/// A view that animates smoothly between numeric values.
///
/// Use `AnimatedCounter` for dashboards, scores, or any numeric display
/// that benefits from smooth transitions when the value changes.
///
/// ```swift
/// @State private var score: Double = 0
///
/// AnimatedCounter(value: score, format: "%.0f")
///     .font(.system(size: 48, weight: .bold))
///
/// Button("Add 100") { score += 100 }
/// ```
public struct AnimatedCounter: View {
    // MARK: - Properties

    private let value: Double
    private let format: String
    private let duration: Double

    @State private var displayedValue: Double = 0

    // MARK: - Initialization

    /// Creates a new animated counter.
    /// - Parameters:
    ///   - value: The target numeric value to animate towards.
    ///   - format: A format string for displaying the number. Defaults to `"%.0f"`.
    ///   - duration: The animation duration in seconds. Defaults to `0.6`.
    public init(
        value: Double,
        format: String = "%.0f",
        duration: Double = 0.6
    ) {
        self.value = value
        self.format = format
        self.duration = duration
    }

    // MARK: - Body

    public var body: some View {
        Text(String(format: format, displayedValue))
            .monospacedDigit()
            .contentTransition(.numericText(value: displayedValue))
            .onAppear {
                displayedValue = value
            }
            .onChange(of: value) { _, newValue in
                withAnimation(.easeInOut(duration: duration)) {
                    displayedValue = newValue
                }
            }
    }
}

#if DEBUG
struct AnimatedCounterPreview: View {
    @State private var count: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            AnimatedCounter(value: count, format: "%.0f")
                .font(.system(size: 64, weight: .bold))

            AnimatedCounter(value: count, format: "$%.2f")
                .font(.title)
                .foregroundStyle(.green)

            Button("Add 50") {
                count += 50
            }
        }
    }
}

#Preview {
    AnimatedCounterPreview()
}
#endif
