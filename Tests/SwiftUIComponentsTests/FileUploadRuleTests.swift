import Foundation
import Testing
@testable import SwiftUIComponents

@Suite("File upload rules")
struct FileUploadRuleTests {
    private func rejection(
        _ name: String,
        size: Int? = 1_000,
        count: Int = 0,
        maxFiles: Int = 5,
        types: [String] = ["pdf", ".PNG"],
        maxMegabytes: Int = 10
    ) -> FileUploadField.Rejection? {
        FileUploadField.rejection(
            name: name, size: size, currentCount: count, maxFiles: maxFiles,
            allowedTypes: types, maxFileSize: maxMegabytes
        )
    }

    @Test func acceptsAllowedFilesWithinTheLimits() {
        #expect(rejection("report.pdf") == nil)
        #expect(rejection("Photo.png") == nil) // case and a leading dot in the list do not matter
        #expect(rejection("big.pdf", size: 10 * 1_048_576) == nil) // exactly at the limit
        #expect(rejection("notes.txt", types: []) == nil) // an empty list allows every type
    }

    @Test func reportsWhyAFileIsNotAdded() {
        #expect(rejection("a.pdf", count: 5) == .tooManyFiles)
        #expect(rejection("a.pdf", maxFiles: -1) == .tooManyFiles)
        #expect(rejection("archive.zip") == .unsupportedType)
        #expect(rejection("pdf") == .unsupportedType) // no extension at all
        #expect(rejection("a.pdf", size: nil) == .unreadable)
        #expect(rejection("a.pdf", size: 10 * 1_048_576 + 1) == .tooLarge)
        #expect(rejection("a.pdf", maxMegabytes: -5) == .tooLarge)
    }

    @Test func aHugeLimitDoesNotOverflow() {
        #expect(rejection("a.pdf", size: Int.max, maxMegabytes: Int.max) == nil)
    }

    @Test func pickerOffersKnownTypesOrEveryFile() {
        #expect(FileUploadField.contentTypes(for: ["pdf", ".PNG"]) == [.pdf, .png])
        #expect(FileUploadField.contentTypes(for: []) == [.item])
    }

    @Test("progress bar fraction stays within 0...1", arguments: [
        (Double.nan, 0.0), (-1, 0), (0.25, 0.25), (7, 1), (.infinity, 1),
    ])
    func progressIsClamped(progress: Double, expected: Double) {
        #expect(FileUploadField.clampedProgress(progress) == expected)
    }
}
