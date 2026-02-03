import SwiftUI

/// A compact chip component for tags, filters, and selections.
///
/// `Chip` displays interactive labels that can be selected,
/// dismissed, or used as filter toggles.
///
/// ```swift
/// Chip("Swift", style: .filled, isSelected: true)
/// Chip("Filter", isDismissible: true, onDismiss: { })
/// ```
public struct Chip: View {
    // MARK: - Types
    
    /// The visual style of the chip.
    public enum Style {
        case filled
        case outlined
        case subtle
    }
    
    /// The size of the chip.
    public enum Size {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small: return .caption
            case .medium: return .subheadline
            case .large: return .body
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .medium: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .large: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
    }
    
    // MARK: - Properties
    
    private let text: String
    private let style: Style
    private let size: Size
    private let color: Color
    private let icon: Image?
    private let isSelected: Bool
    private let isDismissible: Bool
    private let onTap: (() -> Void)?
    private let onDismiss: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new chip.
    public init(
        _ text: String,
        style: Style = .filled,
        size: Size = .medium,
        color: Color = .blue,
        icon: Image? = nil,
        isSelected: Bool = false,
        isDismissible: Bool = false,
        onTap: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.text = text
        self.style = style
        self.size = size
        self.color = color
        self.icon = icon
        self.isSelected = isSelected
        self.isDismissible = isDismissible
        self.onTap = onTap
        self.onDismiss = onDismiss
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 6) {
                if let icon {
                    icon
                        .font(.system(size: size.iconSize))
                }
                
                Text(text)
                    .font(size.font)
                    .fontWeight(.medium)
                
                if isDismissible {
                    Button {
                        onDismiss?()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: size.iconSize, weight: .bold))
                    }
                }
            }
            .foregroundStyle(foregroundColor)
            .padding(size.padding)
            .background(background)
            .clipShape(Capsule())
            .overlay(borderOverlay)
        }
        .buttonStyle(.plain)
        .disabled(onTap == nil)
    }
    
    // MARK: - Styling
    
    private var foregroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? .white : color
        case .outlined:
            return color
        case .subtle:
            return color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            if isSelected {
                color
            } else {
                color.opacity(0.15)
            }
        case .outlined:
            Color.clear
        case .subtle:
            color.opacity(0.1)
        }
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            Capsule()
                .stroke(color, lineWidth: 1.5)
        }
    }
}

// MARK: - Chip Group

/// A group of chips that supports single or multiple selection.
public struct ChipGroup: View {
    public struct ChipItem: Identifiable {
        public let id = UUID()
        public let text: String
        public let icon: Image?
        
        public init(text: String, icon: Image? = nil) {
            self.text = text
            self.icon = icon
        }
    }
    
    private let items: [ChipItem]
    private let style: Chip.Style
    private let size: Chip.Size
    private let color: Color
    private let allowsMultipleSelection: Bool
    @Binding private var selectedItems: Set<UUID>
    
    public init(
        items: [ChipItem],
        selectedItems: Binding<Set<UUID>>,
        style: Chip.Style = .filled,
        size: Chip.Size = .medium,
        color: Color = .blue,
        allowsMultipleSelection: Bool = true
    ) {
        self.items = items
        self._selectedItems = selectedItems
        self.style = style
        self.size = size
        self.color = color
        self.allowsMultipleSelection = allowsMultipleSelection
    }
    
    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items) { item in
                Chip(
                    item.text,
                    style: style,
                    size: size,
                    color: color,
                    icon: item.icon,
                    isSelected: selectedItems.contains(item.id)
                ) {
                    toggleSelection(item.id)
                }
            }
        }
    }
    
    private func toggleSelection(_ id: UUID) {
        if allowsMultipleSelection {
            if selectedItems.contains(id) {
                selectedItems.remove(id)
            } else {
                selectedItems.insert(id)
            }
        } else {
            if selectedItems.contains(id) {
                selectedItems.removeAll()
            } else {
                selectedItems = [id]
            }
        }
    }
}

// MARK: - Flow Layout

/// A layout that wraps chips to the next line when needed.
public struct FlowLayout: Layout {
    var spacing: CGFloat
    
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        
        for (index, subview) in subviews.enumerated() {
            let position = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            positions.append(CGPoint(x: currentX, y: currentY))
            
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            totalWidth = max(totalWidth, currentX - spacing)
            totalHeight = currentY + lineHeight
        }
        
        return (CGSize(width: totalWidth, height: totalHeight), positions)
    }
}

// MARK: - Dismissible Chip Group

/// A chip group where chips can be removed.
public struct DismissibleChipGroup: View {
    @Binding private var items: [String]
    private let style: Chip.Style
    private let size: Chip.Size
    private let color: Color
    
    public init(
        items: Binding<[String]>,
        style: Chip.Style = .filled,
        size: Chip.Size = .medium,
        color: Color = .blue
    ) {
        self._items = items
        self.style = style
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) { item in
                Chip(
                    item,
                    style: style,
                    size: size,
                    color: color,
                    isDismissible: true
                ) {
                    withAnimation {
                        items.removeAll { $0 == item }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ChipPreview: View {
    @State private var selectedItems: Set<UUID> = []
    @State private var tags = ["Swift", "SwiftUI", "iOS", "Xcode", "Apple"]
    
    let items: [ChipGroup.ChipItem] = [
        .init(text: "All"),
        .init(text: "Music", icon: Image(systemName: "music.note")),
        .init(text: "Movies", icon: Image(systemName: "film")),
        .init(text: "Books", icon: Image(systemName: "book")),
        .init(text: "Podcasts", icon: Image(systemName: "mic"))
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 8) {
                Chip("Tag", style: .filled)
                Chip("Outlined", style: .outlined)
                Chip("Subtle", style: .subtle)
            }
            
            ChipGroup(
                items: items,
                selectedItems: $selectedItems,
                style: .filled,
                allowsMultipleSelection: false
            )
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Dismissible:").font(.caption)
                DismissibleChipGroup(items: $tags, color: .purple)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ChipPreview()
}
#endif
