import SwiftUI

/// A tag/chip component
public struct Tag: View {
    let text: String
    let icon: String?
    let color: Color
    let style: TagStyle
    let size: TagSize
    let onRemove: (() -> Void)?
    
    public enum TagStyle {
        case filled
        case outlined
        case soft
    }
    
    public enum TagSize {
        case small
        case medium
        case large
        
        var font: Font {
            switch self {
            case .small: return .system(size: 11, weight: .medium)
            case .medium: return .system(size: 13, weight: .medium)
            case .large: return .system(size: 15, weight: .medium)
            }
        }
        
        var verticalPadding: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 8
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 14
            }
        }
    }
    
    public init(
        _ text: String,
        icon: String? = nil,
        color: Color = .accentColor,
        style: TagStyle = .filled,
        size: TagSize = .medium,
        onRemove: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.color = color
        self.style = style
        self.size = size
        self.onRemove = onRemove
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size == .small ? 10 : 12))
            }
            
            Text(text)
                .font(size.font)
            
            if let onRemove = onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: size == .small ? 8 : 10, weight: .bold))
                }
            }
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, size.horizontalPadding)
        .padding(.vertical, size.verticalPadding)
        .background(background)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined: return color
        case .soft: return color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled:
            Capsule().fill(color)
        case .outlined:
            Capsule().stroke(color, lineWidth: 1)
        case .soft:
            Capsule().fill(color.opacity(0.15))
        }
    }
}

/// A tag group with flow layout
public struct TagGroup: View {
    let tags: [String]
    let color: Color
    let style: Tag.TagStyle
    let onTagTap: ((String) -> Void)?
    let onRemove: ((String) -> Void)?
    
    public init(
        tags: [String],
        color: Color = .accentColor,
        style: Tag.TagStyle = .soft,
        onTagTap: ((String) -> Void)? = nil,
        onRemove: ((String) -> Void)? = nil
    ) {
        self.tags = tags
        self.color = color
        self.style = style
        self.onTagTap = onTagTap
        self.onRemove = onRemove
    }
    
    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Button {
                    onTagTap?(tag)
                } label: {
                    Tag(
                        tag,
                        color: color,
                        style: style,
                        onRemove: onRemove != nil ? { onRemove?(tag) } : nil
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

/// A selectable tag
public struct SelectableTag: View {
    let text: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    public init(
        _ text: String,
        isSelected: Bool,
        color: Color = .accentColor,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isSelected = isSelected
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                }
                Text(text)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? color : color.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isSelected)
    }
}

/// A status tag/badge
public struct StatusTag: View {
    let text: String
    let status: Status
    let showDot: Bool
    
    public enum Status {
        case active
        case pending
        case completed
        case failed
        case draft
        case archived
        
        var color: Color {
            switch self {
            case .active: return .green
            case .pending: return .orange
            case .completed: return .blue
            case .failed: return .red
            case .draft: return .gray
            case .archived: return .purple
            }
        }
    }
    
    public init(_ text: String, status: Status, showDot: Bool = true) {
        self.text = text
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
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(status.color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(status.color.opacity(0.15))
        .cornerRadius(6)
    }
}

#Preview("Tags") {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Tag Styles")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Tag("Filled", style: .filled)
                    Tag("Outlined", style: .outlined)
                    Tag("Soft", style: .soft)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tag Sizes")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Tag("Small", size: .small)
                    Tag("Medium", size: .medium)
                    Tag("Large", size: .large)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("With Icon & Remove")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Tag("Swift", icon: "swift", color: .orange, style: .soft)
                    Tag("SwiftUI", color: .blue, style: .soft, onRemove: {})
                    Tag("iOS", icon: "apple.logo", color: .purple, style: .filled)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tag Group")
                    .font(.headline)
                
                TagGroup(
                    tags: ["Swift", "SwiftUI", "Combine", "UIKit", "iOS", "macOS"],
                    color: .blue,
                    onRemove: { _ in }
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Selectable Tags")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    SelectableTag("Option 1", isSelected: true, action: {})
                    SelectableTag("Option 2", isSelected: false, action: {})
                    SelectableTag("Option 3", isSelected: false, action: {})
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Status Tags")
                    .font(.headline)
                
                HStack(spacing: 8) {
                    StatusTag("Active", status: .active)
                    StatusTag("Pending", status: .pending)
                    StatusTag("Completed", status: .completed)
                    StatusTag("Failed", status: .failed)
                }
            }
        }
        .padding()
    }
}
