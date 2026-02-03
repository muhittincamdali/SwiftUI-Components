import SwiftUI

/// A customizable divider with various styles and orientations.
///
/// `CustomDivider` provides enhanced divider options beyond
/// the system Divider, including labels and custom styling.
///
/// ```swift
/// CustomDivider()
/// CustomDivider(label: "OR")
/// CustomDivider(style: .dashed)
/// ```
public struct CustomDivider: View {
    // MARK: - Types
    
    /// The visual style of the divider.
    public enum Style {
        case solid
        case dashed
        case dotted
        case gradient(colors: [Color])
    }
    
    /// The orientation of the divider.
    public enum Orientation {
        case horizontal
        case vertical
    }
    
    // MARK: - Properties
    
    private let style: Style
    private let orientation: Orientation
    private let color: Color
    private let thickness: CGFloat
    private let label: String?
    private let labelFont: Font
    private let labelColor: Color
    private let padding: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a new custom divider.
    public init(
        style: Style = .solid,
        orientation: Orientation = .horizontal,
        color: Color = Color(.separator),
        thickness: CGFloat = 1,
        label: String? = nil,
        labelFont: Font = .caption,
        labelColor: Color = .secondary,
        padding: CGFloat = 16
    ) {
        self.style = style
        self.orientation = orientation
        self.color = color
        self.thickness = thickness
        self.label = label
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.padding = padding
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if let label {
                labeledDivider(label)
            } else {
                simpleDivider
            }
        }
    }
    
    // MARK: - Simple Divider
    
    @ViewBuilder
    private var simpleDivider: some View {
        switch orientation {
        case .horizontal:
            horizontalLine
                .frame(height: thickness)
        case .vertical:
            verticalLine
                .frame(width: thickness)
        }
    }
    
    // MARK: - Labeled Divider
    
    private func labeledDivider(_ text: String) -> some View {
        HStack(spacing: padding) {
            horizontalLine
            
            Text(text)
                .font(labelFont)
                .foregroundStyle(labelColor)
            
            horizontalLine
        }
    }
    
    // MARK: - Lines
    
    @ViewBuilder
    private var horizontalLine: some View {
        switch style {
        case .solid:
            Rectangle()
                .fill(color)
                .frame(height: thickness)
        
        case .dashed:
            Line()
                .stroke(color, style: StrokeStyle(lineWidth: thickness, dash: [5, 3]))
                .frame(height: thickness)
        
        case .dotted:
            Line()
                .stroke(color, style: StrokeStyle(lineWidth: thickness, lineCap: .round, dash: [1, 4]))
                .frame(height: thickness)
        
        case .gradient(let colors):
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                .frame(height: thickness)
        }
    }
    
    @ViewBuilder
    private var verticalLine: some View {
        switch style {
        case .solid:
            Rectangle()
                .fill(color)
                .frame(width: thickness)
        
        case .dashed:
            VerticalLine()
                .stroke(color, style: StrokeStyle(lineWidth: thickness, dash: [5, 3]))
                .frame(width: thickness)
        
        case .dotted:
            VerticalLine()
                .stroke(color, style: StrokeStyle(lineWidth: thickness, lineCap: .round, dash: [1, 4]))
                .frame(width: thickness)
        
        case .gradient(let colors):
            LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                .frame(width: thickness)
        }
    }
}

// MARK: - Line Shapes

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

private struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        return path
    }
}

// MARK: - Spacer Divider

/// A divider that also adds spacing.
public struct SpacerDivider: View {
    private let spacing: CGFloat
    private let color: Color
    
    public init(spacing: CGFloat = 20, color: Color = Color(.separator)) {
        self.spacing = spacing
        self.color = color
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: spacing)
            
            Rectangle()
                .fill(color)
                .frame(height: 1)
            
            Spacer()
                .frame(height: spacing)
        }
    }
}

// MARK: - Section Divider

/// A divider with a section header style.
public struct SectionDivider: View {
    private let title: String?
    private let backgroundColor: Color
    private let height: CGFloat
    
    public init(
        title: String? = nil,
        backgroundColor: Color = Color(.systemGroupedBackground),
        height: CGFloat = 32
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.height = height
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(backgroundColor)
                .frame(height: height)
            
            if let title {
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 16)
            }
        }
    }
}

// MARK: - Decorative Divider

/// A decorative divider with icons or symbols.
public struct DecorativeDivider: View {
    private let icon: Image
    private let color: Color
    private let lineColor: Color
    
    public init(
        icon: Image = Image(systemName: "star.fill"),
        color: Color = .yellow,
        lineColor: Color = Color(.separator)
    ) {
        self.icon = icon
        self.color = color
        self.lineColor = lineColor
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(lineColor)
                .frame(height: 1)
            
            icon
                .foregroundStyle(color)
            
            Rectangle()
                .fill(lineColor)
                .frame(height: 1)
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        VStack(spacing: 20) {
            CustomDivider()
            CustomDivider(style: .dashed)
            CustomDivider(style: .dotted)
            CustomDivider(style: .gradient(colors: [.blue, .purple]))
        }
        
        CustomDivider(label: "OR")
        
        SpacerDivider()
        
        SectionDivider(title: "Settings")
        
        DecorativeDivider()
        
        HStack(spacing: 20) {
            Text("Left")
            CustomDivider(orientation: .vertical)
                .frame(height: 30)
            Text("Right")
        }
    }
    .padding()
}
#endif
