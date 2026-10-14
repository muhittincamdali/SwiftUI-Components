import SwiftUI

/// A compact sparkline chart for inline data visualization.
///
/// `SparklineChart` displays trends in a small, uncluttered format,
/// perfect for dashboards and list items.
///
/// ```swift
/// SparklineChart(data: [10, 25, 15, 30, 20])
///     .frame(width: 100, height: 30)
/// ```
public struct SparklineChart: View {
    // MARK: - Types
    
    /// The visual style of the sparkline.
    public enum Style {
        case line
        case filled
        case gradient
        case dashed
    }
    
    // MARK: - Properties
    
    private let data: [Double]
    private let style: Style
    private let lineColor: Color
    private let fillColor: Color?
    private let lineWidth: CGFloat
    private let showEndDot: Bool
    private let animated: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    // MARK: - Initialization
    
    /// Creates a new sparkline chart.
    /// - Parameters:
    ///   - data: The data points to display.
    ///   - style: The visual style. Defaults to `.line`.
    ///   - lineColor: The line color. Defaults to `.blue`.
    ///   - fillColor: Optional fill color for gradient style. Defaults to `nil`.
    ///   - lineWidth: The line width. Defaults to `2`.
    ///   - showEndDot: Whether to show a dot at the end. Defaults to `true`.
    ///   - animated: Whether to animate on appear. Defaults to `true`.
    public init(
        data: [Double],
        style: Style = .line,
        lineColor: Color = .blue,
        fillColor: Color? = nil,
        lineWidth: CGFloat = 2,
        showEndDot: Bool = true,
        animated: Bool = true
    ) {
        self.data = data
        self.style = style
        self.lineColor = lineColor
        self.fillColor = fillColor
        self.lineWidth = lineWidth
        self.showEndDot = showEndDot
        self.animated = animated
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch style {
                case .line:
                    linePath(in: geometry.size)
                        .trim(from: 0, to: animated ? animationProgress : 1)
                        .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                
                case .filled:
                    filledPath(in: geometry.size)
                        .fill(lineColor.opacity(0.2))
                    
                    linePath(in: geometry.size)
                        .trim(from: 0, to: animated ? animationProgress : 1)
                        .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                
                case .gradient:
                    filledPath(in: geometry.size)
                        .fill(
                            LinearGradient(
                                colors: [fillColor ?? lineColor.opacity(0.3), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    linePath(in: geometry.size)
                        .trim(from: 0, to: animated ? animationProgress : 1)
                        .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                
                case .dashed:
                    linePath(in: geometry.size)
                        .trim(from: 0, to: animated ? animationProgress : 1)
                        .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, dash: [5, 3]))
                }
                
                if showEndDot, let lastPoint = data.last {
                    endDot(in: geometry.size, value: lastPoint)
                        .opacity(animated ? (animationProgress >= 1 ? 1 : 0) : 1)
                }
            }
        }
        .onAppear {
            if animated {
                withAnimation(.easeOut(duration: 1.0)) {
                    animationProgress = 1
                }
            }
        }
    }
    
    // MARK: - Path Building
    
    private func linePath(in size: CGSize) -> Path {
        guard data.count > 1 else {
            return Path()
        }
        
        var path = Path()
        let points = normalizedPoints(in: size)
        
        path.move(to: points[0])
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        return path
    }
    
    private func filledPath(in size: CGSize) -> Path {
        guard data.count > 1 else {
            return Path()
        }
        
        var path = Path()
        let points = normalizedPoints(in: size)
        
        path.move(to: CGPoint(x: points[0].x, y: size.height))
        path.addLine(to: points[0])
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        
        path.addLine(to: CGPoint(x: points.last!.x, y: size.height))
        path.closeSubpath()
        
        return path
    }
    
    private func normalizedPoints(in size: CGSize) -> [CGPoint] {
        guard let minValue = data.min(), let maxValue = data.max(), maxValue > minValue else {
            return data.enumerated().map { index, _ in
                CGPoint(x: CGFloat(index) / CGFloat(data.count - 1) * size.width, y: size.height / 2)
            }
        }
        
        let range = maxValue - minValue
        
        return data.enumerated().map { index, value in
            let x = CGFloat(index) / CGFloat(data.count - 1) * size.width
            let y = (1 - (value - minValue) / range) * size.height
            return CGPoint(x: x, y: y)
        }
    }
    
    private func endDot(in size: CGSize, value: Double) -> some View {
        let points = normalizedPoints(in: size)
        guard let lastPoint = points.last else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            Circle()
                .fill(lineColor)
                .frame(width: lineWidth * 2.5, height: lineWidth * 2.5)
                .position(lastPoint)
        )
    }
}

// MARK: - Live Sparkline

/// A sparkline that updates in real-time.
public struct LiveSparklineChart: View {
    @Binding private var data: [Double]
    private let maxPoints: Int
    private let lineColor: Color
    private let lineWidth: CGFloat
    
    public init(
        data: Binding<[Double]>,
        maxPoints: Int = 50,
        lineColor: Color = .blue,
        lineWidth: CGFloat = 2
    ) {
        self._data = data
        self.maxPoints = maxPoints
        self.lineColor = lineColor
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        SparklineChart(
            data: Array(data.suffix(maxPoints)),
            lineColor: lineColor,
            lineWidth: lineWidth,
            showEndDot: true,
            animated: false
        )
        .animation(.easeOut(duration: 0.1), value: data)
    }
}

// MARK: - Comparison Sparkline

/// A sparkline showing comparison between two data sets.
public struct ComparisonSparklineChart: View {
    private let primaryData: [Double]
    private let secondaryData: [Double]
    private let primaryColor: Color
    private let secondaryColor: Color
    private let lineWidth: CGFloat
    
    public init(
        primaryData: [Double],
        secondaryData: [Double],
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray,
        lineWidth: CGFloat = 2
    ) {
        self.primaryData = primaryData
        self.secondaryData = secondaryData
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        ZStack {
            SparklineChart(
                data: secondaryData,
                style: .dashed,
                lineColor: secondaryColor,
                lineWidth: lineWidth * 0.8,
                showEndDot: false,
                animated: false
            )
            
            SparklineChart(
                data: primaryData,
                lineColor: primaryColor,
                lineWidth: lineWidth,
                showEndDot: true
            )
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading) {
            Text("Line")
                .font(.caption)
            SparklineChart(data: [10, 25, 15, 30, 20, 35, 28])
                .frame(width: 150, height: 40)
        }
        
        VStack(alignment: .leading) {
            Text("Filled")
                .font(.caption)
            SparklineChart(data: [10, 25, 15, 30, 20, 35, 28], style: .filled, lineColor: .green)
                .frame(width: 150, height: 40)
        }
        
        VStack(alignment: .leading) {
            Text("Gradient")
                .font(.caption)
            SparklineChart(data: [10, 25, 15, 30, 20, 35, 28], style: .gradient, lineColor: .purple)
                .frame(width: 150, height: 40)
        }
        
        VStack(alignment: .leading) {
            Text("Comparison")
                .font(.caption)
            ComparisonSparklineChart(
                primaryData: [10, 25, 15, 30, 20, 35, 28],
                secondaryData: [15, 20, 18, 25, 22, 30, 32]
            )
            .frame(width: 150, height: 40)
        }
    }
    .padding()
}
#endif
