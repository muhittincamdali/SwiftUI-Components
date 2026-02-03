import SwiftUI

/// A tooltip overlay that appears on hover or tap.
///
/// `Tooltip` displays contextual help text near a UI element
/// with automatic positioning.
///
/// ```swift
/// Text("Hover me")
///     .tooltip("This is helpful information")
/// ```
public struct Tooltip: View {
    // MARK: - Types
    
    /// The position of the tooltip relative to the anchor.
    public enum Position {
        case top
        case bottom
        case leading
        case trailing
        case auto
    }
    
    /// The arrow style of the tooltip.
    public enum ArrowStyle {
        case none
        case small
        case medium
        case large
        
        var size: CGFloat {
            switch self {
            case .none: return 0
            case .small: return 6
            case .medium: return 8
            case .large: return 10
            }
        }
    }
    
    // MARK: - Properties
    
    private let text: String
    private let position: Position
    private let arrowStyle: ArrowStyle
    private let backgroundColor: Color
    private let textColor: Color
    private let font: Font
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let maxWidth: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a new tooltip.
    public init(
        _ text: String,
        position: Position = .auto,
        arrowStyle: ArrowStyle = .medium,
        backgroundColor: Color = .black.opacity(0.85),
        textColor: Color = .white,
        font: Font = .caption,
        cornerRadius: CGFloat = 8,
        padding: CGFloat = 8,
        maxWidth: CGFloat = 200
    ) {
        self.text = text
        self.position = position
        self.arrowStyle = arrowStyle
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.maxWidth = maxWidth
    }
    
    // MARK: - Body
    
    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(textColor)
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .frame(maxWidth: maxWidth)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Tooltip Modifier

/// A modifier that adds tooltip functionality to any view.
public struct TooltipModifier: ViewModifier {
    private let text: String
    private let position: Tooltip.Position
    private let trigger: TooltipTrigger
    private let delay: Double
    
    @State private var isShowing: Bool = false
    @State private var tooltipPosition: Tooltip.Position = .top
    
    public enum TooltipTrigger {
        case tap
        case longPress
        case hover
    }
    
    public init(
        text: String,
        position: Tooltip.Position = .auto,
        trigger: TooltipTrigger = .longPress,
        delay: Double = 0.5
    ) {
        self.text = text
        self.position = position
        self.trigger = trigger
        self.delay = delay
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: tooltipAlignment) {
                if isShowing {
                    Tooltip(text, position: tooltipPosition)
                        .offset(tooltipOffset)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        .zIndex(999)
                }
            }
            .gesture(tooltipGesture)
            .onHover { hovering in
                if trigger == .hover {
                    if hovering {
                        showTooltip()
                    } else {
                        hideTooltip()
                    }
                }
            }
    }
    
    private var tooltipAlignment: Alignment {
        switch tooltipPosition {
        case .top: return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        case .auto: return .top
        }
    }
    
    private var tooltipOffset: CGSize {
        let distance: CGFloat = 8
        switch tooltipPosition {
        case .top: return CGSize(width: 0, height: -distance)
        case .bottom: return CGSize(width: 0, height: distance)
        case .leading: return CGSize(width: -distance, height: 0)
        case .trailing: return CGSize(width: distance, height: 0)
        case .auto: return CGSize(width: 0, height: -distance)
        }
    }
    
    private var tooltipGesture: some Gesture {
        switch trigger {
        case .tap:
            return AnyGesture(TapGesture().onEnded {
                toggleTooltip()
            })
        case .longPress:
            return AnyGesture(LongPressGesture(minimumDuration: delay).onEnded { _ in
                showTooltip()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    hideTooltip()
                }
            })
        case .hover:
            return AnyGesture(TapGesture().onEnded { })
        }
    }
    
    private func showTooltip() {
        tooltipPosition = position == .auto ? .top : position
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            isShowing = true
        }
    }
    
    private func hideTooltip() {
        withAnimation(.easeOut(duration: 0.15)) {
            isShowing = false
        }
    }
    
    private func toggleTooltip() {
        if isShowing {
            hideTooltip()
        } else {
            showTooltip()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                hideTooltip()
            }
        }
    }
}

extension View {
    /// Adds a tooltip to the view.
    public func tooltip(
        _ text: String,
        position: Tooltip.Position = .auto,
        trigger: TooltipModifier.TooltipTrigger = .longPress
    ) -> some View {
        modifier(TooltipModifier(text: text, position: position, trigger: trigger))
    }
}

// MARK: - Popover Tooltip

/// A more advanced tooltip with rich content support.
public struct PopoverTooltip<Content: View, PopoverContent: View>: View {
    @Binding private var isPresented: Bool
    private let arrowEdge: Edge
    private let content: () -> Content
    private let popover: () -> PopoverContent
    
    public init(
        isPresented: Binding<Bool>,
        arrowEdge: Edge = .top,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder popover: @escaping () -> PopoverContent
    ) {
        self._isPresented = isPresented
        self.arrowEdge = arrowEdge
        self.content = content
        self.popover = popover
    }
    
    public var body: some View {
        content()
            .popover(isPresented: $isPresented, arrowEdge: arrowEdge) {
                popover()
                    .presentationCompactAdaptation(.popover)
            }
    }
}

// MARK: - Info Tooltip Button

/// A standardized info button with tooltip.
public struct InfoTooltipButton: View {
    private let text: String
    private let iconColor: Color
    
    @State private var isShowing = false
    
    public init(_ text: String, iconColor: Color = .secondary) {
        self.text = text
        self.iconColor = iconColor
    }
    
    public var body: some View {
        Button {
            isShowing.toggle()
        } label: {
            Image(systemName: "info.circle")
                .foregroundStyle(iconColor)
        }
        .popover(isPresented: $isShowing) {
            Text(text)
                .font(.caption)
                .padding()
                .presentationCompactAdaptation(.popover)
        }
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 40) {
        Text("Long press me")
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .tooltip("This is a helpful tooltip!")
        
        HStack {
            Text("Need help?")
            InfoTooltipButton("Here's some additional information about this feature.")
        }
        
        Text("Tap me")
            .padding()
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .tooltip("Tap tooltip example", trigger: .tap)
    }
    .padding()
}
#endif
