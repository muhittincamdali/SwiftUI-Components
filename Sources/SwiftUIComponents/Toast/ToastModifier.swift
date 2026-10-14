import SwiftUI

/// A view modifier that presents a toast notification overlay.
///
/// Use the `.toast()` view modifier to attach toast behavior to any view.
///
/// ```swift
/// ContentView()
///     .toast(isPresenting: $showToast, message: "Done!", style: .success)
/// ```
public struct ToastModifier: ViewModifier {
    // MARK: - Properties

    @Binding var isPresenting: Bool
    let message: String
    let style: ToastStyle
    let duration: Double
    let position: ToastPosition

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: position.alignment) {
                if isPresenting {
                    ToastView(message: message, style: style)
                        .transition(.move(edge: position.edge).combined(with: .opacity))
                        .zIndex(999)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isPresenting = false
                                }
                            }
                        }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresenting)
    }
}

/// The position where a toast notification appears.
public enum ToastPosition {
    case top
    case bottom

    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }

    var edge: Edge {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

// MARK: - View Extension

extension View {
    /// Presents a toast notification overlay.
    /// - Parameters:
    ///   - isPresenting: A binding that controls toast visibility.
    ///   - message: The message to display.
    ///   - style: The visual style. Defaults to `.info`.
    ///   - duration: Auto-dismiss duration in seconds. Defaults to `3`.
    ///   - position: Where the toast appears. Defaults to `.top`.
    /// - Returns: The modified view.
    public func toast(
        isPresenting: Binding<Bool>,
        message: String,
        style: ToastStyle = .info,
        duration: Double = 3,
        position: ToastPosition = .top
    ) -> some View {
        modifier(
            ToastModifier(
                isPresenting: isPresenting,
                message: message,
                style: style,
                duration: duration,
                position: position
            )
        )
    }
}
