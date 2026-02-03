import SwiftUI

/// A list with drag-to-reorder functionality.
///
/// `ReorderableList` provides intuitive drag-and-drop reordering
/// with haptic feedback and smooth animations.
///
/// ```swift
/// ReorderableList(items: $items) { item in
///     Text(item.title)
/// }
/// ```
public struct ReorderableList<Item: Identifiable, RowContent: View>: View {
    // MARK: - Properties
    
    @Binding private var items: [Item]
    private let rowContent: (Item) -> RowContent
    private let rowHeight: CGFloat
    private let spacing: CGFloat
    private let showDragHandle: Bool
    private let onReorder: (([Item]) -> Void)?
    
    @State private var draggingItem: Item?
    @State private var dragOffset: CGSize = .zero
    @State private var draggingIndex: Int?
    
    // MARK: - Initialization
    
    /// Creates a new reorderable list.
    /// - Parameters:
    ///   - items: Binding to the items array.
    ///   - rowHeight: Height of each row. Defaults to `50`.
    ///   - spacing: Spacing between rows. Defaults to `0`.
    ///   - showDragHandle: Whether to show drag handles. Defaults to `true`.
    ///   - onReorder: Called when items are reordered. Defaults to `nil`.
    ///   - rowContent: The row content builder.
    public init(
        items: Binding<[Item]>,
        rowHeight: CGFloat = 50,
        spacing: CGFloat = 0,
        showDragHandle: Bool = true,
        onReorder: (([Item]) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self._items = items
        self.rowHeight = rowHeight
        self.spacing = spacing
        self.showDragHandle = showDragHandle
        self.onReorder = onReorder
        self.rowContent = rowContent
    }
    
    // MARK: - Body
    
    public var body: some View {
        LazyVStack(spacing: spacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                rowView(item: item, index: index)
                    .frame(height: rowHeight)
                    .zIndex(draggingItem?.id == item.id ? 1 : 0)
            }
        }
    }
    
    // MARK: - Row View
    
    private func rowView(item: Item, index: Int) -> some View {
        HStack(spacing: 12) {
            if showDragHandle {
                Image(systemName: "line.3.horizontal")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .gesture(dragGesture(for: item, at: index))
            }
            
            rowContent(item)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .offset(y: calculateOffset(for: item, at: index))
        .scaleEffect(draggingItem?.id == item.id ? 1.02 : 1.0)
        .shadow(
            color: draggingItem?.id == item.id ? .black.opacity(0.15) : .clear,
            radius: draggingItem?.id == item.id ? 8 : 0
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: draggingItem?.id)
    }
    
    // MARK: - Drag Gesture
    
    private func dragGesture(for item: Item, at index: Int) -> some Gesture {
        LongPressGesture(minimumDuration: 0.1)
            .sequenced(before: DragGesture())
            .onChanged { value in
                switch value {
                case .second(true, let drag):
                    if draggingItem == nil {
                        draggingItem = item
                        draggingIndex = index
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    
                    if let drag {
                        dragOffset = drag.translation
                        updateItemPosition(from: index)
                    }
                default:
                    break
                }
            }
            .onEnded { _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    draggingItem = nil
                    draggingIndex = nil
                    dragOffset = .zero
                }
                onReorder?(items)
            }
    }
    
    // MARK: - Position Calculation
    
    private func calculateOffset(for item: Item, at index: Int) -> CGFloat {
        guard let draggingItem, draggingItem.id == item.id else {
            return 0
        }
        return dragOffset.height
    }
    
    private func updateItemPosition(from originalIndex: Int) {
        guard draggingItem != nil else { return }
        
        let totalRowHeight = rowHeight + spacing
        let moveThreshold = totalRowHeight / 2
        let offsetInRows = Int((dragOffset.height + (dragOffset.height > 0 ? moveThreshold : -moveThreshold)) / totalRowHeight)
        
        let newIndex = max(0, min(items.count - 1, originalIndex + offsetInRows))
        
        if newIndex != draggingIndex {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                if let currentIndex = draggingIndex {
                    items.move(fromOffsets: IndexSet(integer: currentIndex), toOffset: newIndex > currentIndex ? newIndex + 1 : newIndex)
                    draggingIndex = newIndex
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }
}

// MARK: - Simple Reorderable List

/// A simpler reorderable list using native SwiftUI APIs (iOS 16+).
@available(iOS 16.0, *)
public struct NativeReorderableList<Item: Identifiable, RowContent: View>: View {
    @Binding private var items: [Item]
    private let rowContent: (Item) -> RowContent
    private let onMove: (([Item]) -> Void)?
    
    public init(
        items: Binding<[Item]>,
        onMove: (([Item]) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self._items = items
        self.onMove = onMove
        self.rowContent = rowContent
    }
    
    public var body: some View {
        List {
            ForEach(items) { item in
                rowContent(item)
            }
            .onMove(perform: moveItems)
        }
        .listStyle(.plain)
    }
    
    private func moveItems(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        onMove?(items)
    }
}

// MARK: - Numbered Reorderable List

/// A reorderable list with automatic numbering.
public struct NumberedReorderableList<Item: Identifiable, RowContent: View>: View {
    @Binding private var items: [Item]
    private let rowContent: (Int, Item) -> RowContent
    private let numberStyle: NumberStyle
    
    public enum NumberStyle {
        case numeric
        case alphabetic
        case roman
        case custom((Int) -> String)
        
        func format(_ index: Int) -> String {
            switch self {
            case .numeric:
                return "\(index + 1)"
            case .alphabetic:
                let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                if index < 26 {
                    return String(letters[letters.index(letters.startIndex, offsetBy: index)])
                }
                return "\(index + 1)"
            case .roman:
                return romanNumeral(index + 1)
            case .custom(let formatter):
                return formatter(index)
            }
        }
        
        private func romanNumeral(_ number: Int) -> String {
            let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
            let symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
            
            var result = ""
            var remaining = number
            
            for (index, value) in values.enumerated() {
                while remaining >= value {
                    result += symbols[index]
                    remaining -= value
                }
            }
            
            return result
        }
    }
    
    public init(
        items: Binding<[Item]>,
        numberStyle: NumberStyle = .numeric,
        @ViewBuilder rowContent: @escaping (Int, Item) -> RowContent
    ) {
        self._items = items
        self.numberStyle = numberStyle
        self.rowContent = rowContent
    }
    
    public var body: some View {
        ReorderableList(items: $items) { item in
            HStack(spacing: 12) {
                if let index = items.firstIndex(where: { $0.id == item.id }) {
                    Text(numberStyle.format(index))
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                        .frame(width: 30)
                }
                
                rowContent(items.firstIndex(where: { $0.id == item.id }) ?? 0, item)
            }
        }
    }
}

#if DEBUG
struct ReorderableListPreview: View {
    struct ListItem: Identifiable {
        let id = UUID()
        var title: String
    }
    
    @State private var items: [ListItem] = [
        .init(title: "First Item"),
        .init(title: "Second Item"),
        .init(title: "Third Item"),
        .init(title: "Fourth Item"),
        .init(title: "Fifth Item")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Drag handles to reorder")
                    .font(.headline)
                
                ReorderableList(items: $items) { item in
                    HStack {
                        Circle()
                            .fill(.blue.opacity(0.2))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(String(item.title.first ?? "?"))
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            )
                        
                        Text(item.title)
                            .font(.body)
                        
                        Spacer()
                    }
                }
                .background(Color(.systemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
    }
}

#Preview {
    ReorderableListPreview()
}
#endif
