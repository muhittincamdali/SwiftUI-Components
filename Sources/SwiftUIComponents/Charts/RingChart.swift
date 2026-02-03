import SwiftUI

/// A circular ring chart for displaying proportions.
///
/// `RingChart` shows data as segments of a circular ring,
/// with optional center content.
///
/// ```swift
/// RingChart(segments: [
///     .init(value: 60, color: .blue),
///     .init(value: 40, color: .green)
/// ])
/// ```
public struct RingChart: View {
    // MARK: - Types
    
    /// A segment of the ring chart.
    public struct Segment: Identifiable {
        public let id = UUID()
        public let value: Double
        public let color: Color
        public let label: String?
        
        public init(value: Double, color: Color, label: String? = nil) {
            self.value = value
            self.color = color
            self.label = label
        }
    }
    
    // MARK: - Properties
    
    private let segments: [Segment]
    private let lineWidth: CGFloat
    private let spacing: CGFloat
    private let startAngle: Double
    private let animated: Bool
    private let showLabels: Bool
    private let centerContent: AnyView?
    
    @State private var animationProgress: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a new ring chart.
    public init(
        segments: [Segment],
        lineWidth: CGFloat = 20,
        spacing: CGFloat = 2,
        startAngle: Double = -90,
        animated: Bool = true,
        showLabels: Bool = false
    ) {
        self.segments = segments
        self.lineWidth = lineWidth
        self.spacing = spacing
        self.startAngle = startAngle
        self.animated = animated
        self.showLabels = showLabels
        self.centerContent = nil
    }
    
    /// Creates a ring chart with center content.
    public init<Center: View>(
        segments: [Segment],
        lineWidth: CGFloat = 20,
        spacing: CGFloat = 2,
        startAngle: Double = -90,
        animated: Bool = true,
        showLabels: Bool = false,
        @ViewBuilder centerContent: () -> Center
    ) {
        self.segments = segments
        self.lineWidth = lineWidth
        self.spacing = spacing
        self.startAngle = startAngle
        self.animated = animated
        self.showLabels = showLabels
        self.centerContent = AnyView(centerContent())
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                ringSegments(size: size)
                
                if let center = centerContent {
                    center
                        .frame(width: size - lineWidth * 3, height: size - lineWidth * 3)
                }
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animationProgress = 1
                }
            }
        }
    }
    
    // MARK: - Ring Segments
    
    private func ringSegments(size: CGFloat) -> some View {
        let total = segments.map(\.value).reduce(0, +)
        let spacingAngle = (spacing / (size / 2)) * 180 / .pi
        let totalSpacing = spacingAngle * Double(segments.count)
        let availableAngle = 360.0 - totalSpacing
        
        var currentAngle = startAngle
        
        return ZStack {
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                let segmentAngle = (segment.value / total) * availableAngle
                let endAngle = currentAngle + segmentAngle * (animated ? Double(animationProgress) : 1)
                
                RingSegmentShape(
                    startAngle: Angle(degrees: currentAngle),
                    endAngle: Angle(degrees: endAngle),
                    lineWidth: lineWidth
                )
                .fill(segment.color)
                
                // Update for next segment
                let _ = {
                    currentAngle = endAngle + spacingAngle
                }()
            }
        }
    }
}

// MARK: - Ring Segment Shape

private struct RingSegmentShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let lineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

// MARK: - Progress Ring

/// A single progress ring with animated fill.
public struct ProgressRingChart: View {
    private let progress: Double
    private let lineWidth: CGFloat
    private let trackColor: Color
    private let progressColor: Color
    private let animated: Bool
    private let showPercentage: Bool
    
    @State private var animatedProgress: Double = 0
    
    public init(
        progress: Double,
        lineWidth: CGFloat = 16,
        trackColor: Color = Color(.systemGray5),
        progressColor: Color = .blue,
        animated: Bool = true,
        showPercentage: Bool = true
    ) {
        self.progress = min(1, max(0, progress))
        self.lineWidth = lineWidth
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.animated = animated
        self.showPercentage = showPercentage
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                // Track
                Circle()
                    .stroke(trackColor, lineWidth: lineWidth)
                
                // Progress
                Circle()
                    .trim(from: 0, to: animated ? animatedProgress : progress)
                    .stroke(
                        progressColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                // Percentage
                if showPercentage {
                    Text("\(Int((animated ? animatedProgress : progress) * 100))%")
                        .font(.system(size: size * 0.2, weight: .bold, design: .rounded))
                        .foregroundStyle(progressColor)
                }
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Multi Ring Chart

/// Multiple concentric progress rings.
public struct MultiRingChart: View {
    public struct Ring: Identifiable {
        public let id = UUID()
        public let progress: Double
        public let color: Color
        public let label: String?
        
        public init(progress: Double, color: Color, label: String? = nil) {
            self.progress = progress
            self.color = color
            self.label = label
        }
    }
    
    private let rings: [Ring]
    private let lineWidth: CGFloat
    private let spacing: CGFloat
    private let animated: Bool
    
    @State private var animatedProgress: [Double] = []
    
    public init(
        rings: [Ring],
        lineWidth: CGFloat = 12,
        spacing: CGFloat = 6,
        animated: Bool = true
    ) {
        self.rings = rings
        self.lineWidth = lineWidth
        self.spacing = spacing
        self.animated = animated
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                ForEach(Array(rings.enumerated()), id: \.element.id) { index, ring in
                    let radius = size / 2 - CGFloat(index) * (lineWidth + spacing) - lineWidth / 2
                    let progress = animated && index < animatedProgress.count ? animatedProgress[index] : ring.progress
                    
                    ZStack {
                        Circle()
                            .stroke(ring.color.opacity(0.2), lineWidth: lineWidth)
                            .frame(width: radius * 2, height: radius * 2)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(ring.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .frame(width: radius * 2, height: radius * 2)
                            .rotationEffect(.degrees(-90))
                    }
                }
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .onAppear {
            animatedProgress = Array(repeating: 0, count: rings.count)
            
            if animated {
                for (index, ring) in rings.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                            if index < animatedProgress.count {
                                animatedProgress[index] = ring.progress
                            }
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        RingChart(segments: [
            .init(value: 40, color: .blue, label: "Blue"),
            .init(value: 30, color: .green, label: "Green"),
            .init(value: 20, color: .orange, label: "Orange"),
            .init(value: 10, color: .red, label: "Red")
        ]) {
            VStack {
                Text("Total")
                    .font(.caption)
                Text("100")
                    .font(.title.bold())
            }
        }
        .frame(width: 150, height: 150)
        
        ProgressRingChart(progress: 0.75)
            .frame(width: 120, height: 120)
        
        MultiRingChart(rings: [
            .init(progress: 0.9, color: .red),
            .init(progress: 0.7, color: .green),
            .init(progress: 0.5, color: .blue)
        ])
        .frame(width: 140, height: 140)
    }
    .padding()
}
#endif
