import SwiftUI

/// A compact button displaying an SF Symbol icon.
///
/// Use `IconButton` for toolbar actions, favorites, or any interaction
/// that benefits from an icon-only button.
///
/// ```swift
/// IconButton(systemName: "heart.fill", color: .red) {
///     toggleFavorite()
/// }
/// ```
public struct IconButton: View {
    // MARK: - Properties

    private let systemName: String
    private let size: CGFloat
    private let color: Color
    private let backgroundColor: Color?
    private let action: () -> Void

    // MARK: - Initialization

    /// Creates a new icon button.
    /// - Parameters:
    ///   - systemName: The SF Symbol name for the icon.
    ///   - size: The tap target size. Defaults to `44`.
    ///   - color: The icon tint color. Defaults to `.primary`.
    ///   - backgroundColor: Optional background color. Defaults to `nil`.
    ///   - action: The closure executed when the button is tapped.
    public init(
        systemName: String,
        size: CGFloat = 44,
        color: Color = .primary,
        backgroundColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.45))
                .foregroundStyle(color)
                .frame(width: size, height: size)
                .background(
                    Group {
                        if let backgroundColor {
                            Circle()
                                .fill(backgroundColor)
                        }
                    }
                )
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG
#Preview {
    HStack(spacing: 16) {
        IconButton(systemName: "heart.fill", color: .red) { }
        IconButton(systemName: "star.fill", color: .yellow) { }
        IconButton(systemName: "bell.fill", backgroundColor: .gray.opacity(0.2)) { }
    }
}
#endif
