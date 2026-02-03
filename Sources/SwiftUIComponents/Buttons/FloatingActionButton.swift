import SwiftUI

/// A Material Design-inspired floating action button with expansion support.
///
/// `FloatingActionButton` provides a prominent circular button that can expand
/// to reveal additional actions.
///
/// ```swift
/// FloatingActionButton(icon: Image(systemName: "plus")) {
///     createNewItem()
/// }
/// ```
public struct FloatingActionButton: View {
    // MARK: - Types
    
    /// The size of the FAB.
    public enum Size {
        case mini
        case regular
        case extended
        
        var dimension: CGFloat {
            switch self {
            case .mini: return 40
            case .regular: return 56
            case .extended: return 48
            }
        }
        
        var iconScale: CGFloat {
            switch self {
            case .mini: return 0.8
            case .regular: return 1.0
            case .extended: return 0.9
            }
        }
    }
    
    /// An action item for expandable FAB.
    public struct ActionItem: Identifiable {
        public let id = UUID()
        public let icon: Image
        public let label: String?
        public let color: Color
        public let action: () -> Void
        
        public init(
            icon: Image,
            label: String? = nil,
            color: Color = .blue,
            action: @escaping () -> Void
        ) {
            self.icon = icon
            self.label = label
            self.color = color
            self.action = action
        }
    }
    
    // MARK: - Properties
    
    private let icon: Image
    private let expandedIcon: Image?
    private let label: String?
    private let size: Size
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let shadowRadius: CGFloat
    private let actions: [ActionItem]
    private let action: (() -> Void)?
    
    @State private var isExpanded: Bool = false
    @State private var rotation: Angle = .zero
    
    // MARK: - Initialization
    
    /// Creates a simple floating action button.
    /// - Parameters:
    ///   - icon: The icon to display.
    ///   - label: Optional label for extended FAB. Defaults to `nil`.
    ///   - size: The FAB size. Defaults to `.regular`.
    ///   - backgroundColor: Background color. Defaults to `.blue`.
    ///   - foregroundColor: Icon and text color. Defaults to `.white`.
    ///   - shadowRadius: Shadow blur radius. Defaults to `8`.
    ///   - action: The action to perform.
    public init(
        icon: Image,
        label: String? = nil,
        size: Size = .regular,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        shadowRadius: CGFloat = 8,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.expandedIcon = nil
        self.label = label
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.shadowRadius = shadowRadius
        self.actions = []
        self.action = action
    }
    
