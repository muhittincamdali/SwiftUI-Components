import SwiftUI

/// A gauge/speedometer chart
public struct GaugeChart: View {
    let value: Double
    let maxValue: Double
    let label: String?
    let valueLabel: String?
    let style: GaugeStyle
    let colors: [Color]
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public enum GaugeStyle {
        case semicircle
        case threeQuarter
        case full
    }
    
    public init(
        value: Double,
        maxValue: Double = 100,
        label: String? = nil,
        valueLabel: String? = nil,
        style: GaugeStyle = .semicircle,
        colors: [Color] = [.green, .yellow, .red],
        animate: Bool = true
    ) {
        self.value = min(value, maxValue)
        self.maxValue = maxValue
        self.label = label
        self.valueLabel = valueLabel
        self.style = style
        self.colors = colors
        self.animate = animate
    }
    
    private var startAngle: Double {
        switch style {
        case .semicircle: return 180
        case .threeQuarter: return 135
        case .full: return 90
        }
    }
    
    private var endAngle: Double {
        switch style {
        case .semicircle: return 360
        case .threeQuarter: return 405
        case .full: return 450
        }
    }
    
    private var totalAngle: Double {
        endAngle - startAngle
    }
    
    private var currentAngle: Double {
        startAngle + (value / maxValue) * totalAngle * Double(animationProgress)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let lineWidth: CGFloat = size * 0.12
            
            ZStack {
                // Background arc
                Arc(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                    .stroke(Color(.systemGray5), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                
                // Gradient arc
                Arc(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(startAngle),
                            endAngle: .degrees(endAngle)
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .mask(
                        Arc(startAngle: .degrees(startAngle), endAngle: .degrees(currentAngle))
                            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    )
                
                // Needle
                GaugeNeedle()
                    .fill(Color.primary)
                    .frame(width: 4, height: size * 0.35)
                    .offset(y: -size * 0.15)
                    .rotationEffect(.degrees(currentAngle - 90))
                
                // Center circle
                Circle()
                    .fill(Color.primary)
                    .frame(width: size * 0.08, height: size * 0.08)
                
                // Labels
                VStack(spacing: 4) {
                    Text(valueLabel ?? String(format: "%.0f", value * Double(animationProgress)))
                        .font(.system(size: size * 0.15, weight: .bold))
                    
                    if let label = label {
                        Text(label)
                            .font(.system(size: size * 0.06))
                            .foregroundColor(.secondary)
                    }
                }
                .offset(y: style == .semicircle ? size * 0.1 : size * 0.2)
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 1.0)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 20
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path
    }
}

struct GaugeNeedle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX - 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + 2, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

/// A radial progress indicator
public struct RadialProgress: View {
    let value: Double
    let maxValue: Double
    let lineWidth: CGFloat
    let color: Color
    let showLabel: Bool
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public init(
        value: Double,
        maxValue: Double = 100,
        lineWidth: CGFloat = 12,
        color: Color = .accentColor,
        showLabel: Bool = true,
        animate: Bool = true
    ) {
        self.value = min(value, maxValue)
        self.maxValue = maxValue
        self.lineWidth = lineWidth
        self.color = color
        self.showLabel = showLabel
        self.animate = animate
    }
    
    private var progress: Double {
        value / maxValue
    }
    
    public var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: progress * Double(animationProgress))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // Label
            if showLabel {
                Text(String(format: "%.0f%%", progress * 100 * Double(animationProgress)))
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 1.0)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

/// A multi-ring progress view
public struct MultiRingProgress: View {
    let rings: [Ring]
    let lineWidth: CGFloat
    let spacing: CGFloat
    let showLabels: Bool
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public struct Ring: Identifiable {
        public let id = UUID()
        let value: Double
        let maxValue: Double
        let color: Color
        let label: String?
        
        public init(value: Double, maxValue: Double = 100, color: Color, label: String? = nil) {
            self.value = value
            self.maxValue = maxValue
            self.color = color
            self.label = label
        }
    }
    
    public init(
        rings: [Ring],
        lineWidth: CGFloat = 16,
        spacing: CGFloat = 8,
        showLabels: Bool = true,
        animate: Bool = true
    ) {
        self.rings = rings
        self.lineWidth = lineWidth
        self.spacing = spacing
        self.showLabels = showLabels
        self.animate = animate
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                
                ZStack {
                    ForEach(Array(rings.enumerated()), id: \.element.id) { index, ring in
                        let radius = size / 2 - (lineWidth / 2) - CGFloat(index) * (lineWidth + spacing)
                        let progress = ring.value / ring.maxValue
                        
                        // Background
                        Circle()
                            .stroke(ring.color.opacity(0.2), lineWidth: lineWidth)
                            .frame(width: radius * 2, height: radius * 2)
                        
                        // Progress
                        Circle()
                            .trim(from: 0, to: progress * Double(animationProgress))
                            .stroke(ring.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                            .frame(width: radius * 2, height: radius * 2)
                            .rotationEffect(.degrees(-90))
                    }
                }
                .frame(width: size, height: size)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .aspectRatio(1, contentMode: .fit)
            
            // Legend
            if showLabels {
                VStack(spacing: 8) {
                    ForEach(rings) { ring in
                        HStack {
                            Circle()
                                .fill(ring.color)
                                .frame(width: 10, height: 10)
                            
                            if let label = ring.label {
                                Text(label)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.0f%%", (ring.value / ring.maxValue) * 100))
                                .font(.system(size: 12, weight: .medium))
                        }
                    }
                }
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 1.0)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

#Preview("Gauge Charts") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Gauge Chart")
                    .font(.headline)
                
                GaugeChart(
                    value: 72,
                    maxValue: 100,
                    label: "Speed",
                    style: .semicircle
                )
                .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Radial Progress")
                    .font(.headline)
                
                HStack(spacing: 20) {
                    RadialProgress(value: 75, color: .blue)
                        .frame(width: 100, height: 100)
                    
                    RadialProgress(value: 45, color: .green)
                        .frame(width: 100, height: 100)
                    
                    RadialProgress(value: 90, color: .orange)
                        .frame(width: 100, height: 100)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Multi-Ring Progress")
                    .font(.headline)
                
                MultiRingProgress(rings: [
                    .init(value: 85, color: .red, label: "Move"),
                    .init(value: 65, color: .green, label: "Exercise"),
                    .init(value: 45, color: .blue, label: "Stand")
                ])
                .frame(height: 250)
            }
        }
        .padding()
    }
}
