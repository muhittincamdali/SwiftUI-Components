import SwiftUI

/// A customizable segmented control with animated selection.
///
/// `SegmentedControl` provides an enhanced alternative to the system
/// segmented control with custom styling options.
///
/// ```swift
/// SegmentedControl(
///     selectedIndex: $selected,
///     segments: ["Day", "Week", "Month"]
/// )
/// ```
public struct SegmentedControl: View {
    // MARK: - Types
    
    /// A segment configuration.
    public struct Segment: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: Image?
        public let badge: String?
        
        public init(title: String, icon: Image? = nil, badge: String? = nil) {
            self.title = title
            self.icon = icon
            self.badge = badge
        }
    }
    
    /// The visual style of the segmented control.
    public enum Style {
        case capsule
        case rounded
        case underline
        case boxed
    }
    
    // MARK: - Properties
    
    @Binding private var selectedIndex: Int
    private let segments: [Segment]
    private let style: Style
    private let tintColor: Color
    private let backgroundColor: Color
    private let textColor: Color
    private let selectedTextColor: Color
    private let font: Font
    private let height: CGFloat
    private let hapticFeedback: Bool
    
    @Namespace private var animation
    
    // MARK: - Initialization
    
    /// Creates a segmented control from strings.
    public init(
        selectedIndex: Binding<Int>,
        segments: [String],
        style: Style = .capsule,
        tintColor: Color = .blue,
        backgroundColor: Color = Color(.systemGray6),
        textColor: Color = .primary,
        selectedTextColor: Color = .white,
        font: Font = .subheadline.weight(.medium),
        height: CGFloat = 36,
        hapticFeedback: Bool = true
    ) {
        self._selectedIndex = selectedIndex
        self.segments = segments.map { Segment(title: $0) }
        self.style = style
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.font = font
        self.height = height
        self.hapticFeedback = hapticFeedback
    }
    
    /// Creates a segmented control from segment objects.
    public init(
        selectedIndex: Binding<Int>,
        segments: [Segment],
        style: Style = .capsule,
        tintColor: Color = .blue,
        backgroundColor: Color = Color(.systemGray6),
        textColor: Color = .primary,
        selectedTextColor: Color = .white,
        font: Font = .subheadline.weight(.medium),
        height: CGFloat = 36,
        hapticFeedback: Bool = true
    ) {
        self._selectedIndex = selectedIndex
        self.segments = segments
        self.style = style
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.font = font
        self.height = height
        self.hapticFeedback = hapticFeedback
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .capsule:
                capsuleStyle
            case .rounded:
                roundedStyle
            case .underline:
                underlineStyle
            case .boxed:
                boxedStyle
            }
        }
    }
    
    // MARK: - Capsule Style
    
    private var capsuleStyle: some View {
        HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                segmentButton(segment: segment, index: index, isSelected: selectedIndex == index) {
                    if selectedIndex == index {
                        Capsule()
                            .fill(tintColor)
                            .matchedGeometryEffect(id: "selection", in: animation)
                    }
                }
            }
        }
        .padding(4)
        .frame(height: height)
        .background(
            Capsule()
                .fill(backgroundColor)
        )
    }
    
    // MARK: - Rounded Style
    
    private var roundedStyle: some View {
        HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                segmentButton(segment: segment, index: index, isSelected: selectedIndex == index) {
                    if selectedIndex == index {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(tintColor)
                            .matchedGeometryEffect(id: "selection", in: animation)
                    }
                }
            }
        }
        .padding(4)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
        )
    }
    
    // MARK: - Underline Style
    
    private var underlineStyle: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                    Button {
                        selectSegment(index)
                    } label: {
                        VStack(spacing: 8) {
                            HStack(spacing: 4) {
                                if let icon = segment.icon {
                                    icon.imageScale(.small)
                                }
                                
                                Text(segment.title)
                                    .font(font)
                                
                                if let badge = segment.badge {
                                    badgeView(badge)
                                }
                            }
                            .foregroundStyle(selectedIndex == index ? tintColor : textColor.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: height)
            
            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(segments.count)
                
                Rectangle()
                    .fill(tintColor)
                    .frame(width: segmentWidth, height: 2)
                    .offset(x: segmentWidth * CGFloat(selectedIndex))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedIndex)
            }
            .frame(height: 2)
        }
    }
    
    // MARK: - Boxed Style
    
    private var boxedStyle: some View {
        HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                Button {
                    selectSegment(index)
                } label: {
                    HStack(spacing: 4) {
                        if let icon = segment.icon {
                            icon.imageScale(.small)
                        }
                        
                        Text(segment.title)
                            .font(font)
                    }
                    .foregroundStyle(selectedIndex == index ? selectedTextColor : textColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
                    .background(selectedIndex == index ? tintColor : Color.clear)
                }
                .buttonStyle(.plain)
                
                if index < segments.count - 1 {
                    Divider()
                        .frame(height: height * 0.6)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    // MARK: - Segment Button
    
    private func segmentButton<Background: View>(
        segment: Segment,
        index: Int,
        isSelected: Bool,
        @ViewBuilder background: () -> Background
    ) -> some View {
        Button {
            selectSegment(index)
        } label: {
            ZStack {
                background()
                
                HStack(spacing: 4) {
                    if let icon = segment.icon {
                        icon.imageScale(.small)
                    }
                    
                    Text(segment.title)
                        .font(font)
                    
                    if let badge = segment.badge {
                        badgeView(badge)
                    }
                }
                .foregroundStyle(isSelected ? selectedTextColor : textColor)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Badge View
    
    private func badgeView(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(Capsule().fill(.red))
    }
    
    // MARK: - Selection
    
    private func selectSegment(_ index: Int) {
        guard index != selectedIndex else { return }
        
        if hapticFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedIndex = index
        }
    }
}

// MARK: - Icon Segmented Control

/// A segmented control with icons only.
public struct IconSegmentedControl: View {
    @Binding private var selectedIndex: Int
    private let icons: [Image]
    private let tintColor: Color
    private let size: CGFloat
    
    @Namespace private var animation
    
    public init(
        selectedIndex: Binding<Int>,
        icons: [Image],
        tintColor: Color = .blue,
        size: CGFloat = 44
    ) {
        self._selectedIndex = selectedIndex
        self.icons = icons
        self.tintColor = tintColor
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<icons.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                } label: {
                    icons[index]
                        .font(.system(size: size * 0.45))
                        .foregroundStyle(selectedIndex == index ? .white : .secondary)
                        .frame(width: size, height: size)
                        .background(
                            Circle()
                                .fill(selectedIndex == index ? tintColor : Color(.systemGray6))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#if DEBUG
struct SegmentedControlPreview: View {
    @State private var selected1 = 0
    @State private var selected2 = 0
    @State private var selected3 = 1
    @State private var selected4 = 0
    @State private var selectedIcon = 0
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Capsule").font(.caption)
                SegmentedControl(
                    selectedIndex: $selected1,
                    segments: ["Day", "Week", "Month", "Year"],
                    style: .capsule
                )
            }
            
            VStack {
                Text("Rounded").font(.caption)
                SegmentedControl(
                    selectedIndex: $selected2,
                    segments: ["All", "Active", "Completed"],
                    style: .rounded,
                    tintColor: .green
                )
            }
            
            VStack {
                Text("Underline").font(.caption)
                SegmentedControl(
                    selectedIndex: $selected3,
                    segments: ["Posts", "Likes", "Comments"],
                    style: .underline,
                    tintColor: .purple
                )
            }
            
            VStack {
                Text("Boxed").font(.caption)
                SegmentedControl(
                    selectedIndex: $selected4,
                    segments: ["List", "Grid"],
                    style: .boxed
                )
            }
            
            VStack {
                Text("Icons").font(.caption)
                IconSegmentedControl(
                    selectedIndex: $selectedIcon,
                    icons: [
                        Image(systemName: "list.bullet"),
                        Image(systemName: "square.grid.2x2"),
                        Image(systemName: "rectangle.grid.1x2")
                    ]
                )
            }
        }
        .padding()
    }
}

#Preview {
    SegmentedControlPreview()
}
#endif
