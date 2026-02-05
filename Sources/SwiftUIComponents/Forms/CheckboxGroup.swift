import SwiftUI

/// A single checkbox control
public struct Checkbox: View {
    @Binding var isChecked: Bool
    let label: String?
    let style: CheckboxStyle
    
    public enum CheckboxStyle {
        case standard
        case rounded
        case circle
    }
    
    public init(isChecked: Binding<Bool>, label: String? = nil, style: CheckboxStyle = .standard) {
        self._isChecked = isChecked
        self.label = label
        self.style = style
    }
    
    public var body: some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                isChecked.toggle()
            }
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    shape
                        .stroke(isChecked ? Color.accentColor : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isChecked {
                        shape
                            .fill(Color.accentColor)
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
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
        .accessibilityLabel(label ?? "Checkbox")
        .accessibilityValue(isChecked ? "checked" : "unchecked")
        .accessibilityAddTraits(.isButton)
    }
    
    @ViewBuilder
    private var shape: some Shape {
        switch style {
        case .standard:
            RoundedRectangle(cornerRadius: 4)
        case .rounded:
            RoundedRectangle(cornerRadius: 8)
        case .circle:
            Circle()
        }
    }
}

/// A group of checkboxes
public struct CheckboxGroup<T: Hashable>: View {
    @Binding var selections: Set<T>
    let options: [(value: T, label: String)]
    let style: CheckboxGroupStyle
    
    public enum CheckboxGroupStyle {
        case vertical
        case horizontal
        case grid(columns: Int)
    }
    
    public init(
        selections: Binding<Set<T>>,
        options: [(value: T, label: String)],
        style: CheckboxGroupStyle = .vertical
    ) {
        self._selections = selections
        self.options = options
        self.style = style
    }
    
    public var body: some View {
        Group {
            switch style {
            case .vertical:
                VStack(alignment: .leading, spacing: 12) {
                    checkboxes
                }
            case .horizontal:
                HStack(spacing: 20) {
                    checkboxes
                }
            case .grid(let columns):
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), spacing: 12) {
                    checkboxes
                }
            }
        }
    }
    
    @ViewBuilder
    private var checkboxes: some View {
        ForEach(options.indices, id: \.self) { index in
            let option = options[index]
            Checkbox(
                isChecked: Binding(
                    get: { selections.contains(option.value) },
                    set: { isChecked in
                        if isChecked {
                            selections.insert(option.value)
                        } else {
                            selections.remove(option.value)
                        }
                    }
                ),
                label: option.label
            )
        }
    }
}

/// A toggle switch with label
public struct LabeledToggle: View {
    @Binding var isOn: Bool
    let label: String
    let description: String?
    let icon: String?
    
    public init(
        isOn: Binding<Bool>,
        label: String,
        description: String? = nil,
        icon: String? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.description = description
        self.icon = icon
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                    .frame(width: 32)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                
                if let description = description {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.accentColor)
        }
        .padding(.vertical, 4)
    }
}

#Preview("Checkbox & Toggle") {
    struct PreviewWrapper: View {
        @State private var isChecked = false
        @State private var selections: Set<String> = ["swift"]
        @State private var notifications = true
        @State private var darkMode = false
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    // Single checkboxes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Single Checkbox")
                            .font(.headline)
                        
                        Checkbox(isChecked: $isChecked, label: "Standard", style: .standard)
                        Checkbox(isChecked: $isChecked, label: "Rounded", style: .rounded)
                        Checkbox(isChecked: $isChecked, label: "Circle", style: .circle)
                    }
                    
                    Divider()
                    
                    // Checkbox group
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Checkbox Group")
                            .font(.headline)
                        
                        CheckboxGroup(
                            selections: $selections,
                            options: [
                                ("swift", "Swift"),
                                ("swiftui", "SwiftUI"),
                                ("combine", "Combine"),
                                ("uikit", "UIKit")
                            ],
                            style: .vertical
                        )
                    }
                    
                    Divider()
                    
                    // Toggles
                    VStack(spacing: 16) {
                        Text("Toggles")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LabeledToggle(
                            isOn: $notifications,
                            label: "Push Notifications",
                            description: "Receive alerts and updates",
                            icon: "bell.fill"
                        )
                        
                        LabeledToggle(
                            isOn: $darkMode,
                            label: "Dark Mode",
                            description: "Use dark appearance",
                            icon: "moon.fill"
                        )
                    }
                }
                .padding()
            }
        }
    }
    return PreviewWrapper()
}
