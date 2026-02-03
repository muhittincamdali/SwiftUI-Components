import SwiftUI

/// A list with expandable/collapsible sections.
///
/// `ExpandableList` provides animated expand/collapse functionality
/// for hierarchical data display.
///
/// ```swift
/// ExpandableList(sections: sections) { section in
///     Text(section.title)
/// } content: { item in
///     Text(item.name)
/// }
/// ```
public struct ExpandableList<Section: Identifiable, Item: Identifiable, Header: View, Row: View>: View {
    // MARK: - Types
    
    /// A section with items.
    public struct ListSection: Identifiable {
        public let id: Section.ID
        public let section: Section
        public var items: [Item]
        public var isExpanded: Bool
        
        public init(section: Section, items: [Item], isExpanded: Bool = true) {
            self.id = section.id
            self.section = section
            self.items = items
            self.isExpanded = isExpanded
        }
    }
    
    // MARK: - Properties
    
    @Binding private var sections: [ListSection]
    private let headerContent: (Section, Bool) -> Header
    private let rowContent: (Item) -> Row
    private let headerHeight: CGFloat
    private let rowHeight: CGFloat
    private let animationDuration: Double
    
    // MARK: - Initialization
    
    /// Creates a new expandable list.
    public init(
        sections: Binding<[ListSection]>,
        headerHeight: CGFloat = 50,
        rowHeight: CGFloat = 44,
        animationDuration: Double = 0.3,
        @ViewBuilder header: @escaping (Section, Bool) -> Header,
        @ViewBuilder content: @escaping (Item) -> Row
    ) {
        self._sections = sections
        self.headerHeight = headerHeight
        self.rowHeight = rowHeight
        self.animationDuration = animationDuration
        self.headerContent = header
        self.rowContent = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                VStack(spacing: 0) {
                    // Header
                    Button {
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            sections[index].isExpanded.toggle()
                        }
                    } label: {
                        headerContent(section.section, section.isExpanded)
                            .frame(height: headerHeight)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    
                    // Items
                    if section.isExpanded {
                        ForEach(section.items) { item in
                            rowContent(item)
                                .frame(height: rowHeight)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .top)),
                                    removal: .opacity.combined(with: .move(edge: .top))
                                ))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Simple Expandable Section

/// A standalone expandable section.
public struct ExpandableSection<Header: View, Content: View>: View {
    @Binding private var isExpanded: Bool
    private let header: () -> Header
    private let content: () -> Content
    private let animation: Animation
    
    public init(
        isExpanded: Binding<Bool>,
        animation: Animation = .easeInOut(duration: 0.3),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isExpanded = isExpanded
        self.animation = animation
        self.header = header
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(animation) {
                    isExpanded.toggle()
                }
            } label: {
                header()
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipped()
    }
}

// MARK: - Accordion List

/// An accordion-style list where only one section can be expanded.
public struct AccordionList<Section: Identifiable, Header: View, Content: View>: View {
    private let sections: [Section]
    private let headerContent: (Section, Bool) -> Header
    private let sectionContent: (Section) -> Content
    
    @State private var expandedSection: Section.ID?
    
    public init(
        sections: [Section],
        @ViewBuilder header: @escaping (Section, Bool) -> Header,
        @ViewBuilder content: @escaping (Section) -> Content
    ) {
        self.sections = sections
        self.headerContent = header
        self.sectionContent = content
    }
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(sections) { section in
                let isExpanded = expandedSection == section.id
                
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if expandedSection == section.id {
                                expandedSection = nil
                            } else {
                                expandedSection = section.id
                            }
                        }
                    } label: {
                        headerContent(section, isExpanded)
                    }
                    .buttonStyle(.plain)
                    
                    if isExpanded {
                        sectionContent(section)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
        }
    }
}

// MARK: - FAQ List

/// A pre-styled FAQ list with expandable questions.
public struct FAQList: View {
    public struct FAQItem: Identifiable {
        public let id = UUID()
        public let question: String
        public let answer: String
        
        public init(question: String, answer: String) {
            self.question = question
            self.answer = answer
        }
    }
    
    private let items: [FAQItem]
    private let questionFont: Font
    private let answerFont: Font
    
    @State private var expandedItem: UUID?
    
    public init(
        items: [FAQItem],
        questionFont: Font = .headline,
        answerFont: Font = .body
    ) {
        self.items = items
        self.questionFont = questionFont
        self.answerFont = answerFont
    }
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items) { item in
                VStack(spacing: 0) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            if expandedItem == item.id {
                                expandedItem = nil
                            } else {
                                expandedItem = item.id
                            }
                        }
                    } label: {
                        HStack {
                            Text(item.question)
                                .font(questionFont)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                                .rotationEffect(.degrees(expandedItem == item.id ? 180 : 0))
                        }
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    if expandedItem == item.id {
                        Text(item.answer)
                            .font(answerFont)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 16)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    Divider()
                }
            }
        }
    }
}

// MARK: - Tree View

/// A hierarchical tree view with expandable nodes.
public struct TreeView<Node: Identifiable, Label: View>: View where Node: Hashable {
    public struct TreeNode: Identifiable {
        public var id: Node.ID { node.id }
        public let node: Node
        public var children: [TreeNode]
        
        public init(node: Node, children: [TreeNode] = []) {
            self.node = node
            self.children = children
        }
        
        var hasChildren: Bool { !children.isEmpty }
    }
    
    private let roots: [TreeNode]
    private let label: (Node, Bool, Int) -> Label
    private let indentation: CGFloat
    
    @State private var expandedNodes: Set<Node.ID> = []
    
    public init(
        roots: [TreeNode],
        indentation: CGFloat = 20,
        @ViewBuilder label: @escaping (Node, Bool, Int) -> Label
    ) {
        self.roots = roots
        self.indentation = indentation
        self.label = label
    }
    
    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(roots) { root in
                nodeView(root, level: 0)
            }
        }
    }
    
    @ViewBuilder
    private func nodeView(_ treeNode: TreeNode, level: Int) -> some View {
        let isExpanded = expandedNodes.contains(treeNode.id)
        
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if expandedNodes.contains(treeNode.id) {
                        expandedNodes.remove(treeNode.id)
                    } else {
                        expandedNodes.insert(treeNode.id)
                    }
                }
            } label: {
                HStack {
                    label(treeNode.node, isExpanded, level)
                    Spacer()
                }
                .padding(.leading, CGFloat(level) * indentation)
            }
            .buttonStyle(.plain)
            .disabled(!treeNode.hasChildren)
            
            if isExpanded {
                ForEach(treeNode.children) { child in
                    nodeView(child, level: level + 1)
                }
            }
        }
    }
}

#if DEBUG
struct ExpandableListPreview: View {
    @State private var isExpanded = true
    @State private var faqItems: [FAQList.FAQItem] = [
        .init(question: "What is SwiftUI?", answer: "SwiftUI is Apple's modern declarative UI framework."),
        .init(question: "How do I get started?", answer: "Start by importing SwiftUI and creating your first View."),
        .init(question: "Is SwiftUI production ready?", answer: "Yes, SwiftUI is mature and used in many production apps.")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ExpandableSection(isExpanded: $isExpanded) {
                    HStack {
                        Text("Settings")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    .padding()
                    .background(Color(.systemGray6))
                } content: {
                    VStack(spacing: 0) {
                        ForEach(0..<3) { i in
                            Text("Option \(i + 1)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            Divider()
                        }
                    }
                }
                
                Divider()
                
                FAQList(items: faqItems)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ExpandableListPreview()
}
#endif
