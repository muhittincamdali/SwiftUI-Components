import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("ColorContrast")
struct ColorContrastTests {
    private let white = ColorContrast.RGB(red: 1, green: 1, blue: 1)
    private let black = ColorContrast.RGB(red: 0, green: 0, blue: 0)

    @Test func blackOnWhiteIsTwentyOneToOne() {
        #expect(abs(ColorContrast.ratio(black, white) - 21) < 1e-9)
        #expect(ColorContrast.ratio(white, black) == ColorContrast.ratio(black, white))
        #expect(ColorContrast.ratio(white, white) == 1)
    }

    @Test func matchesPublishedReferenceValues() throws {
        // #767676 is the lightest gray that passes AA on white (4.54:1); #777777 fails (4.48:1).
        let passing = try #require(ColorContrast.RGB(hex: "#767676"))
        let failing = try #require(ColorContrast.RGB(hex: "777777"))
        #expect(abs(ColorContrast.ratio(passing, white) - 4.54) < 0.01)
        #expect(abs(ColorContrast.ratio(failing, white) - 4.48) < 0.01)
        #expect(ColorContrast.level(for: ColorContrast.ratio(passing, white)) == .aa)
        #expect(ColorContrast.level(for: ColorContrast.ratio(failing, white)) == .aaLarge)
    }

    @Test func parsesHexCodes() {
        #expect(ColorContrast.RGB(hex: "#07E") == ColorContrast.RGB(hex: "0077EE"))
        #expect(ColorContrast.RGB(hex: "#FFFFFF") == white)
        #expect(ColorContrast.RGB(hex: "#GGGGGG") == nil)
        #expect(ColorContrast.RGB(hex: "#12345") == nil)
        #expect(ColorContrast.RGB(hex: "") == nil)
        #expect(ColorContrast.RGB(hex: "+12345") == nil)
    }

    @Test func gradesRatios() {
        #expect(ColorContrast.level(for: 2.99) == .fail)
        #expect(ColorContrast.level(for: 3) == .aaLarge)
        #expect(ColorContrast.level(for: 4.5) == .aa)
        #expect(ColorContrast.level(for: 7) == .aaa)
        #expect(ColorContrast.Level.aa > .aaLarge)
        #expect(ColorContrast.passes(3.2, level: .aa, largeText: true))
        #expect(!ColorContrast.passes(3.2, level: .aa))
        #expect(ColorContrast.passes(5, level: .aaa, largeText: true))
        #expect(!ColorContrast.passes(6.9, level: .aaa))
    }

    @Test func resolvesSwiftUIColorsInTheirEnvironment() {
        #expect(abs(ColorContrast.ratio(Color.black, Color.white) - 21) < 0.01)

        var dark = EnvironmentValues()
        dark.colorScheme = .dark
        var light = EnvironmentValues()
        light.colorScheme = .light
        // `.primary` is near black in light mode and near white in dark mode.
        #expect(ColorContrast.ratio(.primary, .white, in: light) > 15)
        #expect(ColorContrast.ratio(.primary, .white, in: dark) < 1.5)
    }

    @Test func outOfRangeComponentsAreClamped() {
        let extended = ColorContrast.RGB(red: 1.2, green: 1.1, blue: 1.3)
        #expect(abs(extended.luminance - 1) < 1e-9)
    }
}
