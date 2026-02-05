import SwiftUI

/// A vertical bar chart
public struct BarChart: View {
    let data: [BarData]
    let showValues: Bool
    let showGrid: Bool
    let barWidth: CGFloat
    let spacing: CGFloat
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    @State private var selectedBar: UUID?
    
    public struct BarData: Identifiable {
        public let id = UUID()
        let value: Double
        let label: String
        let color: Color
        
        public init(value: Double, label: String, color: Color = .accentColor) {
            self.value = value
            self.label = label
            self.color = color
        }
    }
    
    public init(
        data: [BarData],
        showValues: Bool = true,
        showGrid: Bool = true,
        barWidth: CGFloat = 0,
        spacing: CGFloat = 8,
        animate: Bool = true
    ) {
        self.data = data
        self.showValues = showValues
        self.showGrid = showGrid
        self.barWidth = barWidth
        self.spacing = spacing
        self.animate = animate
    }
    
    private var maxValue: Double {
        data.map { $0.value }.max() ?? 1
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let chartHeight = geometry.size.height - 40
            let calculatedBarWidth = barWidth > 0 ? barWidth : (availableWidth - CGFloat(data.count + 1) * spacing) / CGFloat(data.count)
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    // Grid
                    if showGrid {
                        VStack(spacing: 0) {
                            ForEach(0..<5) { _ in
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 1)
                                Spacer()
                            }
                        }
                        .frame(height: chartHeight)
                    }
                    
                    // Bars
                    HStack(alignment: .bottom, spacing: spacing) {
                        ForEach(data) { bar in
                            VStack(spacing: 4) {
                                // Value label
                                if showValues {
                                    Text(String(format: "%.0f", bar.value))
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .opacity(animationProgress)
                                }
                                
                                // Bar
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(bar.color)
                                    .frame(
                                        width: calculatedBarWidth,
                                        height: max(4, chartHeight * CGFloat(bar.value / maxValue) * animationProgress)
                                    )
                                    .scaleEffect(selectedBar == bar.id ? CGSize(width: 1.1, height: 1.02) : CGSize(width: 1, height: 1), anchor: .bottom)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedBar)
                                    .onTapGesture {
                                        selectedBar = selectedBar == bar.id ? nil : bar.id
                                    }
                            }
                        }
                    }
                    .frame(height: chartHeight)
                }
                .frame(height: chartHeight)
                
                // Labels
                HStack(spacing: spacing) {
                    ForEach(data) { bar in
                        Text(bar.label)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .frame(width: calculatedBarWidth)
                            .lineLimit(1)
                    }
                }
                .frame(height: 40)
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 0.8)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

/// A horizontal bar chart
public struct HorizontalBarChart: View {
    let data: [BarChart.BarData]
    let showValues: Bool
    let barHeight: CGFloat
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public init(
        data: [BarChart.BarData],
        showValues: Bool = true,
        barHeight: CGFloat = 28,
        animate: Bool = true
    ) {
        self.data = data
        self.showValues = showValues
        self.barHeight = barHeight
        self.animate = animate
    }
    
    private var maxValue: Double {
        data.map { $0.value }.max() ?? 1
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ForEach(data) { bar in
                HStack(spacing: 10) {
                    Text(bar.label)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(width: 60, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray6))
                                .frame(height: barHeight)
                            
                            // Filled bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(bar.color)
                                .frame(
                                    width: geometry.size.width * CGFloat(bar.value / maxValue) * animationProgress,
                                    height: barHeight
                                )
                        }
                    }
                    .frame(height: barHeight)
                    
                    if showValues {
                        Text(String(format: "%.0f", bar.value))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(width: 40, alignment: .trailing)
                            .opacity(animationProgress)
                    }
                }
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 0.8)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

/// Grouped bar chart
public struct GroupedBarChart: View {
    let groups: [BarGroup]
    let showLegend: Bool
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    
    public struct BarGroup: Identifiable {
        public let id = UUID()
        let label: String
        let bars: [NamedBar]
        
        public init(label: String, bars: [NamedBar]) {
            self.label = label
            self.bars = bars
        }
    }
    
