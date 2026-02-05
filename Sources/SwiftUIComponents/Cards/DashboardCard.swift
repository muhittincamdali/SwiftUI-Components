import SwiftUI

/// A card for dashboard widgets
public struct DashboardCard: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let content: AnyView
    let headerAction: (() -> Void)?
    let headerActionIcon: String?
    
    public init<Content: View>(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        headerAction: (() -> Void)? = nil,
        headerActionIcon: String? = "ellipsis",
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.headerAction = headerAction
        self.headerActionIcon = headerActionIcon
        self.content = AnyView(content())
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let action = headerAction, let icon = headerActionIcon {
                    Button(action: action) {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
            
            Divider()
            
            // Content
            content
                .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

/// A quick action card for dashboards
public struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    public init(title: String, icon: String, color: Color = .accentColor, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 56, height: 56)
                    .background(color.opacity(0.15))
                    .cornerRadius(14)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Progress overview card
public struct ProgressCard: View {
    let title: String
    let progress: Double
    let target: String
    let current: String
    let color: Color
    
    public init(
        title: String,
        progress: Double,
        target: String,
        current: String,
        color: Color = .accentColor
    ) {
        self.title = title
        self.progress = min(max(progress, 0), 1)
        self.target = target
        self.current = current
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text(current)
                    .font(.system(size: 20, weight: .bold))
                Text("/ \(target)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

/// Activity feed card
public struct ActivityCard: View {
    let activities: [Activity]
    
    public struct Activity: Identifiable {
        public let id = UUID()
        let icon: String
        let color: Color
        let title: String
        let time: String
        
        public init(icon: String, color: Color, title: String, time: String) {
            self.icon = icon
            self.color = color
            self.title = title
            self.time = time
        }
    }
    
    public init(activities: [Activity]) {
        self.activities = activities
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.system(size: 15, weight: .semibold))
            
            ForEach(activities) { activity in
                HStack(spacing: 12) {
                    Image(systemName: activity.icon)
                        .font(.system(size: 14))
                        .foregroundColor(activity.color)
                        .frame(width: 32, height: 32)
                        .background(activity.color.opacity(0.15))
                        .cornerRadius(8)
                    
                    Text(activity.title)
                        .font(.system(size: 13))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(activity.time)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

#Preview("Dashboard Cards") {
    ScrollView {
        VStack(spacing: 16) {
            // Quick actions
            HStack(spacing: 12) {
                QuickActionCard(title: "Add", icon: "plus", color: .blue) {}
                QuickActionCard(title: "Scan", icon: "qrcode.viewfinder", color: .green) {}
                QuickActionCard(title: "Send", icon: "paperplane.fill", color: .orange) {}
                QuickActionCard(title: "More", icon: "ellipsis", color: .purple) {}
            }
            
            // Progress cards
            ProgressCard(
                title: "Monthly Goal",
                progress: 0.72,
                target: "$10,000",
                current: "$7,200",
                color: .green
            )
            
            ProgressCard(
                title: "Storage Used",
                progress: 0.85,
                target: "100 GB",
                current: "85 GB",
                color: .orange
            )
            
            // Dashboard card with custom content
            DashboardCard(
                title: "Revenue",
                subtitle: "Last 7 days",
                icon: "chart.line.uptrend.xyaxis",
                headerAction: {}
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("$24,560")
                        .font(.system(size: 28, weight: .bold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                        Text("+12.5%")
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.green)
                }
            }
            
            // Activity feed
            ActivityCard(activities: [
                .init(icon: "cart.fill", color: .blue, title: "New order #1234", time: "2m ago"),
                .init(icon: "person.fill", color: .green, title: "New user registered", time: "15m ago"),
                .init(icon: "star.fill", color: .yellow, title: "5-star review received", time: "1h ago"),
                .init(icon: "creditcard.fill", color: .purple, title: "Payment processed", time: "2h ago")
            ])
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
