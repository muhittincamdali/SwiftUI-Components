import SwiftUI

/// The visual style of a toast notification.
public enum ToastStyle {
    case success
    case error
    case warning
    case info

    /// The default icon name for the style.
    public var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }

    /// The default color for the style.
    public var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

/// A non-intrusive toast notification view.
///
/// Display brief messages to the user with automatic dismissal.
///
/// ```swift
/// ToastView(message: "Saved!", style: .success)
/// ```
public struct ToastView: View {
    // MARK: - Properties

    private let message: String
    private let style: ToastStyle
    private let icon: String?

    // MARK: - Initialization

    /// Creates a new toast view.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - style: The visual style of the toast. Defaults to `.info`.
    ///   - icon: An optional custom SF Symbol name. Uses the style's default if `nil`.
    public init(
        message: String,
        style: ToastStyle = .info,
        icon: String? = nil
    ) {
        self.message = message
        self.style = style
        self.icon = icon
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon ?? style.iconName)
                .font(.system(size: 20))
                .foregroundStyle(style.color)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
        .padding(.horizontal, 16)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        ToastView(message: "Profile saved successfully!", style: .success)
        ToastView(message: "Something went wrong.", style: .error)
        ToastView(message: "Check your connection.", style: .warning)
        ToastView(message: "New update available.", style: .info)
    }
    .padding(.vertical)
}
#endif
