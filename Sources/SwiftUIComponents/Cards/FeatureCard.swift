import SwiftUI

/// A card for highlighting features
public struct FeatureCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let style: FeatureCardStyle
    let onTap: (() -> Void)?
    
    public enum FeatureCardStyle {
        case standard
        case horizontal
        case icon
        case numbered(Int)
        case gradient
    }
    
    public init(
        title: String,
        description: String,
        icon: String,
        color: Color = .accentColor,
        style: FeatureCardStyle = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.color = color
        self.style = style
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .horizontal:
                horizontalView
            case .icon:
                iconView
            case .numbered(let number):
                numberedView(number)
            case .gradient:
                gradientView
            }
        }
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(description)")
    }
    
    private var iconBox: some View {
        Image(systemName: icon)
            .font(.system(size: 24))
            .foregroundColor(color)
            .frame(width: 56, height: 56)
            .background(color.opacity(0.15))
            .cornerRadius(14)
    }
    
    private var standardView: some View {
        VStack(alignment: .leading, spacing: 12) {
            iconBox
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    private var horizontalView: some View {
        HStack(spacing: 16) {
            iconBox
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if onTap != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
    
    private var iconView: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
                .frame(width: 72, height: 72)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
    
    private func numberedView(_ number: Int) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
    
    private var gradientView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(description)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(3)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 160, alignment: .leading)
        .background(
            LinearGradient(
                colors: [color, color.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: color.opacity(0.4), radius: 10, x: 0, y: 4)
    }
}

/// A showcase card for app features
public struct ShowcaseCard: View {
    let title: String
    let description: String
    let imageName: String?
    let badge: String?
    let onLearnMore: (() -> Void)?
    
    public init(
        title: String,
        description: String,
        imageName: String? = nil,
        badge: String? = nil,
        onLearnMore: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.badge = badge
        self.onLearnMore = onLearnMore
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            ZStack(alignment: .topTrailing) {
                LinearGradient(
                    colors: [.purple.opacity(0.6), .blue.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 160)
                
                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .cornerRadius(6)
                        .padding(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                if onLearnMore != nil {
                    Button(action: { onLearnMore?() }) {
                        HStack(spacing: 4) {
                            Text("Learn More")
                                .font(.system(size: 14, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(.accentColor)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

#Preview("Feature Cards") {
    ScrollView {
        VStack(spacing: 20) {
            FeatureCard(
                title: "Fast Performance",
                description: "Lightning-fast load times with optimized caching and lazy loading.",
                icon: "bolt.fill",
                color: .yellow,
                style: .standard
            )
            
            FeatureCard(
                title: "Secure by Default",
                description: "Enterprise-grade encryption for all your data.",
                icon: "lock.fill",
                color: .green,
                style: .horizontal
            )
            
            HStack(spacing: 12) {
                FeatureCard(
                    title: "Cloud Sync",
                    description: "Auto-sync across devices",
                    icon: "cloud.fill",
                    color: .blue,
                    style: .icon
                )
                
                FeatureCard(
                    title: "Analytics",
                    description: "Real-time insights",
                    icon: "chart.bar.fill",
                    color: .purple,
                    style: .icon
                )
            }
            
            FeatureCard(
                title: "Step One: Sign Up",
                description: "Create your account in seconds with email or social login.",
                icon: "person.fill",
                color: .orange,
                style: .numbered(1)
            )
            
            FeatureCard(
                title: "Premium Features",
                description: "Unlock all features with our premium plan.",
                icon: "star.fill",
                color: .purple,
                style: .gradient
            )
            
            ShowcaseCard(
                title: "New Dark Mode",
                description: "Enjoy a beautiful dark theme that's easy on your eyes during night sessions.",
                badge: "NEW",
                onLearnMore: {}
            )
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
