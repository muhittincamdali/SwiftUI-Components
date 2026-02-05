import SwiftUI

/// A custom navigation bar
public struct CustomNavigationBar: View {
    let title: String
    let subtitle: String?
    let leadingItems: [NavBarItem]
    let trailingItems: [NavBarItem]
    let style: NavBarStyle
    
    public struct NavBarItem: Identifiable {
        public let id = UUID()
        let icon: String?
        let title: String?
        let badge: Int?
        let action: () -> Void
        
        public init(icon: String? = nil, title: String? = nil, badge: Int? = nil, action: @escaping () -> Void) {
            self.icon = icon
            self.title = title
            self.badge = badge
            self.action = action
        }
    }
    
    public enum NavBarStyle {
        case standard
        case large
        case transparent
        case colored(Color)
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        leadingItems: [NavBarItem] = [],
        trailingItems: [NavBarItem] = [],
        style: NavBarStyle = .standard
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingItems = leadingItems
        self.trailingItems = trailingItems
        self.style = style
    }
    
    private var foregroundColor: Color {
        switch style {
        case .colored: return .white
        case .transparent: return .primary
        default: return .primary
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch style {
            case .large:
                largeNavBar
            default:
                standardNavBar
            }
        }
        .background(backgroundColor)
    }
    
    private var backgroundColor: some View {
        Group {
            switch style {
            case .standard:
                Color(.systemBackground)
            case .large:
                Color(.systemBackground)
            case .transparent:
                Color.clear
            case .colored(let color):
                color
            }
        }
    }
    
    private var standardNavBar: some View {
        HStack(spacing: 16) {
            // Leading items
            HStack(spacing: 12) {
                ForEach(leadingItems) { item in
                    navBarButton(item)
                }
            }
            .frame(minWidth: 60, alignment: .leading)
            
            Spacer()
            
            // Title
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(foregroundColor)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(foregroundColor.opacity(0.7))
                }
            }
            
            Spacer()
            
            // Trailing items
            HStack(spacing: 12) {
                ForEach(trailingItems) { item in
                    navBarButton(item)
                }
            }
            .frame(minWidth: 60, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var largeNavBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Top bar with items
            HStack {
                HStack(spacing: 12) {
                    ForEach(leadingItems) { item in
                        navBarButton(item)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    ForEach(trailingItems) { item in
                        navBarButton(item)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Large title
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 34, weight: .bold))
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
    
    private func navBarButton(_ item: NavBarItem) -> some View {
        Button(action: item.action) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let icon = item.icon {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                    } else if let title = item.title {
                        Text(title)
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .foregroundColor(foregroundColor)
                
                if let badge = item.badge, badge > 0 {
                    Text("\(min(badge, 99))")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

/// A search bar for navigation
public struct SearchNavigationBar: View {
    @Binding var searchText: String
    let placeholder: String
    let onCancel: (() -> Void)?
    @FocusState private var isFocused: Bool
    
    public init(
        searchText: Binding<String>,
        placeholder: String = "Search",
        onCancel: (() -> Void)? = nil
    ) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.onCancel = onCancel
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                TextField(placeholder, text: $searchText)
                    .font(.system(size: 16))
                    .focused($isFocused)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isFocused || !searchText.isEmpty {
                Button("Cancel") {
                    searchText = ""
                    isFocused = false
                    onCancel?()
                }
                .font(.system(size: 15))
                .foregroundColor(.accentColor)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isFocused)
    }
}

/// Tab bar item
public struct TabBarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let badge: Int?
    let action: () -> Void
    
    public init(
        icon: String,
        label: String,
        isSelected: Bool,
        badge: Int? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.isSelected = isSelected
        self.badge = badge
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? icon + ".fill" : icon)
                        .font(.system(size: 22))
                    
                    if let badge = badge, badge > 0 {
                        Text("\(min(badge, 99))")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 10, y: -6)
                    }
                }
                
                Text(label)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? .accentColor : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Custom tab bar
public struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [Tab]
    let style: TabBarStyle
    
    public struct Tab {
        let icon: String
        let label: String
        let badge: Int?
        
        public init(icon: String, label: String, badge: Int? = nil) {
            self.icon = icon
            self.label = label
            self.badge = badge
        }
    }
    
    public enum TabBarStyle {
        case standard
        case floating
        case minimal
    }
    
    public init(
        selectedTab: Binding<Int>,
        tabs: [Tab],
        style: TabBarStyle = .standard
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardTabBar
            case .floating:
                floatingTabBar
            case .minimal:
                minimalTabBar
            }
        }
    }
    
    private var standardTabBar: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarItem(
                    icon: tabs[index].icon,
                    label: tabs[index].label,
                    isSelected: selectedTab == index,
                    badge: tabs[index].badge
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4)
    }
    
    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == index ? tabs[index].icon + ".fill" : tabs[index].icon)
                            .font(.system(size: 20))
                        
                        if selectedTab == index {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 5, height: 5)
                        }
                    }
                    .foregroundColor(selectedTab == index ? .accentColor : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
    
    private var minimalTabBar: some View {
        HStack(spacing: 32) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    Image(systemName: selectedTab == index ? tabs[index].icon + ".fill" : tabs[index].icon)
                        .font(.system(size: 24))
                        .foregroundColor(selectedTab == index ? .accentColor : .secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview("Navigation Components") {
    struct PreviewWrapper: View {
        @State private var searchText = ""
        @State private var selectedTab = 0
        
        var body: some View {
            VStack(spacing: 0) {
                // Standard nav bar
                CustomNavigationBar(
                    title: "Messages",
                    leadingItems: [
                        .init(icon: "chevron.left", action: {})
                    ],
                    trailingItems: [
                        .init(icon: "bell", badge: 3, action: {}),
                        .init(icon: "ellipsis", action: {})
                    ],
                    style: .standard
                )
                
                Divider()
                
                // Search bar
                SearchNavigationBar(searchText: $searchText)
                
                Divider()
                
                // Large nav bar
                CustomNavigationBar(
                    title: "Library",
                    subtitle: "Your collection",
                    trailingItems: [
                        .init(icon: "plus", action: {})
                    ],
                    style: .large
                )
                
                Spacer()
                
                // Tab bars
                VStack(spacing: 20) {
                    CustomTabBar(
                        selectedTab: $selectedTab,
                        tabs: [
                            .init(icon: "house", label: "Home"),
                            .init(icon: "magnifyingglass", label: "Search"),
                            .init(icon: "bell", label: "Alerts", badge: 5),
                            .init(icon: "person", label: "Profile")
                        ],
                        style: .floating
                    )
                }
                
                CustomTabBar(
                    selectedTab: $selectedTab,
                    tabs: [
                        .init(icon: "house", label: "Home"),
                        .init(icon: "magnifyingglass", label: "Search"),
                        .init(icon: "bell", label: "Alerts", badge: 5),
                        .init(icon: "person", label: "Profile")
                    ],
                    style: .standard
                )
            }
            .background(Color(.systemGray6))
        }
    }
    
    return PreviewWrapper()
}
