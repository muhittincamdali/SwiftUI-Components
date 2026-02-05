import SwiftUI

/// An accordion component for collapsible content
public struct Accordion<Content: View>: View {
    let items: [AccordionItem<Content>]
    let allowMultiple: Bool
    let style: AccordionStyle
    
    @State private var expandedItems: Set<UUID> = []
    
    public struct AccordionItem<ItemContent: View>: Identifiable {
        public let id = UUID()
        let title: String
        let subtitle: String?
        let icon: String?
        @ViewBuilder let content: () -> ItemContent
        
        public init(
            title: String,
            subtitle: String? = nil,
            icon: String? = nil,
            @ViewBuilder content: @escaping () -> ItemContent
        ) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.content = content
        }
    }
    
    public enum AccordionStyle {
        case standard
        case separated
        case bordered
    }
    
    public init(
        items: [AccordionItem<Content>],
        allowMultiple: Bool = false,
        style: AccordionStyle = .standard
    ) {
        self.items = items
        self.allowMultiple = allowMultiple
        self.style = style
    }
    
    public var body: some View {
        VStack(spacing: style == .separated ? 12 : 0) {
            ForEach(items) { item in
                accordionRow(item)
            }
        }
    }
    
    private func accordionRow(_ item: AccordionItem<Content>) -> some View {
        let isExpanded = expandedItems.contains(item.id)
        
        return VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    if isExpanded {
                        expandedItems.remove(item.id)
                    } else {
                        if !allowMultiple {
                            expandedItems.removeAll()
                        }
                        expandedItems.insert(item.id)
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    if let icon = item.icon {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(.accentColor)
                            .frame(width: 28)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        
                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(16)
                .background(headerBackground(for: style, isExpanded: isExpanded))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Content
            if isExpanded {
                item.content()
                    .padding(16)
                    .background(Color(.systemBackground))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Divider for standard style
            if style == .standard {
                Divider()
            }
        }
        .background(rowBackground(for: style))
        .clipShape(RoundedRectangle(cornerRadius: style == .standard ? 0 : 12))
        .overlay(
            style == .bordered ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 1)
            : nil
        )
    }
    
    @ViewBuilder
    private func headerBackground(for style: AccordionStyle, isExpanded: Bool) -> some View {
        switch style {
        case .standard:
            Color(.systemBackground)
        case .separated:
            Color(.systemGray6)
        case .bordered:
            Color(.systemBackground)
        }
    }
    
    @ViewBuilder
    private func rowBackground(for style: AccordionStyle) -> some View {
        switch style {
        case .standard:
            Color(.systemBackground)
        case .separated:
            Color(.systemBackground)
        case .bordered:
            Color(.systemBackground)
        }
    }
}

/// FAQ style accordion
public struct FAQAccordion: View {
    let items: [FAQItem]
    
    @State private var expandedIndex: Int? = nil
    
    public struct FAQItem: Identifiable {
        public let id = UUID()
        let question: String
        let answer: String
        
        public init(question: String, answer: String) {
            self.question = question
            self.answer = answer
        }
    }
    
    public init(items: [FAQItem]) {
        self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let isExpanded = expandedIndex == index
                
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            expandedIndex = isExpanded ? nil : index
                        }
                    } label: {
                        HStack {
                            Text(item.question)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: isExpanded ? "minus" : "plus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.accentColor)
                        }
                        .padding(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if isExpanded {
                        Text(item.answer)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .transition(.opacity)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
    }
}

#Preview("Accordion Components") {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Standard Accordion")
                    .font(.headline)
                    .padding(.horizontal)
                
                Accordion(
                    items: [
                        .init(title: "Section 1", subtitle: "Description", icon: "star.fill") {
                            Text("Content for section 1")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        },
                        .init(title: "Section 2", icon: "heart.fill") {
                            Text("Content for section 2")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        },
                        .init(title: "Section 3", icon: "bell.fill") {
                            Text("Content for section 3")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    ],
                    style: .standard
                )
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Separated Accordion")
                    .font(.headline)
                    .padding(.horizontal)
                
                Accordion(
                    items: [
                        .init(title: "Account", icon: "person.fill") {
                            Text("Account settings content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        },
                        .init(title: "Privacy", icon: "lock.fill") {
                            Text("Privacy settings content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        },
                        .init(title: "Notifications", icon: "bell.fill") {
                            Text("Notification settings content")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    ],
                    allowMultiple: true,
                    style: .separated
                )
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("FAQ Accordion")
                    .font(.headline)
                    .padding(.horizontal)
                
                FAQAccordion(items: [
                    .init(
                        question: "What is SwiftUI Components?",
                        answer: "SwiftUI Components is a comprehensive library of reusable UI components built with SwiftUI for iOS, macOS, and other Apple platforms."
                    ),
                    .init(
                        question: "How do I install it?",
                        answer: "You can install SwiftUI Components using Swift Package Manager. Simply add the package URL to your Xcode project."
                    ),
                    .init(
                        question: "Is it free to use?",
                        answer: "Yes! SwiftUI Components is open source and free to use under the MIT license."
                    )
                ])
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    .background(Color(.systemGray6))
}
