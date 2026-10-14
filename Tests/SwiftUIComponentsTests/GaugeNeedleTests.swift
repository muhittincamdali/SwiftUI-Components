import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

/// Renders `GaugeChart` and reads the pixels around the centre, so the test checks where the
/// needle is actually drawn instead of repeating the rotation formula.
@MainActor
@Suite("GaugeChart needle")
struct GaugeNeedleTests {
    /// Mirrors `GaugeChart.GaugeStyle`, which is not `Sendable`, so it can be a test argument.
    enum Style: String, Sendable {
        case semicircle, threeQuarter, full

        var gaugeStyle: GaugeChart.GaugeStyle {
            switch self {
            case .semicircle: .semicircle
            case .threeQuarter: .threeQuarter
            case .full: .full
            }
        }
    }

    struct Case: CustomTestStringConvertible, Sendable {
        let style: Style
        let value: Double
        /// Screen direction of the needle in degrees: 0 = right, 90 = down, 180 = left, 270 = up.
        let direction: Double

        var testDescription: String { "\(style.rawValue) at \(value) points to \(direction)°" }
    }

    private static let side: CGFloat = 300
    private static let scale: CGFloat = 2
    /// Directions that are checked for needle pixels in every case.
    private static let probes: [Double] = [0, 45, 180, 270]

    @Test(arguments: [
        Case(style: .semicircle, value: 0, direction: 180),
        Case(style: .semicircle, value: 50, direction: 270),
        Case(style: .semicircle, value: 100, direction: 0),
        Case(style: .threeQuarter, value: 100, direction: 45),
        Case(style: .full, value: 25, direction: 180),
    ])
    func needlePointsAtValue(_ testCase: Case) throws {
        let pixels = try render(GaugeChart(
            value: testCase.value,
            valueLabel: "",
            style: testCase.style.gaugeStyle,
            colors: [.clear],
            animate: false
        ))

        for direction in Self.probes {
            let darkest = pixels.darkestLuminance(near: probePoint(direction: direction))
            if direction == testCase.direction {
                #expect(darkest < 0.3, "no needle at \(direction)°, darkest luminance \(darkest)")
            } else {
                #expect(darkest > 0.7, "unexpected needle pixels at \(direction)°, darkest luminance \(darkest)")
            }
        }
    }

    /// A point on the needle's path: 15 % of the chart size from the centre, past the hub
    /// (radius 4 %) and well inside the arc.
    private func probePoint(direction: Double) -> CGPoint {
        let radians = direction * .pi / 180
        let distance = Self.side * 0.15
        return CGPoint(
            x: (Self.side / 2 + distance * cos(radians)) * Self.scale,
            y: (Self.side / 2 + distance * sin(radians)) * Self.scale
        )
    }

    private func render(_ chart: GaugeChart) throws -> Pixels {
        let content = chart
            .frame(width: Self.side, height: Self.side)
            .background(Color.white)
            .environment(\.colorScheme, .light)
        let renderer = ImageRenderer(content: content)
        renderer.scale = Self.scale
        return try Pixels(try #require(renderer.cgImage))
    }
}

/// RGBA pixels of a rendered image, top row first.
private struct Pixels {
    let width: Int
    let height: Int
    private let bytes: [UInt8]

    init(_ image: CGImage) throws {
        let width = image.width
        let height = image.height
        var buffer = [UInt8](repeating: 0, count: width * height * 4)
        let drawn = buffer.withUnsafeMutableBytes { raw -> Bool in
            guard let context = CGContext(
                data: raw.baseAddress,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        try #require(drawn)
        self.width = width
        self.height = height
        bytes = buffer
    }

    /// Lowest luminance (0 black, 1 white) in a 5 × 5 pixel square around `point`.
    func darkestLuminance(near point: CGPoint) -> Double {
        var darkest = 1.0
        for y in Int(point.y) - 2...Int(point.y) + 2 {
            for x in Int(point.x) - 2...Int(point.x) + 2 where (0..<width).contains(x) && (0..<height).contains(y) {
                let offset = (y * width + x) * 4
                let luminance = (0.2126 * Double(bytes[offset]) + 0.7152 * Double(bytes[offset + 1]) + 0.0722 * Double(bytes[offset + 2])) / 255
                darkest = min(darkest, luminance)
            }
        }
        return darkest
    }
}
