import SwiftUI

/// A card for displaying notifications
public struct NotificationCard: View {
    let title: String
    let message: String
    let icon: String?
    let time: String?
    let type: NotificationType
    let isRead: Bool
    let onTap: (() -> Void)?
    let onDismiss: (() -> Void)?
    
    public enum NotificationType {
        case info
        case success
        case warning
        case error
        case message
        case update
        
        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            case .message: return .purple
            case .update: return .indigo
            }
        }
        
        var defaultIcon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .message: return "message.fill"
            case .update: return "arrow.down.circle.fill"
            }
        }
    }
    
    public init(
        title: String,
        message: String,
        icon: String? = nil,
        time: String? = nil,
        type: NotificationType = .info,
        isRead: Bool = false,
        onTap: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.time = time
        self.type = type
        self.isRead = isRead
        self.onTap = onTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            Image(systemName: icon ?? type.defaultIcon)
                .font(.system(size: 24))
                .foregroundColor(type.color)
                .frame(width: 40, height: 40)
                .background(type.color.opacity(0.15))
                .cornerRadius(10)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                    
                    if !isRead {
                        Circle()
                            .fill(type.color)
                            .frame(width: 8, height: 8)
                    }
                    
                    Spacer()
                    
                    if let time = time {
                        Text(time)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(message)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Dismiss button
            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(6)
                }
            }
        }
        .padding(12)
        .background(isRead ? Color(.systemBackground) : type.color.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRead ? Color.clear : type.color.opacity(0.2), lineWidth: 1)
        )
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(type) notification: \(title). \(message)")
    }
}

/// An inline notification banner
public struct NotificationBanner: View {
    let message: String
    let type: NotificationCard.NotificationType
    let action: (() -> Void)?
    let actionLabel: String?
    let onDismiss: (() -> Void)?
    
    public init(
        message: String,
        type: NotificationCard.NotificationType = .info,
        action: (() -> Void)? = nil,
        actionLabel: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.type = type
        self.action = action
        self.actionLabel = actionLabel
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.defaultIcon)
                .font(.system(size: 18))
                .foregroundColor(type.color)
            
            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            if let action = action, let label = actionLabel {
                Button(action: action) {
                    Text(label)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(type.color)
                }
            }
            
            if onDismiss != nil {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.color.opacity(0.1))
        .cornerRadius(10)
    }
}

/// A notification dot indicator
public struct NotificationDot: View {
    let count: Int?
    let color: Color
    let size: DotSize
    
    public enum DotSize {
        case small
        case medium
        case large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 18
            case .large: return 24
            }
        }
    }
    
    public init(count: Int? = nil, color: Color = .red, size: DotSize = .medium) {
        self.count = count
        self.color = color
        self.size = size
    }
    
    public var body: some View {
        Group {
            if let count = count, count > 0 {
                Text(count > 99 ? "99+" : "\(count)")
                    .font(.system(size: size == .large ? 12 : 10, weight: .bold))
                    .foregroundColor(.white)
                    .frame(minWidth: size.dimension, minHeight: size.dimension)
                    .padding(.horizontal, count > 9 ? 4 : 0)
                    .background(color)
                    .clipShape(Capsule())
            } else if count == nil {
                Circle()
                    .fill(color)
                    .frame(width: size.dimension / 2, height: size.dimension / 2)
            }
        }
    }
}

#Preview("Notification Cards") {
    ScrollView {
        VStack(spacing: 16) {
            NotificationCard(
                title: "Update Available",
                message: "A new version of the app is available. Tap to update.",
                time: "2m ago",
                type: .update,
                isRead: false,
                onDismiss: {}
            )
            
            NotificationCard(
                title: "Payment Successful",
                message: "Your payment of $49.99 has been processed successfully.",
                time: "1h ago",
                type: .success,
                isRead: true
            )
            
            NotificationCard(
                title: "New Message",
                message: "John sent you a message: Hey, how's the project going?",
                time: "3h ago",
                type: .message,
                isRead: false
            )
            
            NotificationCard(
                title: "Warning",
                message: "Your storage is almost full. Consider upgrading.",
                time: "Yesterday",
                type: .warning,
                isRead: true,
                onDismiss: {}
            )
            
            NotificationCard(
                title: "Error",
                message: "Failed to sync data. Please check your connection.",
                time: "2d ago",
                type: .error,
                isRead: false
            )
            
            Divider().padding(.vertical, 8)
            
            NotificationBanner(
                message: "Your trial expires in 3 days",
                type: .warning,
                action: {},
                actionLabel: "Upgrade",
                onDismiss: {}
            )
            
            NotificationBanner(
                message: "Successfully saved!",
                type: .success,
                onDismiss: {}
            )
            
            HStack(spacing: 20) {
                NotificationDot()
                NotificationDot(count: 5)
                NotificationDot(count: 42, color: .blue)
                NotificationDot(count: 150, size: .large)
            }
            .padding()
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
