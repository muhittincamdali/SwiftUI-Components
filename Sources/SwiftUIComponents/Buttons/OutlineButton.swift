import SwiftUI

/// A button with an outlined border style
public struct OutlineButton: View {
    let title: String
    let action: () -> Void
    let color: Color
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    
    @State private var isPressed = false
    
    public init(
        _ title: String,
        color: Color = .accentColor,
        cornerRadius: CGFloat = 10,
        lineWidth: CGFloat = 2,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color, lineWidth: lineWidth)
                )
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isPressed ? color.opacity(0.1) : Color.clear)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Outline Buttons") {
    VStack(spacing: 20) {
        OutlineButton("Default") {}
        OutlineButton("Colored", color: .purple) {}
        OutlineButton("Rounded", cornerRadius: 25) {}
    }
    .padding()
}
