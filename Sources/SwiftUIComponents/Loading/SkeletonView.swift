import SwiftUI

/// A skeleton loading placeholder that mimics content layout.
///
/// `SkeletonView` provides pre-built skeleton layouts for common
/// UI patterns like list items, cards, and profiles.
///
/// ```swift
/// SkeletonView.listItem()
/// SkeletonView.card()
/// ```
public struct SkeletonView: View {
    // MARK: - Types
    
    /// Predefined skeleton layout templates.
    public enum Template {
        case text(lines: Int, lastLineWidth: CGFloat)
        case avatar(size: CGFloat)
        case image(height: CGFloat)
        case listItem
        case card
        case profile
        case article
        case custom
    }
    
    // MARK: - Properties
    
    private let template: Template
    private let baseColor: Color
    private let highlightColor: Color
    private let cornerRadius: CGFloat
    private let animationSpeed: Double
    
    // MARK: - Initialization
    
    /// Creates a new skeleton view.
    public init(
        template: Template = .custom,
        baseColor: Color = Color(.systemGray5),
        highlightColor: Color = Color(.systemGray4),
        cornerRadius: CGFloat = 4,
        animationSpeed: Double = 1.5
    ) {
        self.template = template
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.cornerRadius = cornerRadius
        self.animationSpeed = animationSpeed
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch template {
            case .text(let lines, let lastLineWidth):
                textSkeleton(lines: lines, lastLineWidth: lastLineWidth)
            case .avatar(let size):
                avatarSkeleton(size: size)
            case .image(let height):
                imageSkeleton(height: height)
            case .listItem:
                listItemSkeleton
            case .card:
                cardSkeleton
            case .profile:
                profileSkeleton
            case .article:
                articleSkeleton
            case .custom:
                EmptyView()
            }
        }
    }
    
    // MARK: - Text Skeleton
    
    private func textSkeleton(lines: Int, lastLineWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(0..<lines, id: \.self) { index in
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(height: 12)
                    .frame(maxWidth: index == lines - 1 ? .infinity : nil)
                    .frame(width: index == lines - 1 ? nil : nil)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                    .frame(maxWidth: index == lines - 1 ? lastLineWidth : .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Avatar Skeleton
    
    private func avatarSkeleton(size: CGFloat) -> some View {
        Circle()
            .fill(baseColor)
            .frame(width: size, height: size)
            .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
    }
    
    // MARK: - Image Skeleton
    
    private func imageSkeleton(height: CGFloat) -> some View {
        SkeletonShape(cornerRadius: cornerRadius)
            .frame(height: height)
            .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
    }
    
    // MARK: - List Item Skeleton
    
    private var listItemSkeleton: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(baseColor)
                .frame(width: 44, height: 44)
                .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(width: 120, height: 14)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(height: 10)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            }
        }
    }
    
    // MARK: - Card Skeleton
    
    private var cardSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkeletonShape(cornerRadius: 8)
                .frame(height: 160)
                .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            
            VStack(alignment: .leading, spacing: 8) {
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(height: 16)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(width: 200, height: 12)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            }
            .padding(.horizontal, 4)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
    
    // MARK: - Profile Skeleton
    
    private var profileSkeleton: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(baseColor)
                .frame(width: 80, height: 80)
                .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            
            VStack(spacing: 8) {
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(width: 140, height: 18)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(width: 100, height: 12)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            }
            
            HStack(spacing: 20) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: 4) {
                        SkeletonShape(cornerRadius: cornerRadius)
                            .frame(width: 40, height: 16)
                            .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                        
                        SkeletonShape(cornerRadius: cornerRadius)
                            .frame(width: 50, height: 10)
                            .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                    }
                }
            }
        }
    }
    
    // MARK: - Article Skeleton
    
    private var articleSkeleton: some View {
        VStack(alignment: .leading, spacing: 16) {
            SkeletonShape(cornerRadius: 8)
                .frame(height: 200)
                .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            
            VStack(alignment: .leading, spacing: 10) {
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(height: 20)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                
                SkeletonShape(cornerRadius: cornerRadius)
                    .frame(width: 250, height: 20)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
            }
            
            HStack(spacing: 12) {
                Circle()
                    .fill(baseColor)
                    .frame(width: 32, height: 32)
                    .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                
                VStack(alignment: .leading, spacing: 4) {
                    SkeletonShape(cornerRadius: cornerRadius)
                        .frame(width: 80, height: 12)
                        .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                    
                    SkeletonShape(cornerRadius: cornerRadius)
                        .frame(width: 60, height: 10)
                        .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    SkeletonShape(cornerRadius: cornerRadius)
                        .frame(height: 12)
                        .frame(maxWidth: index == 3 ? 200 : .infinity)
                        .shimmer(baseColor: baseColor, highlightColor: highlightColor, speed: animationSpeed)
                }
            }
        }
    }
}

// MARK: - Skeleton Shape

/// A basic skeleton placeholder shape.
public struct SkeletonShape: View {
    let cornerRadius: CGFloat
    
    public init(cornerRadius: CGFloat = 4) {
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}

// MARK: - Shimmer Modifier for Skeleton

private struct SkeletonShimmerModifier: ViewModifier {
    let baseColor: Color
    let highlightColor: Color
    let speed: Double
    
    @State private var phase: CGFloat = -1
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(baseColor)
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: highlightColor.opacity(0.5), location: 0.45),
                            .init(color: highlightColor, location: 0.5),
                            .init(color: highlightColor.opacity(0.5), location: 0.55),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: phase * geometry.size.width * 2)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    fileprivate func shimmer(baseColor: Color, highlightColor: Color, speed: Double) -> some View {
        modifier(SkeletonShimmerModifier(baseColor: baseColor, highlightColor: highlightColor, speed: speed))
    }
}

// MARK: - Convenience Factory Methods

extension SkeletonView {
    /// Creates a text skeleton.
    public static func text(lines: Int = 3, lastLineWidth: CGFloat = 0.7) -> SkeletonView {
        SkeletonView(template: .text(lines: lines, lastLineWidth: lastLineWidth))
    }
    
    /// Creates an avatar skeleton.
    public static func avatar(size: CGFloat = 44) -> SkeletonView {
        SkeletonView(template: .avatar(size: size))
    }
    
    /// Creates an image skeleton.
    public static func image(height: CGFloat = 160) -> SkeletonView {
        SkeletonView(template: .image(height: height))
    }
    
    /// Creates a list item skeleton.
    public static func listItem() -> SkeletonView {
        SkeletonView(template: .listItem)
    }
    
    /// Creates a card skeleton.
    public static func card() -> SkeletonView {
        SkeletonView(template: .card)
    }
    
    /// Creates a profile skeleton.
    public static func profile() -> SkeletonView {
        SkeletonView(template: .profile)
    }
    
    /// Creates an article skeleton.
    public static func article() -> SkeletonView {
        SkeletonView(template: .article)
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 30) {
            SkeletonView.listItem()
            SkeletonView.listItem()
            SkeletonView.listItem()
            
            Divider()
            
            SkeletonView.card()
            
            Divider()
            
            SkeletonView.profile()
            
            Divider()
            
            SkeletonView.article()
        }
        .padding()
    }
}
#endif
