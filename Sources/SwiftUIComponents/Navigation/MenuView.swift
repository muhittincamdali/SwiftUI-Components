import SwiftUI

/// A sidebar/drawer menu
public struct SideMenu<Content: View>: View {
    @Binding var isOpen: Bool
    let width: CGFloat
    let edge: HorizontalEdge
    @ViewBuilder let content: () -> Content
    
    public init(
        isOpen: Binding<Bool>,
        width: CGFloat = 280,
        edge: HorizontalEdge = .leading,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOpen = isOpen
        self.width = width
        self.edge = edge
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: edge == .leading ? .leading : .trailing) {
            // Overlay
            if isOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isOpen = false
                        }
                    }
            }
            
            // Menu content
            content()
                .frame(width: width)
                .frame(maxHeight: .infinity)
                .background(Color(.systemBackground))
                .offset(x: isOpen ? 0 : (edge == .leading ? -width : width))
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isOpen)
    }
}

/// A navigation menu item
public struct MenuItem: View {
    let title: String
    let icon: String
    let badge: Int?
    let isSelected: Bool
    let action: () -> Void
    
    public init(
        title: String,
        icon: String,
        badge: Int? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 28)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .primary : .primary.opacity(0.8))
                
                Spacer()
                
                if let badge = badge, badge > 0 {
                    Text("\(min(badge, 99))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                if isSelected {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected ? Color.accentColor.opacity(0.1) : Color.clear
            )
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// A dropdown menu
public struct DropdownMenu<Label: View, Content: View>: View {
    @Binding var isExpanded: Bool
    @ViewBuilder let label: () -> Label
    @ViewBuilder let content: () -> Content
    
    public init(
        isExpanded: Binding<Bool>,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.label = label
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
                    label()
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                content()
                    .padding(.top, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

/// Context menu items container
public struct ContextMenuItems: View {
    let items: [ContextItem]
    
    public struct ContextItem: Identifiable {
        public let id = UUID()
        let title: String
        let icon: String
        let isDestructive: Bool
        let action: () -> Void
        
        public init(_ title: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.isDestructive = isDestructive
            self.action = action
        }
    }
    
    public init(items: [ContextItem]) {
        self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button(action: item.action) {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .font(.system(size: 16))
                            .frame(width: 24)
                        
                        Text(item.title)
                            .font(.system(size: 15))
                        
                        Spacer()
                    }
                    .foregroundColor(item.isDestructive ? .red : .primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
                
                if item.id != items.last?.id {
                    Divider()
                        .padding(.leading, 50)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

#Preview("Menu Components") {
    struct PreviewWrapper: View {
        @State private var isMenuOpen = false
        @State private var selectedItem = "Home"
        @State private var isDropdownOpen = false
        
        var body: some View {
            ZStack {
                // Main content
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 20))
                        }
                        
                        Spacer()
                        
                        Text("Menu Demo")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Menu Items")
                            .font(.headline)
                        
                        MenuItem(title: "Home", icon: "house.fill", isSelected: selectedItem == "Home") {
                            selectedItem = "Home"
                        }
                        
                        MenuItem(title: "Messages", icon: "message.fill", badge: 5, isSelected: selectedItem == "Messages") {
                            selectedItem = "Messages"
                        }
                        
                        MenuItem(title: "Settings", icon: "gear", isSelected: selectedItem == "Settings") {
                            selectedItem = "Settings"
                        }
                        
                        Divider()
                        
                        Text("Dropdown Menu")
                            .font(.headline)
                        
                        DropdownMenu(isExpanded: $isDropdownOpen) {
                            Text("Select Category")
                                .foregroundColor(.primary)
                        } content: {
                            VStack(spacing: 0) {
                                ForEach(["All", "Work", "Personal", "Archive"], id: \.self) { option in
                                    Button {
                                        isDropdownOpen = false
                                    } label: {
                                        Text(option)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                        
                        Divider()
                        
                        Text("Context Menu")
                            .font(.headline)
                        
                        ContextMenuItems(items: [
                            .init("Edit", icon: "pencil") {},
                            .init("Share", icon: "square.and.arrow.up") {},
                            .init("Duplicate", icon: "doc.on.doc") {},
                            .init("Delete", icon: "trash", isDestructive: true) {}
                        ])
                        .frame(width: 200)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Side menu
                SideMenu(isOpen: $isMenuOpen, width: 280) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Menu")
                            .font(.title2.bold())
                            .padding(20)
                        
                        Divider()
                        
                        VStack(spacing: 4) {
                            MenuItem(title: "Home", icon: "house.fill", isSelected: true) {}
                            MenuItem(title: "Profile", icon: "person.fill") {}
                            MenuItem(title: "Settings", icon: "gear") {}
                        }
                        .padding(12)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    return PreviewWrapper()
}
