import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// Renders every gallery page off screen. This catches views that crash or lay out
/// to an empty size, and, when `SCREENSHOT_DIR` is set, writes the PNGs used in the README.
@MainActor
@Suite("Rendering")
struct RenderTests {
    @Test("gallery page renders", arguments: Gallery.allCases, [ColorScheme.light, .dark])
    func rendersGalleryPage(page: Gallery, scheme: ColorScheme) throws {
        let renderer = ImageRenderer(content: page.canvas(colorScheme: scheme))
        renderer.scale = 2

        let image = try #require(renderer.cgImage)
        #expect(image.width == 780)
        #expect(image.height > 200)

        if let directory = ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] {
            let name = "\(page.rawValue)-\(scheme == .dark ? "dark" : "light").png"
            try writePNG(image, to: URL(fileURLWithPath: directory).appendingPathComponent(name))
        }
    }

    @Test func readmeExamplesRender() throws {
        let renderer = ImageRenderer(content: ReadmeExamples().frame(width: 390))
        let image = try #require(renderer.cgImage)
        #expect(image.height > 100)
    }

    private func writePNG(_ image: CGImage, to url: URL) throws {
        #if canImport(UIKit)
        let data = try #require(UIImage(cgImage: image).pngData())
        #else
        let data = try #require(NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]))
        #endif
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url)
    }
}
