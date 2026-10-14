import SwiftUI

/// An animated dots loader with multiple animation patterns.
///
/// `DotLoader` provides various dot-based loading animations
/// suitable for different UI contexts.
///
/// ```swift
/// DotLoader(style: .bouncing, color: .blue)
/// ```
public struct DotLoader: View {
    // MARK: - Types
    
    /// The animation style for the dots.
    public enum Style {
        case bouncing
        case fading
        case scaling
        case typing
        case elastic
        case orbital
    }
    
    // MARK: - Properties
    
    private let style: Style
    private let color: Color
    private let dotCount: Int
    private let dotSize: CGFloat
    private let spacing: CGFloat
    private let speed: Double
    
    @State private var animationPhase: [Bool]
    
    // MARK: - Initialization
    
    /// Creates a new dot loader.
    /// - Parameters:
    ///   - style: The animation style. Defaults to `.bouncing`.
    ///   - color: The dot color. Defaults to `.blue`.
    ///   - dotCount: Number of dots. Defaults to `3`.
    ///   - dotSize: Size of each dot. Defaults to `10`.
    ///   - spacing: Spacing between dots. Defaults to `8`.
    ///   - speed: Animation speed. Defaults to `0.6`.
    public init(
        style: Style = .bouncing,
        color: Color = .blue,
        dotCount: Int = 3,
        dotSize: CGFloat = 10,
        spacing: CGFloat = 8,
        speed: Double = 0.6
    ) {
        self.style = style
        self.color = color
        self.dotCount = dotCount
        self.dotSize = dotSize
        self.spacing = spacing
        self.speed = speed
        self._animationPhase = State(initialValue: Array(repeating: false, count: dotCount))
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .bouncing:
                bouncingDots
            case .fading:
                fadingDots
            case .scaling:
                scalingDots
            case .typing:
                typingDots
            case .elastic:
                elasticDots
            case .orbital:
                orbitalDots
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    // MARK: - Bouncing Dots
    
    private var bouncingDots: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: animationPhase[index] ? -dotSize : 0)
            }
        }
    }
    
    // MARK: - Fading Dots
    
    private var fadingDots: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .opacity(animationPhase[index] ? 1.0 : 0.3)
            }
        }
    }
    
    // MARK: - Scaling Dots
    
    private var scalingDots: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(animationPhase[index] ? 1.3 : 0.7)
            }
        }
    }
    
    // MARK: - Typing Dots
    
    private var typingDots: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(animationPhase[index] ? 1.0 : 0.0)
            }
        }
    }
    
    // MARK: - Elastic Dots
    
    private var elasticDots: some View {
        HStack(spacing: spacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(
                        width: animationPhase[index] ? dotSize * 0.7 : dotSize,
                        height: animationPhase[index] ? dotSize * 1.5 : dotSize
                    )
            }
        }
    }
    
    // MARK: - Orbital Dots
    
    @State private var rotation: Double = 0
    
    private var orbitalDots: some View {
        let radius = dotSize * 2
        
        return ZStack {
            ForEach(0..<dotCount, id: \.self) { index in
                let angle = (360.0 / Double(dotCount)) * Double(index)
                Circle()
                    .fill(color)
                    .frame(width: dotSize, height: dotSize)
                    .offset(x: radius)
                    .rotationEffect(.degrees(angle + rotation))
            }
        }
        .frame(width: radius * 2 + dotSize, height: radius * 2 + dotSize)
        .onAppear {
            withAnimation(.linear(duration: speed * 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
    
    // MARK: - Animation
    
    private func startAnimation() {
        for index in 0..<dotCount {
            let delay = Double(index) * (speed / Double(dotCount))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(
                    .easeInOut(duration: speed)
                    .repeatForever(autoreverses: true)
                ) {
                    animationPhase[index] = true
                }
            }
        }
    }
}

// MARK: - Inline Loading Indicator

/// A compact inline loading indicator for text or buttons.
public struct InlineLoader: View {
    private let text: String?
    private let color: Color
    private let dotSize: CGFloat
    
    @State private var phase: Int = 0
    
    public init(text: String? = nil, color: Color = .secondary, dotSize: CGFloat = 4) {
        self.text = text
        self.color = color
        self.dotSize = dotSize
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if let text {
                Text(text)
            }
            
            HStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(color)
                        .frame(width: dotSize, height: dotSize)
                        .opacity(phase == index ? 1.0 : 0.3)
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                phase = (phase + 1) % 3
            }
        }
    }
}

// MARK: - Loading Text

/// Animated "Loading..." text with animated dots.
public struct LoadingText: View {
    private let text: String
    private let font: Font
    private let color: Color
    
    @State private var dotCount: Int = 0
    
    public init(text: String = "Loading", font: Font = .body, color: Color = .secondary) {
        self.text = text
        self.font = font
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(text)
            Text(String(repeating: ".", count: dotCount))
                .frame(width: 20, alignment: .leading)
        }
        .font(font)
        .foregroundStyle(color)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                dotCount = (dotCount + 1) % 4
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            VStack {
                DotLoader(style: .bouncing)
                Text("Bouncing").font(.caption)
            }
            
            VStack {
                DotLoader(style: .fading, color: .purple)
                Text("Fading").font(.caption)
            }
            
            VStack {
                DotLoader(style: .scaling, color: .green)
                Text("Scaling").font(.caption)
            }
        }
        
        HStack(spacing: 40) {
            VStack {
                DotLoader(style: .typing, color: .orange)
                Text("Typing").font(.caption)
            }
            
            VStack {
                DotLoader(style: .elastic, color: .red)
                Text("Elastic").font(.caption)
            }
            
            VStack {
                DotLoader(style: .orbital, color: .blue)
                Text("Orbital").font(.caption)
            }
        }
        
        Divider()
        
        InlineLoader(text: "Sending")
        
        LoadingText()
    }
    .padding()
}
#endif
