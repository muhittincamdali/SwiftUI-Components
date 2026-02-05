import SwiftUI

/// A card displaying user profile information
public struct ProfileCard: View {
    let name: String
    let subtitle: String?
    let avatarURL: URL?
    let avatarInitials: String?
    let stats: [ProfileStat]?
    let style: ProfileCardStyle
    let onTap: (() -> Void)?
    
    public struct ProfileStat: Identifiable {
        public let id = UUID()
        let value: String
        let label: String
        
        public init(value: String, label: String) {
            self.value = value
            self.label = label
        }
    }
    
    public enum ProfileCardStyle {
        case compact
        case standard
        case expanded
        case horizontal
    }
    
    public init(
        name: String,
        subtitle: String? = nil,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        stats: [ProfileStat]? = nil,
        style: ProfileCardStyle = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.subtitle = subtitle
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials ?? String(name.prefix(2)).uppercased()
        self.stats = stats
        self.style = style
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            switch style {
            case .compact:
                compactView
            case .standard:
                standardView
            case .expanded:
                expandedView
            case .horizontal:
                horizontalView
            }
        }
        .onTapGesture {
            onTap?()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Profile: \(name)")
    }
    
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            Text(avatarInitials ?? "")
                .font(.system(size: avatarSize / 2.5, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: avatarSize, height: avatarSize)
    }
    
    private var avatarSize: CGFloat {
        switch style {
        case .compact: return 40
        case .standard: return 60
        case .expanded: return 80
        case .horizontal: return 50
        }
    }
    
    private var compactView: some View {
        HStack(spacing: 12) {
            avatar
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 14, weight: .semibold))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var standardView: some View {
        VStack(spacing: 12) {
            avatar
            
            Text(name)
                .font(.system(size: 18, weight: .bold))
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            if let stats = stats {
                HStack(spacing: 24) {
                    ForEach(stats) { stat in
                        VStack(spacing: 2) {
                            Text(stat.value)
                                .font(.system(size: 16, weight: .bold))
                            Text(stat.label)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }
    
    private var expandedView: some View {
        VStack(spacing: 0) {
            // Cover gradient
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 80)
            
            // Avatar overlapping cover
            avatar
                .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 4))
                .offset(y: -40)
                .padding(.bottom, -40)
            
            VStack(spacing: 8) {
                Text(name)
                    .font(.system(size: 20, weight: .bold))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                if let stats = stats {
                    Divider()
                        .padding(.vertical, 12)
                    
                    HStack {
                        ForEach(stats) { stat in
                            Spacer()
                            VStack(spacing: 2) {
                                Text(stat.value)
                                    .font(.system(size: 18, weight: .bold))
                                Text(stat.label)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 5)
    }
    
    private var horizontalView: some View {
        HStack(spacing: 16) {
            avatar
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let stats = stats, let first = stats.first {
                VStack(alignment: .trailing, spacing: 2) {
                    Text(first.value)
                        .font(.system(size: 16, weight: .bold))
                    Text(first.label)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}

#Preview("Profile Cards") {
    ScrollView {
        VStack(spacing: 20) {
            ProfileCard(name: "John Doe", subtitle: "@johndoe", style: .compact)
            
            ProfileCard(
                name: "Jane Smith",
                subtitle: "iOS Developer",
                stats: [
                    .init(value: "1.2K", label: "Posts"),
                    .init(value: "45K", label: "Followers"),
                    .init(value: "890", label: "Following")
                ],
                style: .standard
            )
            
            ProfileCard(
                name: "Alex Johnson",
                subtitle: "Product Designer",
                stats: [
                    .init(value: "234", label: "Projects"),
                    .init(value: "12K", label: "Likes"),
                    .init(value: "5.0", label: "Rating")
                ],
                style: .expanded
            )
            
            ProfileCard(
                name: "Sarah Wilson",
                subtitle: "Marketing Lead",
                stats: [.init(value: "4.9★", label: "Rating")],
                style: .horizontal
            )
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
