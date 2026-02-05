import SwiftUI

/// A grouped list with sections
public struct GroupedList<Item: Identifiable, Content: View, Header: View>: View {
    let sections: [ListSection<Item>]
    let style: GroupedListStyle
    @ViewBuilder let content: (Item) -> Content
    @ViewBuilder let header: (ListSection<Item>) -> Header
    
    public struct ListSection<T: Identifiable>: Identifiable {
        public let id = UUID()
        let title: String
        let subtitle: String?
        let items: [T]
        
        public init(title: String, subtitle: String? = nil, items: [T]) {
            self.title = title
            self.subtitle = subtitle
            self.items = items
        }
    }
    
    public enum GroupedListStyle {
        case inset
        case plain
        case sidebar
    }
    
    public init(
        sections: [ListSection<Item>],
        style: GroupedListStyle = .inset,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder header: @escaping (ListSection<Item>) -> Header
    ) {
        self.sections = sections
        self.style = style
        self.content = content
        self.header = header
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: style == .inset ? 16 : 0) {
                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 0) {
                        // Section header
                        header(section)
                            .padding(.horizontal, style == .inset ? 20 : 16)
                            .padding(.bottom, 8)
                        
                        // Items
                        VStack(spacing: 0) {
                            ForEach(section.items) { item in
                                VStack(spacing: 0) {
                                    content(item)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                    
                                    if item.id as AnyHashable != section.items.last?.id as AnyHashable {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(style == .inset ? 12 : 0)
                        .padding(.horizontal, style == .inset ? 16 : 0)
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}

/// Simple section header
public struct SectionHeader: View {
    let title: String
    let subtitle: String?
    let action: (() -> Void)?
    let actionLabel: String?
    
    public init(
        title: String,
        subtitle: String? = nil,
        action: (() -> Void)? = nil,
        actionLabel: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.actionLabel = actionLabel
    }
    
    public var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.8))
                }
            }
            
            Spacer()
            
            if let action = action, let label = actionLabel {
                Button(action: action) {
                    Text(label)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

/// A selectable list with checkmarks
public struct SelectableList<Item: Identifiable & Hashable, Content: View>: View {
    @Binding var selection: Set<Item>
    let items: [Item]
    let allowsMultipleSelection: Bool
    @ViewBuilder let content: (Item, Bool) -> Content
    
    public init(
        selection: Binding<Set<Item>>,
        items: [Item],
        allowsMultipleSelection: Bool = true,
        @ViewBuilder content: @escaping (Item, Bool) -> Content
    ) {
        self._selection = selection
        self.items = items
        self.allowsMultipleSelection = allowsMultipleSelection
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button {
                    toggleSelection(item)
                } label: {
                    HStack {
                        content(item, selection.contains(item))
                        
                        Spacer()
                        
                        if selection.contains(item) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(selection.contains(item) ? Color.accentColor.opacity(0.08) : Color.clear)
                }
                .buttonStyle(PlainButtonStyle())
                
                if item.id as AnyHashable != items.last?.id as AnyHashable {
                    Divider()
                        .padding(.leading, 16)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func toggleSelection(_ item: Item) {
        if selection.contains(item) {
            selection.remove(item)
        } else {
            if !allowsMultipleSelection {
                selection.removeAll()
            }
            selection.insert(item)
        }
    }
}

/// A collapsible list section
public struct CollapsibleSection<Content: View>: View {
    let title: String
    let icon: String?
    let badge: Int?
    @State private var isExpanded: Bool
    @ViewBuilder let content: () -> Content
    
    public init(
        title: String,
        icon: String? = nil,
        badge: Int? = nil,
        isExpanded: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self._isExpanded = State(initialValue: isExpanded)
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundColor(.accentColor)
                            .frame(width: 28)
                    }
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if let badge = badge, badge > 0 {
                        Text("\(badge)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.systemGray6))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Grouped Lists") {
    struct ListItem: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let subtitle: String
    }
    
    struct PreviewWrapper: View {
        @State private var selection: Set<ListItem> = []
        
        let sections = [
            GroupedList<ListItem, AnyView, AnyView>.ListSection(
                title: "Favorites",
                subtitle: "Your pinned items",
                items: [
                    ListItem(title: "Home", subtitle: "Main dashboard"),
                    ListItem(title: "Settings", subtitle: "App preferences")
                ]
            ),
            GroupedList<ListItem, AnyView, AnyView>.ListSection(
                title: "Recent",
                items: [
                    ListItem(title: "Project A", subtitle: "Last edited today"),
                    ListItem(title: "Project B", subtitle: "Last edited yesterday"),
                    ListItem(title: "Project C", subtitle: "Last edited 3 days ago")
                ]
            )
        ]
        
        let selectItems = [
            ListItem(title: "Option 1", subtitle: "Description 1"),
            ListItem(title: "Option 2", subtitle: "Description 2"),
            ListItem(title: "Option 3", subtitle: "Description 3")
        ]
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    // Grouped List
                    GroupedList(
                        sections: sections,
                        style: .inset,
                        content: { item in
                            AnyView(
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.system(size: 15, weight: .medium))
                                        Text(item.subtitle)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                            )
                        },
                        header: { section in
                            AnyView(
                                SectionHeader(
                                    title: section.title,
                                    subtitle: section.subtitle,
                                    action: {},
                                    actionLabel: "See All"
                                )
                            )
                        }
                    )
                    .frame(height: 400)
                    
                    // Selectable List
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selectable List")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        SelectableList(
                            selection: $selection,
                            items: selectItems
                        ) { item, isSelected in
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.system(size: 15, weight: .medium))
                                Text(item.subtitle)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Collapsible Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Collapsible Section")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        CollapsibleSection(title: "Categories", icon: "folder.fill", badge: 5) {
                            VStack(spacing: 0) {
                                ForEach(["Work", "Personal", "Archive"], id: \.self) { item in
                                    HStack {
                                        Text(item)
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
        }
    }
    
    return PreviewWrapper()
}
