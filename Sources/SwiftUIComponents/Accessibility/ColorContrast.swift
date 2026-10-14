import SwiftUI

/// Contrast checks from the Web Content Accessibility Guidelines (WCAG) 2.2, for choosing text
/// and background colors that people with low vision can read.
///
/// ```swift
/// let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890))
/// ColorContrast.level(for: ratio) // .aa (about 4.9:1)
/// ```
public enum ColorContrast {
    /// How a contrast ratio scores against the WCAG 2.2 success criteria 1.4.3 (AA) and
    /// 1.4.6 (AAA).
    public enum Level: Int, Comparable, Sendable, CaseIterable {
        /// Below 3:1. Not enough even for large text.
        case fail
        /// At least 3:1. Enough for large text (24 pt, or 18.66 pt bold) and for icons and
        /// control borders (criterion 1.4.11).
        case aaLarge
        /// At least 4.5:1. Enough for body text.
        case aa
        /// At least 7:1. The enhanced level for body text.
        case aaa

        public static func < (lhs: Level, rhs: Level) -> Bool { lhs.rawValue < rhs.rawValue }
    }

    /// An sRGB color with components from 0 to 1, as written in design files and hex codes.
    public struct RGB: Equatable, Sendable {
        public var red: Double
        public var green: Double
        public var blue: Double

        public init(red: Double, green: Double, blue: Double) {
            self.red = red
            self.green = green
            self.blue = blue
        }

        /// Creates a color from a hex code such as `"#0071E3"`, `"0071e3"` or `"#07E"`.
        /// Returns `nil` for anything else.
        public init?(hex: String) {
            var digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
            if digits.count == 3 { digits = digits.map { "\($0)\($0)" }.joined() }
            guard digits.count == 6, digits.allSatisfy(\.isHexDigit),
                  let value = UInt32(digits, radix: 16) else { return nil }
            self.init(
                red: Double((value >> 16) & 0xFF) / 255,
                green: Double((value >> 8) & 0xFF) / 255,
                blue: Double(value & 0xFF) / 255
            )
        }

        /// The relative luminance: 0 for black, 1 for white.
        public var luminance: Double {
            0.2126 * Self.linear(red) + 0.7152 * Self.linear(green) + 0.0722 * Self.linear(blue)
        }

        /// Converts a gamma-encoded sRGB component to linear light.
        static func linear(_ component: Double) -> Double {
            let value = min(max(component, 0), 1)
            return value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
    }

    /// The contrast ratio between two colors, from 1 (identical) to 21 (black on white).
    /// The order of the colors does not matter.
    public static func ratio(_ first: RGB, _ second: RGB) -> Double {
        let lighter = max(first.luminance, second.luminance)
        let darker = min(first.luminance, second.luminance)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// The contrast ratio between two SwiftUI colors as they appear in `environment`, so
    /// adaptive colors such as `.primary` resolve for the environment's color scheme.
    ///
    /// Opacity is ignored: a translucent color is measured as if it were opaque.
    public static func ratio(
        _ first: Color,
        _ second: Color,
        in environment: EnvironmentValues = EnvironmentValues()
    ) -> Double {
        ratio(RGB(first.resolve(in: environment)), RGB(second.resolve(in: environment)))
    }

    /// The highest level `ratio` reaches.
    public static func level(for ratio: Double) -> Level {
        switch ratio {
        case 7...: .aaa
        case 4.5...: .aa
        case 3...: .aaLarge
        default: .fail
        }
    }

    /// `true` when `ratio` is enough for text of the given size at the given level.
    ///
    /// Large text is at least 24 points, or at least 18.66 points and bold.
    public static func passes(_ ratio: Double, level: Level, largeText: Bool = false) -> Bool {
        let required: Double = switch (level, largeText) {
        case (.fail, _): 1
        case (.aaLarge, _): 3
        case (.aa, false): 4.5
        case (.aa, true): 3
        case (.aaa, false): 7
        case (.aaa, true): 4.5
        }
        return ratio >= required
    }
}

extension ColorContrast.RGB {
    /// The gamma-encoded sRGB components of a resolved SwiftUI color. Components of wide-gamut
    /// colors outside 0–1 are clamped when the luminance is computed.
    init(_ resolved: Color.Resolved) {
        self.init(red: Double(resolved.red), green: Double(resolved.green), blue: Double(resolved.blue))
    }
}
