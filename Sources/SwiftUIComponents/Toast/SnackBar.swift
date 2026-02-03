import SwiftUI

/// A Material Design-inspired snackbar notification.
///
/// `SnackBar` displays brief messages at the bottom of the screen
/// with optional action buttons.
///
/// ```swift
/// SnackBar(
///     message: "Item deleted",
///     action: .init(title: "Undo") { undoDelete() }
/// )
/// ```
public struct SnackBar: View {
    // MARK: - Types
    
    /// An action button for the snackbar.
    public struct Action {
        public let title: String
        public let action: () -> Void
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }
    
    /// The visual style of the snackbar.
    public enum Style {
        case standard
        case info
        case success
        case warning
        case error
        
        var backgroundColor: Color {
            switch self {
            case .standard: return Color(.systemGray2)
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }
        
        var icon: Image? {
            switch self {
            case .standard: return nil
            case .info: return Image(systemName: "info.circle.fill")
            case .success: return Image(systemName: "checkmark.circle.fill")
            case .warning: return Image(systemName: "exclamationmark.triangle.fill")
            case .error: return Image(systemName: "xmark.circle.fill")
            }
        }
    }
    
    // MARK: - Properties
    
    private let message: String
    private let style: Style
    private let action: Action?
    private let dismissAction: (() -> Void)?
    private let showDismissButton: Bool
    
    // MARK: - Initialization
    
    /// Creates a new snackbar.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - style: The visual style. Defaults to `.standard`.
    ///   - action: Optional action button. Defaults to `nil`.
    ///   - showDismissButton: Whether to show dismiss button. Defaults to `false`.
    ///   - dismissAction: Called when dismissed. Defaults to `nil`.
    public init(
        message: String,
        style: Style = .standard,
        action: Action? = nil,
        showDismissButton: Bool = false,
        dismissAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.action = action
        self.showDismissButton = showDismissButton
        self.dismissAction = dismissAction
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 12) {
            if let icon = style.icon {
                icon
                    .foregroundStyle(.white)
            }
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white)
                .lineLimit(2)
            
            Spacer()
            
            if let action {
                Button(action.title) {
                    action.action()
                }
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.9))
            }
            
            if showDismissButton {
                Button {
                    dismissAction?()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Snackbar Manager

/// Manages snackbar presentation and queue.
@MainActor
public final class SnackBarManager: ObservableObject {
    public static let shared = SnackBarManager()
    
    @Published public var currentSnackBar: SnackBarData?
    @Published public var isShowing: Bool = false
    
    private var queue: [SnackBarData] = []
    private var dismissTask: Task<Void, Never>?
    
    public struct SnackBarData: Identifiable {
        public let id = UUID()
        public let message: String
        public let style: SnackBar.Style
        public let action: SnackBar.Action?
        public let duration: Double
        
        public init(
            message: String,
            style: SnackBar.Style = .standard,
            action: SnackBar.Action? = nil,
            duration: Double = 3.0
        ) {
            self.message = message
            self.style = style
            self.action = action
            self.duration = duration
        }
    }
    
    private init() {}
    
    /// Shows a snackbar.
    public func show(_ data: SnackBarData) {
        queue.append(data)
        processQueue()
    }
    
    /// Shows a simple message.
    public func show(
        message: String,
        style: SnackBar.Style = .standard,
        duration: Double = 3.0
    ) {
        show(SnackBarData(message: message, style: style, duration: duration))
    }
    
    /// Dismisses the current snackbar.
    public func dismiss() {
        dismissTask?.cancel()
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowing = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentSnackBar = nil
            self.processQueue()
        }
    }
    
    private func processQueue() {
        guard !isShowing, !queue.isEmpty else { return }
        
        let data = queue.removeFirst()
        currentSnackBar = data
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isShowing = true
        }
        
        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(data.duration * 1_000_000_000))
            if !Task.isCancelled {
                dismiss()
            }
        }
    }
}

// MARK: - Snackbar View Modifier

/// A modifier that adds snackbar support to a view.
public struct SnackBarModifier: ViewModifier {
    @ObservedObject private var manager = SnackBarManager.shared
    let edge: VerticalEdge
    let padding: CGFloat
    
    public init(edge: VerticalEdge = .bottom, padding: CGFloat = 16) {
        self.edge = edge
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: edge == .bottom ? .bottom : .top) {
            content
            
            if manager.isShowing, let data = manager.currentSnackBar {
                SnackBar(
                    message: data.message,
                    style: data.style,
                    action: data.action,
                    showDismissButton: true,
                    dismissAction: { manager.dismiss() }
                )
                .padding(.horizontal, padding)
                .padding(edge == .bottom ? .bottom : .top, padding)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: edge).combined(with: .opacity),
                        removal: .move(edge: edge).combined(with: .opacity)
                    )
                )
                .zIndex(999)
            }
        }
    }
}

extension View {
    /// Adds snackbar support to the view.
    public func snackBarHost(edge: VerticalEdge = .bottom, padding: CGFloat = 16) -> some View {
        modifier(SnackBarModifier(edge: edge, padding: padding))
    }
}

#if DEBUG
struct SnackBarPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            SnackBar(message: "Standard snackbar message")
            
            SnackBar(
                message: "Item deleted successfully",
                style: .success,
                action: .init(title: "Undo") { }
            )
            
            SnackBar(
                message: "Network connection lost",
                style: .error,
                showDismissButton: true
            )
            
            SnackBar(
                message: "Please check your settings",
                style: .warning
            )
            
            Spacer()
            
            Button("Show Snackbar") {
                SnackBarManager.shared.show(message: "Hello from SnackBar!", style: .info)
            }
        }
        .padding()
        .snackBarHost()
    }
}

#Preview {
    SnackBarPreview()
}
#endif
