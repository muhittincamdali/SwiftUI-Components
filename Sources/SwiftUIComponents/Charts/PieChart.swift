import SwiftUI

/// A pie chart with interactive segments
public struct PieChart: View {
    let slices: [PieSlice]
    let showLabels: Bool
    let showLegend: Bool
    let innerRadius: CGFloat
    let animate: Bool
    
    @State private var animationProgress: CGFloat = 0
    @State private var selectedSlice: UUID?
    
    public struct PieSlice: Identifiable {
        public let id = UUID()
        let value: Double
        let label: String
        let color: Color
        
        public init(value: Double, label: String, color: Color) {
            self.value = value
            self.label = label
            self.color = color
        }
    }
    
    public init(
        slices: [PieSlice],
        showLabels: Bool = true,
        showLegend: Bool = true,
        innerRadius: CGFloat = 0,
        animate: Bool = true
    ) {
        self.slices = slices
        self.showLabels = showLabels
        self.showLegend = showLegend
        self.innerRadius = innerRadius
        self.animate = animate
    }
    
    private var total: Double {
        slices.reduce(0) { $0 + $1.value }
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = size / 2
                
                ZStack {
                    ForEach(Array(slices.enumerated()), id: \.element.id) { index, slice in
                        let startAngle = angleFor(index: index)
                        let endAngle = angleFor(index: index + 1)
                        
                        PieSliceShape(
                            startAngle: startAngle,
                            endAngle: Angle(degrees: startAngle.degrees + (endAngle.degrees - startAngle.degrees) * animationProgress),
                            innerRadius: innerRadius
                        )
                        .fill(slice.color)
                        .scaleEffect(selectedSlice == slice.id ? 1.05 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedSlice)
                        .onTapGesture {
                            selectedSlice = selectedSlice == slice.id ? nil : slice.id
                        }
                        
                        // Labels
                        if showLabels && animationProgress == 1 {
                            let midAngle = Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
                            let labelRadius = radius * (innerRadius > 0 ? (1 + innerRadius) / 2 : 0.7)
                            let x = center.x + labelRadius * CGFloat(cos(midAngle.radians - .pi / 2))
                            let y = center.y + labelRadius * CGFloat(sin(midAngle.radians - .pi / 2))
                            
                            let percentage = slice.value / total * 100
                            
                            Text(String(format: "%.0f%%", percentage))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .position(x: x, y: y)
                        }
                    }
                    
                    // Center label for donut
                    if innerRadius > 0 && selectedSlice != nil {
                        if let selected = slices.first(where: { $0.id == selectedSlice }) {
                            VStack(spacing: 2) {
                                Text(selected.label)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.0f", selected.value))
                                    .font(.system(size: 20, weight: .bold))
                            }
                            .position(center)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            // Legend
            if showLegend {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(slices) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(slice.color)
                                .frame(width: 10, height: 10)
                            
                            Text(slice.label)
                                .font(.system(size: 12))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(String(format: "%.0f", slice.value))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .background(selectedSlice == slice.id ? slice.color.opacity(0.1) : Color.clear)
                        .cornerRadius(6)
                        .onTapGesture {
                            selectedSlice = selectedSlice == slice.id ? nil : slice.id
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
    
    private func angleFor(index: Int) -> Angle {
        let sum = slices.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: sum / total * 360)
    }
}

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadiusValue = radius * innerRadius
        
        var path = Path()
        
        path.move(to: CGPoint(
            x: center.x + innerRadiusValue * CGFloat(cos(startAngle.radians - .pi / 2)),
            y: center.y + innerRadiusValue * CGFloat(sin(startAngle.radians - .pi / 2))
        ))
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(degrees: startAngle.degrees - 90),
            endAngle: Angle(degrees: endAngle.degrees - 90),
            clockwise: false
        )
        
        if innerRadius > 0 {
            path.addArc(
                center: center,
                radius: innerRadiusValue,
                startAngle: Angle(degrees: endAngle.degrees - 90),
                endAngle: Angle(degrees: startAngle.degrees - 90),
                clockwise: true
            )
        } else {
            path.addLine(to: center)
        }
        
        path.closeSubpath()
        
        return path
    }
}

/// A donut chart (pie chart with hole)
public struct DonutChart: View {
    let slices: [PieChart.PieSlice]
    let centerValue: String?
    let centerLabel: String?
    let showLegend: Bool
    
    public init(
        slices: [PieChart.PieSlice],
        centerValue: String? = nil,
        centerLabel: String? = nil,
        showLegend: Bool = true
    ) {
        self.slices = slices
        self.centerValue = centerValue
        self.centerLabel = centerLabel
        self.showLegend = showLegend
    }
    
    public var body: some View {
        ZStack {
            PieChart(
                slices: slices,
                showLabels: false,
                showLegend: showLegend,
                innerRadius: 0.6
            )
            
            if let value = centerValue {
                VStack(spacing: 2) {
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                    
                    if let label = centerLabel {
                        Text(label)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview("Pie Charts") {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pie Chart")
                    .font(.headline)
                
                PieChart(slices: [
                    .init(value: 35, label: "iOS", color: .blue),
                    .init(value: 25, label: "Android", color: .green),
                    .init(value: 20, label: "Web", color: .orange),
                    .init(value: 15, label: "Desktop", color: .purple),
                    .init(value: 5, label: "Other", color: .gray)
                ])
                .frame(height: 300)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Donut Chart")
                    .font(.headline)
                
                DonutChart(
                    slices: [
                        .init(value: 60, label: "Complete", color: .green),
                        .init(value: 25, label: "In Progress", color: .blue),
                        .init(value: 15, label: "Pending", color: .orange)
                    ],
                    centerValue: "85%",
                    centerLabel: "Done"
                )
                .frame(height: 300)
            }
        }
        .padding()
    }
}
