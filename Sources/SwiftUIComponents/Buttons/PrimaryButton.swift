import SwiftUI

/// A customizable primary button with built-in loading state support.
///
/// Use `PrimaryButton` to create prominent call-to-action buttons with
/// configurable colors, corner radius, and an animated loading spinner.
///
/// ```swift
/// PrimaryButton("Submit", isLoading: isLoading) {
///     performSubmit()
/// }
/// ```
public struct PrimaryButton: View {
    // MARK: - Properties

    private let title: String
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let cornerRadius: CGFloat
    private let isLoading: Bool
    private let isDisabled: Bool
    private let height: CGFloat
    private let font: Font
    private let action: () -> Void

    // MARK: - Initialization

    /// Creates a new primary button.
    /// - Parameters:
    ///   - title: The text displayed on the button.
    ///   - backgroundColor: The background color of the button. Defaults to `.blue`.
    ///   - foregroundColor: The text and spinner color. Defaults to `.white`.
    ///   - cornerRadius: The corner radius of the button. Defaults to `12`.
    ///   - isLoading: Whether the button shows a loading spinner. Defaults to `false`.
    ///   - isDisabled: Whether the button is disabled. Defaults to `false`.
    ///   - height: The height of the button. Defaults to `50`.
    ///   - font: The font used for the title. Defaults to `.headline`.
    ///   - action: The closure executed when the button is tapped.
    public init(
        _ title: String,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        height: CGFloat = 50,
        font: Font = .headline,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.height = height
        self.font = font
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.9)
                }

                Text(title)
                    .font(font)
                    .opacity(isLoading ? 0.7 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundStyle(foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor.opacity(isDisabled ? 0.5 : 1.0))
            )
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Get Started") { }
        PrimaryButton("Loading...", isLoading: true) { }
        PrimaryButton("Disabled", isDisabled: true) { }
    }
    .padding()
}
#endif
