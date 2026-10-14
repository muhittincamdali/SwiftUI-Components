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

    /// Each of these used to stop the process with `0..<count`, `Array(repeating:count:)`,
    /// a `prefix`/`suffix` of negative length, or a division by zero.
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
            AvatarGroup(avatars: [.init(initials: "AB"), .init(initials: "CD")], maxVisible: count)
            LiveSparklineChart(data: .constant([1, 3, 2]), maxPoints: count)
            ReadingTimeText("Three short words", wordsPerMinute: count)
        }
        let renderer = ImageRenderer(content: views.frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 0)
    }

    /// A limit below what the layout needs used to slice past the array or build `1...0`.
    @MainActor
    @Test("views render with limits below their minimum", arguments: [-1, 0, 1, 2])
    func rendersBelowTheMinimumLimit(limit: Int) throws {
        let crumbs = ["Home", "Products", "Phones", "Cases"].map { BreadcrumbView.Crumb(title: $0) }
        let views = VStack {
            RatingInput(rating: .constant(1), maxRating: limit)
            RatingDisplay(rating: 1, maxRating: limit)
            DropdownBreadcrumb(crumbs: Array(crumbs.prefix(2)), maxVisible: limit)
            DropdownBreadcrumb(crumbs: crumbs, maxVisible: limit)
            BreadcrumbView(crumbs: crumbs, maxItems: limit)
            BreadcrumbView(path: ["Home", "Settings"], maxItems: limit)
        }
        let renderer = ImageRenderer(content: views.frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 0)
    }
}
