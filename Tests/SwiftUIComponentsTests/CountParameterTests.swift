import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

/// Counts such as a page total or a column count come from the app. A negative one used to
/// build an invalid range, which stops the process.
@Suite("Count parameters")
struct CountParameterTests {
    @Test("page window stays inside the pages for any input", arguments: [
        (0, -3, 7, 0..<0),
        (Int.max, 10, 7, 3..<10),
        (Int.min, 10, 7, 0..<7),
        (5, 10, Int.max, 0..<10),
        (2, 10, 0, 2..<3),
        (Int.max, Int.max, Int.max, 0..<Int.max),
    ])
    func pageWindow(current: Int, total: Int, visible: Int, expected: Range<Int>) {
        #expect(ScrollingPageIndicator.visibleRange(currentPage: current, totalPages: total, visibleDots: visible) == expected)
    }

    /// Each of these used to stop the process with `0..<count` or `Array(repeating:count:)`.
    @MainActor
    @Test("views render with zero and negative counts", arguments: [0, -1])
    func rendersWithoutACount(count: Int) throws {
        let views = VStack {
            DotLoader(dotCount: count)
            SkeletonView(template: .text(lines: count, lastLineWidth: 0.6))
            PageIndicator(currentPage: .constant(0), totalPages: count)
            ScrollingPageIndicator(currentPage: .constant(0), totalPages: count, visibleDots: count)
            CheckboxGroup(selections: .constant(Set<Int>()), options: [(1, "One")], style: .grid(columns: count))
            TimeSlotPicker(selectedSlot: .constant(nil), slots: ["9:00"], columns: count)
            StatGrid(stats: [], columns: count)
            OTPField(code: .constant(""), length: count)
            SecurePINField(pin: .constant(""), length: count)
            PinInput(code: .constant(""), length: count)
            PasscodeInput(passcode: .constant(""), length: count) { _ in }
        }
        let renderer = ImageRenderer(content: views.frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 0)
    }
}
