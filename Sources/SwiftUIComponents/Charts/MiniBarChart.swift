import SwiftUI

/// A compact bar chart for inline data visualization.
///
/// `MiniBarChart` displays categorical data in a small format,
/// perfect for quick comparisons in limited space.
///
/// ```swift
/// MiniBarChart(data: [30, 45, 60, 25, 50])
///     .frame(width: 100, height: 40)
/// ```
public struct MiniBarChart: View {
    // MARK: - Types
    
    /// Data point with optional label and color.
    public struct DataPoint: Identifiable {
        public let id = UUID()
        public let value: Double
        public let label: String?
        public let color: Color?
        
        public init(value: Double, label: String? = nil, color: Color? = nil) {
            self.value = value
            self.label = label
            self.color = color
        }
    }
    
    // MARK: - Properties
    
    private let data: [DataPoint]
    private let defaultColor: Color
    private let spacing: CGFloat
    private let cornerRadius: CGFloat
    private let showValues: Bool
    private let animated: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a mini bar chart from raw values.
    public init(
        data: [Double],
        color: Color = .blue,
        spacing: CGFloat = 2,
        cornerRadius: CGFloat = 2,
        showValues: Bool = false,
        animated: Bool = true
    ) {
        self.data = data.map { DataPoint(value: $0) }
        self.defaultColor = color
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.showValues = showValues
        self.animated = animated
    }
    
    /// Creates a mini bar chart from data points.
    public init(
        dataPoints: [DataPoint],
        defaultColor: Color = .blue,
        spacing: CGFloat = 2,
        cornerRadius: CGFloat = 2,
        showValues: Bool = false,
        animated: Bool = true
    ) {
        self.data = dataPoints
        self.defaultColor = defaultColor
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.showValues = showValues
        self.animated = animated
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let barWidth = (geometry.size.width - spacing * CGFloat(data.count - 1)) / CGFloat(data.count)
            let maxValue = data.map(\.value).max() ?? 1
            
            HStack(alignment: .bottom, spacing: spacing) {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, point in
                    let height = (point.value / maxValue) * geometry.size.height
                    
                    VStack(spacing: 2) {
                        if showValues {
                            Text(formatValue(point.value))
                                .font(.system(size: 8))
                                .foregroundStyle(.secondary)
                        }
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(point.color ?? defaultColor)
                            .frame(width: barWidth, height: (animated ? animationProgress : 1) * height)
                    }
                }
            }
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animationProgress = 1
                }
            }
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "%.1fK", value / 1000)
        } else if value == floor(value) {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}

// MARK: - Horizontal Bar Chart

/// A horizontal mini bar chart variant.
public struct HorizontalMiniBarChart: View {
    public struct DataPoint: Identifiable {
        public let id = UUID()
        public let value: Double
        public let label: String
        public let color: Color?
        
        public init(value: Double, label: String, color: Color? = nil) {
            self.value = value
            self.label = label
            self.color = color
        }
    }
    
    private let data: [DataPoint]
    private let defaultColor: Color
    private let barHeight: CGFloat
    private let spacing: CGFloat
    private let showValues: Bool
    private let animated: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public init(
        data: [DataPoint],
        defaultColor: Color = .blue,
        barHeight: CGFloat = 8,
        spacing: CGFloat = 8,
        showValues: Bool = true,
        animated: Bool = true
    ) {
        self.data = data
        self.defaultColor = defaultColor
        self.barHeight = barHeight
        self.spacing = spacing
        self.showValues = showValues
        self.animated = animated
    }
    
    public var body: some View {
        let maxValue = data.map(\.value).max() ?? 1
        
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(data) { point in
                HStack(spacing: 8) {
                    Text(point.label)
                        .font(.caption)
                        .frame(width: 60, alignment: .trailing)
                    
                    GeometryReader { geometry in
                        let width = (point.value / maxValue) * geometry.size.width
                        
                        RoundedRectangle(cornerRadius: barHeight / 2)
                            .fill(point.color ?? defaultColor)
                            .frame(width: (animated ? animationProgress : 1) * width, height: barHeight)
                    }
                    .frame(height: barHeight)
                    
                    if showValues {
                        Text(formatValue(point.value))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 40, alignment: .leading)
                    }
                }
            }
        }
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animationProgress = 1
                }
            }
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "%.1fK", value / 1000)
        }
        return String(format: "%.0f", value)
    }
}

// MARK: - Stacked Bar

/// A single stacked bar showing proportions.
public struct StackedBar: View {
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
    
    private let segments: [Segment]
    private let height: CGFloat
    private let cornerRadius: CGFloat
    private let animated: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public init(
        segments: [Segment],
        height: CGFloat = 8,
        cornerRadius: CGFloat = 4,
        animated: Bool = true
    ) {
        self.segments = segments
        self.height = height
        self.cornerRadius = cornerRadius
        self.animated = animated
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let total = segments.map(\.value).reduce(0, +)
            
            HStack(spacing: 0) {
                ForEach(segments) { segment in
                    let width = (segment.value / total) * geometry.size.width * (animated ? animationProgress : 1)
                    
                    Rectangle()
                        .fill(segment.color)
                        .frame(width: width)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .frame(height: height)
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    animationProgress = 1
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading) {
            Text("Mini Bar Chart")
                .font(.caption)
            MiniBarChart(data: [30, 45, 60, 25, 50, 40])
                .frame(width: 150, height: 50)
        }
        
        VStack(alignment: .leading) {
            Text("With Colors")
                .font(.caption)
            MiniBarChart(dataPoints: [
                .init(value: 30, color: .red),
                .init(value: 45, color: .orange),
                .init(value: 60, color: .green),
                .init(value: 25, color: .blue),
                .init(value: 50, color: .purple)
            ])
            .frame(width: 150, height: 50)
        }
        
        VStack(alignment: .leading) {
            Text("Horizontal Bar")
                .font(.caption)
            HorizontalMiniBarChart(data: [
                .init(value: 80, label: "iOS"),
                .init(value: 60, label: "Android"),
                .init(value: 40, label: "Web")
            ])
            .frame(width: 250)
        }
        
        VStack(alignment: .leading) {
            Text("Stacked Bar")
                .font(.caption)
            StackedBar(segments: [
                .init(value: 40, color: .blue),
                .init(value: 30, color: .green),
                .init(value: 20, color: .orange),
                .init(value: 10, color: .red)
            ])
            .frame(width: 200)
        }
    }
    .padding()
}
#endif
