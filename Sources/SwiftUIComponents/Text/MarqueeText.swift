import SwiftUI

/// Text that scrolls horizontally when it overflows its container.
///
/// `MarqueeText` creates a classic scrolling text effect, useful for
/// displaying long titles or messages in constrained spaces.
///
/// ```swift
/// MarqueeText("This is a very long text that will scroll horizontally")
///     .frame(width: 200)
/// ```
public struct MarqueeText: View {
    // MARK: - Types
    
    /// The direction of the scroll animation.
    public enum ScrollDirection {
        case leftToRight
        case rightToLeft
    }
    
    /// The animation style.
    public enum AnimationStyle {
        case continuous
        case bounce
        case pauseAtEdges
    }
    
    // MARK: - Properties
    
    private let text: String
    private let font: Font
    private let textColor: Color
    private let direction: ScrollDirection
    private let speed: Double
    private let spacing: CGFloat
    private let animationStyle: AnimationStyle
    private let pauseDuration: Double
    private let fadeEdges: Bool
    private let fadeWidth: CGFloat
    
    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new marquee text view.
    /// - Parameters:
    ///   - text: The text to display.
    ///   - font: The text font. Defaults to `.body`.
    ///   - textColor: The text color. Defaults to `.primary`.
    ///   - direction: Scroll direction. Defaults to `.rightToLeft`.
    ///   - speed: Animation speed (points per second). Defaults to `50`.
    ///   - spacing: Space between repeated text. Defaults to `40`.
    ///   - animationStyle: The animation behavior. Defaults to `.continuous`.
    ///   - pauseDuration: Pause duration for `.pauseAtEdges`. Defaults to `1.5`.
    ///   - fadeEdges: Whether to fade text at edges. Defaults to `true`.
    ///   - fadeWidth: Width of the fade gradient. Defaults to `20`.
    public init(
        _ text: String,
        font: Font = .body,
        textColor: Color = .primary,
        direction: ScrollDirection = .rightToLeft,
        speed: Double = 50,
        spacing: CGFloat = 40,
        animationStyle: AnimationStyle = .continuous,
        pauseDuration: Double = 1.5,
        fadeEdges: Bool = true,
        fadeWidth: CGFloat = 20
    ) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.direction = direction
        self.speed = speed
        self.spacing = spacing
        self.animationStyle = animationStyle
        self.pauseDuration = pauseDuration
        self.fadeEdges = fadeEdges
        self.fadeWidth = fadeWidth
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let needsScroll = textWidth > geometry.size.width
            
            ZStack {
                if needsScroll {
                    scrollingContent
                        .mask(edgeMask)
                } else {
                    staticContent
                }
            }
            .onAppear {
                containerWidth = geometry.size.width
                if needsScroll && !isAnimating {
                    startAnimation()
                }
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                containerWidth = newWidth
                if textWidth > newWidth && !isAnimating {
                    startAnimation()
                }
            }
        }
        .frame(height: textHeight)
        .clipped()
    }
    
    // MARK: - Content Views
    
    private var staticContent: some View {
        Text(text)
            .font(font)
            .foregroundStyle(textColor)
            .lineLimit(1)
            .fixedSize()
            .background(measureTextWidth)
    }
    
    private var scrollingContent: some View {
        HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { _ in
                Text(text)
                    .font(font)
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        .background(measureTextWidth)
        .offset(x: offset)
    }
    
    // MARK: - Edge Mask
    
    @ViewBuilder
    private var edgeMask: some View {
        if fadeEdges {
            HStack(spacing: 0) {
                LinearGradient(
                    colors: [.clear, .white],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: fadeWidth)
                
                Rectangle()
                    .fill(.white)
                
                LinearGradient(
                    colors: [.white, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: fadeWidth)
            }
        } else {
            Rectangle()
        }
    }
    
    // MARK: - Measurement
    
    private var measureTextWidth: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    textWidth = geometry.size.width / 3 - spacing * 2/3
                }
        }
    }
    
    private var textHeight: CGFloat {
        let uiFont: UIFont
        switch font {
        case .largeTitle:
            uiFont = .preferredFont(forTextStyle: .largeTitle)
        case .title:
            uiFont = .preferredFont(forTextStyle: .title1)
        case .title2:
            uiFont = .preferredFont(forTextStyle: .title2)
        case .title3:
            uiFont = .preferredFont(forTextStyle: .title3)
        case .headline:
            uiFont = .preferredFont(forTextStyle: .headline)
        case .subheadline:
            uiFont = .preferredFont(forTextStyle: .subheadline)
        case .callout:
            uiFont = .preferredFont(forTextStyle: .callout)
        case .caption:
            uiFont = .preferredFont(forTextStyle: .caption1)
        case .caption2:
            uiFont = .preferredFont(forTextStyle: .caption2)
        case .footnote:
            uiFont = .preferredFont(forTextStyle: .footnote)
        default:
            uiFont = .preferredFont(forTextStyle: .body)
        }
        return uiFont.lineHeight + 4
    }
    
    // MARK: - Animation
    
    private func startAnimation() {
        isAnimating = true
        
        switch animationStyle {
        case .continuous:
            continuousAnimation()
        case .bounce:
            bounceAnimation()
        case .pauseAtEdges:
            pauseAtEdgesAnimation()
        }
    }
    
    private func continuousAnimation() {
        let totalWidth = textWidth + spacing
        let duration = totalWidth / speed
        
        // Start from right
        offset = direction == .rightToLeft ? 0 : -totalWidth
        
        withAnimation(
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
        ) {
            offset = direction == .rightToLeft ? -totalWidth : 0
        }
    }
    
    private func bounceAnimation() {
        let totalTravel = textWidth - containerWidth + spacing
        let duration = totalTravel / speed
        
        offset = 0
        
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            offset = -totalTravel
        }
    }
    
    private func pauseAtEdgesAnimation() {
        let totalTravel = textWidth - containerWidth + spacing
        let duration = totalTravel / speed
        
        func animateForward() {
            offset = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
                withAnimation(.linear(duration: duration)) {
                    offset = -totalTravel
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration + pauseDuration) {
                    withAnimation(.linear(duration: duration)) {
                        offset = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        animateForward()
                    }
                }
            }
        }
        
        animateForward()
    }
}

