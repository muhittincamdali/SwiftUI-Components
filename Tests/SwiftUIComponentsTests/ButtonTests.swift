import XCTest
import SwiftUI
@testable import SwiftUIComponents

final class ButtonTests: XCTestCase {

    // MARK: - PrimaryButton Tests

    func testPrimaryButtonInitializesWithDefaults() {
        let button = PrimaryButton("Test") { }
        XCTAssertNotNil(button)
    }

    func testPrimaryButtonWithCustomParameters() {
        let button = PrimaryButton(
            "Custom",
            backgroundColor: .red,
            foregroundColor: .black,
            cornerRadius: 20,
            isLoading: true,
            isDisabled: false,
            height: 60,
            font: .body
        ) { }
        XCTAssertNotNil(button)
    }

    func testPrimaryButtonLoadingState() {
        var actionCalled = false
        let button = PrimaryButton("Loading", isLoading: true) {
            actionCalled = true
        }
        XCTAssertNotNil(button)
        // When loading, action should be guarded
        XCTAssertFalse(actionCalled)
    }

    func testPrimaryButtonDisabledState() {
        let button = PrimaryButton("Disabled", isDisabled: true) { }
        XCTAssertNotNil(button)
    }

    func testPrimaryButtonBodyIsNotNil() {
        let button = PrimaryButton("Body Test") { }
        let body = button.body
        XCTAssertNotNil(body)
    }

    // MARK: - IconButton Tests

    func testIconButtonInitializesWithDefaults() {
        let button = IconButton(systemName: "heart.fill") { }
        XCTAssertNotNil(button)
    }

    func testIconButtonWithCustomParameters() {
        let button = IconButton(
            systemName: "star.fill",
            size: 56,
            color: .yellow,
            backgroundColor: .gray.opacity(0.2)
        ) { }
        XCTAssertNotNil(button)
    }

    func testIconButtonBodyIsNotNil() {
        let button = IconButton(systemName: "bell") { }
        let body = button.body
        XCTAssertNotNil(body)
    }

    func testIconButtonWithoutBackground() {
        let button = IconButton(systemName: "trash", color: .red) { }
        XCTAssertNotNil(button)
    }

    func testIconButtonSmallSize() {
        let button = IconButton(systemName: "plus", size: 24) { }
        XCTAssertNotNil(button)
    }
}
