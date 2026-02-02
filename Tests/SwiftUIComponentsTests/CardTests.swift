import XCTest
import SwiftUI
@testable import SwiftUIComponents

final class CardTests: XCTestCase {

    // MARK: - CardView Tests

    func testCardViewInitializesWithDefaults() {
        let card = CardView { Text("Hello") }
        XCTAssertNotNil(card)
    }

    func testCardViewWithCustomParameters() {
        let card = CardView(
            cornerRadius: 20,
            shadowRadius: 10,
            shadowColor: .blue.opacity(0.2),
            shadowOffset: CGSize(width: 2, height: 4),
            padding: 24,
            borderColor: .gray,
            borderWidth: 2
        ) {
            Text("Custom card")
        }
        XCTAssertNotNil(card)
    }

    func testCardViewBodyRendersContent() {
        let card = CardView {
            VStack {
                Text("Title")
                Text("Subtitle")
            }
        }
        let body = card.body
        XCTAssertNotNil(body)
    }

    func testCardViewWithZeroShadow() {
        let card = CardView(shadowRadius: 0) {
            Text("Flat card")
        }
        XCTAssertNotNil(card)
    }

    // MARK: - ExpandableCard Tests

    func testExpandableCardInitializesWithDefaults() {
        let card = ExpandableCard(title: "Test") {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testExpandableCardWithSubtitle() {
        let card = ExpandableCard(title: "Title", subtitle: "Subtitle") {
            Text("Expandable content")
        }
        XCTAssertNotNil(card)
    }

    func testExpandableCardInitiallyExpanded() {
        let card = ExpandableCard(
            title: "Expanded",
            isInitiallyExpanded: true
        ) {
            Text("Visible content")
        }
        let body = card.body
        XCTAssertNotNil(body)
    }

    func testExpandableCardCustomHeaderColor() {
        let card = ExpandableCard(
            title: "Colored",
            headerColor: .blue,
            cornerRadius: 20
        ) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }
}