    /// Creates an expandable floating action button with sub-actions.
    /// - Parameters:
    ///   - icon: The default icon.
    ///   - expandedIcon: Icon shown when expanded. Defaults to `nil`.
    ///   - size: The FAB size. Defaults to `.regular`.
    ///   - backgroundColor: Background color. Defaults to `.blue`.
    ///   - foregroundColor: Icon color. Defaults to `.white`.
    ///   - shadowRadius: Shadow blur radius. Defaults to `8`.
    ///   - actions: Array of sub-actions.
    public init(
        icon: Image,
        expandedIcon: Image? = nil,
        size: Size = .regular,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        shadowRadius: CGFloat = 8,
        actions: [ActionItem]
    ) {
        self.icon = icon
        self.expandedIcon = expandedIcon
        self.label = nil
        self.size = size
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.shadowRadius = shadowRadius
        self.actions = actions
        self.action = nil
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if !actions.isEmpty {
                expandableContent
            }
            
            mainButton
        }
    }
    
    // MARK: - Main Button
    
    private var mainButton: some View {
        Button {
            if actions.isEmpty {
                action?()
            } else {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                    rotation = isExpanded ? .degrees(45) : .zero
                }
            }
        } label: {
            HStack(spacing: 8) {
                Group {
                    if isExpanded, let expandedIcon {
                        expandedIcon
                    } else {
                        icon
                    }
                }
                .imageScale(size == .mini ? .small : .large)
                .scaleEffect(size.iconScale)
                .rotationEffect(actions.isEmpty ? .zero : rotation)
                
                if let label, size == .extended {
                    Text(label)
                        .font(.headline)
                        .fontWeight(.medium)
                }
            }
            .foregroundStyle(foregroundColor)
            .frame(width: size == .extended ? nil : size.dimension, height: size.dimension)
            .padding(.horizontal, size == .extended ? 20 : 0)
            .background(backgroundColor)
            .clipShape(size == .extended ? AnyShape(Capsule()) : AnyShape(Circle()))
            .shadow(color: backgroundColor.opacity(0.4), radius: shadowRadius, x: 0, y: 4)
        }
        .buttonStyle(FABButtonStyle())
    }
    
    // MARK: - Expandable Content
    
    @ViewBuilder
    private var expandableContent: some View {
        if isExpanded {
            // Backdrop
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        isExpanded = false
                        rotation = .zero
                    }
                }
                .transition(.opacity)
        }
        
        VStack(spacing: 12) {
            ForEach(Array(actions.enumerated()), id: \.element.id) { index, item in
                if isExpanded {
                    actionButton(for: item, index: index)
                        .transition(
                            .asymmetric(
                                insertion: .scale.combined(with: .opacity).animation(
                                    .spring(response: 0.35, dampingFraction: 0.7)
                                    .delay(Double(actions.count - index - 1) * 0.05)
                                ),
                                removal: .scale.combined(with: .opacity).animation(
                                    .spring(response: 0.25, dampingFraction: 0.9)
                                    .delay(Double(index) * 0.03)
                                )
                            )
                        )
                }
            }
        }
        .padding(.bottom, size.dimension + 16)
    }
    
    // MARK: - Action Button
    
    private func actionButton(for item: ActionItem, index: Int) -> some View {
        HStack(spacing: 12) {
            if let label = item.label {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                    )
            }
            
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded = false
                    rotation = .zero
                }
                item.action()
            } label: {
                item.icon
                    .imageScale(.medium)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(item.color)
                    .clipShape(Circle())
                    .shadow(color: item.color.opacity(0.4), radius: 4, y: 2)
            }
            .buttonStyle(FABButtonStyle())
        }
    }
}

// MARK: - Button Style

private struct FABButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - AnyShape Helper

private struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = { rect in shape.path(in: rect) }
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - View Modifier

/// Positions a FAB at the bottom trailing corner.
public struct FABModifier<FABContent: View>: ViewModifier {
    let fab: FABContent
    let padding: CGFloat
    
    public init(@ViewBuilder fab: () -> FABContent, padding: CGFloat = 16) {
        self.fab = fab()
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            fab.padding(padding)
        }
    }
}

extension View {
    /// Adds a floating action button to the view.
    public func floatingActionButton<FAB: View>(
        padding: CGFloat = 16,
        @ViewBuilder fab: () -> FAB
    ) -> some View {
        modifier(FABModifier(fab: fab, padding: padding))
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            
            HStack {
                // Simple FAB
                FloatingActionButton(
                    icon: Image(systemName: "plus"),
                    size: .mini,
                    backgroundColor: .green
                ) { }
                
                // Extended FAB
                FloatingActionButton(
                    icon: Image(systemName: "pencil"),
                    label: "Compose",
                    size: .extended
                ) { }
                
                Spacer()
            }
            .padding()
            
            // Expandable FAB
            FloatingActionButton(
                icon: Image(systemName: "plus"),
                expandedIcon: Image(systemName: "xmark"),
                actions: [
                    .init(icon: Image(systemName: "camera.fill"), label: "Camera", color: .purple) { },
                    .init(icon: Image(systemName: "photo.fill"), label: "Gallery", color: .orange) { },
                    .init(icon: Image(systemName: "doc.fill"), label: "File", color: .green) { }
                ]
            )
            .padding()
        }
    }
}
#endif
