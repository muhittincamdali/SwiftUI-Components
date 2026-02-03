import SwiftUI

/// A breadcrumb navigation component showing the current path.
///
/// `BreadcrumbView` displays a hierarchical navigation path
/// with interactive links.
///
/// ```swift
/// BreadcrumbView(path: ["Home", "Products", "Electronics"])
/// ```
public struct BreadcrumbView: View {
    // MARK: - Types
    
    /// A breadcrumb item.
    public struct Crumb: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: Image?
        public let action: (() -> Void)?
        
        public init(title: String, icon: Image? = nil, action: (() -> Void)? = nil) {
            self.title = title
            self.icon = icon
            self.action = action
        }
    }
    
    /// The visual style of the breadcrumb.
    public enum Style {
        case chevron
        case slash
        case arrow
        case dot
    }
    
    // MARK: - Properties
    
    private let crumbs: [Crumb]
    private let style: Style
    private let font: Font
    private let activeColor: Color
    private let inactiveColor: Color
    private let separatorColor: Color
    private let truncateMiddle: Bool
    private let maxItems: Int
    
    // MARK: - Initialization
    
    /// Creates a breadcrumb from strings.
    public init(
        path: [String],
        style: Style = .chevron,
        font: Font = .subheadline,
        activeColor: Color = .primary,
        inactiveColor: Color = .blue,
        separatorColor: Color = .secondary,
        truncateMiddle: Bool = true,
        maxItems: Int = 4,
        onSelect: ((Int) -> Void)? = nil
    ) {
        self.crumbs = path.enumerated().map { index, title in
            Crumb(title: title) { onSelect?(index) }
        }
        self.style = style
        self.font = font
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.separatorColor = separatorColor
        self.truncateMiddle = truncateMiddle
        self.maxItems = maxItems
    }
    
    /// Creates a breadcrumb from crumb objects.
    public init(
        crumbs: [Crumb],
        style: Style = .chevron,
        font: Font = .subheadline,
        activeColor: Color = .primary,
        inactiveColor: Color = .blue,
        separatorColor: Color = .secondary,
        truncateMiddle: Bool = true,
        maxItems: Int = 4
    ) {
        self.crumbs = crumbs
        self.style = style
        self.font = font
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.separatorColor = separatorColor
        self.truncateMiddle = truncateMiddle
        self.maxItems = maxItems
    }
    
    // MARK: - Body
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(displayCrumbs.enumerated()), id: \.element.id) { index, crumb in
                    if index > 0 {
                        separator
                    }
                    
                    crumbView(crumb, isLast: index == displayCrumbs.count - 1)
                }
            }
        }
    }
    
    // MARK: - Display Crumbs
    
    private var displayCrumbs: [Crumb] {
        guard truncateMiddle && crumbs.count > maxItems else {
            return crumbs
        }
        
        var result: [Crumb] = []
        
        // First item
        result.append(crumbs[0])
        
        // Ellipsis
        result.append(Crumb(title: "...", icon: nil, action: nil))
        
        // Last items
        let lastItems = crumbs.suffix(maxItems - 2)
        result.append(contentsOf: lastItems)
        
        return result
    }
    
    // MARK: - Crumb View
    
    private func crumbView(_ crumb: Crumb, isLast: Bool) -> some View {
        Button {
            crumb.action?()
        } label: {
            HStack(spacing: 4) {
                if let icon = crumb.icon {
                    icon
                        .imageScale(.small)
                }
                
                Text(crumb.title)
                    .font(font)
                    .fontWeight(isLast ? .semibold : .regular)
            }
            .foregroundStyle(isLast ? activeColor : inactiveColor)
        }
        .buttonStyle(.plain)
        .disabled(crumb.action == nil || isLast)
    }
    
    // MARK: - Separator
    
    private var separator: some View {
        Group {
            switch style {
            case .chevron:
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
            case .slash:
                Text("/")
                    .font(font)
            case .arrow:
                Image(systemName: "arrow.right")
                    .font(.caption2)
            case .dot:
                Circle()
                    .frame(width: 4, height: 4)
            }
        }
        .foregroundStyle(separatorColor)
    }
}

// MARK: - Compact Breadcrumb

/// A more compact breadcrumb showing only back navigation.
public struct CompactBreadcrumb: View {
    private let currentTitle: String
    private let parentTitle: String?
    private let onBack: (() -> Void)?
    
    public init(
        currentTitle: String,
        parentTitle: String? = nil,
        onBack: (() -> Void)? = nil
    ) {
        self.currentTitle = currentTitle
        self.parentTitle = parentTitle
        self.onBack = onBack
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            if let parent = parentTitle, let action = onBack {
                Button {
                    action()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.caption.weight(.semibold))
                        Text(parent)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            
            Text(currentTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Breadcrumb with Dropdown

/// A breadcrumb that shows overflow items in a dropdown menu.
public struct DropdownBreadcrumb: View {
    private let crumbs: [BreadcrumbView.Crumb]
    private let maxVisible: Int
    private let font: Font
    
    public init(
        crumbs: [BreadcrumbView.Crumb],
        maxVisible: Int = 3,
        font: Font = .subheadline
    ) {
        self.crumbs = crumbs
        self.maxVisible = maxVisible
        self.font = font
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            if crumbs.count > maxVisible {
                // First crumb
                crumbButton(crumbs[0], isLast: false)
                
                separator
                
                // Overflow menu
                Menu {
                    ForEach(Array(crumbs[1..<crumbs.count - maxVisible + 2].enumerated()), id: \.element.id) { index, crumb in
                        Button(crumb.title) {
                            crumb.action?()
                        }
                    }
                } label: {
                    Text("...")
                        .font(font)
                        .foregroundStyle(.blue)
                }
                
                separator
                
                // Last crumbs
                ForEach(Array(crumbs.suffix(maxVisible - 2).enumerated()), id: \.element.id) { index, crumb in
                    if index > 0 {
                        separator
                    }
                    crumbButton(crumb, isLast: index == maxVisible - 3)
                }
            } else {
                ForEach(Array(crumbs.enumerated()), id: \.element.id) { index, crumb in
                    if index > 0 {
                        separator
                    }
                    crumbButton(crumb, isLast: index == crumbs.count - 1)
                }
            }
        }
    }
    
    private func crumbButton(_ crumb: BreadcrumbView.Crumb, isLast: Bool) -> some View {
        Button {
            crumb.action?()
        } label: {
            Text(crumb.title)
                .font(font)
                .fontWeight(isLast ? .semibold : .regular)
                .foregroundStyle(isLast ? .primary : .blue)
        }
        .buttonStyle(.plain)
        .disabled(isLast)
    }
    
    private var separator: some View {
        Image(systemName: "chevron.right")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading) {
            Text("Chevron Style").font(.caption)
            BreadcrumbView(path: ["Home", "Products", "Electronics", "Phones"])
        }
        
        VStack(alignment: .leading) {
            Text("Slash Style").font(.caption)
            BreadcrumbView(path: ["Home", "Settings", "Account"], style: .slash)
        }
        
        VStack(alignment: .leading) {
            Text("Compact").font(.caption)
            CompactBreadcrumb(currentTitle: "Account", parentTitle: "Settings") { }
        }
        
        VStack(alignment: .leading) {
            Text("Long Path (Truncated)").font(.caption)
            BreadcrumbView(path: ["Home", "Category", "Subcategory", "Product", "Details", "Reviews"])
        }
    }
    .padding()
}
#endif
