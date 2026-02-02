import SwiftUI

/// An animated card that expands and collapses to reveal additional content.
///
/// Tap the header to toggle the expanded state with a smooth animation.
///
/// ```swift
/// ExpandableCard(title: "Details", subtitle: "Tap to expand") {
///     Text("Hidden content revealed on expand.")
/// }
/// ```
public struct ExpandableCard<Content: View>: View {
    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let headerColor: Color
    private let cornerRadius: CGFloat
    private let content: () -> Content

    @State private var isExpanded: Bool = false

    // MARK: - Initialization

    /// Creates a new expandable card.
    /// - Parameters:
    ///   - title: The header title text.
    ///   - subtitle: Optional subtitle displayed below the title. Defaults to `nil`.
    ///   - headerColor: The color of the title text. Defaults to `.primary`.
    ///   - cornerRadius: The corner radius. Defaults to `12`.
    ///   - isInitiallyExpanded: Whether the card starts expanded. Defaults to `false`.
    ///   - content: A view builder for the expandable content.
    public init(
        title: String,
        subtitle: String? = nil,
        headerColor: Color = .primary,
        cornerRadius: CGFloat = 12,
        isInitiallyExpanded: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.headerColor = headerColor
        self.cornerRadius = cornerRadius
        self._isExpanded = State(initialValue: isInitiallyExpanded)
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }

            if isExpanded {
                Divider()
                    .padding(.horizontal, 16)

                content()
                    .padding(16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(headerColor)

                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
        }
        .padding(16)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        ExpandableCard(title: "Account Settings", subtitle: "Manage your profile") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Email: user@example.com")
                Text("Member since 2024")
            }
        }

        ExpandableCard(title: "Notifications", isInitiallyExpanded: true) {
            Text("All notifications are enabled.")
        }
    }
    .padding()
}
#endif
