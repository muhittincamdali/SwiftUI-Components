import SwiftUI

/// A card with configurable action buttons and interaction states.
///
/// `ActionCard` provides a complete card layout with header, content,
/// and action buttons, suitable for list items or dashboard widgets.
///
/// ```swift
/// ActionCard(
///     title: "Payment Due",
///     subtitle: "$150.00",
///     icon: Image(systemName: "creditcard.fill"),
///     primaryAction: .init(title: "Pay Now") { },
///     secondaryAction: .init(title: "Later") { }
/// )
/// ```
public struct ActionCard: View {
    // MARK: - Types
    
    /// An action button configuration.
    public struct Action {
        public let title: String
        public let icon: Image?
        public let style: Style
        public let isDestructive: Bool
        public let action: () -> Void
        
        public enum Style {
            case filled
            case outlined
            case text
        }
        
        public init(
            title: String,
            icon: Image? = nil,
            style: Style = .filled,
            isDestructive: Bool = false,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.style = style
            self.isDestructive = isDestructive
            self.action = action
        }
    }
    
    /// The layout direction for action buttons.
    public enum ActionLayout {
        case horizontal
        case vertical
        case stacked
    }
    
    /// Visual style variants.
    public enum CardStyle {
        case standard
        case elevated
        case outlined
        case filled(Color)
    }
    
    // MARK: - Properties
    
    private let title: String
    private let subtitle: String?
    private let description: String?
    private let icon: Image?
    private let iconColor: Color
    private let badge: String?
    private let badgeColor: Color
    private let primaryAction: Action?
    private let secondaryAction: Action?
    private let menuActions: [Action]
    private let actionLayout: ActionLayout
    private let cardStyle: CardStyle
    private let cornerRadius: CGFloat
    private let onTap: (() -> Void)?
    
