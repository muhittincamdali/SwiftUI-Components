import SwiftUI

/// A card displaying customer testimonials
public struct TestimonialCard: View {
    let quote: String
    let authorName: String
    let authorTitle: String?
    let rating: Int?
    let avatarInitials: String?
    let style: TestimonialStyle
    
    public enum TestimonialStyle {
        case standard
        case minimal
        case featured
        case bubble
    }
    
    public init(
        quote: String,
        authorName: String,
        authorTitle: String? = nil,
        rating: Int? = nil,
        avatarInitials: String? = nil,
        style: TestimonialStyle = .standard
    ) {
        self.quote = quote
        self.authorName = authorName
        self.authorTitle = authorTitle
        self.rating = rating
        self.avatarInitials = avatarInitials ?? String(authorName.prefix(2)).uppercased()
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .minimal:
                minimalView
            case .featured:
                featuredView
            case .bubble:
                bubbleView
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Testimonial from \(authorName): \(quote)")
    }
    
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    colors: [.orange, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            Text(avatarInitials ?? "")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 48, height: 48)
    }
    
    @ViewBuilder
    private var ratingStars: some View {
        if let rating = rating {
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: 14))
                        .foregroundColor(star <= rating ? .yellow : .gray.opacity(0.3))
                }
            }
        }
    }
    
    private var standardView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ratingStars
            
            Text("\"\(quote)\"")
                .font(.system(size: 15))
                .italic()
                .foregroundColor(.primary.opacity(0.9))
            
            HStack(spacing: 12) {
                avatar
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(authorName)
                        .font(.system(size: 14, weight: .semibold))
                    
                    if let title = authorTitle {
                        Text(title)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    private var minimalView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.system(size: 24))
                    .foregroundColor(.accentColor.opacity(0.5))
                Spacer()
            }
            
            Text(quote)
                .font(.system(size: 14))
                .foregroundColor(.primary.opacity(0.85))
            
            HStack(spacing: 8) {
                Text("—")
                Text(authorName)
                    .font(.system(size: 13, weight: .medium))
                
                if let title = authorTitle {
                    Text("·")
                    Text(title)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var featuredView: some View {
        VStack(spacing: 20) {
            avatar
                .scaleEffect(1.2)
            
            ratingStars
            
            Text("\"\(quote)\"")
                .font(.system(size: 17))
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary.opacity(0.9))
            
            VStack(spacing: 4) {
                Text(authorName)
                    .font(.system(size: 16, weight: .bold))
                
                if let title = authorTitle {
                    Text(title)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 5)
    }
    
    private var bubbleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Speech bubble
            VStack(alignment: .leading, spacing: 8) {
                ratingStars
                
                Text(quote)
                    .font(.system(size: 14))
            }
            .padding(16)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                Triangle()
                    .fill(Color(.systemGray6))
                    .frame(width: 16, height: 10)
                    .offset(x: 20, y: 5),
                alignment: .bottomLeading
            )
            
            // Author
            HStack(spacing: 10) {
                avatar
                    .scaleEffect(0.8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(authorName)
                        .font(.system(size: 13, weight: .semibold))
                    
                    if let title = authorTitle {
                        Text(title)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.leading, 8)
            .padding(.top, 4)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

/// A carousel of testimonials
public struct TestimonialCarousel: View {
    let testimonials: [TestimonialCard]
    @State private var currentIndex = 0
    
    public init(testimonials: [TestimonialCard]) {
        self.testimonials = testimonials
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentIndex) {
                ForEach(0..<testimonials.count, id: \.self) { index in
                    testimonials[index]
                        .padding(.horizontal)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)
            
            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<testimonials.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }
        }
    }
}

#Preview("Testimonial Cards") {
    ScrollView {
        VStack(spacing: 24) {
            TestimonialCard(
                quote: "This app has completely transformed how I manage my daily tasks. The interface is intuitive and the features are exactly what I needed.",
                authorName: "Sarah Johnson",
                authorTitle: "Product Manager",
                rating: 5,
                style: .standard
            )
            
            TestimonialCard(
                quote: "Simple, elegant, and powerful. Highly recommend!",
                authorName: "Mike Chen",
                authorTitle: "Designer",
                style: .minimal
            )
            
            TestimonialCard(
                quote: "The best investment I've made for my productivity. Worth every penny.",
                authorName: "Emily Davis",
                authorTitle: "CEO, TechStart",
                rating: 5,
                style: .featured
            )
            
            TestimonialCard(
                quote: "Love the dark mode and the smooth animations. Great attention to detail!",
                authorName: "Alex Kim",
                authorTitle: "iOS Developer",
                rating: 4,
                style: .bubble
            )
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
