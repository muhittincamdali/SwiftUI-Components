import SwiftUI

/// A horizontal scrolling list
public struct HorizontalList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let showsIndicators: Bool
    let sectionTitle: String?
    let seeAllAction: (() -> Void)?
    @ViewBuilder let content: (Item) -> Content
    
    public init(
        items: [Item],
        spacing: CGFloat = 16,
        showsIndicators: Bool = false,
        sectionTitle: String? = nil,
        seeAllAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.sectionTitle = sectionTitle
        self.seeAllAction = seeAllAction
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if sectionTitle != nil || seeAllAction != nil {
                HStack {
                    if let title = sectionTitle {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    Spacer()
                    
                    if let action = seeAllAction {
                        Button(action: action) {
                            HStack(spacing: 4) {
                                Text("See All")
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            ScrollView(.horizontal, showsIndicators: showsIndicators) {
                HStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

/// A snap scrolling horizontal list
public struct SnapList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let itemWidth: CGFloat
    let spacing: CGFloat
    @ViewBuilder let content: (Item, Bool) -> Content
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    public init(
        items: [Item],
        itemWidth: CGFloat,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping (Item, Bool) -> Content
    ) {
        self.items = items
        self.itemWidth = itemWidth
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = itemWidth + spacing
            let leadingPadding = (geometry.size.width - itemWidth) / 2
            
            HStack(spacing: spacing) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item, index == currentIndex)
                        .frame(width: itemWidth)
                }
            }
            .padding(.horizontal, leadingPadding)
            .offset(x: -CGFloat(currentIndex) * totalWidth + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = itemWidth / 3
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if value.translation.width < -threshold && currentIndex < items.count - 1 {
                                currentIndex += 1
                            } else if value.translation.width > threshold && currentIndex > 0 {
                                currentIndex -= 1
                            }
                            dragOffset = 0
                        }
                    }
            )
        }
    }
}

#Preview("Horizontal Lists") {
    struct ListItem: Identifiable {
        let id = UUID()
        let title: String
        let color: Color
    }
    
    let items = [
        ListItem(title: "Item 1", color: .blue),
        ListItem(title: "Item 2", color: .green),
        ListItem(title: "Item 3", color: .orange),
        ListItem(title: "Item 4", color: .purple),
        ListItem(title: "Item 5", color: .pink)
    ]
    
    return ScrollView {
        VStack(spacing: 32) {
            HorizontalList(
                items: items,
                sectionTitle: "Featured",
                seeAllAction: {}
            ) { item in
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.color)
                    .frame(width: 150, height: 100)
                    .overlay(
                        Text(item.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
            }
            
            Text("Snap List")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            SnapList(items: items, itemWidth: 280) { item, isActive in
                RoundedRectangle(cornerRadius: 16)
                    .fill(item.color)
                    .frame(height: 180)
                    .opacity(isActive ? 1 : 0.7)
                    .overlay(
                        Text(item.title)
                            .foregroundColor(.white)
                            .font(.title2.bold())
                    )
            }
            .frame(height: 180)
        }
        .padding(.vertical)
    }
}
