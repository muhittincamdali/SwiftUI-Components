// ComponentTemplate.swift
// SwiftUI-Components
//
// Template for creating new components

import SwiftUI

// MARK: - Component

/// A brief description of what this component does.
///
/// Use `ComponentName` when you need to display...
///
/// ## Overview
///
/// This component provides...
///
/// ## Usage
///
/// ```swift
/// ComponentName(title: "Example") {
///     // Content
/// }
/// ```
///
/// ## Customization
///
/// You can customize the appearance using `ComponentStyle`:
///
/// ```swift
/// ComponentName(
///     title: "Example",
///     style: .custom(backgroundColor: .blue)
/// ) {
///     // Content
/// }
/// ```
///
/// - Note: This component supports VoiceOver and Dynamic Type.
/// - Important: Requires iOS 15.0 or later.
public struct ComponentName<Content: View>: View {
    // MARK: - Properties
    
    private let title: String
    private let content: Content
    private let style: ComponentStyle
    private let action: (() -> Void)?
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: - State
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    // MARK: - Initialization
    
    /// Creates a new component with the specified configuration.
    ///
    /// - Parameters:
    ///   - title: The title displayed at the top of the component.
    ///   - style: The visual style to apply. Defaults to `.default`.
    ///   - action: An optional action to perform when tapped.
    ///   - content: A view builder that creates the component's content.
    public init(
        title: String,
        style: ComponentStyle = .default,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.style = style
        self.action = action
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            // Header
            headerView
            
            // Content
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(style.padding)
        .background(backgroundView)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        .shadow(
            color: style.shadowColor.opacity(colorScheme == .dark ? 0.3 : 0.1),
            radius: style.shadowRadius,
            x: 0,
            y: style.shadowRadius / 2
        )
        .opacity(isEnabled ? 1.0 : 0.6)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            guard isEnabled else { return }
            
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                action?()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityAddTraits(action != nil ? .isButton : [])
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text(title)
                .font(style.titleFont)
                .foregroundColor(style.titleColor)
            
            Spacer()
            
            if let action = action {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if style.isGlass {
            // Glassmorphism background
            ZStack {
                Color.clear
                    .background(.ultraThinMaterial)
                
                style.backgroundColor
                    .opacity(0.1)
            }
        } else {
            style.backgroundColor
        }
    }
}

// MARK: - Style

/// Configuration options for `ComponentName` appearance.
public struct ComponentStyle {
    /// The background color of the component.
    public let backgroundColor: Color
    
    /// The color of the title text.
    public let titleColor: Color
    
    /// The font used for the title.
    public let titleFont: Font
    
    /// The corner radius of the component.
    public let cornerRadius: CGFloat
    
    /// The internal padding.
    public let padding: EdgeInsets
    
    /// The spacing between elements.
    public let spacing: CGFloat
    
    /// The shadow radius.
    public let shadowRadius: CGFloat
    
    /// The shadow color.
    public let shadowColor: Color
    
    /// Whether to use glassmorphism effect.
    public let isGlass: Bool
    
    /// Creates a custom style configuration.
    public init(
        backgroundColor: Color = .white,
        titleColor: Color = .primary,
        titleFont: Font = .headline,
        cornerRadius: CGFloat = 12,
        padding: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16),
        spacing: CGFloat = 12,
        shadowRadius: CGFloat = 8,
        shadowColor: Color = .black,
        isGlass: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.spacing = spacing
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.isGlass = isGlass
    }
    
    // MARK: - Presets
    
    /// The default style with standard appearance.
    public static let `default` = ComponentStyle()
    
    /// A compact style with reduced padding and spacing.
    public static let compact = ComponentStyle(
        padding: .init(top: 12, leading: 12, bottom: 12, trailing: 12),
        spacing: 8
    )
    
    /// A large style with increased padding and larger title.
    public static let large = ComponentStyle(
        titleFont: .title2,
        padding: .init(top: 20, leading: 20, bottom: 20, trailing: 20),
        spacing: 16
    )
    
    /// A glass style with blur effect.
    public static let glass = ComponentStyle(
        backgroundColor: .clear,
        isGlass: true
    )
    
    /// Creates a custom style with specified background color.
    public static func custom(backgroundColor: Color) -> ComponentStyle {
        ComponentStyle(backgroundColor: backgroundColor)
    }
}

// MARK: - Convenience Initializers

extension ComponentName where Content == EmptyView {
    /// Creates a component with only a title.
    public init(
        title: String,
        style: ComponentStyle = .default,
        action: (() -> Void)? = nil
    ) {
        self.init(title: title, style: style, action: action) {
            EmptyView()
        }
    }
}

// MARK: - View Modifiers

extension ComponentName {
    /// Applies a custom background color.
    public func backgroundColor(_ color: Color) -> some View {
        ComponentName(
            title: title,
            style: ComponentStyle(
                backgroundColor: color,
                titleColor: style.titleColor,
                titleFont: style.titleFont,
                cornerRadius: style.cornerRadius,
                padding: style.padding,
                spacing: style.spacing,
                shadowRadius: style.shadowRadius,
                shadowColor: style.shadowColor,
                isGlass: style.isGlass
            ),
            action: action
        ) {
            content
        }
    }
    
    /// Applies a glass effect.
    public func glass() -> some View {
        ComponentName(
            title: title,
            style: .glass,
            action: action
        ) {
            content
        }
    }
}

// MARK: - Previews

#Preview("Default") {
    ComponentName(title: "Example Component") {
        Text("This is the content area")
            .foregroundColor(.secondary)
    }
    .padding()
}

#Preview("With Action") {
    ComponentName(title: "Tappable Component", action: {
        print("Tapped!")
    }) {
        Text("Tap me to trigger the action")
            .foregroundColor(.secondary)
    }
    .padding()
}

#Preview("Glass Style") {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        ComponentName(title: "Glass Component", style: .glass) {
            Text("Beautiful glassmorphism effect")
                .foregroundColor(.white)
        }
        .padding()
    }
}

#Preview("Compact") {
    ComponentName(title: "Compact", style: .compact) {
        Text("Reduced padding and spacing")
            .foregroundColor(.secondary)
    }
    .padding()
}
