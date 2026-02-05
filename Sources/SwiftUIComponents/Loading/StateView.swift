import SwiftUI

/// A view that handles different loading states
public struct StateView<Content: View, Loading: View, Empty: View, Error: View>: View {
    let state: ViewState
    @ViewBuilder let content: () -> Content
    @ViewBuilder let loading: () -> Loading
    @ViewBuilder let empty: () -> Empty
    @ViewBuilder let error: (Swift.Error) -> Error
    
    public enum ViewState {
        case idle
        case loading
        case loaded
        case empty
        case error(Swift.Error)
    }
    
    public init(
        state: ViewState,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder loading: @escaping () -> Loading,
        @ViewBuilder empty: @escaping () -> Empty,
        @ViewBuilder error: @escaping (Swift.Error) -> Error
    ) {
        self.state = state
        self.content = content
        self.loading = loading
        self.empty = empty
        self.error = error
    }
    
    public var body: some View {
        switch state {
        case .idle, .loaded:
            content()
        case .loading:
            loading()
        case .empty:
            empty()
        case .error(let err):
            error(err)
        }
    }
}

/// A simple async content loader
public struct AsyncContentView<T, Content: View, Loading: View>: View {
    let loader: () async throws -> T
    @ViewBuilder let content: (T) -> Content
    @ViewBuilder let loading: () -> Loading
    
    @State private var loadedData: T?
    @State private var isLoading = true
    @State private var error: Error?
    
    public init(
        loader: @escaping () async throws -> T,
        @ViewBuilder content: @escaping (T) -> Content,
        @ViewBuilder loading: @escaping () -> Loading
    ) {
        self.loader = loader
        self.content = content
        self.loading = loading
    }
    
    public var body: some View {
        Group {
            if isLoading {
                loading()
            } else if let data = loadedData {
                content(data)
            } else if let error = error {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("Error loading content")
                        .font(.headline)
                    
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Retry") {
                        Task {
                            await load()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .task {
            await load()
        }
    }
    
    private func load() async {
        isLoading = true
        error = nil
        
        do {
            loadedData = try await loader()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

/// A refresh control wrapper
public struct RefreshableView<Content: View>: View {
    let onRefresh: () async -> Void
    @ViewBuilder let content: () -> Content
    
    public init(
        onRefresh: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.onRefresh = onRefresh
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            content()
        }
        .refreshable {
            await onRefresh()
        }
    }
}

/// A retry view for error states
public struct RetryView: View {
    let message: String
    let buttonTitle: String
    let onRetry: () -> Void
    
    public init(
        message: String = "Something went wrong",
        buttonTitle: String = "Try Again",
        onRetry: @escaping () -> Void
    ) {
        self.message = message
        self.buttonTitle = buttonTitle
        self.onRetry = onRetry
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "arrow.clockwise.circle")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text(buttonTitle)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview("State Views") {
    VStack(spacing: 32) {
        // Loading state
        VStack {
            Text("Loading State")
                .font(.headline)
            
            StateView(state: .loading) {
                Text("Content")
            } loading: {
                ProgressView()
                    .scaleEffect(1.5)
            } empty: {
                Text("Empty")
            } error: { _ in
                Text("Error")
            }
        }
        .frame(height: 100)
        
        Divider()
        
        // Retry view
        RetryView(
            message: "Could not load data.\nPlease check your connection.",
            onRetry: {}
        )
    }
}
