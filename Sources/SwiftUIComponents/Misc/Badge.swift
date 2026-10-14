import SwiftUI

/// A versatile badge component for labels and notifications.
///
/// `Badge` displays status indicators, counts, or labels
/// with customizable styling.
///
/// ```swift
/// Badge("New", style: .filled, color: .blue)
/// Badge(count: 5, style: .notification)
/// ```
public struct Badge: View {
    // MARK: - Types
    
    /// The visual style of the badge.
    public enum Style {
        case filled
        case outlined
        case subtle
        case notification
        case dot
    }
    
    /// The size of the badge.
    public enum Size {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small: return .system(size: 10, weight: .semibold)
            case .medium: return .system(size: 12, weight: .semibold)
            case .large: return .system(size: 14, weight: .semibold)
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            case .medium: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .large: return EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
            }
        }
        
        var dotSize: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 10
            }
        }
    }
    
    // MARK: - Properties
    
    private let text: String?
    private let count: Int?
    private let maxCount: Int
    private let style: Style
    private let size: Size
    private let color: Color
    private let icon: Image?
    
    // MARK: - Initialization
    
    /// Creates a text badge.
    public init(
        _ text: String,
        style: Style = .filled,
        size: Size = .medium,
        color: Color = .blue,
        icon: Image? = nil
    ) {
        self.text = text
        self.count = nil
        self.maxCount = 99
        self.style = style
        self.size = size
        self.color = color
        self.icon = icon
    }
    
    /// Creates a count badge.
    public init(
        count: Int,
        maxCount: Int = 99,
        style: Style = .notification,
        size: Size = .medium,
        color: Color = .red
    ) {
        self.text = nil
        self.count = count
        self.maxCount = maxCount
        self.style = style
        self.size = size
        self.color = color
        self.icon = nil
    }
    
    /// Creates a dot badge.
    public init(
        dot color: Color = .red,
        size: Size = .medium
    ) {
        self.text = nil
        self.count = nil
        self.maxCount = 99
        self.style = .dot
        self.size = size
        self.color = color
        self.icon = nil
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch style {
            case .dot:
                dotBadge
            default:
                contentBadge
            }
        }
    }
    
    // MARK: - Dot Badge
    
    private var dotBadge: some View {
        Circle()
            .fill(color)
            .frame(width: size.dotSize, height: size.dotSize)
    }
    
    // MARK: - Content Badge
    
    private var contentBadge: some View {
        HStack(spacing: 4) {
            if let icon {
                icon
                    .font(size.font)
            }
            
            if let displayText {
                Text(displayText)
                    .font(size.font)
            }
        }
        .foregroundStyle(foregroundColor)
        .padding(size.padding)
        .background(background)
        .clipShape(clipShape)
        .overlay(borderOverlay)
    }
    
    // MARK: - Display Text
    
    private var displayText: String? {
        if let text {
            return text
        } else if let count, count > 0 {
            return count > maxCount ? "\(maxCount)+" : "\(count)"
        }
        return nil
    }
    
    // MARK: - Styling
    
    private var foregroundColor: Color {
        switch style {
        case .filled, .notification:
            return .white
        case .outlined, .subtle:
            return color
        case .dot:
            return .clear
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled, .notification:
            color
        case .subtle:
            color.opacity(0.15)
        case .outlined, .dot:
            Color.clear
        }
    }
    
    private var clipShape: some Shape {
        if style == .notification || (count != nil && text == nil) {
            return AnyShape(Capsule())
        }
        return AnyShape(RoundedRectangle(cornerRadius: 6))
    }
    
    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            clipShape
                .stroke(color, lineWidth: 1.5)
        }
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

// MARK: - Badge Modifier

/// A modifier that adds a badge to any view.
public struct BadgeModifier: ViewModifier {
    let badge: Badge
    let alignment: Alignment
    let offset: CGSize
    
    public func body(content: Content) -> some View {
        content.overlay(alignment: alignment) {
            badge
                .offset(offset)
        }
    }
}

extension View {
    /// Adds a badge to the view.
    public func badge(
        _ text: String,
        style: Badge.Style = .filled,
        color: Color = .blue,
        alignment: Alignment = .topTrailing,
        offset: CGSize = CGSize(width: 8, height: -8)
    ) -> some View {
        modifier(BadgeModifier(
            badge: Badge(text, style: style, color: color),
            alignment: alignment,
            offset: offset
        ))
    }
    
    /// Adds a count badge to the view.
    public func badge(
        count: Int,
        color: Color = .red,
        alignment: Alignment = .topTrailing,
        offset: CGSize = CGSize(width: 8, height: -8)
    ) -> some View {
        modifier(BadgeModifier(
            badge: Badge(count: count, color: color),
            alignment: alignment,
            offset: offset
        ))
    }
    
    /// Adds a dot badge to the view.
    public func dotBadge(
        color: Color = .red,
        alignment: Alignment = .topTrailing,
        offset: CGSize = CGSize(width: 4, height: -4)
    ) -> some View {
        modifier(BadgeModifier(
            badge: Badge(dot: color),
            alignment: alignment,
            offset: offset
        ))
    }
}

// MARK: - Status Badge

/// A pre-styled badge for displaying status.
public struct StatusBadge: View {
    public enum Status {
        case active
        case inactive
        case pending
        case error
        case success
        case warning
        
        var color: Color {
            switch self {
            case .active, .success: return .green
            case .inactive: return .gray
            case .pending, .warning: return .orange
            case .error: return .red
            }
        }
        
        var label: String {
            switch self {
            case .active: return "Active"
            case .inactive: return "Inactive"
            case .pending: return "Pending"
            case .error: return "Error"
            case .success: return "Success"
            case .warning: return "Warning"
            }
        }
    }
    
    private let status: Status
    private let showDot: Bool
    
    public init(_ status: Status, showDot: Bool = true) {
        self.status = status
        self.showDot = showDot
    }
    
    public var body: some View {
        HStack(spacing: 6) {
            if showDot {
                Circle()
                    .fill(status.color)
                    .frame(width: 6, height: 6)
            }
            
            Text(status.label)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(status.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(status.color.opacity(0.1))
        .clipShape(Capsule())
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            Badge("New", style: .filled)
            Badge("Sale", style: .outlined, color: .green)
            Badge("Hot", style: .subtle, color: .orange)
        }
        
        HStack(spacing: 12) {
            Badge(count: 5)
            Badge(count: 99)
            Badge(count: 150, maxCount: 99)
        }
        
        HStack(spacing: 20) {
            Image(systemName: "bell")
                .font(.title2)
                .badge(count: 3)
            
            Image(systemName: "envelope")
                .font(.title2)
                .dotBadge()
            
            Image(systemName: "cart")
                .font(.title2)
                .badge("2", color: .green)
        }
        
        HStack(spacing: 12) {
            StatusBadge(.active)
            StatusBadge(.pending)
            StatusBadge(.error)
        }
    }
    .padding()
}
#endif
