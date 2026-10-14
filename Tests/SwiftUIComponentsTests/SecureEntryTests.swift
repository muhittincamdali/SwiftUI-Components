import SwiftUI
import Testing
@testable import SwiftUIComponents

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// The PIN boxes only draw dots; the hidden field behind them decides whether the keyboard
/// suggestions, the keyboard cache and VoiceOver see the PIN. These tests host the view and
/// look at the platform text field SwiftUI creates for it.
@MainActor
@Suite("Secure code entry")
struct SecureEntryTests {
    @Test("PinInput uses a secure field only when isSecure is set", arguments: [true, false])
    func pinInputField(isSecure: Bool) throws {
        let fields = hostedTextFields(PinInput(code: .constant("1234"), length: 4, isSecure: isSecure))
        try #require(fields.count == 1)
        #expect(fields[0] == isSecure)
    }

    @Test func otpFieldPinTypeUsesASecureField() throws {
        let fields = hostedTextFields(SecurePINField(pin: .constant("1234"), length: 4))
        try #require(fields.count == 1)
        #expect(fields[0])
    }

    /// Returns one entry per platform text field in the hosted view: `true` for a secure one.
    private func hostedTextFields(_ view: some View) -> [Bool] {
        #if canImport(UIKit)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 400))
        let controller = UIHostingController(rootView: view)
        window.rootViewController = controller
        window.isHidden = false
        controller.view.layoutIfNeeded()
        defer { window.isHidden = true }
        return textFields(in: controller.view).map(\.isSecureTextEntry)
        #elseif canImport(AppKit)
        let host = NSHostingView(rootView: view)
        let window = NSWindow(
            contentRect: CGRect(x: 0, y: 0, width: 390, height: 400),
            styleMask: [.titled],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.contentView = host
        host.layoutSubtreeIfNeeded()
        defer { window.close() }
        return textFields(in: host).map { $0 is NSSecureTextField }
        #endif
    }

    #if canImport(UIKit)
    private func textFields(in view: UIView) -> [UITextField] {
        let own = (view as? UITextField).map { [$0] } ?? []
        return own + view.subviews.flatMap(textFields(in:))
    }
    #elseif canImport(AppKit)
    private func textFields(in view: NSView) -> [NSTextField] {
        let own = (view as? NSTextField).flatMap { $0.isEditable ? [$0] : nil } ?? []
        return own + view.subviews.flatMap(textFields(in:))
    }
    #endif
}
