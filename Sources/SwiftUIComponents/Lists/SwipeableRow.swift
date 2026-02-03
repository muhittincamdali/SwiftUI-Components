import SwiftUI

/// A list row with swipeable action buttons.
///
/// `SwipeableRow` provides iOS-style swipe actions with
/// customizable leading and trailing buttons.
///
/// ```swift
/// SwipeableRow(
///     leadingActions: [.init(title: "Archive", color: .blue) { }],
///     trailingActions: [.init(title: "Delete", color: .red) { }]
/// ) {
///     Text("Swipe me!")
/// }
/// ```
public struct SwipeableRow<Content: View>: View {
    // MARK: - Types
    
    /// A swipe action configuration.
    public struct SwipeAction: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: Image?
        public let color: Color
        public let isDestructive: Bool
        public let action: () -> Void
        
        public init(
            title: String,
            icon: Image? = nil,
            color: Color = .blue,
            isDestructive: Bool = false,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.color = color
            self.isDestructive = isDestructive
            self.action = action
        }
    }
    
    // MARK: - Properties
    
    private let leadingActions: [SwipeAction]
    private let trailingActions: [SwipeAction]
    private let actionWidth: CGFloat
    private let threshold: CGFloat
    private let content: () -> Content
    
    @State private var offset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    @GestureState private var isDragging: Bool = false
    
    // MARK: - Initialization
    
    /// Creates a new swipeable row.
    /// - Parameters:
    ///   - leadingActions: Actions revealed on right swipe. Defaults to `[]`.
    ///   - trailingActions: Actions revealed on left swipe. Defaults to `[]`.
    ///   - actionWidth: Width of each action button. Defaults to `70`.
    ///   - threshold: Swipe threshold for full action. Defaults to `0.4`.
    ///   - content: The row content.
    public init(
        leadingActions: [SwipeAction] = [],
        trailingActions: [SwipeAction] = [],
        actionWidth: CGFloat = 70,
        threshold: CGFloat = 0.4,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.actionWidth = actionWidth
        self.threshold = threshold
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background actions
                HStack(spacing: 0) {
                    // Leading actions
                    leadingActionsView
                    
                    Spacer()
                    
                    // Trailing actions
                    trailingActionsView
                }
                
                // Content
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .updating($isDragging) { _, state, _ in
                                state = true
                            }
                            .onChanged { value in
                                handleDrag(value: value, width: geometry.size.width)
                            }
                            .onEnded { value in
                                handleDragEnd(value: value, width: geometry.size.width)
                            }
                    )
            }
        }
        .clipped()
    }
    
    // MARK: - Leading Actions View
    
    private var leadingActionsView: some View {
        HStack(spacing: 0) {
            ForEach(leadingActions) { action in
                actionButton(action)
            }
        }
        .frame(width: max(0, offset))
        .clipped()
    }
    
    // MARK: - Trailing Actions View
    
    private var trailingActionsView: some View {
        HStack(spacing: 0) {
            ForEach(trailingActions) { action in
                actionButton(action)
            }
        }
        .frame(width: max(0, -offset))
        .clipped()
    }
    
    // MARK: - Action Button
    
    private func actionButton(_ action: SwipeAction) -> some View {
        Button {
            performAction(action)
        } label: {
            VStack(spacing: 4) {
                if let icon = action.icon {
                    icon
                        .font(.title3)
                }
                Text(action.title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundStyle(.white)
            .frame(width: actionWidth)
            .frame(maxHeight: .infinity)
            .background(action.color)
        }
    }
    
    // MARK: - Gesture Handling
    
    private func handleDrag(value: DragGesture.Value, width: CGFloat) {
        let translation = value.translation.width + startOffset
        
        // Limit based on available actions
        let maxLeading = CGFloat(leadingActions.count) * actionWidth
        let maxTrailing = -CGFloat(trailingActions.count) * actionWidth
        
        if leadingActions.isEmpty && translation > 0 {
            offset = translation * 0.3 // Resistance
        } else if trailingActions.isEmpty && translation < 0 {
            offset = translation * 0.3 // Resistance
        } else {
            offset = min(maxLeading, max(maxTrailing, translation))
        }
    }
    
    private func handleDragEnd(value: DragGesture.Value, width: CGFloat) {
        let velocity = value.predictedEndLocation.x - value.location.x
        let maxLeading = CGFloat(leadingActions.count) * actionWidth
        let maxTrailing = -CGFloat(trailingActions.count) * actionWidth
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            // Check for full swipe actions
            if offset > width * threshold && !leadingActions.isEmpty {
                if let firstAction = leadingActions.first, firstAction.isDestructive {
                    offset = width
                    performAction(firstAction)
                    return
                }
            } else if offset < -width * threshold && !trailingActions.isEmpty {
                if let firstAction = trailingActions.first, firstAction.isDestructive {
                    offset = -width
                    performAction(firstAction)
                    return
                }
            }
            
            // Snap to positions
            if offset > maxLeading / 2 || velocity > 200 {
                offset = maxLeading
            } else if offset < maxTrailing / 2 || velocity < -200 {
                offset = maxTrailing
            } else {
                offset = 0
            }
            
            startOffset = offset
        }
    }
    
    private func performAction(_ action: SwipeAction) {
        action.action()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            offset = 0
            startOffset = 0
        }
    }
}

