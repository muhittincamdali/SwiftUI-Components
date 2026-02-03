import SwiftUI

/// A secondary button style with outline or subtle fill variants.
///
/// Use `SecondaryButton` for less prominent actions that complement primary buttons.
/// Supports outline, subtle fill, and ghost styles.
///
/// ```swift
/// SecondaryButton("Cancel", style: .outline) {
///     dismiss()
/// }
/// ```
public struct SecondaryButton: View {
    // MARK: - Types
    
    /// The visual style of the secondary button.
    public enum Style {
        /// Outlined border with transparent fill.
        case outline
        /// Subtle background fill with matching text.
        case subtle
        /// Text-only ghost button with no background.
        case ghost
        /// Tinted background with colored text.
        case tinted
    }
    
    /// The size preset for the button.
    public enum Size {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .subheadline
            case .medium: return .body
            case .large: return .headline
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            }
        }
    }
    
    // MARK: - Properties
    
    private let title: String
    private let style: Style
    private let size: Size
    private let accentColor: Color
    private let cornerRadius: CGFloat
    private let isLoading: Bool
    private let isDisabled: Bool
    private let isFullWidth: Bool
    private let icon: Image?
    private let iconPosition: IconPosition
    private let action: () -> Void
    
    /// Position of the icon relative to the title.
    public enum IconPosition {
        case leading
        case trailing
    }
    
    // MARK: - Initialization
    
    /// Creates a new secondary button.
    /// - Parameters:
    ///   - title: The text displayed on the button.
    ///   - style: The visual style. Defaults to `.outline`.
    ///   - size: The size preset. Defaults to `.medium`.
    ///   - accentColor: The accent color for borders and text. Defaults to `.blue`.
    ///   - cornerRadius: The corner radius. Defaults to `10`.
    ///   - isLoading: Whether to show a loading spinner. Defaults to `false`.
    ///   - isDisabled: Whether the button is disabled. Defaults to `false`.
    ///   - isFullWidth: Whether the button expands to full width. Defaults to `false`.
    ///   - icon: An optional icon image. Defaults to `nil`.
    ///   - iconPosition: Position of the icon. Defaults to `.leading`.
    ///   - action: The closure executed when tapped.
    public init(
        _ title: String,
        style: Style = .outline,
        size: Size = .medium,
        accentColor: Color = .blue,
        cornerRadius: CGFloat = 10,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        isFullWidth: Bool = false,
        icon: Image? = nil,
        iconPosition: IconPosition = .leading,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.accentColor = accentColor
        self.cornerRadius = cornerRadius
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.isFullWidth = isFullWidth
        self.icon = icon
        self.iconPosition = iconPosition
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon, iconPosition == .leading {
                        icon
                            .imageScale(.medium)
                    }
                    
                    Text(title)
                        .font(size.font)
                        .fontWeight(.medium)
                    
                    if let icon, iconPosition == .trailing {
                        icon
                            .imageScale(.medium)
                    }
                }
            }
            .padding(.horizontal, size.padding)
            .frame(height: size.height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
    
    // MARK: - Computed Properties
    
    private var foregroundColor: Color {
        switch style {
        case .outline, .ghost:
            return accentColor
        case .subtle:
            return .primary
        case .tinted:
            return accentColor
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .outline, .ghost:
            return .clear
        case .subtle:
            return Color(.systemGray6)
        case .tinted:
            return accentColor.opacity(0.15)
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline:
            return accentColor.opacity(0.5)
        case .subtle, .ghost, .tinted:
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        style == .outline ? 1.5 : 0
    }
}

// MARK: - Button Style

/// A custom button style for secondary buttons with press animation.
public struct SecondaryButtonStyle: ButtonStyle {
    private let accentColor: Color
    
    public init(accentColor: Color = .blue) {
        self.accentColor = accentColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 16) {
        SecondaryButton("Outline Style", style: .outline) { }
        SecondaryButton("Subtle Style", style: .subtle) { }
        SecondaryButton("Ghost Style", style: .ghost) { }
        SecondaryButton("Tinted Style", style: .tinted, accentColor: .green) { }
        SecondaryButton("With Icon", icon: Image(systemName: "star.fill")) { }
        SecondaryButton("Loading...", isLoading: true) { }
        SecondaryButton("Full Width", isFullWidth: true) { }
    }
    .padding()
}
#endif
