import SwiftUI

/// A flexible card container with customizable shadow, corner radius, and padding.
///
/// Use `CardView` to wrap content in a styled card with elevation and rounded corners.
///
/// ```swift
/// CardView(cornerRadius: 16, shadowRadius: 8) {
///     Text("Hello from a card!")
/// }
/// ```
public struct CardView<Content: View>: View {
    // MARK: - Properties

    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowColor: Color
    private let shadowOffset: CGSize
    private let backgroundColor: Color
    private let padding: CGFloat
    private let borderColor: Color?
    private let borderWidth: CGFloat
    private let content: () -> Content

    // MARK: - Initialization

    /// Creates a new card view.
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the card. Defaults to `12`.
    ///   - shadowRadius: The blur radius of the shadow. Defaults to `4`.
    ///   - shadowColor: The shadow color. Defaults to `.black.opacity(0.1)`.
    ///   - shadowOffset: The shadow offset. Defaults to `(0, 2)`.
    ///   - backgroundColor: The card background color. Defaults to system background.
    ///   - padding: The inner padding. Defaults to `16`.
    ///   - borderColor: Optional border color. Defaults to `nil`.
    ///   - borderWidth: The border width if borderColor is set. Defaults to `1`.
    ///   - content: A view builder for the card's content.
    public init(
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 4,
        shadowColor: Color = .black.opacity(0.1),
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        backgroundColor: Color = Color(.systemBackground),
        padding: CGFloat = 16,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        content()
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .overlay(
                Group {
                    if let borderColor {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    }
                }
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}

// MARK: - Convenience Initializers

extension CardView {
    /// Creates a card with no shadow, useful for flat design layouts.
    /// - Parameters:
    ///   - cornerRadius: The corner radius. Defaults to `12`.
    ///   - backgroundColor: The background color.
    ///   - content: A view builder for the card's content.
    public static func flat(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = Color(.systemBackground),
        @ViewBuilder content: @escaping () -> Content
    ) -> CardView {
        CardView(
            cornerRadius: cornerRadius,
            shadowRadius: 0,
            backgroundColor: backgroundColor,
            content: content
        )
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 20) {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Default Card")
                    .font(.headline)
                Text("With subtle shadow and rounded corners.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }

        CardView(cornerRadius: 20, shadowRadius: 10, borderColor: .blue.opacity(0.3)) {
            Text("Custom styled card")
        }
    }
    .padding()
}
#endif
