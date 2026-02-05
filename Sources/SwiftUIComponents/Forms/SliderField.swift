import SwiftUI

/// A styled slider with labels and value display
public struct SliderField: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let label: String?
    let showValue: Bool
    let valueFormat: String
    let style: SliderStyle
    
    public enum SliderStyle {
        case standard
        case pill
        case gradient(colors: [Color])
    }
    
    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        label: String? = nil,
        showValue: Bool = true,
        valueFormat: String = "%.0f",
        style: SliderStyle = .standard
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.showValue = showValue
        self.valueFormat = valueFormat
        self.style = style
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if label != nil || showValue {
                HStack {
                    if let label = label {
                        Text(label)
                            .font(.system(size: 14, weight: .medium))
                    }
                    
                    Spacer()
                    
                    if showValue {
                        Text(String(format: valueFormat, value))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            Group {
                switch style {
                case .standard:
                    if let step = step {
                        Slider(value: $value, in: range, step: step)
                    } else {
                        Slider(value: $value, in: range)
                    }
                    
                case .pill:
                    pillSlider
                    
                case .gradient(let colors):
                    gradientSlider(colors: colors)
                }
            }
        }
    }
    
    private var pillSlider: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 8)
                
                // Filled track
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: max(0, geometry.size.width * progress), height: 8)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .offset(x: max(0, geometry.size.width * progress - 12))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newProgress = gesture.location.x / geometry.size.width
                                let clampedProgress = min(max(newProgress, 0), 1)
                                value = range.lowerBound + (range.upperBound - range.lowerBound) * clampedProgress
                                
                                if let step = step {
                                    value = (value / step).rounded() * step
                                }
                            }
                    )
            }
        }
        .frame(height: 24)
    }
    
    private func gradientSlider(colors: [Color]) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track with gradient
                Capsule()
                    .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                    .frame(height: 8)
                    .opacity(0.3)
                
                // Filled track with gradient
                Capsule()
                    .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(0, geometry.size.width * progress), height: 8)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 16, height: 16)
                    )
                    .offset(x: max(0, geometry.size.width * progress - 12))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newProgress = gesture.location.x / geometry.size.width
                                let clampedProgress = min(max(newProgress, 0), 1)
                                value = range.lowerBound + (range.upperBound - range.lowerBound) * clampedProgress
                                
                                if let step = step {
                                    value = (value / step).rounded() * step
                                }
                            }
                    )
            }
        }
        .frame(height: 24)
    }
    
    private var progress: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
}

/// Range slider for selecting a range
public struct RangeSlider: View {
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>
    let label: String?
    let valueFormat: String
    
    public init(
        lowerValue: Binding<Double>,
        upperValue: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        label: String? = nil,
        valueFormat: String = "%.0f"
    ) {
        self._lowerValue = lowerValue
        self._upperValue = upperValue
        self.range = range
        self.label = label
        self.valueFormat = valueFormat
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if label != nil {
                HStack {
                    if let label = label {
                        Text(label)
                            .font(.system(size: 14, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("\(String(format: valueFormat, lowerValue)) - \(String(format: valueFormat, upperValue))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    // Selected range
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(width: (upperProgress - lowerProgress) * geometry.size.width, height: 8)
                        .offset(x: lowerProgress * geometry.size.width)
                    
                    // Lower thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .offset(x: max(0, lowerProgress * geometry.size.width - 12))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newProgress = gesture.location.x / geometry.size.width
                                    let clampedProgress = min(max(newProgress, 0), upperProgress - 0.05)
                                    lowerValue = range.lowerBound + (range.upperBound - range.lowerBound) * clampedProgress
                                }
                        )
                    
                    // Upper thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .offset(x: max(0, upperProgress * geometry.size.width - 12))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newProgress = gesture.location.x / geometry.size.width
                                    let clampedProgress = min(max(newProgress, lowerProgress + 0.05), 1)
                                    upperValue = range.lowerBound + (range.upperBound - range.lowerBound) * clampedProgress
                                }
                        )
                }
            }
            .frame(height: 24)
        }
    }
    
    private var lowerProgress: Double {
        (lowerValue - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private var upperProgress: Double {
        (upperValue - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
}

#Preview("Sliders") {
    struct PreviewWrapper: View {
        @State private var value1: Double = 50
        @State private var value2: Double = 30
        @State private var value3: Double = 70
        @State private var lowerValue: Double = 20
        @State private var upperValue: Double = 80
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    SliderField(
                        value: $value1,
                        label: "Standard Slider",
                        style: .standard
                    )
                    
                    SliderField(
                        value: $value2,
                        label: "Pill Slider",
                        style: .pill
                    )
                    
                    SliderField(
                        value: $value3,
                        label: "Gradient Slider",
                        style: .gradient(colors: [.purple, .pink, .orange])
                    )
                    
                    SliderField(
                        value: $value1,
                        range: 0...10,
                        step: 1,
                        label: "Stepped Slider (0-10)",
                        style: .pill
                    )
                    
                    Divider()
                    
                    RangeSlider(
                        lowerValue: $lowerValue,
                        upperValue: $upperValue,
                        label: "Price Range"
                    )
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
