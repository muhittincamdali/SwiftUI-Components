import Foundation
import Testing
@testable import SwiftUIComponents

private struct Row: Identifiable, Equatable {
    let id: Int
}

private struct FetchError: Error {}

@MainActor
@Suite("PaginatedListViewModel")
struct PaginatedListViewModelTests {
    @Test func loadsPagesUntilAShortPage() async {
        let model = PaginatedListViewModel<Row>(pageSize: 2) { page, size in
            let all = (0..<5).map(Row.init)
            return Array(all.dropFirst(page * size).prefix(size))
        }

        await model.loadMore()
        await model.loadMore()
        #expect(model.items.map(\.id) == [0, 1, 2, 3])
        #expect(model.hasMore)

        await model.loadMore()
        #expect(model.items.map(\.id) == [0, 1, 2, 3, 4])
        #expect(!model.hasMore)

        await model.loadMore()
        #expect(model.items.count == 5)
    }

    @Test func keepsItemsAndReportsErrorOnFailure() async {
        var shouldFail = false
        let model = PaginatedListViewModel<Row>(pageSize: 1) { page, _ in
            if shouldFail { throw FetchError() }
            return [Row(id: page)]
        }

        await model.loadMore()
        shouldFail = true
        await model.loadMore()

        #expect(model.items == [Row(id: 0)])
        #expect(model.error is FetchError)
        #expect(!model.isLoading)

        shouldFail = false
        await model.loadMore()
        #expect(model.items == [Row(id: 0), Row(id: 1)])
        #expect(model.error == nil)
    }

    @Test func refreshStartsOverFromPageZero() async {
        var requestedPages: [Int] = []
        let model = PaginatedListViewModel<Row>(pageSize: 1) { page, _ in
            requestedPages.append(page)
            return [Row(id: page)]
        }

        await model.loadMore()
        await model.loadMore()
        await model.refresh()

        #expect(requestedPages == [0, 1, 0])
        #expect(model.items == [Row(id: 0)])
    }

    @Test func refreshDiscardsAPageThatWasInFlight() async {
        let gate = Gate()
        var calls = 0
        let model = PaginatedListViewModel<Row>(pageSize: 1) { page, _ in
            calls += 1
            if calls == 1 {
                await gate.wait()
                return [Row(id: 100)]
            }
            return [Row(id: page)]
        }

        let slowLoad = Task { await model.loadMore() }
        await Task.yield()
        #expect(model.isLoading)

        await model.refresh()
        await gate.open()
        await slowLoad.value

        #expect(model.items == [Row(id: 0)])
        #expect(!model.isLoading)
    }
}

/// Suspends callers until `open()` is called.
private actor Gate {
    private var continuations: [CheckedContinuation<Void, Never>] = []
    private var isOpen = false

    func wait() async {
        if isOpen { return }
        await withCheckedContinuation { continuations.append($0) }
    }

    func open() {
        isOpen = true
        continuations.forEach { $0.resume() }
        continuations.removeAll()
    }
}

@MainActor
@Suite("Toast managers")
struct ToastManagerTests {
    /// The managers clear their current item 250-300 ms after `dismiss()`.
    private static let exitAnimation: Duration = .milliseconds(300)

    /// Polls until `condition` holds, so a slow CI machine only makes the test slower, not red.
    ///
    /// The rendering suite runs at the same time and holds the main actor for seconds per page on
    /// a CI simulator. The manager's clear task and this loop both wait for the main actor then, so
    /// the deadline can pass while the clear task is still queued behind the render. After the
    /// deadline the loop therefore waits once more, long enough for an exit animation, and only
    /// fails if the condition still does not hold.
    private func waitUntil(
        timeout: Duration = .seconds(30),
        _ condition: () -> Bool,
        sourceLocation: SourceLocation = #_sourceLocation
    ) async throws {
        let deadline = ContinuousClock.now + timeout
        while !condition() {
            if ContinuousClock.now >= deadline {
                try await Task.sleep(for: Self.exitAnimation)
                if condition() { return }
                Issue.record("Condition not met within \(timeout)", sourceLocation: sourceLocation)
                return
            }
            try await Task.sleep(for: .milliseconds(10))
        }
    }

