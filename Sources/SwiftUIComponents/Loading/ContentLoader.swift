import SwiftUI

/// A content placeholder loader with multiple styles
public struct ContentLoader: View {
    let style: ContentLoaderStyle
    let animate: Bool
    
    @State private var isAnimating = false
    
    public enum ContentLoaderStyle {
        case card
        case list
        case profile
        case article
        case grid
    }
    
    public init(style: ContentLoaderStyle = .card, animate: Bool = true) {
        self.style = style
        self.animate = animate
    }
    
    public var body: some View {
        Group {
            switch style {
            case .card:
                cardLoader
            case .list:
                listLoader
            case .profile:
                profileLoader
            case .article:
                articleLoader
            case .grid:
                gridLoader
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
    
    private var shimmerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(.systemGray5),
                Color(.systemGray4),
                Color(.systemGray5)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var cardLoader: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(height: 150)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
                .frame(height: 20)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray5))
                .frame(width: 200, height: 16)
            
            HStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(width: 100, height: 12)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 10)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .opacity(isAnimating ? 0.6 : 1.0)
    }
    
    private var listLoader: some View {
        VStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 60)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 150, height: 12)
                    }
                    
                    Spacer()
                }
            }
        }
        .opacity(isAnimating ? 0.6 : 1.0)
    }
    
    private var profileLoader: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 80)
            
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 150, height: 20)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 14)
            }
            
            HStack(spacing: 32) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 18)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 40, height: 12)
                    }
                }
            }
        }
        .opacity(isAnimating ? 0.6 : 1.0)
    }
    
    private var articleLoader: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 24)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 250, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(height: 14)
                }
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(.systemGray5))
                    .frame(width: 200, height: 14)
            }
        }
        .opacity(isAnimating ? 0.6 : 1.0)
    }
    
    private var gridLoader: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(0..<6, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .aspectRatio(1, contentMode: .fill)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 14)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: 80, height: 12)
                }
            }
        }
        .opacity(isAnimating ? 0.6 : 1.0)
    }
}

/// A circular loading spinner
public struct LoadingSpinner: View {
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    
    @State private var isAnimating = false
    
    public init(size: CGFloat = 40, lineWidth: CGFloat = 4, color: Color = .accentColor) {
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

/// A loading overlay view
public struct LoadingOverlay: View {
    let isLoading: Bool
    let message: String?
    let style: OverlayStyle
    
    public enum OverlayStyle {
        case fullscreen
        case blur
        case dimmed
    }
    
    public init(isLoading: Bool, message: String? = nil, style: OverlayStyle = .blur) {
        self.isLoading = isLoading
        self.message = message
        self.style = style
    }
    
    public var body: some View {
        Group {
            if isLoading {
                ZStack {
                    switch style {
                    case .fullscreen:
                        Color(.systemBackground)
                    case .blur:
                        Color.clear.background(.ultraThinMaterial)
                    case .dimmed:
                        Color.black.opacity(0.4)
                    }
                    
                    VStack(spacing: 16) {
                        LoadingSpinner(size: 50, lineWidth: 5)
                        
                        if let message = message {
                            Text(message)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(style == .dimmed ? .white : .primary)
                        }
                    }
                    .padding(32)
                    .background(
                        style == .dimmed ?
                        RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)) :
                        nil
                    )
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

#Preview("Loading Components") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Card Loader")
                    .font(.headline)
                ContentLoader(style: .card)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("List Loader")
                    .font(.headline)
                ContentLoader(style: .list)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Profile Loader")
                    .font(.headline)
                ContentLoader(style: .profile)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Grid Loader")
                    .font(.headline)
                ContentLoader(style: .grid)
            }
            
            HStack(spacing: 32) {
                LoadingSpinner(size: 30, color: .blue)
                LoadingSpinner(size: 40, color: .green)
                LoadingSpinner(size: 50, color: .orange)
            }
        }
        .padding()
    }
}