// MARK: - News Ticker

/// A news ticker style marquee with multiple items.
public struct NewsTicker: View {
    private let items: [String]
    private let separator: String
    private let font: Font
    private let textColor: Color
    private let separatorColor: Color
    private let speed: Double
    
    public init(
        items: [String],
        separator: String = " • ",
        font: Font = .subheadline,
        textColor: Color = .primary,
        separatorColor: Color = .secondary,
        speed: Double = 40
    ) {
        self.items = items
        self.separator = separator
        self.font = font
        self.textColor = textColor
        self.separatorColor = separatorColor
        self.speed = speed
    }
    
    public var body: some View {
        let combinedText = items.joined(separator: separator)
        
        MarqueeText(
            combinedText + separator,
            font: font,
            textColor: textColor,
            speed: speed,
            animationStyle: .continuous
        )
    }
}

// MARK: - Vertical Marquee

/// Text that scrolls vertically.
public struct VerticalMarqueeText: View {
    private let texts: [String]
    private let font: Font
    private let textColor: Color
    private let displayDuration: Double
    private let transitionDuration: Double
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    public init(
        texts: [String],
        font: Font = .body,
        textColor: Color = .primary,
        displayDuration: Double = 3.0,
        transitionDuration: Double = 0.5
    ) {
        self.texts = texts
        self.font = font
        self.textColor = textColor
        self.displayDuration = displayDuration
        self.transitionDuration = transitionDuration
    }
    
    public var body: some View {
        Text(texts.isEmpty ? "" : texts[currentIndex])
            .font(font)
            .foregroundStyle(textColor)
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        guard texts.count > 1 else { return }
        
        Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: transitionDuration)) {
                offset = -20
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
                currentIndex = (currentIndex + 1) % texts.count
                offset = 20
                
                withAnimation(.easeInOut(duration: transitionDuration)) {
                    offset = 0
                    opacity = 1
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading) {
            Text("Continuous Scroll:")
                .font(.caption)
            MarqueeText(
                "This is a very long text that will continuously scroll from right to left",
                font: .headline,
                speed: 40
            )
            .frame(width: 250)
        }
        
        VStack(alignment: .leading) {
            Text("Bounce:")
                .font(.caption)
            MarqueeText(
                "Bouncing back and forth smoothly",
                animationStyle: .bounce,
                fadeEdges: false
            )
            .frame(width: 180)
        }
        
        VStack(alignment: .leading) {
            Text("News Ticker:")
                .font(.caption)
            NewsTicker(
                items: [
                    "Breaking: SwiftUI is awesome",
                    "Weather: Sunny 72°F",
                    "Sports: Local team wins"
                ],
                font: .subheadline.bold()
            )
            .frame(width: 280)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
        }
        
        VStack(alignment: .leading) {
            Text("Vertical:")
                .font(.caption)
            VerticalMarqueeText(
                texts: ["First message", "Second message", "Third message"],
                font: .title3
            )
            .frame(height: 30)
        }
    }
    .padding()
}
#endif
