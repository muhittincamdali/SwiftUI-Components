import SwiftUI

/// A view for displaying empty states
public struct EmptyStateView: View {
    let title: String
    let message: String
    let icon: String?
    let illustration: Illustration?
    let action: Action?
    let style: EmptyStateStyle
    
    public enum Illustration {
        case noResults
        case noConnection
        case empty
        case error
        case comingSoon
        case maintenance
        case search
        case notifications
        case messages
        case files
        
        var systemImage: String {
            switch self {
            case .noResults: return "magnifyingglass"
            case .noConnection: return "wifi.slash"
            case .empty: return "tray"
            case .error: return "exclamationmark.triangle"
            case .comingSoon: return "clock"
            case .maintenance: return "wrench.and.screwdriver"
            case .search: return "doc.text.magnifyingglass"
            case .notifications: return "bell.slash"
            case .messages: return "message"
            case .files: return "folder"
            }
        }
        
        var color: Color {
            switch self {
            case .noResults: return .blue
            case .noConnection: return .orange
            case .empty: return .gray
            case .error: return .red
            case .comingSoon: return .purple
            case .maintenance: return .yellow
            case .search: return .blue
            case .notifications: return .gray
            case .messages: return .blue
            case .files: return .gray
            }
        }
    }
    
    public struct Action {
        let title: String
        let icon: String?
        let action: () -> Void
        
        public init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
    }
    
    public enum EmptyStateStyle {
        case standard
        case compact
        case card
        case fullscreen
    }
    
    public init(
        title: String,
        message: String,
        icon: String? = nil,
        illustration: Illustration? = nil,
        action: Action? = nil,
        style: EmptyStateStyle = .standard
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.illustration = illustration
        self.action = action
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .compact:
                compactView
            case .card:
                cardView
            case .fullscreen:
                fullscreenView
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
    }
    
    private var illustrationView: some View {
        Group {
            if let illustration = illustration {
                ZStack {
                    Circle()
                        .fill(illustration.color.opacity(0.15))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: illustration.systemImage)
                        .font(.system(size: 40))
                        .foregroundColor(illustration.color)
                }
            } else if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var standardView: some View {
        VStack(spacing: 16) {
            illustrationView
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action {
                Button(action: action.action) {
                    HStack(spacing: 8) {
                        if let icon = action.icon {
                            Image(systemName: icon)
                        }
                        Text(action.title)
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                .padding(.top, 8)
            }
        }
        .padding(32)
    }
    
    private var compactView: some View {
        HStack(spacing: 16) {
            if let illustration = illustration {
                Image(systemName: illustration.systemImage)
                    .font(.system(size: 28))
                    .foregroundColor(illustration.color)
                    .frame(width: 56, height: 56)
                    .background(illustration.color.opacity(0.15))
                    .cornerRadius(12)
            } else if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let action = action {
                Button(action: action.action) {
                    if let icon = action.icon {
                        Image(systemName: icon)
                    } else {
                        Text(action.title)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .foregroundColor(.accentColor)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var cardView: some View {
        VStack(spacing: 16) {
            illustrationView
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action {
                Button(action: action.action) {
                    HStack(spacing: 6) {
                        if let icon = action.icon {
                            Image(systemName: icon)
                        }
                        Text(action.title)
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
    
    private var fullscreenView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            if let illustration = illustration {
                ZStack {
                    Circle()
                        .fill(illustration.color.opacity(0.1))
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .fill(illustration.color.opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: illustration.systemImage)
                        .font(.system(size: 50))
                        .foregroundColor(illustration.color)
                }
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let action = action {
                Button(action: action.action) {
                    HStack(spacing: 8) {
                        if let icon = action.icon {
                            Image(systemName: icon)
                        }
                        Text(action.title)
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 48)
            }
            
            Spacer()
        }
    }
}

/// Predefined empty states
public extension EmptyStateView {
    static func noResults(action: Action? = nil) -> EmptyStateView {
        EmptyStateView(
            title: "No Results Found",
            message: "We couldn't find anything matching your search. Try different keywords.",
            illustration: .noResults,
            action: action
        )
    }
    
    static func noConnection(action: Action? = nil) -> EmptyStateView {
        EmptyStateView(
            title: "No Internet Connection",
            message: "Please check your network settings and try again.",
            illustration: .noConnection,
            action: action ?? Action("Retry", icon: "arrow.clockwise") {}
        )
    }
    
    static func empty(title: String = "Nothing Here Yet", message: String = "Items you add will appear here.", action: Action? = nil) -> EmptyStateView {
        EmptyStateView(
            title: title,
            message: message,
            illustration: .empty,
            action: action
        )
    }
    
    static func error(message: String = "Something went wrong. Please try again.", action: Action? = nil) -> EmptyStateView {
        EmptyStateView(
            title: "Oops!",
            message: message,
            illustration: .error,
            action: action ?? Action("Try Again", icon: "arrow.clockwise") {}
        )
    }
    
    static func comingSoon(feature: String = "This feature") -> EmptyStateView {
        EmptyStateView(
            title: "Coming Soon",
            message: "\(feature) is under development. Stay tuned!",
            illustration: .comingSoon
        )
    }
}

#Preview("Empty States") {
    ScrollView {
        VStack(spacing: 32) {
            EmptyStateView(
                title: "No Messages",
                message: "Start a conversation by tapping the compose button.",
                illustration: .messages,
                action: .init("New Message", icon: "square.and.pencil") {},
                style: .standard
            )
            
            EmptyStateView(
                title: "No Notifications",
                message: "You're all caught up!",
                illustration: .notifications,
                style: .compact
            )
            
            EmptyStateView(
                title: "No Files",
                message: "Upload your first file to get started.",
                illustration: .files,
                action: .init("Upload", icon: "plus") {},
                style: .card
            )
            
            EmptyStateView.noResults(action: .init("Clear Search") {})
            
            EmptyStateView.noConnection()
            
            EmptyStateView.error()
            
            EmptyStateView.comingSoon(feature: "Analytics")
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
