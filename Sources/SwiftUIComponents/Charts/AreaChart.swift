import SwiftUI

/// An area chart with gradient fill
public struct AreaChart: View {
    let data: [Double]
    let labels: [String]?
    let color: Color
    let showGrid: Bool
    let showLabels: Bool
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public init(
        data: [Double],
        labels: [String]? = nil,
        color: Color = .accentColor,
        showGrid: Bool = true,
        showLabels: Bool = true,
        animate: Bool = true
    ) {
        self.data = data
        self.labels = labels
        self.color = color
        self.showGrid = showGrid
        self.showLabels = showLabels
        self.animate = animate
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height - (showLabels ? 30 : 0)
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            VStack(spacing: 0) {
                ZStack {
                    // Grid
                    if showGrid {
                        gridLines(height: height)
                    }
                    
                    // Area
                    Path { path in
                        guard data.count > 1 else { return }
                        
                        let stepX = width / CGFloat(data.count - 1)
                        
                        path.move(to: CGPoint(x: 0, y: height))
                        
                        for (index, value) in data.enumerated() {
                            let x = stepX * CGFloat(index)
                            let normalizedValue = (value - minValue) / (range == 0 ? 1 : range)
                            let y = height - (CGFloat(normalizedValue) * height * animationProgress)
                            
                            if index == 0 {
                                path.addLine(to: CGPoint(x: x, y: y))
                            } else {
                                // Smooth curve
                                let prevX = stepX * CGFloat(index - 1)
                                let prevValue = (data[index - 1] - minValue) / (range == 0 ? 1 : range)
                                let prevY = height - (CGFloat(prevValue) * height * animationProgress)
                                
                                let controlX1 = (prevX + x) / 2
                                let controlX2 = (prevX + x) / 2
                                
                                path.addCurve(
                                    to: CGPoint(x: x, y: y),
                                    control1: CGPoint(x: controlX1, y: prevY),
                                    control2: CGPoint(x: controlX2, y: y)
                                )
                            }
                        }
                        
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.4), color.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Line
                    Path { path in
                        guard data.count > 1 else { return }
                        
                        let stepX = width / CGFloat(data.count - 1)
                        
                        for (index, value) in data.enumerated() {
                            let x = stepX * CGFloat(index)
                            let normalizedValue = (value - minValue) / (range == 0 ? 1 : range)
                            let y = height - (CGFloat(normalizedValue) * height * animationProgress)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                let prevX = stepX * CGFloat(index - 1)
                                let prevValue = (data[index - 1] - minValue) / (range == 0 ? 1 : range)
                                let prevY = height - (CGFloat(prevValue) * height * animationProgress)
                                
                                let controlX1 = (prevX + x) / 2
                                let controlX2 = (prevX + x) / 2
                                
                                path.addCurve(
                                    to: CGPoint(x: x, y: y),
                                    control1: CGPoint(x: controlX1, y: prevY),
                                    control2: CGPoint(x: controlX2, y: y)
                                )
                            }
                        }
                    }
                    .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    
                    // Data points
                    ForEach(0..<data.count, id: \.self) { index in
                        let stepX = width / CGFloat(data.count - 1)
                        let x = stepX * CGFloat(index)
                        let normalizedValue = (data[index] - minValue) / (range == 0 ? 1 : range)
                        let y = height - (CGFloat(normalizedValue) * height * animationProgress)
                        
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(color, lineWidth: 2))
                            .position(x: x, y: y)
                    }
                }
                .frame(height: height)
                
                // Labels
                if showLabels, let labels = labels {
                    HStack {
                        ForEach(0..<min(labels.count, data.count), id: \.self) { index in
                            Text(labels[index])
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            
                            if index < min(labels.count, data.count) - 1 {
                                Spacer()
                            }
                        }
                    }
                    .frame(height: 30)
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
    
    private func gridLines(height: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { _ in
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 1)
                Spacer()
            }
        }
        .frame(height: height)
    }
}

/// Line chart with multiple series
public struct LineChart: View {
    let series: [ChartSeries]
    let showLegend: Bool
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public struct ChartSeries: Identifiable {
        public let id = UUID()
        let name: String
        let data: [Double]
        let color: Color
        
        public init(name: String, data: [Double], color: Color) {
            self.name = name
            self.data = data
            self.color = color
        }
    }
    
    public init(series: [ChartSeries], showLegend: Bool = true, animate: Bool = true) {
        self.series = series
        self.showLegend = showLegend
        self.animate = animate
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            // Legend
            if showLegend {
                HStack(spacing: 16) {
                    ForEach(series) { s in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(s.color)
                                .frame(width: 8, height: 8)
                            Text(s.name)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let allData = series.flatMap { $0.data }
                let maxValue = allData.max() ?? 1
                let minValue = allData.min() ?? 0
                let range = maxValue - minValue
                
                ZStack {
                    // Grid
                    VStack(spacing: 0) {
                        ForEach(0..<5) { _ in
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 1)
                            Spacer()
                        }
                    }
                    
                    // Lines
                    ForEach(series) { s in
                        Path { path in
                            guard s.data.count > 1 else { return }
                            
                            let stepX = width / CGFloat(s.data.count - 1)
                            
                            for (index, value) in s.data.enumerated() {
                                let x = stepX * CGFloat(index)
                                let normalizedValue = (value - minValue) / (range == 0 ? 1 : range)
                                let y = height - (CGFloat(normalizedValue) * height * animationProgress)
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: x, y: y))
                                } else {
                                    path.addLine(to: CGPoint(x: x, y: y))
                                }
                            }
                        }
                        .stroke(s.color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
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

#Preview("Area & Line Charts") {
    VStack(spacing: 32) {
        VStack(alignment: .leading, spacing: 8) {
            Text("Area Chart")
                .font(.headline)
            
            AreaChart(
                data: [10, 25, 15, 40, 30, 55, 45, 60, 50, 70],
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"],
                color: .blue
            )
            .frame(height: 200)
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Line Chart")
                .font(.headline)
            
            LineChart(series: [
                .init(name: "Sales", data: [20, 35, 25, 45, 40, 55], color: .blue),
                .init(name: "Profit", data: [10, 20, 15, 30, 25, 40], color: .green)
            ])
            .frame(height: 200)
        }
    }
    .padding()
}
