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

    @Test("page number stays inside the pages for any input", arguments: [
        (3, 10, 4), (9, 10, 10), (Int.max, 10, 10), (-1, 10, 0), (Int.min, 10, 0),
        (0, 0, 0), (Int.max, Int.max, Int.max),
    ])
    func pageNumber(current: Int, total: Int, expected: Int) {
        #expect(PageIndicator.pageNumber(currentPage: current, totalPages: total) == expected)
    }

    /// `currentPage + 1` stopped the process for a page of `Int.max` in these two styles.
    @MainActor
    @Test("page indicators render with any current page", arguments: [Int.max, Int.min, 3])
    func rendersAnyCurrentPage(page: Int) throws {
        let views = VStack {
            PageIndicator(currentPage: .constant(page), totalPages: 10, style: .numbers)
            PageIndicator(currentPage: .constant(page), totalPages: 10, style: .progress)
            PageIndicator(currentPage: .constant(page), totalPages: 0, style: .progress)
        }
        let renderer = ImageRenderer(content: views.frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 0)
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

    /// SwiftUI's `Slider` stops the process ("max stride must be positive") for a step that is
    /// not positive, not finite or larger than the range.
    @MainActor
    @Test("sliders render with steps Slider cannot use", arguments: [0, -5, Double.nan, .infinity, 200])
    func rendersWithAnUnusableStep(step: Double) throws {
        let views = VStack {
            SliderField(value: .constant(5), range: 0...100, step: step)
            SliderRatingInput(rating: .constant(5), range: 0...10, step: step)
            SliderRatingInput(rating: .constant(5), range: 5...5)
        }
        let renderer = ImageRenderer(content: views.frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 0)
    }

    /// A step on an infinite range stopped the process, and a range of 1e15 steps tried to
    /// allocate one entry per step. Over 10,000 steps the sliders move without steps.
    @MainActor
    @Test("sliders render with ranges too large for their step", arguments: [
        (0.0...Double.infinity, 1.0), (0.0...1e15, 1.0), (0.0...1.0, 1e-300), (0.0...1_000_000.0, 0.01),
    ])
    func rendersWithTooManySteps(range: ClosedRange<Double>, step: Double) throws {
        let views = VStack {
            SliderField(value: .constant(0.5), range: range, step: step)
            SliderRatingInput(rating: .constant(0.5), range: range, step: step)
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