    @State private var isPressed: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new action card.
    public init(
        title: String,
        subtitle: String? = nil,
        description: String? = nil,
        icon: Image? = nil,
        iconColor: Color = .blue,
        badge: String? = nil,
        badgeColor: Color = .red,
        primaryAction: Action? = nil,
        secondaryAction: Action? = nil,
        menuActions: [Action] = [],
        actionLayout: ActionLayout = .horizontal,
        cardStyle: CardStyle = .elevated,
        cornerRadius: CGFloat = 16,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.icon = icon
        self.iconColor = iconColor
        self.badge = badge
        self.badgeColor = badgeColor
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.menuActions = menuActions
        self.actionLayout = actionLayout
        self.cardStyle = cardStyle
        self.cornerRadius = cornerRadius
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            
            if let description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            
            if primaryAction != nil || secondaryAction != nil {
                actionsSection
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(cardOverlay)
        .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            onTap?()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(alignment: .top, spacing: 12) {
            if let icon {
                iconView(icon)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if let badge {
                        badgeView(badge)
                    }
                }
                
                if let subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if !menuActions.isEmpty {
                menuButton
            }
        }
    }
    
    // MARK: - Icon View
    
    private func iconView(_ icon: Image) -> some View {
        icon
            .font(.title2)
            .foregroundStyle(iconColor)
            .frame(width: 44, height: 44)
            .background(iconColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Badge View
    
    private func badgeView(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(badgeColor)
            .clipShape(Capsule())
    }
    
    // MARK: - Menu Button
    
    private var menuButton: some View {
        Menu {
            ForEach(Array(menuActions.enumerated()), id: \.offset) { _, action in
                Button(role: action.isDestructive ? .destructive : nil) {
                    action.action()
                } label: {
                    Label {
                        Text(action.title)
                    } icon: {
                        action.icon
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
    }
    
    // MARK: - Actions Section
    
    @ViewBuilder
    private var actionsSection: some View {
        switch actionLayout {
        case .horizontal:
            HStack(spacing: 12) {
                if let secondary = secondaryAction {
                    actionButton(secondary, isSecondary: true)
                }
                if let primary = primaryAction {
                    actionButton(primary, isSecondary: false)
                }
            }
        case .vertical:
            VStack(spacing: 10) {
                if let primary = primaryAction {
                    actionButton(primary, isSecondary: false)
                }
                if let secondary = secondaryAction {
                    actionButton(secondary, isSecondary: true)
                }
            }
        case .stacked:
            VStack(spacing: 8) {
                if let primary = primaryAction {
                    actionButton(primary, isSecondary: false)
                        .frame(maxWidth: .infinity)
                }
                if let secondary = secondaryAction {
                    actionButton(secondary, isSecondary: true)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - Action Button
    
    private func actionButton(_ action: Action, isSecondary: Bool) -> some View {
        Button(action: action.action) {
            HStack(spacing: 6) {
                action.icon?
                    .imageScale(.small)
                Text(action.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: actionLayout == .horizontal ? nil : .infinity)
            .foregroundStyle(buttonForeground(action, isSecondary: isSecondary))
            .background(buttonBackground(action, isSecondary: isSecondary))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(buttonOverlay(action, isSecondary: isSecondary))
        }
        .buttonStyle(.plain)
    }
    
    private func buttonForeground(_ action: Action, isSecondary: Bool) -> Color {
        let color = action.isDestructive ? Color.red : iconColor
        switch action.style {
        case .filled:
            return .white
        case .outlined, .text:
            return color
        }
    }
    
    private func buttonBackground(_ action: Action, isSecondary: Bool) -> Color {
        let color = action.isDestructive ? Color.red : iconColor
        switch action.style {
        case .filled:
            return color
        case .outlined, .text:
            return .clear
        }
    }
    
    @ViewBuilder
    private func buttonOverlay(_ action: Action, isSecondary: Bool) -> some View {
        if action.style == .outlined {
            let color = action.isDestructive ? Color.red : iconColor
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.5), lineWidth: 1.5)
        }
    }
    
    // MARK: - Card Styling
    
    @ViewBuilder
    private var cardBackground: some View {
        switch cardStyle {
        case .standard, .elevated, .outlined:
            Color(.systemBackground)
        case .filled(let color):
            color
        }
    }
    
    @ViewBuilder
    private var cardOverlay: some View {
        switch cardStyle {
        case .outlined:
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.separator), lineWidth: 1)
        default:
            EmptyView()
        }
    }
    
    private var shadowColor: Color {
        switch cardStyle {
        case .elevated:
            return .black.opacity(0.1)
        default:
            return .clear
        }
    }
    
    private var shadowRadius: CGFloat {
        switch cardStyle {
        case .elevated:
            return 8
        default:
            return 0
        }
    }
    
    private var shadowY: CGFloat {
        switch cardStyle {
        case .elevated:
            return 4
        default:
            return 0
        }
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            ActionCard(
                title: "Payment Due",
                subtitle: "Due in 3 days",
                description: "Your monthly subscription payment of $9.99 is due soon.",
                icon: Image(systemName: "creditcard.fill"),
                badge: "NEW",
                primaryAction: .init(title: "Pay Now") { },
                secondaryAction: .init(title: "Later", style: .outlined) { }
            )
            
            ActionCard(
                title: "Upload Complete",
                subtitle: "15 files uploaded",
                icon: Image(systemName: "checkmark.circle.fill"),
                iconColor: .green,
                primaryAction: .init(title: "View Files") { },
                menuActions: [
                    .init(title: "Share", icon: Image(systemName: "square.and.arrow.up")) { },
                    .init(title: "Delete", icon: Image(systemName: "trash"), isDestructive: true) { }
                ]
            )
            
            ActionCard(
                title: "Sync Error",
                subtitle: "Failed to sync 3 items",
                icon: Image(systemName: "exclamationmark.triangle.fill"),
                iconColor: .orange,
                primaryAction: .init(title: "Retry") { },
                secondaryAction: .init(title: "Dismiss", style: .text) { },
                cardStyle: .outlined
            )
        }
        .padding()
    }
}
#endif
