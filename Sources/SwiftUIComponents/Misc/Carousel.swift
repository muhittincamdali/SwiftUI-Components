import SwiftUI

/// A horizontal carousel view
public struct Carousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let showIndicators: Bool
    let autoScroll: Bool
    let autoScrollInterval: TimeInterval
    @ViewBuilder let content: (Item) -> Content
    
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var timer: Timer?
    
    public init(
        items: [Item],
        spacing: CGFloat = 16,
        showIndicators: Bool = true,
        autoScroll: Bool = false,
        autoScrollInterval: TimeInterval = 3.0,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.showIndicators = showIndicators
        self.autoScroll = autoScroll
        self.autoScrollInterval = autoScrollInterval
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                let cardWidth = geometry.size.width - 60
                
                HStack(spacing: spacing) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        content(item)
                            .frame(width: cardWidth)
                            .scaleEffect(index == currentIndex ? 1.0 : 0.9)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
                    }
                }
                .padding(.horizontal, 30)
                .offset(x: -CGFloat(currentIndex) * (cardWidth + spacing) + offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold = cardWidth / 3
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if value.translation.width < -threshold && currentIndex < items.count - 1 {
                                    currentIndex += 1
                                } else if value.translation.width > threshold && currentIndex > 0 {
                                    currentIndex -= 1
                                }
                                offset = 0
                            }
                        }
                )
            }
            
            // Page indicators
            if showIndicators {
                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.accentColor : Color(.systemGray4))
                            .frame(width: index == currentIndex ? 10 : 8, height: index == currentIndex ? 10 : 8)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
            }
        }
        .onAppear {
            if autoScroll {
                startAutoScroll()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
}

/// A card carousel with peek effect
public struct PeekCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let peekAmount: CGFloat
    @ViewBuilder let content: (Item, Bool) -> Content
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    public init(
        items: [Item],
        peekAmount: CGFloat = 40,
        @ViewBuilder content: @escaping (Item, Bool) -> Content
    ) {
        self.items = items
        self.peekAmount = peekAmount
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width - peekAmount * 2
            
            HStack(spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item, index == currentIndex)
                        .frame(width: cardWidth)
                }
            }
            .padding(.horizontal, peekAmount)
            .offset(x: -CGFloat(currentIndex) * (cardWidth + 12) + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = cardWidth / 4
                        
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

/// A vertical snap carousel
public struct SnapCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let itemHeight: CGFloat
    @ViewBuilder let content: (Item, Bool) -> Content
    
    @State private var currentIndex = 0
    
    public init(
        items: [Item],
        itemHeight: CGFloat = 300,
        @ViewBuilder content: @escaping (Item, Bool) -> Content
    ) {
        self.items = items
        self.itemHeight = itemHeight
        self.content = content
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    GeometryReader { geo in
                        let minY = geo.frame(in: .global).minY
                        let isVisible = minY > 100 && minY < UIScreen.main.bounds.height - 200
                        
                        content(item, isVisible)
                            .frame(height: itemHeight)
                            .scaleEffect(isVisible ? 1.0 : 0.95)
                            .opacity(isVisible ? 1.0 : 0.8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isVisible)
                    }
                    .frame(height: itemHeight)
                }
            }
            .padding(.vertical, 20)
        }
    }
}

/// A 3D card carousel
public struct Card3DCarousel<Item: Identifiable, Content: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    
    public init(
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let offset = CGFloat(index - currentIndex)
                    let scale = 1.0 - abs(offset) * 0.15
                    let xOffset = offset * 60 + dragOffset / 3
                    let rotation = -offset * 5 - Double(dragOffset) / 50
                    
                    content(item)
                        .frame(width: geometry.size.width * 0.7)
                        .scaleEffect(max(scale, 0.7))
                        .offset(x: xOffset)
                        .rotation3DEffect(
                            .degrees(rotation),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.5
                        )
                        .zIndex(Double(-abs(index - currentIndex)))
                        .opacity(abs(offset) > 2 ? 0 : 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
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

#Preview("Carousel Components") {
    struct CarouselItem: Identifiable {
        let id = UUID()
        let color: Color
        let title: String
    }
    
    let items = [
        CarouselItem(color: .blue, title: "Card 1"),
        CarouselItem(color: .green, title: "Card 2"),
        CarouselItem(color: .orange, title: "Card 3"),
        CarouselItem(color: .purple, title: "Card 4"),
        CarouselItem(color: .pink, title: "Card 5")
    ]
    
    return ScrollView {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Basic Carousel")
                    .font(.headline)
                    .padding(.horizontal)
                
                Carousel(items: items, autoScroll: true) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(item.color)
                        .overlay(
                            Text(item.title)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Peek Carousel")
                    .font(.headline)
                    .padding(.horizontal)
                
                PeekCarousel(items: items) { item, isActive in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(item.color)
                        .opacity(isActive ? 1 : 0.7)
                        .overlay(
                            Text(item.title)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("3D Carousel")
                    .font(.headline)
                    .padding(.horizontal)
                
                Card3DCarousel(items: items) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(item.color)
                        .shadow(radius: 10)
                        .overlay(
                            Text(item.title)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 300)
            }
        }
        .padding(.vertical)
    }
}
