import SwiftUI

/// A customizable tab bar with animated selection and badges.
///
/// `TabBarView` provides a flexible alternative to the system tab bar
/// with custom styling and animation options.
///
/// ```swift
/// TabBarView(selectedIndex: $selectedTab, items: [
///     .init(icon: Image(systemName: "house"), title: "Home"),
///     .init(icon: Image(systemName: "gear"), title: "Settings")
/// ])
/// ```
public struct TabBarView: View {
    // MARK: - Types
    
    /// A tab bar item configuration.
    public struct Item: Identifiable {
        public let id = UUID()
        public let icon: Image
        public let selectedIcon: Image?
        public let title: String
        public let badge: String?
        
        public init(
            icon: Image,
            selectedIcon: Image? = nil,
            title: String,
            badge: String? = nil
        ) {
            self.icon = icon
            self.selectedIcon = selectedIcon
            self.title = title
            self.badge = badge
        }
    }
    
    /// The visual style of the tab bar.
    public enum Style {
        case standard
        case pill
        case floating
        case minimal
    }
    
    // MARK: - Properties
    
    @Binding private var selectedIndex: Int
    private let items: [Item]
    private let style: Style
    private let tintColor: Color
    private let backgroundColor: Color
    private let showLabels: Bool
    private let hapticFeedback: Bool
    
    // MARK: - Initialization
    
    /// Creates a new tab bar view.
    public init(
        selectedIndex: Binding<Int>,
        items: [Item],
        style: Style = .standard,
        tintColor: Color = .blue,
        backgroundColor: Color = Color(.systemBackground),
        showLabels: Bool = true,
        hapticFeedback: Bool = true
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.style = style
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.showLabels = showLabels
        self.hapticFeedback = hapticFeedback
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardTabBar
            case .pill:
                pillTabBar
            case .floating:
                floatingTabBar
            case .minimal:
                minimalTabBar
            }
        }
    }
    
    // MARK: - Standard Tab Bar
    
    private var standardTabBar: some View {
        HStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                tabButton(item: item, index: index, isSelected: selectedIndex == index)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(backgroundColor)
        .overlay(
            Divider(),
            alignment: .top
        )
    }
    
    // MARK: - Pill Tab Bar
    
    private var pillTabBar: some View {
        HStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                pillButton(item: item, index: index, isSelected: selectedIndex == index)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        )
        .padding(.horizontal, 16)
    }
    
    // MARK: - Floating Tab Bar
    
    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                floatingButton(item: item, index: index, isSelected: selectedIndex == index)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        )
        .padding(.horizontal, 40)
    }
    
    // MARK: - Minimal Tab Bar
    
    private var minimalTabBar: some View {
        HStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                minimalButton(item: item, index: index, isSelected: selectedIndex == index)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
    
    // MARK: - Tab Buttons
    
    private func tabButton(item: Item, index: Int, isSelected: Bool) -> some View {
        Button {
            selectTab(index)
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    (isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                        .font(.system(size: 24))
                        .symbolVariant(isSelected ? .fill : .none)
                    
                    if let badge = item.badge {
                        badgeView(badge)
                            .offset(x: 8, y: -4)
                    }
                }
                
                if showLabels {
                    Text(item.title)
                        .font(.caption2)
                        .fontWeight(isSelected ? .semibold : .regular)
                }
            }
            .foregroundStyle(isSelected ? tintColor : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
    
    private func pillButton(item: Item, index: Int, isSelected: Bool) -> some View {
        Button {
            selectTab(index)
        } label: {
            HStack(spacing: 8) {
                (isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                    .font(.system(size: 20))
                    .symbolVariant(isSelected ? .fill : .none)
                
                if isSelected && showLabels {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(isSelected ? .white : .secondary)
            .padding(.horizontal, isSelected ? 16 : 12)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? tintColor : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
    
    private func floatingButton(item: Item, index: Int, isSelected: Bool) -> some View {
        Button {
            selectTab(index)
        } label: {
            VStack(spacing: 2) {
                ZStack(alignment: .topTrailing) {
                    (isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                        .font(.system(size: 22))
                        .symbolVariant(isSelected ? .fill : .none)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                    
                    if let badge = item.badge {
                        badgeView(badge)
                            .offset(x: 8, y: -4)
                    }
                }
                
                Circle()
                    .fill(tintColor)
                    .frame(width: 5, height: 5)
                    .opacity(isSelected ? 1 : 0)
            }
            .foregroundStyle(isSelected ? tintColor : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
    
    private func minimalButton(item: Item, index: Int, isSelected: Bool) -> some View {
        Button {
            selectTab(index)
        } label: {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(tintColor)
                    .frame(height: 2)
                    .opacity(isSelected ? 1 : 0)
                    .padding(.bottom, 8)
                
                (isSelected ? (item.selectedIcon ?? item.icon) : item.icon)
                    .font(.system(size: 24))
                    .symbolVariant(isSelected ? .fill : .none)
            }
            .foregroundStyle(isSelected ? tintColor : .secondary)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
    
    // MARK: - Badge View
    
    private func badgeView(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Capsule().fill(.red))
            .fixedSize()
    }
    
    // MARK: - Selection
    
    private func selectTab(_ index: Int) {
        guard index != selectedIndex else { return }
        
        if hapticFeedback {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            selectedIndex = index
        }
    }
}

// MARK: - Tab Bar Container

/// A container view that displays content with a tab bar.
public struct TabBarContainer<Content: View>: View {
    @Binding private var selectedIndex: Int
    private let items: [TabBarView.Item]
    private let style: TabBarView.Style
    private let content: (Int) -> Content
    
    public init(
        selectedIndex: Binding<Int>,
        items: [TabBarView.Item],
        style: TabBarView.Style = .standard,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.style = style
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            content(selectedIndex)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TabBarView(selectedIndex: $selectedIndex, items: items, style: style)
        }
    }
}

#if DEBUG
struct TabBarViewPreview: View {
    @State private var selectedTab1 = 0
    @State private var selectedTab2 = 0
    @State private var selectedTab3 = 0
    
    let items: [TabBarView.Item] = [
        .init(icon: Image(systemName: "house"), title: "Home"),
        .init(icon: Image(systemName: "magnifyingglass"), title: "Search"),
        .init(icon: Image(systemName: "bell"), title: "Alerts", badge: "3"),
        .init(icon: Image(systemName: "person"), title: "Profile")
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Standard").font(.caption)
                TabBarView(selectedIndex: $selectedTab1, items: items, style: .standard)
            }
            
            VStack {
                Text("Pill").font(.caption)
                TabBarView(selectedIndex: $selectedTab2, items: items, style: .pill)
            }
            
            VStack {
                Text("Floating").font(.caption)
                TabBarView(selectedIndex: $selectedTab3, items: items, style: .floating)
            }
            
            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    TabBarViewPreview()
}
#endif
