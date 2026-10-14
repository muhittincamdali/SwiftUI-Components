import SwiftUI

/// A list with automatic pagination and infinite scrolling.
///
/// `InfiniteScrollList` loads more content as the user scrolls
/// near the bottom of the list.
///
/// ```swift
/// InfiniteScrollList(
///     items: items,
///     isLoading: isLoading,
///     hasMore: hasMore,
///     loadMore: { await fetchMore() }
/// ) { item in
///     Text(item.title)
/// }
/// ```
public struct InfiniteScrollList<Item: Identifiable, RowContent: View>: View {
    // MARK: - Properties
    
    private let items: [Item]
    private let isLoading: Bool
    private let hasMore: Bool
    private let loadThreshold: Int
    private let loadMore: () async -> Void
    private let rowContent: (Item) -> RowContent
    private let loadingIndicator: AnyView?
    private let emptyView: AnyView?
    private let errorView: AnyView?
    private let error: Error?
    
    // MARK: - Initialization
    
    /// Creates a new infinite scroll list.
    /// - Parameters:
    ///   - items: The current items to display.
    ///   - isLoading: Whether more items are being loaded.
    ///   - hasMore: Whether more items are available.
    ///   - error: Current error, if any.
    ///   - loadThreshold: Items from end to trigger load. Defaults to `3`.
    ///   - loadMore: Async function to load more items.
    ///   - rowContent: The row content builder.
    public init(
        items: [Item],
        isLoading: Bool,
        hasMore: Bool,
        error: Error? = nil,
        loadThreshold: Int = 3,
        loadMore: @escaping () async -> Void,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.items = items
        self.isLoading = isLoading
        self.hasMore = hasMore
        self.error = error
        self.loadThreshold = loadThreshold
        self.loadMore = loadMore
        self.rowContent = rowContent
        self.loadingIndicator = nil
        self.emptyView = nil
        self.errorView = nil
    }
    
    /// Creates an infinite scroll list with custom views.
    public init<Loading: View, Empty: View, ErrorV: View>(
        items: [Item],
        isLoading: Bool,
        hasMore: Bool,
        error: Error? = nil,
        loadThreshold: Int = 3,
        loadMore: @escaping () async -> Void,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent,
        @ViewBuilder loadingIndicator: () -> Loading,
        @ViewBuilder emptyView: () -> Empty,
        @ViewBuilder errorView: () -> ErrorV
    ) {
        self.items = items
        self.isLoading = isLoading
        self.hasMore = hasMore
        self.error = error
        self.loadThreshold = loadThreshold
        self.loadMore = loadMore
        self.rowContent = rowContent
        self.loadingIndicator = AnyView(loadingIndicator())
        self.emptyView = AnyView(emptyView())
        self.errorView = AnyView(errorView())
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if items.isEmpty && !isLoading {
                emptyStateView
            } else if let error, items.isEmpty {
                errorStateView(error)
            } else {
                contentView
            }
        }
    }
    
    // MARK: - Content View
    
    private var contentView: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                rowContent(item)
                    .onAppear {
                        checkLoadMore(index: index)
                    }
            }
            
            if isLoading {
                loadingView
            }
            
            if !hasMore && !items.isEmpty {
                endOfListView
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        Group {
            if let custom = loadingIndicator {
                custom
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        Group {
            if let custom = emptyView {
                custom
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No items")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
    
    // MARK: - Error State View
    
    private func errorStateView(_ error: Error) -> some View {
        Group {
            if let custom = errorView {
                custom
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text("Error loading items")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task { await loadMore() }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
    
    // MARK: - End of List View
    
    private var endOfListView: some View {
        HStack {
            Spacer()
            Text("End of list")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding()
            Spacer()
        }
    }
    
    // MARK: - Load More Check
    
    private func checkLoadMore(index: Int) {
        guard hasMore && !isLoading else { return }
        
        let threshold = items.count - loadThreshold
        if index >= threshold {
            Task {
                await loadMore()
            }
        }
    }
}

// MARK: - Paginated List View Model

/// A view model for managing paginated list state.
@MainActor
public final class PaginatedListViewModel<Item: Identifiable>: ObservableObject {
    @Published public private(set) var items: [Item] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var hasMore: Bool = true
    @Published public private(set) var error: Error?
    
    private var currentPage: Int = 0
    private let pageSize: Int
    private let fetchPage: (Int, Int) async throws -> [Item]
    
    public init(
        pageSize: Int = 20,
        fetchPage: @escaping (Int, Int) async throws -> [Item]
    ) {
        self.pageSize = pageSize
        self.fetchPage = fetchPage
    }
    
    /// Loads the next page of items.
    public func loadMore() async {
        guard !isLoading && hasMore else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newItems = try await fetchPage(currentPage, pageSize)
            items.append(contentsOf: newItems)
            currentPage += 1
            hasMore = newItems.count >= pageSize
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    /// Refreshes the list from the beginning.
    public func refresh() async {
        items = []
        currentPage = 0
        hasMore = true
        error = nil
        await loadMore()
    }
}

// MARK: - Pull to Refresh Wrapper

/// A wrapper that adds pull-to-refresh to an infinite scroll list.
public struct RefreshableInfiniteList<Item: Identifiable, RowContent: View>: View {
    @ObservedObject private var viewModel: PaginatedListViewModel<Item>
    private let rowContent: (Item) -> RowContent
    
    public init(
        viewModel: PaginatedListViewModel<Item>,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.viewModel = viewModel
        self.rowContent = rowContent
    }
    
    public var body: some View {
        ScrollView {
            InfiniteScrollList(
                items: viewModel.items,
                isLoading: viewModel.isLoading,
                hasMore: viewModel.hasMore,
                error: viewModel.error,
                loadMore: { await viewModel.loadMore() },
                rowContent: rowContent
            )
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.items.isEmpty {
                await viewModel.loadMore()
            }
        }
    }
}

#if DEBUG
struct InfiniteScrollListPreview: View {
    struct MockItem: Identifiable {
        let id = UUID()
        let title: String
    }
    
    @State private var items: [MockItem] = (1...10).map { MockItem(title: "Item \($0)") }
    @State private var isLoading = false
    @State private var hasMore = true
    @State private var page = 1
    
    var body: some View {
        ScrollView {
            InfiniteScrollList(
                items: items,
                isLoading: isLoading,
                hasMore: hasMore,
                loadMore: loadMore
            ) { item in
                HStack {
                    Circle()
                        .fill(.blue.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Text(item.title)
                        .font(.body)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
            }
        }
    }
    
    private func loadMore() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newItems = ((page * 10 + 1)...(page * 10 + 10)).map { MockItem(title: "Item \($0)") }
        items.append(contentsOf: newItems)
        page += 1
        hasMore = page < 5
        
        isLoading = false
    }
}

#Preview {
    InfiniteScrollListPreview()
}
#endif
