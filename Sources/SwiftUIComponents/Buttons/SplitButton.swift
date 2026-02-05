import SwiftUI

/// A button split into primary action and dropdown menu
public struct SplitButton<Content: View>: View {
    let title: String
    let icon: String?
    let primaryAction: () -> Void
    let color: Color
    @ViewBuilder let menuContent: () -> Content
    
    @State private var showMenu = false
    
    public init(
        _ title: String,
        icon: String? = nil,
        color: Color = .accentColor,
        primaryAction: @escaping () -> Void,
        @ViewBuilder menuContent: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.primaryAction = primaryAction
        self.menuContent = menuContent
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            // Primary action
            Button(action: primaryAction) {
                HStack(spacing: 8) {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 1)
                .padding(.vertical, 8)
            
            // Menu trigger
            Menu {
                menuContent()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) with options")
    }
}

/// A button group with multiple options
public struct ButtonGroup: View {
    let buttons: [GroupButton]
    let style: GroupStyle
    
    public struct GroupButton: Identifiable {
        public let id = UUID()
        let title: String
        let icon: String?
        let action: () -> Void
        
        public init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.action = action
        }
    }
    
    public enum GroupStyle {
        case filled(Color)
        case outlined(Color)
    }
    
    public init(buttons: [GroupButton], style: GroupStyle = .filled(.accentColor)) {
        self.buttons = buttons
        self.style = style
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(buttons.enumerated()), id: \.element.id) { index, button in
                Button(action: button.action) {
                    HStack(spacing: 6) {
                        if let icon = button.icon {
                            Image(systemName: icon)
                        }
                        Text(button.title)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(foregroundColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .buttonStyle(PlainButtonStyle())
                
                if index < buttons.count - 1 {
                    divider
                }
            }
        }
        .background(background)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .filled: return .white
        case .outlined(let color): return color
        }
    }
    
    @ViewBuilder
    private var background: some View {
        switch style {
        case .filled(let color):
            RoundedRectangle(cornerRadius: 10).fill(color)
        case .outlined(let color):
            RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 2)
        }
    }
    
    @ViewBuilder
    private var divider: some View {
        switch style {
        case .filled:
            Rectangle().fill(Color.white.opacity(0.3)).frame(width: 1)
        case .outlined(let color):
            Rectangle().fill(color.opacity(0.3)).frame(width: 1)
        }
    }
}

/// Stepper button for increment/decrement
public struct StepperButton: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let color: Color
    
    public init(
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100,
        step: Int = 1,
        color: Color = .accentColor
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Button {
                if value - step >= range.lowerBound {
                    value -= step
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(value <= range.lowerBound ? .gray : .white)
                    .frame(width: 44, height: 44)
            }
            .disabled(value <= range.lowerBound)
            
            Text("\(value)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(minWidth: 50)
            
            Button {
                if value + step <= range.upperBound {
                    value += step
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(value >= range.upperBound ? .gray : .white)
                    .frame(width: 44, height: 44)
            }
            .disabled(value >= range.upperBound)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Stepper, value \(value)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if value + step <= range.upperBound { value += step }
            case .decrement:
                if value - step >= range.lowerBound { value -= step }
            @unknown default:
                break
            }
        }
    }
}

#Preview("Split & Group Buttons") {
    VStack(spacing: 24) {
        // Split button
        SplitButton("Save", icon: "square.and.arrow.down", primaryAction: {}) {
            Button("Save as Draft") {}
            Button("Save as Template") {}
            Button("Save and Close") {}
        }
        
        // Button group
        ButtonGroup(buttons: [
            .init("Bold", icon: "bold") {},
            .init("Italic", icon: "italic") {},
            .init("Underline", icon: "underline") {}
        ])
        
        ButtonGroup(buttons: [
            .init("Left", icon: "text.alignleft") {},
            .init("Center", icon: "text.aligncenter") {},
            .init("Right", icon: "text.alignright") {}
        ], style: .outlined(.blue))
        
        // Stepper
        StepperButton(value: .constant(5), range: 0...10)
    }
    .padding()
}
