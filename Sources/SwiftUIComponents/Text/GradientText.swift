import SwiftUI

/// A text view that renders with a linear gradient fill.
///
/// Use `GradientText` to create visually striking headings or labels
/// with smooth color transitions.
///
/// ```swift
/// GradientText("Hello World", colors: [.purple, .blue])
///     .font(.largeTitle)
/// ```
public struct GradientText: View {
    // MARK: - Properties

    private let text: String
    private let colors: [Color]
    private let startPoint: UnitPoint
    private let endPoint: UnitPoint

    // MARK: - Initialization

    /// Creates a new gradient text view.
    /// - Parameters:
    ///   - text: The text string to display.
    ///   - colors: An array of colors for the gradient. Defaults to `[.blue, .purple]`.
    ///   - startPoint: The starting point of the gradient. Defaults to `.leading`.
    ///   - endPoint: The ending point of the gradient. Defaults to `.trailing`.
    public init(
        _ text: String,
        colors: [Color] = [.blue, .purple],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) {
        self.text = text
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
    }

    // MARK: - Body

    public var body: some View {
        Text(text)
            .overlay(
                LinearGradient(
                    colors: colors,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .mask(
                    Text(text)
                )
            )
            .foregroundStyle(.clear)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        GradientText("Hello World", colors: [.red, .orange, .yellow])
            .font(.largeTitle.bold())

        GradientText("Subtle Effect", colors: [.blue, .cyan])
            .font(.title2)

        GradientText("Vertical", startPoint: .top, endPoint: .bottom)
            .font(.title3)
    }
}
#endif
