import SwiftUI

/// A dropdown select field
public struct SelectField<T: Hashable>: View {
    @Binding var selection: T?
    let options: [(value: T, label: String)]
    let placeholder: String
    let icon: String?
    @State private var isExpanded = false
    
    public init(
        selection: Binding<T?>,
        options: [(value: T, label: String)],
        placeholder: String = "Select an option",
        icon: String? = nil
    ) {
        self._selection = selection
        self.options = options
        self.placeholder = placeholder
        self.icon = icon
    }
    
    private var selectedLabel: String {
        if let selection = selection {
            return options.first { $0.value == selection }?.label ?? placeholder
        }
        return placeholder
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(selectedLabel)
                        .font(.system(size: 16))
                        .foregroundColor(selection == nil ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isExpanded ? Color.accentColor : Color(.systemGray4), lineWidth: isExpanded ? 2 : 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options.indices, id: \.self) { index in
                        let option = options[index]
                        Button {
                            selection = option.value
                            withAnimation {
                                isExpanded = false
                            }
                        } label: {
                            HStack {
                                Text(option.label)
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selection == option.value {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(selection == option.value ? Color.accentColor.opacity(0.1) : Color.clear)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if index < options.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

/// A multi-select field with chips
public struct MultiSelectField<T: Hashable>: View {
    @Binding var selections: Set<T>
    let options: [(value: T, label: String)]
    let placeholder: String
    @State private var isExpanded = false
    
    public init(
        selections: Binding<Set<T>>,
        options: [(value: T, label: String)],
        placeholder: String = "Select options"
    ) {
        self._selections = selections
        self.options = options
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Selected chips
            if !selections.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(options.filter { selections.contains($0.value) }, id: \.value) { option in
                        HStack(spacing: 4) {
                            Text(option.label)
                                .font(.system(size: 13))
                            
                            Button {
                                selections.remove(option.value)
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10, weight: .bold))
                            }
                        }
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(16)
                    }
                }
            }
            
            // Dropdown trigger
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(selections.isEmpty ? placeholder : "Add more...")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Options list
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.value) { option in
                        Button {
                            if selections.contains(option.value) {
                                selections.remove(option.value)
                            } else {
                                selections.insert(option.value)
                            }
                        } label: {
                            HStack {
                                Image(systemName: selections.contains(option.value) ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 18))
                                    .foregroundColor(selections.contains(option.value) ? .accentColor : .secondary)
                                
                                Text(option.label)
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
}

/// Simple flow layout for chips
struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        
        return (CGSize(width: maxWidth, height: currentY + lineHeight), positions)
    }
}

#Preview("Select Fields") {
    struct PreviewWrapper: View {
        @State private var selectedCountry: String? = nil
        @State private var selectedTags: Set<String> = []
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    FormField(label: "Country", isRequired: true) {
                        SelectField(
                            selection: $selectedCountry,
                            options: [
                                ("us", "United States"),
                                ("uk", "United Kingdom"),
                                ("ca", "Canada"),
                                ("au", "Australia"),
                                ("de", "Germany")
                            ],
                            placeholder: "Select country",
                            icon: "globe"
                        )
                    }
                    
                    FormField(label: "Tags") {
                        MultiSelectField(
                            selections: $selectedTags,
                            options: [
                                ("swift", "Swift"),
                                ("swiftui", "SwiftUI"),
                                ("ios", "iOS"),
                                ("macos", "macOS"),
                                ("watchos", "watchOS")
                            ],
                            placeholder: "Select tags"
                        )
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
