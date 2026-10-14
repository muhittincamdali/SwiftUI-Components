import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// Small shims that let the components compile for both iOS and macOS.
// UIKit-only APIs are mapped to the closest AppKit equivalent or become no-ops.

// MARK: - System Colors

extension Color {
    #if canImport(UIKit)
    @usableFromInline static let platformBackground = Color(uiColor: .systemBackground)
    @usableFromInline static let platformGroupedBackground = Color(uiColor: .systemGroupedBackground)
    @usableFromInline static let platformGray2 = Color(uiColor: .systemGray2)
    @usableFromInline static let platformGray3 = Color(uiColor: .systemGray3)
    @usableFromInline static let platformGray4 = Color(uiColor: .systemGray4)
    @usableFromInline static let platformGray5 = Color(uiColor: .systemGray5)
    @usableFromInline static let platformGray6 = Color(uiColor: .systemGray6)
    @usableFromInline static let platformSeparator = Color(uiColor: .separator)
    #else
    @usableFromInline static let platformBackground = Color(nsColor: .windowBackgroundColor)
    @usableFromInline static let platformGroupedBackground = Color(nsColor: .underPageBackgroundColor)
    @usableFromInline static let platformGray2 = Color(nsColor: .systemGray).opacity(0.8)
    @usableFromInline static let platformGray3 = Color(nsColor: .systemGray).opacity(0.6)
    @usableFromInline static let platformGray4 = Color(nsColor: .systemGray).opacity(0.45)
    @usableFromInline static let platformGray5 = Color(nsColor: .systemGray).opacity(0.3)
    @usableFromInline static let platformGray6 = Color(nsColor: .systemGray).opacity(0.15)
    @usableFromInline static let platformSeparator = Color(nsColor: .separatorColor)
    #endif
}

// MARK: - Haptics

/// Plays light haptic feedback on iOS; does nothing on platforms without haptics.
enum Haptics {
    enum Intensity {
        case light, medium
    }

    @MainActor
    static func impact(_ intensity: Intensity) {
        #if os(iOS)
        let style: UIImpactFeedbackGenerator.FeedbackStyle = intensity == .light ? .light : .medium
        UIImpactFeedbackGenerator(style: style).impactOccurred()
        #endif
    }
}

// MARK: - Keyboard

/// The software keyboard a text input should request. Ignored on macOS.
public enum KeyboardKind: Sendable {
    case standard
    case ascii
    case email
    case number
    case decimal
    case phone
    case url
}

extension View {
    /// Requests the given software keyboard on iOS.
    @ViewBuilder
    func keyboard(_ kind: KeyboardKind) -> some View {
        #if os(iOS)
        switch kind {
        case .standard: keyboardType(.default)
        case .ascii: keyboardType(.asciiCapable)
        case .email: keyboardType(.emailAddress)
        case .number: keyboardType(.numberPad)
        case .decimal: keyboardType(.decimalPad)
        case .phone: keyboardType(.phonePad)
        case .url: keyboardType(.URL)
        }
        #else
        self
        #endif
    }

    /// Turns off automatic capitalization where the platform supports it.
    @ViewBuilder
    func noAutocapitalization() -> some View {
        #if os(iOS)
        textInputAutocapitalization(.never)
        #else
        self
        #endif
    }

    /// Capitalizes each word where the platform supports it.
    @ViewBuilder
    func wordCapitalization() -> some View {
        #if os(iOS)
        textInputAutocapitalization(.words)
        #else
        self
        #endif
    }

    /// Wheel date picker on iOS, stepper field on macOS.
    @ViewBuilder
    func wheelDatePickerStyle() -> some View {
        #if os(iOS)
        datePickerStyle(.wheel)
        #else
        datePickerStyle(.stepperField)
        #endif
    }

    /// Wheel picker on iOS, pop-up menu on macOS.
    @ViewBuilder
    func wheelPickerStyle() -> some View {
        #if os(iOS)
        pickerStyle(.wheel)
        #else
        pickerStyle(.menu)
        #endif
    }

    /// Uses an inline navigation title on iOS.
    @ViewBuilder
    func inlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

// MARK: - Repeating Work

/// Repeats work on the main actor inside a SwiftUI `.task`, so it stops when the view disappears.
enum Ticker {
    /// Calls `tick` every `interval` seconds until it returns `false` or the task is cancelled.
    @MainActor
    static func run(every interval: TimeInterval, _ tick: @MainActor () -> Bool) async {
        while true {
            do {
                try await Task.sleep(for: .seconds(interval))
            } catch {
                return
            }
            if !tick() { return }
        }
    }
}

// MARK: - Fonts

#if canImport(UIKit)
typealias PlatformFont = UIFont
#else
typealias PlatformFont = NSFont
#endif

extension PlatformFont {
    /// Default line height for the font on both UIKit and AppKit.
    var platformLineHeight: CGFloat {
        #if canImport(UIKit)
        lineHeight
        #else
        ceil(ascender - descender + leading)
        #endif
    }
}
