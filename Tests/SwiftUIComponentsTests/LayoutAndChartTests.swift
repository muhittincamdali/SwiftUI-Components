import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("FlowLayout.arrange")
struct FlowLayoutTests {
    private let chip = CGSize(width: 40, height: 20)

    @Test func placesItemsOnOneLineWhenTheyFit() {
        let result = FlowLayout.arrange(sizes: [chip, chip], maxWidth: 100, spacing: 8)
        #expect(result.positions == [CGPoint(x: 0, y: 0), CGPoint(x: 48, y: 0)])
        #expect(result.size == CGSize(width: 88, height: 20))
    }

    @Test func wrapsWhenTheNextItemOverflows() {
        let result = FlowLayout.arrange(sizes: [chip, chip, chip], maxWidth: 100, spacing: 8)
        #expect(result.positions[2] == CGPoint(x: 0, y: 28))
        #expect(result.size == CGSize(width: 88, height: 48))
    }

    @Test func lineHeightIsTheTallestItemOnTheLine() {
        let tall = CGSize(width: 40, height: 50)
        let result = FlowLayout.arrange(sizes: [chip, tall, chip], maxWidth: 100, spacing: 8)
        #expect(result.positions[2].y == 58)
    }

    @Test func oversizedItemGetsItsOwnLine() {
        let wide = CGSize(width: 300, height: 20)
        let result = FlowLayout.arrange(sizes: [wide, chip], maxWidth: 100, spacing: 8)
        #expect(result.positions == [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 28)])
        #expect(result.size.width == 300)
    }

    @Test func emptyInputHasZeroSize() {
        let result = FlowLayout.arrange(sizes: [], maxWidth: 100, spacing: 8)
        #expect(result.positions.isEmpty)
        #expect(result.size == .zero)
    }

    @Test func unboundedWidthKeepsEverythingOnOneLine() {
        let result = FlowLayout.arrange(sizes: Array(repeating: chip, count: 10), maxWidth: .infinity, spacing: 8)
        #expect(result.positions.allSatisfy { $0.y == 0 })
    }
}

@Suite("Chart geometry")
struct ChartGeometryTests {
    private let size = CGSize(width: 100, height: 50)

    @Test func sparklineSpansWidthAndInvertsY() {
        let points = SparklineChart.normalizedPoints([0, 5, 10], in: size)
        #expect(points == [CGPoint(x: 0, y: 50), CGPoint(x: 50, y: 25), CGPoint(x: 100, y: 0)])
    }

    @Test func flatSparklineIsCentredVertically() {
        let points = SparklineChart.normalizedPoints([3, 3, 3], in: size)
        #expect(points.map(\.y) == [25, 25, 25])
        #expect(points.map(\.x) == [0, 50, 100])
    }

    @Test func singleValueSparklineHasNoNaN() {
        let points = SparklineChart.normalizedPoints([42], in: size)
        #expect(points == [CGPoint(x: 50, y: 25)])
    }

    @Test func emptySparklineHasNoPoints() {
        #expect(SparklineChart.normalizedPoints([], in: size).isEmpty)
    }

    @Test func pieBoundariesAreCumulative() {
        let angles = PieChart.boundaryAngles(for: [1, 1, 2]).map(\.degrees)
        #expect(angles == [0, 90, 180, 360])
    }

    @Test func pieWithZeroTotalDrawsNothing() {
        let angles = PieChart.boundaryAngles(for: [0, 0]).map(\.degrees)
        #expect(angles == [0, 0, 0])
        #expect(angles.allSatisfy { !$0.isNaN })
    }

    @Test func pieTreatsNegativeValuesAsZero() {
        let angles = PieChart.boundaryAngles(for: [-5, 1]).map(\.degrees)
        #expect(angles == [0, 0, 360])
    }
}

@Suite("Indicators")
struct IndicatorTests {
    @Test("scrolling page window", arguments: [
        (0, 10, 5, 0..<5),
        (5, 10, 5, 3..<8),
        (9, 10, 5, 5..<10),
        (2, 3, 5, 0..<3),
        (0, 0, 5, 0..<0),
    ])
    func visibleRange(current: Int, total: Int, visible: Int, expected: Range<Int>) {
        #expect(ScrollingPageIndicator.visibleRange(currentPage: current, totalPages: total, visibleDots: visible) == expected)
    }

    @Test func snapCarouselFocusesTheMiddleHalf() {
        let height: CGFloat = 800
        #expect(SnapCarousel<Item, EmptyView>.isFocused(itemFrame: CGRect(x: 0, y: 250, width: 10, height: 300), viewportHeight: height))
        #expect(!SnapCarousel<Item, EmptyView>.isFocused(itemFrame: CGRect(x: 0, y: -200, width: 10, height: 300), viewportHeight: height))
        #expect(!SnapCarousel<Item, EmptyView>.isFocused(itemFrame: CGRect(x: 0, y: 700, width: 10, height: 300), viewportHeight: height))
    }

    struct Item: Identifiable {
        let id: Int
    }
}
