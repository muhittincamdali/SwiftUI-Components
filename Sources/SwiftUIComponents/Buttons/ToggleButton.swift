import SwiftUI

/// A button that toggles between two states
public struct ToggleButton: View {
    @Binding var isOn: Bool
    let onLabel: String
    let offLabel: String
    let onIcon: String?
    let offIcon: String?
    let onColor: Color
    let offColor: Color
    
    public init(
        isOn: Binding<Bool>,
        onLabel: String = "On",
        offLabel: String = "Off",
        onIcon: String? = "checkmark",
        offIcon: String? = "xmark",
        onColor: Color = .green,
        offColor: Color = .gray
    ) {
        self._isOn = isOn
        self.onLabel = onLabel
        self.offLabel = offLabel
        self.onIcon = onIcon
        self.offIcon = offIcon
        self.onColor = onColor
        self.offColor = offColor
    }
    
    public var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                if let icon = isOn ? onIcon : offIcon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                }
                Text(isOn ? onLabel : offLabel)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(isOn ? onColor : offColor)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isOn ? onLabel : offLabel)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(isOn ? "on" : "off")
    }
}

/// A toggle button group for selecting one option
public struct ToggleButtonGroup<T: Hashable>: View {
    @Binding var selection: T
    let options: [(value: T, label: String)]
    let color: Color
    
    public init(
        selection: Binding<T>,
        options: [(value: T, label: String)],
        color: Color = .accentColor
    ) {
        self._selection = selection
        self.options = options
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option.value
                    }
                } label: {
                    Text(option.label)
                        .fontWeight(.medium)
                        .foregroundColor(selection == option.value ? .white : color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            selection == option.value ? color : Color.clear
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            Capsule()
                .stroke(color, lineWidth: 2)
        )
        .clipShape(Capsule())
    }
}

#Preview("Toggle Buttons") {
    struct PreviewWrapper: View {
        @State private var isOn = false
        @State private var selection = "Day"
        
        var body: some View {
            VStack(spacing: 30) {
                ToggleButton(
                    isOn: $isOn,
                    onLabel: "Following",
                    offLabel: "Follow",
                    onIcon: "checkmark",
                    offIcon: "plus"
                )
                
                ToggleButton(
                    isOn: $isOn,
                    onLabel: "Liked",
                    offLabel: "Like",
                    onIcon: "heart.fill",
                    offIcon: "heart",
                    onColor: .pink,
                    offColor: .gray
                )
                
                ToggleButtonGroup(
                    selection: $selection,
                    options: [
                        ("Day", "Day"),
                        ("Week", "Week"),
                        ("Month", "Month")
                    ]
                )
            }
            .padding()
        }
    }
    return PreviewWrapper()
}
