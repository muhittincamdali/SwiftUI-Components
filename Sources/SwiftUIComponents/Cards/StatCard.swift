import SwiftUI

/// A card displaying statistics with optional trend indicator
public struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String?
    let trend: Trend?
    let color: Color
    let style: StatCardStyle
    
    public struct Trend {
        let value: Double
        let isPositive: Bool
        let label: String?
        
        public init(value: Double, isPositive: Bool, label: String? = nil) {
            self.value = value
            self.isPositive = isPositive
            self.label = label
        }
    }
    
    public enum StatCardStyle {
        case standard
        case minimal
        case gradient
        case outlined
        case compact
    }
    
    public init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String? = nil,
        trend: Trend? = nil,
        color: Color = .accentColor,
        style: StatCardStyle = .standard
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.trend = trend
        self.color = color
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .minimal:
                minimalView
            case .gradient:
                gradientView
            case .outlined:
                outlinedView
            case .compact:
                compactView
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
    
    @ViewBuilder
    private var trendView: some View {
        if let trend = trend {
            HStack(spacing: 4) {
                Image(systemName: trend.isPositive ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: 12, weight: .bold))
                Text(String(format: "%.1f%%", abs(trend.value)))
                    .font(.system(size: 12, weight: .semibold))
                if let label = trend.label {
                    Text(label)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(trend.isPositive ? .green : .red)
        }
    }
    
    @ViewBuilder
    private var iconView: some View {
        if let icon = icon {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(10)
        }
    }
    
    private var standardView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                iconView
                Spacer()
                trendView
            }
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    private var minimalView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                
                trendView
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var gradientView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                }
                Spacer()
                trendView
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
        .background(
            LinearGradient(
                colors: [color, color.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: color.opacity(0.4), radius: 10, x: 0, y: 4)
    }
    
    private var outlinedView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                iconView
                Spacer()
                trendView
            }
            
            Text(value)
                .font(.system(size: 26, weight: .bold))
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
        .cornerRadius(14)
    }
    
    private var compactView: some View {
        HStack(spacing: 12) {
            iconView
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 18, weight: .bold))
            }
            
            Spacer()
            
            trendView
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

/// A grid of stat cards
public struct StatGrid: View {
    let stats: [StatCard]
    let columns: Int
    
    public init(stats: [StatCard], columns: Int = 2) {
        self.stats = stats
        self.columns = columns
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: columns), spacing: 12) {
            ForEach(0..<stats.count, id: \.self) { index in
                stats[index]
            }
        }
    }
}

#Preview("Stat Cards") {
    ScrollView {
        VStack(spacing: 20) {
            StatCard(
                title: "Total Revenue",
                value: "$124,500",
                icon: "dollarsign.circle.fill",
                trend: .init(value: 12.5, isPositive: true, label: "vs last month"),
                color: .green,
                style: .standard
            )
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Users",
                    value: "8,542",
                    trend: .init(value: 8.2, isPositive: true),
                    style: .minimal
                )
                
                StatCard(
                    title: "Bounce Rate",
                    value: "24.5%",
                    trend: .init(value: 3.1, isPositive: false),
                    style: .minimal
                )
            }
            
            StatCard(
                title: "Active Subscribers",
                value: "12,847",
                icon: "person.3.fill",
                trend: .init(value: 15.3, isPositive: true),
                color: .purple,
                style: .gradient
            )
            
            StatCard(
                title: "Conversion Rate",
                value: "3.24%",
                icon: "chart.line.uptrend.xyaxis",
                trend: .init(value: 0.8, isPositive: true),
                color: .orange,
                style: .outlined
            )
            
            StatCard(
                title: "Orders",
                value: "1,234",
                icon: "cart.fill",
                trend: .init(value: 5.2, isPositive: true),
                color: .blue,
                style: .compact
            )
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
