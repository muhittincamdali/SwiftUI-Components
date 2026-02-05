import SwiftUI

/// A custom popover view
public struct PopoverView<Content: View>: View {
    let arrowDirection: ArrowDirection
    let backgroundColor: Color
    @ViewBuilder let content: () -> Content
    
    public enum ArrowDirection {
        case up
        case down
        case left
        case right
    }
    
    public init(
        arrowDirection: ArrowDirection = .up,
        backgroundColor: Color = Color(.systemBackground),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.arrowDirection = arrowDirection
        self.backgroundColor = backgroundColor
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if arrowDirection == .up {
                arrow
            }
            
            HStack(spacing: 0) {
                if arrowDirection == .left {
                    horizontalArrow
                }
                
                content()
                    .padding(16)
                    .background(backgroundColor)
                    .cornerRadius(12)
                
                if arrowDirection == .right {
                    horizontalArrow
                }
            }
            
            if arrowDirection == .down {
                arrow
            }
        }
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
    
    private var arrow: some View {
        Triangle()
            .fill(backgroundColor)
            .frame(width: 16, height: 8)
            .rotationEffect(.degrees(arrowDirection == .down ? 180 : 0))
    }
    
    private var horizontalArrow: some View {
        Triangle()
            .fill(backgroundColor)
            .frame(width: 8, height: 16)
            .rotationEffect(.degrees(arrowDirection == .left ? -90 : 90))
    }
}

struct PopoverTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// A menu popover
public struct MenuPopover: View {
    let items: [MenuItem]
    
    public struct MenuItem: Identifiable {
        public let id = UUID()
        let title: String
        let icon: String?
        let isDestructive: Bool
        let action: () -> Void
        
        public init(title: String, icon: String? = nil, isDestructive: Bool = false, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.isDestructive = isDestructive
            self.action = action
        }
    }
    
    public init(items: [MenuItem]) {
        self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button(action: item.action) {
                    HStack(spacing: 12) {
                        if let icon = item.icon {
                            Image(systemName: icon)
                                .font(.system(size: 16))
                                .frame(width: 24)
                        }
                        
                        Text(item.title)
                            .font(.system(size: 15))
                        
                        Spacer()
                    }
                    .foregroundColor(item.isDestructive ? .red : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                if item.id != items.last?.id {
                    Divider()
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        .frame(minWidth: 180)
    }
}

/// Action sheet style popover
public struct ActionSheetPopover: View {
    let title: String?
    let message: String?
    let actions: [SheetAction]
    let cancelAction: (() -> Void)?
    
    public struct SheetAction: Identifiable {
        public let id = UUID()
        let title: String
        let style: ActionStyle
        let action: () -> Void
        
        public enum ActionStyle {
            case normal
            case destructive
            case cancel
        }
        
        public init(_ title: String, style: ActionStyle = .normal, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
    
    public init(
        title: String? = nil,
        message: String? = nil,
        actions: [SheetAction],
        cancelAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            // Main actions
            VStack(spacing: 0) {
                if title != nil || message != nil {
                    VStack(spacing: 4) {
                        if let title = title {
                            Text(title)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        
                        if let message = message {
                            Text(message)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 16)
                    
                    Divider()
                }
                
                ForEach(actions.filter { $0.style != .cancel }) { action in
                    Button(action: action.action) {
                        Text(action.title)
                            .font(.system(size: 17, weight: action.style == .destructive ? .regular : .regular))
                            .foregroundColor(action.style == .destructive ? .red : .accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if action.id != actions.filter({ $0.style != .cancel }).last?.id {
                        Divider()
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(14)
            
            // Cancel button
            if let cancel = actions.first(where: { $0.style == .cancel }) {
                Button(action: cancel.action) {
                    Text(cancel.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
            } else if cancelAction != nil {
                Button(action: { cancelAction?() }) {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(14)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview("Popover Components") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 32) {
            PopoverView(arrowDirection: .up) {
                Text("Hello, this is a popover!")
                    .font(.system(size: 14))
            }
            
            MenuPopover(items: [
                .init(title: "Edit", icon: "pencil") {},
                .init(title: "Share", icon: "square.and.arrow.up") {},
                .init(title: "Delete", icon: "trash", isDestructive: true) {}
            ])
            
            ActionSheetPopover(
                title: "Choose Action",
                message: "Select an option below",
                actions: [
                    .init("Save to Photos") {},
                    .init("Share") {},
                    .init("Delete", style: .destructive) {},
                    .init("Cancel", style: .cancel) {}
                ]
            )
        }
        .padding()
    }
}
