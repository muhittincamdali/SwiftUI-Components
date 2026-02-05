import SwiftUI

/// A card for displaying product information
public struct ProductCard: View {
    let title: String
    let subtitle: String?
    let price: String
    let originalPrice: String?
    let rating: Double?
    let reviewCount: Int?
    let badge: String?
    let imageURL: URL?
    let style: ProductCardStyle
    let onTap: (() -> Void)?
    let onAddToCart: (() -> Void)?
    
    public enum ProductCardStyle {
        case vertical
        case horizontal
        case compact
        case featured
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        price: String,
        originalPrice: String? = nil,
        rating: Double? = nil,
        reviewCount: Int? = nil,
        badge: String? = nil,
        imageURL: URL? = nil,
        style: ProductCardStyle = .vertical,
        onTap: (() -> Void)? = nil,
        onAddToCart: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.originalPrice = originalPrice
        self.rating = rating
        self.reviewCount = reviewCount
        self.badge = badge
        self.imageURL = imageURL
        self.style = style
        self.onTap = onTap
        self.onAddToCart = onAddToCart
    }
    
    public var body: some View {
        Group {
            switch style {
            case .vertical:
                verticalView
            case .horizontal:
                horizontalView
            case .compact:
                compactView
            case .featured:
                featuredView
            }
        }
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(price)")
    }
    
    private var imagePlaceholder: some View {
        ZStack {
            Color(.systemGray5)
            Image(systemName: "photo")
                .font(.system(size: 30))
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var badgeView: some View {
        if let badge = badge {
            Text(badge)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red)
                .cornerRadius(4)
        }
    }
    
    @ViewBuilder
    private var ratingView: some View {
        if let rating = rating {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 12, weight: .medium))
                if let count = reviewCount {
                    Text("(\(count))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var priceView: some View {
        HStack(spacing: 8) {
            Text(price)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            
            if let original = originalPrice {
                Text(original)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .strikethrough()
            }
        }
    }
    
    private var verticalView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                imagePlaceholder
                    .aspectRatio(1, contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                
                badgeView
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                ratingView
                
                HStack {
                    priceView
                    Spacer()
                    if onAddToCart != nil {
                        Button(action: { onAddToCart?() }) {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 18))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .padding(12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    private var horizontalView: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                imagePlaceholder
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
                
                badgeView
                    .padding(6)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                ratingView
                
                Spacer()
                
                HStack {
                    priceView
                    Spacer()
                    if onAddToCart != nil {
                        Button(action: { onAddToCart?() }) {
                            Image(systemName: "cart.badge.plus")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
    
    private var compactView: some View {
        HStack(spacing: 10) {
            imagePlaceholder
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                Text(price)
                    .font(.system(size: 14, weight: .bold))
            }
            
            Spacer()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private var featuredView: some View {
        ZStack(alignment: .bottom) {
            imagePlaceholder
                .aspectRatio(16/9, contentMode: .fill)
                .frame(height: 200)
                .clipped()
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    badgeView
                    Spacer()
                    ratingView
                }
                
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Text(price)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let original = originalPrice {
                        Text(original)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .strikethrough()
                    }
                    
                    Spacer()
                    
                    if onAddToCart != nil {
                        Button(action: { onAddToCart?() }) {
                            Text("Add to Cart")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(16)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
}

#Preview("Product Cards") {
    ScrollView {
        VStack(spacing: 20) {
            ProductCard(
                title: "Wireless Headphones",
                subtitle: "Premium Sound Quality",
                price: "$149.99",
                originalPrice: "$199.99",
                rating: 4.5,
                reviewCount: 2340,
                badge: "25% OFF",
                style: .vertical,
                onAddToCart: {}
            )
            .frame(width: 180)
            
            ProductCard(
                title: "Smart Watch Series 5",
                subtitle: "Health & Fitness Tracker",
                price: "$399.99",
                rating: 4.8,
                reviewCount: 1250,
                style: .horizontal,
                onAddToCart: {}
            )
            
            ProductCard(
                title: "USB-C Cable",
                price: "$19.99",
                style: .compact
            )
            
            ProductCard(
                title: "MacBook Pro 16\"",
                price: "$2,499",
                originalPrice: "$2,799",
                rating: 4.9,
                reviewCount: 890,
                badge: "SALE",
                style: .featured,
                onAddToCart: {}
            )
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