// MARK: - Swipeable List

/// A list with swipeable rows.
public struct SwipeableList<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let leadingActions: (Data.Element) -> [SwipeableRow<RowContent>.SwipeAction]
    private let trailingActions: (Data.Element) -> [SwipeableRow<RowContent>.SwipeAction]
    private let rowContent: (Data.Element) -> RowContent
    
    public init(
        _ data: Data,
        leadingActions: @escaping (Data.Element) -> [SwipeableRow<RowContent>.SwipeAction] = { _ in [] },
        trailingActions: @escaping (Data.Element) -> [SwipeableRow<RowContent>.SwipeAction] = { _ in [] },
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.data = data
        self.leadingActions = leadingActions
        self.trailingActions = trailingActions
        self.rowContent = rowContent
    }
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(data) { item in
                SwipeableRow(
                    leadingActions: leadingActions(item),
                    trailingActions: trailingActions(item)
                ) {
                    rowContent(item)
                }
                .frame(height: 60)
                
                Divider()
            }
        }
    }
}

// MARK: - Convenience Actions

extension SwipeableRow.SwipeAction {
    /// Creates a delete action.
    public static func delete(action: @escaping () -> Void) -> Self {
        .init(
            title: "Delete",
            icon: Image(systemName: "trash.fill"),
            color: .red,
            isDestructive: true,
            action: action
        )
    }
    
    /// Creates an archive action.
    public static func archive(action: @escaping () -> Void) -> Self {
        .init(
            title: "Archive",
            icon: Image(systemName: "archivebox.fill"),
            color: .purple,
            action: action
        )
    }
    
    /// Creates a pin action.
    public static func pin(action: @escaping () -> Void) -> Self {
        .init(
            title: "Pin",
            icon: Image(systemName: "pin.fill"),
            color: .orange,
            action: action
        )
    }
    
    /// Creates a share action.
    public static func share(action: @escaping () -> Void) -> Self {
        .init(
            title: "Share",
            icon: Image(systemName: "square.and.arrow.up"),
            color: .blue,
            action: action
        )
    }
    
    /// Creates a flag action.
    public static func flag(action: @escaping () -> Void) -> Self {
        .init(
            title: "Flag",
            icon: Image(systemName: "flag.fill"),
            color: .orange,
            action: action
        )
    }
    
    /// Creates a more action.
    public static func more(action: @escaping () -> Void) -> Self {
        .init(
            title: "More",
            icon: Image(systemName: "ellipsis.circle.fill"),
            color: .gray,
            action: action
        )
    }
}

#if DEBUG
struct SwipeableRowPreview: View {
    var body: some View {
        VStack(spacing: 0) {
            SwipeableRow(
                leadingActions: [.pin { }, .share { }],
                trailingActions: [.more { }, .delete { }]
            ) {
                HStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.headline)
                        Text("Hello, how are you?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .frame(height: 70)
            
            Divider()
            
            SwipeableRow(
                trailingActions: [.delete { }]
            ) {
                HStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .font(.headline)
                        Text("See you tomorrow!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .frame(height: 70)
            
            Spacer()
        }
    }
}

#Preview {
    SwipeableRowPreview()
}
#endif
