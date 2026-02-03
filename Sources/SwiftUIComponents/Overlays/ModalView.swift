import SwiftUI

/// A customizable modal overlay with various presentation styles.
///
/// `ModalView` provides a flexible modal presentation with
/// different animation and sizing options.
///
/// ```swift
/// ModalView(isPresented: $showModal) {
///     Text("Modal Content")
/// }
/// ```
public struct ModalView<Content: View>: View {
    // MARK: - Types
    
    /// The presentation style of the modal.
    public enum Style {
        case center
        case fullScreen
        case bottomSheet
        case alert
    }
    
    /// The transition animation for the modal.
    public enum Transition {
        case fade
        case scale
        case slide
        case spring
    }
    
    // MARK: - Properties
    
    @Binding private var isPresented: Bool
    private let style: Style
    private let transition: Transition
    private let backgroundColor: Color
    private let backgroundBlur: Bool
    private let dismissOnBackgroundTap: Bool
    private let showCloseButton: Bool
    private let cornerRadius: CGFloat
    private let content: () -> Content
    
    // MARK: - Initialization
    
    /// Creates a new modal view.
    public init(
        isPresented: Binding<Bool>,
        style: Style = .center,
        transition: Transition = .scale,
        backgroundColor: Color = Color(.systemBackground),
        backgroundBlur: Bool = false,
        dismissOnBackgroundTap: Bool = true,
        showCloseButton: Bool = true,
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.style = style
        self.transition = transition
        self.backgroundColor = backgroundColor
        self.backgroundBlur = backgroundBlur
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.showCloseButton = showCloseButton
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            if isPresented {
                // Background
                backgroundView
                
                // Modal content
                modalContent
            }
        }
        .animation(animation, value: isPresented)
    }
    
    // MARK: - Background View
    
    @ViewBuilder
    private var backgroundView: some View {
        Group {
            if backgroundBlur {
                Color.clear
                    .background(.ultraThinMaterial)
            } else {
                Color.black.opacity(0.5)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            if dismissOnBackgroundTap {
                dismiss()
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Modal Content
    
    @ViewBuilder
    private var modalContent: some View {
        switch style {
        case .center:
            centerModal
        case .fullScreen:
            fullScreenModal
        case .bottomSheet:
            bottomSheetModal
        case .alert:
            alertModal
        }
    }
    
    // MARK: - Center Modal
    
    private var centerModal: some View {
        VStack {
            if showCloseButton {
                HStack {
                    Spacer()
                    closeButton
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
            
            content()
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        .padding(32)
        .transition(contentTransition)
    }
    
    // MARK: - Full Screen Modal
    
    private var fullScreenModal: some View {
        VStack(spacing: 0) {
            if showCloseButton {
                HStack {
                    Spacer()
                    closeButton
                }
                .padding()
            }
            
            content()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .ignoresSafeArea()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Bottom Sheet Modal
    
    private var bottomSheetModal: some View {
        VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            
            if showCloseButton {
                HStack {
                    Spacer()
                    closeButton
                }
                .padding(.horizontal, 12)
            }
            
            content()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(edges: .bottom)
        .transition(.move(edge: .bottom))
    }
    
    // MARK: - Alert Modal
    
    private var alertModal: some View {
        content()
            .padding(20)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.15), radius: 10)
            .frame(maxWidth: 280)
            .transition(.scale(scale: 0.9).combined(with: .opacity))
    }
    
    // MARK: - Close Button
    
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.secondary)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Animation
    
    private var animation: Animation {
        switch transition {
        case .fade:
            return .easeInOut(duration: 0.25)
        case .scale:
            return .spring(response: 0.35, dampingFraction: 0.8)
        case .slide:
            return .easeOut(duration: 0.3)
        case .spring:
            return .spring(response: 0.4, dampingFraction: 0.7)
        }
    }
    
    private var contentTransition: AnyTransition {
        switch transition {
        case .fade:
            return .opacity
        case .scale:
            return .scale(scale: 0.85).combined(with: .opacity)
        case .slide:
            return .move(edge: .bottom).combined(with: .opacity)
        case .spring:
            return .scale(scale: 0.9).combined(with: .opacity)
        }
    }
    
    // MARK: - Actions
    
    private func dismiss() {
        withAnimation(animation) {
            isPresented = false
        }
    }
}

// MARK: - Alert Modal

/// A pre-styled alert modal with title, message, and actions.
public struct AlertModal: View {
    @Binding private var isPresented: Bool
    private let title: String
    private let message: String?
    private let primaryAction: AlertAction?
    private let secondaryAction: AlertAction?
    
    public struct AlertAction {
        public let title: String
        public let style: Style
        public let action: () -> Void
        
        public enum Style {
            case `default`
            case cancel
            case destructive
        }
        
        public init(title: String, style: Style = .default, action: @escaping () -> Void) {
            self.title = title
            self.style = style
            self.action = action
        }
    }
    
    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        primaryAction: AlertAction? = nil,
        secondaryAction: AlertAction? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        ModalView(
            isPresented: $isPresented,
            style: .alert,
            showCloseButton: false
        ) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    if let message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                VStack(spacing: 8) {
                    if let primary = primaryAction {
                        actionButton(primary)
                    }
                    
                    if let secondary = secondaryAction {
                        actionButton(secondary)
                    }
                }
            }
        }
    }
    
    private func actionButton(_ action: AlertAction) -> some View {
        Button {
            action.action()
            isPresented = false
        } label: {
            Text(action.title)
                .font(.subheadline)
                .fontWeight(action.style == .cancel ? .regular : .semibold)
                .foregroundStyle(buttonColor(for: action.style))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(buttonBackground(for: action.style))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private func buttonColor(for style: AlertAction.Style) -> Color {
        switch style {
        case .default: return .white
        case .cancel: return .primary
        case .destructive: return .white
        }
    }
    
    private func buttonBackground(for style: AlertAction.Style) -> Color {
        switch style {
        case .default: return .blue
        case .cancel: return Color(.systemGray5)
        case .destructive: return .red
        }
    }
}

#if DEBUG
struct ModalViewPreview: View {
    @State private var showCenter = false
    @State private var showAlert = false
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button("Show Center Modal") { showCenter = true }
                Button("Show Alert") { showAlert = true }
                Button("Show Bottom Sheet") { showSheet = true }
            }
            
            ModalView(isPresented: $showCenter) {
                VStack(spacing: 20) {
                    Text("Center Modal")
                        .font(.headline)
                    Text("This is a centered modal with custom content.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            
            AlertModal(
                isPresented: $showAlert,
                title: "Delete Item?",
                message: "This action cannot be undone.",
                primaryAction: .init(title: "Delete", style: .destructive) { },
                secondaryAction: .init(title: "Cancel", style: .cancel) { }
            )
            
            ModalView(isPresented: $showSheet, style: .bottomSheet) {
                VStack(spacing: 16) {
                    Text("Bottom Sheet")
                        .font(.headline)
                    Text("Swipe down or tap outside to dismiss")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding()
                .frame(height: 300)
            }
        }
    }
}

#Preview {
    ModalViewPreview()
}
#endif
