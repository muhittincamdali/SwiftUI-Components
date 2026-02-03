import SwiftUI

/// An animated pulsing loader with multiple style variants.
///
/// `PulseLoader` creates engaging loading indicators with
/// concentric pulsing circles or rings.
///
/// ```swift
/// PulseLoader(color: .blue, style: .rings)
/// ```
public struct PulseLoader: View {
    // MARK: - Types
    
    /// The visual style of the pulse loader.
    public enum Style {
        case single
        case rings
        case dots
        case wave
        case heartbeat
    }
    
    // MARK: - Properties
    
    private let color: Color
    private let style: Style
    private let size: CGFloat
    private let lineWidth: CGFloat
    private let speed: Double
    
    @State private var animate: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new pulse loader.
    /// - Parameters:
    ///   - color: The pulse color. Defaults to `.blue`.
    ///   - style: The animation style. Defaults to `.rings`.
    ///   - size: The loader size. Defaults to `60`.
    ///   - lineWidth: Line width for ring styles. Defaults to `4`.
    ///   - speed: Animation duration. Defaults to `1.5`.
    public init(
        color: Color = .blue,
        style: Style = .rings,
        size: CGFloat = 60,
        lineWidth: CGFloat = 4,
        speed: Double = 1.5
    ) {
        self.color = color
        self.style = style
        self.size = size
        self.lineWidth = lineWidth
        self.speed = speed
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .single:
                singlePulse
            case .rings:
                ringsPulse
            case .dots:
                dotsPulse
            case .wave:
                wavePulse
            case .heartbeat:
                heartbeatPulse
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            animate = true
        }
    }
    
    // MARK: - Single Pulse
    
    private var singlePulse: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.3))
                .scaleEffect(animate ? 2.0 : 1.0)
                .opacity(animate ? 0 : 1)
            
            Circle()
                .fill(color)
                .frame(width: size * 0.4, height: size * 0.4)
        }
        .animation(
            .easeInOut(duration: speed)
            .repeatForever(autoreverses: false),
            value: animate
        )
    }
    
    // MARK: - Rings Pulse
    
    private var ringsPulse: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(color.opacity(0.7), lineWidth: lineWidth)
                    .scaleEffect(animate ? 1.0 : 0.0)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: speed)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * speed / 3),
                        value: animate
                    )
            }
        }
    }
    
    // MARK: - Dots Pulse
    
    private var dotsPulse: some View {
        HStack(spacing: size * 0.15) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: size * 0.2, height: size * 0.2)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .opacity(animate ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: speed * 0.5)
                        .repeatForever()
                        .delay(Double(index) * 0.15),
                        value: animate
                    )
            }
        }
    }
    
    // MARK: - Wave Pulse
    
    private var wavePulse: some View {
        HStack(spacing: size * 0.08) {
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: lineWidth / 2)
                    .fill(color)
                    .frame(width: lineWidth, height: size * 0.3)
                    .scaleEffect(y: animate ? 1.5 : 0.5)
                    .animation(
                        .easeInOut(duration: speed * 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.1),
                        value: animate
                    )
            }
        }
    }
    
    // MARK: - Heartbeat Pulse
    
    private var heartbeatPulse: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(color)
            .scaleEffect(animate ? 1.2 : 0.9)
            .animation(
                .easeInOut(duration: speed * 0.3)
                .repeatForever(),
                value: animate
            )
    }
}

// MARK: - Activity Indicator

/// A customizable activity indicator with multiple styles.
public struct ActivityIndicator: View {
    public enum Style {
        case circular
        case linear
        case orbital
    }
    
    private let style: Style
    private let color: Color
    private let size: CGFloat
    private let lineWidth: CGFloat
    
    @State private var rotation: Double = 0
    @State private var progress: Double = 0
    
    public init(
        style: Style = .circular,
        color: Color = .blue,
        size: CGFloat = 40,
        lineWidth: CGFloat = 3
    ) {
        self.style = style
        self.color = color
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        Group {
            switch style {
            case .circular:
                circularIndicator
            case .linear:
                linearIndicator
            case .orbital:
                orbitalIndicator
            }
        }
        .frame(width: size, height: style == .linear ? lineWidth * 2 : size)
        .onAppear {
            startAnimation()
        }
    }
    
    private var circularIndicator: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(rotation))
    }
    
    private var linearIndicator: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(color.opacity(0.2))
                
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * 0.3)
                    .offset(x: progress * (geometry.size.width * 0.7))
            }
        }
    }
    
    private var orbitalIndicator: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .fill(color)
                .frame(width: lineWidth * 2, height: lineWidth * 2)
                .offset(y: -size / 2 + lineWidth)
                .rotationEffect(.degrees(rotation))
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            progress = 1
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 30) {
            PulseLoader(style: .single)
            PulseLoader(style: .rings, color: .purple)
            PulseLoader(style: .dots, color: .green)
        }
        
        HStack(spacing: 30) {
            PulseLoader(style: .wave, color: .orange)
            PulseLoader(style: .heartbeat, color: .red)
        }
        
        HStack(spacing: 30) {
            ActivityIndicator(style: .circular)
            ActivityIndicator(style: .orbital, color: .purple)
        }
        
        ActivityIndicator(style: .linear, color: .blue, size: 200)
            .padding(.horizontal)
    }
    .padding()
}
#endif