    public struct NamedBar {
        let name: String
        let value: Double
        let color: Color
        
        public init(name: String, value: Double, color: Color) {
            self.name = name
            self.value = value
            self.color = color
        }
    }
    
    public init(groups: [BarGroup], showLegend: Bool = true, animate: Bool = true) {
        self.groups = groups
        self.showLegend = showLegend
        self.animate = animate
    }
    
    private var maxValue: Double {
        groups.flatMap { $0.bars.map { $0.value } }.max() ?? 1
    }
    
    private var uniqueNames: [(name: String, color: Color)] {
        var seen = Set<String>()
        var result: [(String, Color)] = []
        for group in groups {
            for bar in group.bars {
                if !seen.contains(bar.name) {
                    seen.insert(bar.name)
                    result.append((bar.name, bar.color))
                }
            }
        }
        return result
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            // Legend
            if showLegend {
                HStack(spacing: 16) {
                    ForEach(uniqueNames, id: \.name) { item in
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(item.color)
                                .frame(width: 12, height: 12)
                            Text(item.name)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            GeometryReader { geometry in
                let groupWidth = geometry.size.width / CGFloat(groups.count)
                let barWidth = (groupWidth - 16) / CGFloat(uniqueNames.count)
                let chartHeight = geometry.size.height - 30
                
                VStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(groups) { group in
                            VStack(spacing: 4) {
                                HStack(alignment: .bottom, spacing: 2) {
                                    ForEach(0..<group.bars.count, id: \.self) { index in
                                        let bar = group.bars[index]
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(bar.color)
                                            .frame(
                                                width: max(barWidth - 2, 8),
                                                height: max(4, chartHeight * CGFloat(bar.value / maxValue) * animationProgress)
                                            )
                                    }
                                }
                            }
                            .frame(width: groupWidth)
                        }
                    }
                    .frame(height: chartHeight)
                    
                    // Labels
                    HStack(spacing: 0) {
                        ForEach(groups) { group in
                            Text(group.label)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                                .frame(width: groupWidth)
                                .lineLimit(1)
                        }
                    }
                    .frame(height: 30)
                }
            }
        }
        .onAppear {
            if animate {
                withAnimation(.easeOut(duration: 0.8)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
    }
}

#Preview("Bar Charts") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Vertical Bar Chart")
                    .font(.headline)
                
                BarChart(data: [
                    .init(value: 85, label: "Mon", color: .blue),
                    .init(value: 65, label: "Tue", color: .blue),
                    .init(value: 90, label: "Wed", color: .blue),
                    .init(value: 70, label: "Thu", color: .blue),
                    .init(value: 55, label: "Fri", color: .blue),
                    .init(value: 45, label: "Sat", color: .gray),
                    .init(value: 35, label: "Sun", color: .gray)
                ])
                .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Horizontal Bar Chart")
                    .font(.headline)
                
                HorizontalBarChart(data: [
                    .init(value: 85, label: "Swift", color: .orange),
                    .init(value: 70, label: "Python", color: .blue),
                    .init(value: 55, label: "Java", color: .red),
                    .init(value: 45, label: "Go", color: .cyan),
                    .init(value: 30, label: "Rust", color: .brown)
                ])
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Grouped Bar Chart")
                    .font(.headline)
                
                GroupedBarChart(groups: [
                    .init(label: "Q1", bars: [
                        .init(name: "Sales", value: 80, color: .blue),
                        .init(name: "Profit", value: 45, color: .green)
                    ]),
                    .init(label: "Q2", bars: [
                        .init(name: "Sales", value: 95, color: .blue),
                        .init(name: "Profit", value: 60, color: .green)
                    ]),
                    .init(label: "Q3", bars: [
                        .init(name: "Sales", value: 70, color: .blue),
                        .init(name: "Profit", value: 35, color: .green)
                    ]),
                    .init(label: "Q4", bars: [
                        .init(name: "Sales", value: 110, color: .blue),
                        .init(name: "Profit", value: 75, color: .green)
                    ])
                ])
                .frame(height: 200)
            }
        }
        .padding()
    }
}
