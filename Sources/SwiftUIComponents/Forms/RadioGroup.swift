import SwiftUI

/// A single radio button
public struct RadioButton: View {
    let isSelected: Bool
    let label: String?
    let action: () -> Void
    
    public init(isSelected: Bool, label: String? = nil, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.label = label
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accentColor : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 12, height: 12)
                            .transition(.scale)
                    }
                }
                
                if let label = label {
                    Text(label)
                        .font(.system(size: 15))
                        .foregroundColor(.primary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isSelected)
        .accessibilityLabel(label ?? "Radio button")
        .accessibilityValue(isSelected ? "selected" : "not selected")
        .accessibilityAddTraits(.isButton)
    }
}

/// A group of radio buttons
public struct RadioGroup<T: Hashable>: View {
    @Binding var selection: T
    let options: [(value: T, label: String)]
    let style: RadioGroupStyle
    
    public enum RadioGroupStyle {
        case vertical
        case horizontal
        case segmented
        case cards
    }
    
    public init(
        selection: Binding<T>,
        options: [(value: T, label: String)],
        style: RadioGroupStyle = .vertical
    ) {
        self._selection = selection
        self.options = options
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .vertical:
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(options.indices, id: \.self) { index in
                        let option = options[index]
                        RadioButton(
                            isSelected: selection == option.value,
                            label: option.label
                        ) {
                            selection = option.value
                        }
                    }
                }
                
            case .horizontal:
                HStack(spacing: 20) {
                    ForEach(options.indices, id: \.self) { index in
                        let option = options[index]
                        RadioButton(
                            isSelected: selection == option.value,
                            label: option.label
                        ) {
                            selection = option.value
                        }
                    }
                }
                
            case .segmented:
                HStack(spacing: 0) {
                    ForEach(options.indices, id: \.self) { index in
                        let option = options[index]
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selection = option.value
                            }
                        } label: {
                            Text(option.label)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selection == option.value ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(selection == option.value ? Color.accentColor : Color.clear)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
            case .cards:
                VStack(spacing: 10) {
                    ForEach(options.indices, id: \.self) { index in
                        let option = options[index]
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selection = option.value
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(selection == option.value ? Color.accentColor : Color(.systemGray3), lineWidth: 2)
                                        .frame(width: 22, height: 22)
                                    
                                    if selection == option.value {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                
                                Text(option.label)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selection == option.value ? Color.accentColor : Color(.systemGray4), lineWidth: selection == option.value ? 2 : 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selection == option.value ? Color.accentColor.opacity(0.05) : Color.clear)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

/// Radio group with descriptions
public struct DetailedRadioGroup<T: Hashable>: View {
    @Binding var selection: T
    let options: [DetailedOption]
    
    public struct DetailedOption {
        let value: T
        let title: String
        let description: String
        let icon: String?
        
        public init(value: T, title: String, description: String, icon: String? = nil) {
            self.value = value
            self.title = title
            self.description = description
            self.icon = icon
        }
    }
    
    public init(selection: Binding<T>, options: [DetailedOption]) {
        self._selection = selection
        self.options = options
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                let isSelected = selection == option.value
                
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option.value
                    }
                } label: {
                    HStack(spacing: 14) {
                        if let icon = option.icon {
                            Image(systemName: icon)
                                .font(.system(size: 24))
                                .foregroundColor(isSelected ? .accentColor : .secondary)
                                .frame(width: 40)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(option.title)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(option.description)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(isSelected ? Color.accentColor : Color(.systemGray3), lineWidth: 2)
                                .frame(width: 22, height: 22)
                            
                            if isSelected {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.accentColor.opacity(0.05) : Color(.systemBackground))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview("Radio Groups") {
    struct PreviewWrapper: View {
        @State private var selectedOption = "option1"
        @State private var selectedPlan = "pro"
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    // Vertical
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vertical")
                            .font(.headline)
                        
                        RadioGroup(
                            selection: $selectedOption,
                            options: [
                                ("option1", "Option 1"),
                                ("option2", "Option 2"),
                                ("option3", "Option 3")
                            ],
                            style: .vertical
                        )
                    }
                    
                    Divider()
                    
                    // Segmented
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Segmented")
                            .font(.headline)
                        
                        RadioGroup(
                            selection: $selectedOption,
                            options: [
                                ("option1", "Day"),
                                ("option2", "Week"),
                                ("option3", "Month")
                            ],
                            style: .segmented
                        )
                    }
                    
                    Divider()
                    
                    // Cards
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cards")
                            .font(.headline)
                        
                        RadioGroup(
                            selection: $selectedPlan,
                            options: [
                                ("basic", "Basic"),
                                ("pro", "Pro"),
                                ("enterprise", "Enterprise")
                            ],
                            style: .cards
                        )
                    }
                    
                    Divider()
                    
                    // Detailed
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detailed")
                            .font(.headline)
                        
                        DetailedRadioGroup(
                            selection: $selectedPlan,
                            options: [
                                .init(value: "basic", title: "Basic", description: "For individuals and small projects", icon: "person"),
                                .init(value: "pro", title: "Pro", description: "For professionals and teams", icon: "person.2"),
                                .init(value: "enterprise", title: "Enterprise", description: "For large organizations", icon: "building.2")
                            ]
                        )
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