    /// Waits past the exit animation before checking that something did *not* happen.
    /// A slow machine can only delay the clear, so this cannot fail spuriously.
    private func waitPastExitAnimation() async throws {
        try await Task.sleep(for: Self.exitAnimation * 2)
    }

    @Test func snackBarsAreShownInOrder() async throws {
        let manager = SnackBarManager()
        manager.show(message: "first", duration: 60)
        manager.show(message: "second", duration: 60)

        #expect(manager.currentSnackBar?.message == "first")
        #expect(manager.pendingCount == 1)

        manager.dismiss()
        try await waitUntil { manager.currentSnackBar?.message == "second" }

        #expect(manager.currentSnackBar?.message == "second")
        #expect(manager.isShowing)
        #expect(manager.pendingCount == 0)
    }

    @Test func snackBarShownDuringExitAnimationStaysVisible() async throws {
        let manager = SnackBarManager()
        manager.show(message: "first", duration: 60)
        manager.dismiss()
        manager.show(message: "second", duration: 60)
        try await waitPastExitAnimation()

        #expect(manager.currentSnackBar?.message == "second")
        #expect(manager.isShowing)
    }

    @Test func snackBarDismissesItselfAfterDuration() async throws {
        let manager = SnackBarManager()
        manager.show(message: "short", duration: 0.05)
        try await waitUntil { manager.currentSnackBar == nil }

        #expect(!manager.isShowing)
        #expect(manager.currentSnackBar == nil)
    }

    @Test func bannerSurvivesItsOwnShowCall() async throws {
        let manager = BannerManager()
        manager.show(title: "Saved", duration: nil)
        try await waitPastExitAnimation()

        #expect(manager.currentBanner?.title == "Saved")
        #expect(manager.isShowing)
    }

    @Test func newBannerReplacesTheCurrentOne() async throws {
        let manager = BannerManager()
        manager.show(title: "One", duration: nil)
        manager.show(title: "Two", duration: nil)
        try await waitPastExitAnimation()

        #expect(manager.currentBanner?.title == "Two")
    }

    @Test func bannerClearsAfterDismiss() async throws {
        let manager = BannerManager()
        manager.show(title: "Bye", duration: nil)
        manager.dismiss()
        try await waitUntil { manager.currentBanner == nil }

        #expect(manager.currentBanner == nil)
        #expect(!manager.isShowing)
    }
}

/// `Ticker` drives the repeating animations in the loaders, text effects, PIN countdown and
/// carousel. These views rely on it returning once their `.task` is cancelled.
///
/// No time limit: these tests run on the main actor, and Swift Testing counts the time a test
/// waits for it. The rendering suites keep the main actor busy for 30 seconds or more on a CI
/// simulator, so a one-minute limit failed tests that never got to run. Each test below ends on
/// its own instead, even when `Ticker` is broken.
@MainActor
@Suite("Ticker")
struct TickerTests {
    /// Ends the loop in tests that would otherwise tick forever if `Ticker` failed to stop.
    private static let tickLimit = 100

    /// Sleeps without leaving the main actor, so the loop does not wait for a timer.
    @Test func stopsWhenTickReturnsFalse() async {
        var ticks = 0
        var sleeps: [Duration] = []
        await Ticker.run(every: 0.25, sleep: { sleeps.append($0) }) {
            ticks += 1
            return ticks < 3
        }
        #expect(ticks == 3)
        #expect(sleeps == Array(repeating: .milliseconds(250), count: 3))
    }

    @Test func stopsWhenSleepThrows() async {
        var ticks = 0
        await Ticker.run(every: 0.25, sleep: { _ in
            if ticks == 2 { throw CancellationError() }
        }) {
            ticks += 1
            return ticks < Self.tickLimit
        }
        #expect(ticks == 2)
    }

    /// Uses the real `Task.sleep`. The task cancels itself on the second tick; a `Ticker` that
    /// ignored the cancellation would keep going until the tick limit and fail the expectation.
    @Test func stopsWhenItsTaskIsCancelled() async {
        var ticks = 0
        let task = Task { @MainActor in
            await Ticker.run(every: 0.001) {
                ticks += 1
                if ticks == 2 {
                    withUnsafeCurrentTask { $0?.cancel() }
                }
                return ticks < Self.tickLimit
            }
        }
        await task.value
        #expect(ticks == 2)
    }
}
