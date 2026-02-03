import SwiftUI

/// A button with sophisticated loading state animations.
///
/// `LoadingButton` provides multiple loading animation styles and
/// supports success/failure state transitions.
///
/// ```swift
/// LoadingButton("Submit", state: $buttonState) {
///     await performSubmission()
/// }
/// ```
public struct LoadingButton: View {
    // MARK: - Types
    
    /// The current state of the loading button.
    public enum LoadingState: Equatable {
        case idle
        case loading
        case success
        case failure
    }
    
    /// The animation style for the loading indicator.
    public enum LoadingStyle {
        case spinner
        case dots
        case pulse
        case progress(Double)
    }
    
    // MARK: - Properties
    
    private let title: String
    private let loadingTitle: String?
    private let successTitle: String?
    private let failureTitle: String?
    private let style: LoadingStyle
    private let backgroundColor: Color
    private let foregroundColor: Color
    private let successColor: Color
    private let failureColor: Color
    private let cornerRadius: CGFloat
    private let height: CGFloat
    private let resetDelay: Double
    private let action: () async -> Bool
    
    @Binding private var state: LoadingState
    @State private var dotPhase: Int = 0
    @State private var pulseScale: CGFloat = 1.0
    
    // MARK: - Initialization
    
    /// Creates a new loading button.
    /// - Parameters:
    ///   - title: The default button title.
    ///   - state: Binding to the loading state.
    ///   - loadingTitle: Optional title during loading. Defaults to `nil`.
    ///   - successTitle: Optional title on success. Defaults to `nil`.
    ///   - failureTitle: Optional title on failure. Defaults to `nil`.
    ///   - style: The loading animation style. Defaults to `.spinner`.
    ///   - backgroundColor: Background color. Defaults to `.blue`.
    ///   - foregroundColor: Foreground color. Defaults to `.white`.
    ///   - successColor: Color on success. Defaults to `.green`.
    ///   - failureColor: Color on failure. Defaults to `.red`.
    ///   - cornerRadius: Corner radius. Defaults to `12`.
    ///   - height: Button height. Defaults to `50`.
    ///   - resetDelay: Delay before resetting state. Defaults to `2.0`.
    ///   - action: Async action returning success/failure.
    public init(
        _ title: String,
        state: Binding<LoadingState>,
        loadingTitle: String? = nil,
        successTitle: String? = nil,
        failureTitle: String? = nil,
        style: LoadingStyle = .spinner,
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white,
        successColor: Color = .green,
        failureColor: Color = .red,
        cornerRadius: CGFloat = 12,
        height: CGFloat = 50,
        resetDelay: Double = 2.0,
        action: @escaping () async -> Bool
    ) {
        self.title = title
        self._state = state
        self.loadingTitle = loadingTitle
        self.successTitle = successTitle
        self.failureTitle = failureTitle
        self.style = style
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.successColor = successColor
        self.failureColor = failureColor
        self.cornerRadius = cornerRadius
        self.height = height
        self.resetDelay = resetDelay
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            guard state == .idle else { return }
            Task {
                state = .loading
                let success = await action()
                withAnimation(.spring(response: 0.3)) {
                    state = success ? .success : .failure
                }
                try? await Task.sleep(nanoseconds: UInt64(resetDelay * 1_000_000_000))
                withAnimation(.spring(response: 0.3)) {
                    state = .idle
                }
            }
        } label: {
            HStack(spacing: 10) {
                stateIcon
                Text(currentTitle)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .foregroundStyle(foregroundColor)
            .background(currentBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .disabled(state != .idle)
        .animation(.spring(response: 0.4), value: state)
    }
    
    // MARK: - Computed Properties
    
    private var currentTitle: String {
        switch state {
        case .idle:
            return title
        case .loading:
            return loadingTitle ?? title
        case .success:
            return successTitle ?? "Success"
        case .failure:
            return failureTitle ?? "Failed"
        }
    }
    
    private var currentBackgroundColor: Color {
        switch state {
        case .idle, .loading:
            return backgroundColor
        case .success:
            return successColor
        case .failure:
            return failureColor
        }
    }
    
    @ViewBuilder
    private var stateIcon: some View {
        switch state {
        case .idle:
            EmptyView()
        case .loading:
            loadingIndicator
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .transition(.scale.combined(with: .opacity))
        case .failure:
            Image(systemName: "xmark.circle.fill")
                .transition(.scale.combined(with: .opacity))
        }
    }
    
    @ViewBuilder
    private var loadingIndicator: some View {
        switch style {
        case .spinner:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                .scaleEffect(0.9)
        case .dots:
            DotsLoadingView(color: foregroundColor, phase: $dotPhase)
        case .pulse:
            PulseLoadingView(color: foregroundColor, scale: $pulseScale)
        case .progress(let value):
            CircularProgressView(progress: value, color: foregroundColor)
        }
    }
}

// MARK: - Supporting Views

/// Animated dots loading indicator.
private struct DotsLoadingView: View {
    let color: Color
    @Binding var phase: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                    .scaleEffect(phase == index ? 1.3 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(Double(index) * 0.15),
                        value: phase
                    )
            }
        }
        .onAppear {
            withAnimation {
                phase = 2
            }
        }
    }
}

/// Pulsing loading indicator.
private struct PulseLoadingView: View {
    let color: Color
    @Binding var scale: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
            .scaleEffect(scale)
            .opacity(2 - scale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: false)
                ) {
                    scale = 1.8
                }
            }
    }
}

/// Circular progress indicator.
private struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 18, height: 18)
            .rotationEffect(.degrees(-90))
    }
}

#if DEBUG
struct LoadingButtonPreview: View {
    @State private var state1: LoadingButton.LoadingState = .idle
    @State private var state2: LoadingButton.LoadingState = .idle
    @State private var state3: LoadingButton.LoadingState = .idle
    
    var body: some View {
        VStack(spacing: 20) {
            LoadingButton("Submit", state: $state1) {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return true
            }
            
            LoadingButton(
                "Process Payment",
                state: $state2,
                loadingTitle: "Processing...",
                successTitle: "Payment Complete",
                style: .dots
            ) {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return true
            }
            
            LoadingButton(
                "Upload",
                state: $state3,
                style: .pulse,
                backgroundColor: .purple
            ) {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return false
            }
        }
        .padding()
    }
}

#Preview {
    LoadingButtonPreview()
}
#endif
