import SwiftUI

/// A customizable page indicator for paged content.
///
/// `PageIndicator` shows the current position in a paged view
/// with various styles and animations.
///
/// ```swift
/// PageIndicator(currentPage: $currentPage, totalPages: 5)
/// ```
public struct PageIndicator: View {
    // MARK: - Types
    
    /// The visual style of the page indicator.
    public enum Style {
        case dots
        case pills
        case numbers
        case progress
        case worm
    }
    
    // MARK: - Properties
    
    @Binding private var currentPage: Int
    private let totalPages: Int
    private let style: Style
    private let activeColor: Color
    private let inactiveColor: Color
    private let dotSize: CGFloat
    private let spacing: CGFloat
    private let interactive: Bool
    
    // MARK: - Initialization
    
    /// Creates a new page indicator.
    public init(
        currentPage: Binding<Int>,
        totalPages: Int,
        style: Style = .dots,
        activeColor: Color = .blue,
        inactiveColor: Color = .gray.opacity(0.4),
        dotSize: CGFloat = 8,
        spacing: CGFloat = 8,
        interactive: Bool = true
    ) {
        self._currentPage = currentPage
        self.totalPages = totalPages
        self.style = style
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
        self.spacing = spacing
        self.interactive = interactive
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .dots:
                dotsIndicator
            case .pills:
                pillsIndicator
            case .numbers:
                numbersIndicator
            case .progress:
                progressIndicator
            case .worm:
                wormIndicator
            }
        }
    }
    
    // MARK: - Dots Indicator
    
    private var dotsIndicator: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? activeColor : inactiveColor)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    .onTapGesture {
                        if interactive {
                            withAnimation {
                                currentPage = index
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Pills Indicator
    
    private var pillsIndicator: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(currentPage == index ? activeColor : inactiveColor)
                    .frame(width: currentPage == index ? dotSize * 2.5 : dotSize, height: dotSize)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    .onTapGesture {
                        if interactive {
                            withAnimation {
                                currentPage = index
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - Numbers Indicator
    
    private var numbersIndicator: some View {
        HStack(spacing: 4) {
            Text("\(currentPage + 1)")
                .font(.subheadline.monospacedDigit())
                .fontWeight(.bold)
                .foregroundStyle(activeColor)
            
            Text("/")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("\(totalPages)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(inactiveColor)
                
                Capsule()
                    .fill(activeColor)
                    .frame(width: geometry.size.width * CGFloat(currentPage + 1) / CGFloat(totalPages))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
        .frame(height: dotSize / 2)
        .frame(width: CGFloat(totalPages) * (dotSize + spacing) * 2)
    }
    
    // MARK: - Worm Indicator
    
    private var wormIndicator: some View {
        GeometryReader { geometry in
            let dotWidth = dotSize
            let totalWidth = CGFloat(totalPages) * dotWidth + CGFloat(totalPages - 1) * spacing
            let startX = (geometry.size.width - totalWidth) / 2
            
            ZStack(alignment: .leading) {
                // Background dots
                HStack(spacing: spacing) {
                    ForEach(0..<totalPages, id: \.self) { _ in
                        Circle()
                            .fill(inactiveColor)
                            .frame(width: dotWidth, height: dotWidth)
                    }
                }
                
                // Animated worm
                Capsule()
                    .fill(activeColor)
                    .frame(width: dotWidth * 1.5, height: dotWidth)
                    .offset(x: CGFloat(currentPage) * (dotWidth + spacing))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
            }
        }
        .frame(height: dotSize)
        .frame(width: CGFloat(totalPages) * (dotSize + spacing) + dotSize)
    }
}

// MARK: - Scrolling Page Indicator

/// A page indicator that handles many pages with scrolling.
public struct ScrollingPageIndicator: View {
    @Binding private var currentPage: Int
    private let totalPages: Int
    private let visibleDots: Int
    private let activeColor: Color
    private let inactiveColor: Color
    private let dotSize: CGFloat
    
    public init(
        currentPage: Binding<Int>,
        totalPages: Int,
        visibleDots: Int = 7,
        activeColor: Color = .blue,
        inactiveColor: Color = .gray.opacity(0.4),
        dotSize: CGFloat = 8
    ) {
        self._currentPage = currentPage
        self.totalPages = totalPages
        self.visibleDots = visibleDots
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            ForEach(visibleRange, id: \.self) { index in
                let scale = scaleForIndex(index)
                
                Circle()
                    .fill(currentPage == index ? activeColor : inactiveColor)
                    .frame(width: dotSize * scale, height: dotSize * scale)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
    
    private var visibleRange: Range<Int> {
        let half = visibleDots / 2
        var start = max(0, currentPage - half)
        var end = min(totalPages, start + visibleDots)
        
        if end - start < visibleDots {
            start = max(0, end - visibleDots)
        }
        
        return start..<end
    }
    
    private func scaleForIndex(_ index: Int) -> CGFloat {
        let distance = abs(currentPage - index)
        switch distance {
        case 0: return 1.2
        case 1: return 1.0
        case 2: return 0.8
        default: return 0.6
        }
    }
}

#if DEBUG
struct PageIndicatorPreview: View {
    @State private var page1 = 0
    @State private var page2 = 0
    @State private var page3 = 2
    @State private var page4 = 0
    @State private var page5 = 5
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Dots").font(.caption)
                PageIndicator(currentPage: $page1, totalPages: 5, style: .dots)
            }
            
            VStack {
                Text("Pills").font(.caption)
                PageIndicator(currentPage: $page2, totalPages: 5, style: .pills)
            }
            
            VStack {
                Text("Numbers").font(.caption)
                PageIndicator(currentPage: $page3, totalPages: 5, style: .numbers)
            }
            
            VStack {
                Text("Progress").font(.caption)
                PageIndicator(currentPage: $page4, totalPages: 5, style: .progress)
            }
            
            VStack {
                Text("Scrolling (many pages)").font(.caption)
                ScrollingPageIndicator(currentPage: $page5, totalPages: 20)
            }
            
            HStack {
                Button("Prev") {
                    withAnimation {
                        page1 = max(0, page1 - 1)
                        page2 = max(0, page2 - 1)
                        page3 = max(0, page3 - 1)
                        page4 = max(0, page4 - 1)
                        page5 = max(0, page5 - 1)
                    }
                }
                
                Button("Next") {
                    withAnimation {
                        page1 = min(4, page1 + 1)
                        page2 = min(4, page2 + 1)
                        page3 = min(4, page3 + 1)
                        page4 = min(4, page4 + 1)
                        page5 = min(19, page5 + 1)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    PageIndicatorPreview()
}
#endif
