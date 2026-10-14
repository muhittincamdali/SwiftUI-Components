import CoreGraphics
import Foundation
import Testing
@testable import SwiftUIComponents

/// Values an app passes in, such as a NaN progress or a negative count, used to stop the
/// process in `Int(_:)`, `Duration.seconds(_:)` or `0..<count`. These pin the clamping.
@Suite("Numeric conversions")
struct NumericConversionTests {
    @Test("Int(saturating:) never traps", arguments: [
        (Double.nan, 0), (.infinity, Int.max), (-.infinity, Int.min), (1e300, Int.max),
        (-1e300, Int.min), (2.9, 2), (-2.9, -2), (Double(Int.max), Int.max), (Double(Int.min), Int.min),
    ])
    func saturatingInt(value: Double, expected: Int) {
        #expect(Int(saturating: value) == expected)
    }

    @Test func clampedSecondsNeverTraps() {
        #expect(Duration.clampedSeconds(.nan) == .zero)
        #expect(Duration.clampedSeconds(-1) == .zero)
        #expect(Duration.clampedSeconds(.infinity) == Duration.longestWait)
        #expect(Duration.clampedSeconds(1.5) == .milliseconds(1_500))
    }

    @MainActor
    @Test("Ticker returns at once for an interval that is not positive", arguments: [0, -1, Double.nan])
    func tickerIgnoresNonPositiveIntervals(interval: Double) async {
        var ticks = 0
        await Ticker.run(every: interval) {
            ticks += 1
            return true
        }
        #expect(ticks == 0)
    }

    @Test("noise texture draws a bounded number of dots", arguments: [
        (CGSize(width: 100, height: 100), 1_000),
        (CGSize(width: 10_000, height: 10_000), 4_000),
        (CGSize(width: 0, height: 500), 0),
        (CGSize(width: CGFloat.infinity, height: 10), 0),
        (CGSize(width: CGFloat.nan, height: 10), 0),
        (CGSize(width: -50, height: -50), 0),
    ])
    func noiseDotCount(size: CGSize, expected: Int) {
        #expect(NoiseView.dotCount(for: size) == expected)
    }
}
