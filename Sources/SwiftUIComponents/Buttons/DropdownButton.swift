import SwiftUI

/// A button that reveals a dropdown menu
public struct DropdownButton<Content: View>: View {
    let title: String
    let icon: String?
    @ViewBuilder let content: () -> Content
    
    @State private var isExpanded = false
    
    public init(
        _ title: String,
        icon: String? = "chevron.down",
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    if let icon = icon {
                        Image(systemName: icon)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                content()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand")")
    }
}

/// Individual dropdown menu item
public struct DropdownItem: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    public init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .frame(width: 24)
                }
                Text(title)
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Dropdown Button") {
    VStack(spacing: 20) {
        DropdownButton("Select Option") {
            VStack(spacing: 4) {
                DropdownItem("Edit", icon: "pencil") {}
                DropdownItem("Share", icon: "square.and.arrow.up") {}
                DropdownItem("Delete", icon: "trash") {}
            }
        }
        
        DropdownButton("More Actions", icon: "ellipsis") {
            VStack(spacing: 4) {
                DropdownItem("Copy") {}
                DropdownItem("Move") {}
                DropdownItem("Archive") {}
            }
        }
    }
    .padding()
    .frame(width: 300)
}
