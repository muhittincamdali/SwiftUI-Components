import SwiftUI

/// A full-width banner notification for important messages.
///
/// `Banner` displays prominent notifications at the top or bottom
/// of the screen with customizable styling.
///
/// ```swift
/// Banner(
///     title: "Update Available",
///     message: "A new version is ready to install",
///     style: .info
/// )
/// ```
public struct Banner: View {
    // MARK: - Types
    
    /// The visual style of the banner.
    public enum Style {
        case info
        case success
        case warning
        case error
        case custom(background: Color, foreground: Color)
        
        var backgroundColor: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            case .custom(let bg, _): return bg
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .custom(_, let fg): return fg
            default: return .white
            }
        }
        
        var icon: Image {
            switch self {
            case .info: return Image(systemName: "info.circle.fill")
            case .success: return Image(systemName: "checkmark.circle.fill")
            case .warning: return Image(systemName: "exclamationmark.triangle.fill")
            case .error: return Image(systemName: "xmark.circle.fill")
            case .custom: return Image(systemName: "bell.fill")
            }
        }
    }
    
    /// An action button for the banner.
    public struct Action {
        public let title: String
        public let style: ActionStyle
        public let action: () -> Void
        
        public enum ActionStyle {
            case primary
            case secondary
        }
        
        public init(title: String, style: ActionStyle = .primary, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
    
    // MARK: - Properties
    
    private let title: String
    private let message: String?
    private let style: Style
    private let icon: Image?
    private let showCloseButton: Bool
    private let primaryAction: Action?
    private let secondaryAction: Action?
    private let onDismiss: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new banner.
    public init(
        title: String,
        message: String? = nil,
        style: Style = .info,
        icon: Image? = nil,
        showCloseButton: Bool = true,
        primaryAction: Action? = nil,
        secondaryAction: Action? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.icon = icon
        self.showCloseButton = showCloseButton
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.onDismiss = onDismiss
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // Icon
                (icon ?? style.icon)
                    .font(.title3)
                    .foregroundStyle(style.foregroundColor)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(style.foregroundColor)
                    
                    if let message {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(style.foregroundColor.opacity(0.9))
                            .lineLimit(3)
                    }
                }
                
                Spacer()
                
                // Close button
                if showCloseButton {
                    Button {
                        onDismiss?()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.caption.bold())
                            .foregroundStyle(style.foregroundColor.opacity(0.8))
                            .padding(6)
                            .background(style.foregroundColor.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            
            // Actions
            if primaryAction != nil || secondaryAction != nil {
                HStack(spacing: 12) {
                    Spacer()
                    
                    if let secondary = secondaryAction {
                        Button(secondary.title) {
                            secondary.action()
                        }
                        .font(.subheadline)
                        .foregroundStyle(style.foregroundColor.opacity(0.9))
                    }
                    
                    if let primary = primaryAction {
                        Button(primary.title) {
                            primary.action()
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(style.backgroundColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(style.foregroundColor)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(16)
        .background(style.backgroundColor)
    }
}

// MARK: - Banner Manager

/// Manages banner presentation.
@MainActor
public final class BannerManager: ObservableObject {
    public static let shared = BannerManager()
    
    @Published public var currentBanner: BannerData?
    @Published public var isShowing: Bool = false
    
    private var dismissTask: Task<Void, Never>?
    
    public struct BannerData: Identifiable {
        public let id = UUID()
        public let title: String
        public let message: String?
        public let style: Banner.Style
        public let duration: Double?
        public let primaryAction: Banner.Action?
        
        public init(
            title: String,
            message: String? = nil,
            style: Banner.Style = .info,
            duration: Double? = 4.0,
            primaryAction: Banner.Action? = nil
        ) {
            self.title = title
            self.message = message
            self.style = style
            self.duration = duration
            self.primaryAction = primaryAction
        }
    }
    
    private init() {}
    
    /// Shows a banner.
    public func show(_ data: BannerData) {
        dismiss()
        
        currentBanner = data
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isShowing = true
        }
        
        if let duration = data.duration {
            dismissTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                if !Task.isCancelled {
                    dismiss()
                }
            }
        }
    }
    
    /// Shows a simple banner.
    public func show(
        title: String,
        message: String? = nil,
        style: Banner.Style = .info,
        duration: Double? = 4.0
    ) {
        show(BannerData(title: title, message: message, style: style, duration: duration))
    }
    
    /// Dismisses the current banner.
    public func dismiss() {
        dismissTask?.cancel()
        
        withAnimation(.easeOut(duration: 0.2)) {
            isShowing = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.currentBanner = nil
        }
    }
}

// MARK: - Banner View Modifier

/// A modifier that adds banner support to a view.
public struct BannerModifier: ViewModifier {
    @ObservedObject private var manager = BannerManager.shared
    let edge: VerticalEdge
    
    public init(edge: VerticalEdge = .top) {
        self.edge = edge
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: edge == .top ? .top : .bottom) {
            content
            
            if manager.isShowing, let data = manager.currentBanner {
                Banner(
                    title: data.title,
                    message: data.message,
                    style: data.style,
                    primaryAction: data.primaryAction,
                    onDismiss: { manager.dismiss() }
                )
                .transition(.move(edge: edge).combined(with: .opacity))
                .zIndex(999)
            }
        }
    }
}

extension View {
    /// Adds banner support to the view.
    public func bannerHost(edge: VerticalEdge = .top) -> some View {
        modifier(BannerModifier(edge: edge))
    }
}

// MARK: - Inline Banner

/// A smaller, inline banner for contextual messages.
public struct InlineBanner: View {
    private let message: String
    private let style: Banner.Style
    private let onDismiss: (() -> Void)?
    
    public init(
        message: String,
        style: Banner.Style = .info,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            style.icon
                .font(.subheadline)
            
            Text(message)
                .font(.subheadline)
            
            Spacer()
            
            if onDismiss != nil {
                Button {
                    onDismiss?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption)
                }
            }
        }
        .foregroundStyle(style.foregroundColor)
        .padding(12)
        .background(style.backgroundColor.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#if DEBUG
struct BannerPreview: View {
    var body: some View {
        VStack(spacing: 16) {
            Banner(
                title: "Update Available",
                message: "A new version of the app is ready to install.",
                style: .info,
                primaryAction: .init(title: "Update") { }
            )
            
            Banner(
                title: "Payment Successful",
                message: "Your order has been confirmed.",
                style: .success
            )
            
            Banner(
                title: "Connection Lost",
                style: .error,
                primaryAction: .init(title: "Retry") { },
                secondaryAction: .init(title: "Cancel", style: .secondary) { }
            )
            
            InlineBanner(
                message: "Please verify your email address",
                style: .warning
            )
            
            Spacer()
            
            Button("Show Banner") {
                BannerManager.shared.show(
                    title: "Hello!",
                    message: "This is a test banner",
                    style: .success
                )
            }
        }
        .padding()
        .bannerHost()
    }
}

#Preview {
    BannerPreview()
}
#endif
