import Foundation
import Testing
@testable import SwiftUIComponents

/// Counts calls from any isolation domain.
private actor CallCounter {
    private(set) var calls: [String] = []
    func record(_ value: String) { calls.append(value) }
}

@MainActor
@Suite("AsyncValidation")
struct AsyncValidationTests {
    private func waitUntilChecking(_ validation: AsyncValidation<String>) async {
        while validation.state != .checking { await Task.yield() }
    }

    @Test func reportsValidAndInvalidResults() async {
        let validation = AsyncValidation<String>(debounce: .zero) { name in
            name == "taken" ? .invalid("This name is taken") : .valid
        }
        await validation.validate("free")
        #expect(validation.state == .valid)
        #expect(validation.isValid)

        await validation.validate("taken")
        #expect(validation.state == .invalid("This name is taken"))
        #expect(validation.message == "This name is taken")
    }

    @Test func thrownErrorsBecomeFailures() async {
        let validation = AsyncValidation<String>(debounce: .zero) { _ in
            throw URLError(.notConnectedToInternet)
        }
        await validation.validate("ada")
        guard case .failed(let message) = validation.state else {
            Issue.record("expected .failed, got \(validation.state)")
            return
        }
        #expect(!message.isEmpty)
        #expect(validation.message == message)
        #expect(!validation.isValid)
    }

    @Test func aNewerValueWinsOverASlowerOlderCheck() async {
        let validation = AsyncValidation<String>(debounce: .zero) { name in
            if name == "slow" {
                try? await Task.sleep(for: .milliseconds(150))
                return .invalid("outdated answer")
            }
            return .valid
        }
        let slow = Task { await validation.validate("slow") }
        await waitUntilChecking(validation)
        await validation.validate("fast")
        await slow.value
        #expect(validation.state == .valid)
    }

    @Test func cancellingDuringTheDebounceSkipsTheCheck() async {
        let counter = CallCounter()
        let validation = AsyncValidation<String>(debounce: .seconds(30)) { name in
            await counter.record(name)
            return .valid
        }
        let typing = Task { await validation.validate("a") }
        await waitUntilChecking(validation)
        typing.cancel()
        await typing.value

        #expect(validation.state == .idle)
        #expect(await counter.calls.isEmpty)
    }

    @Test func resetDropsAPendingAnswer() async {
        let validation = AsyncValidation<String>(debounce: .zero) { _ in
            try? await Task.sleep(for: .milliseconds(100))
            return .invalid("late")
        }
        let pending = Task { await validation.validate("x") }
        await waitUntilChecking(validation)
        validation.reset()
        await pending.value
        #expect(validation.state == .idle)
    }
}

@Suite("StepFlow")
struct StepFlowTests {
    @Test func initializerClampsCountAndCurrent() {
        #expect(StepFlow(count: 0).count == 1)
        #expect(StepFlow(count: 3, current: 7).current == 2)
        #expect(StepFlow(count: 3, current: -1).current == 0)
    }

    @Test func advanceMarksStepsAndStopsAtTheLast() {
        var flow = StepFlow(count: 3)
        #expect(flow.isFirst && !flow.isLast)
        let movedToSecond = flow.advance()
        #expect(movedToSecond)
        let movedToThird = flow.advance()
        #expect(movedToThird)
        #expect(flow.current == 2 && flow.isLast)
        #expect(!flow.isFinished)
        #expect(flow.progress == 2.0 / 3.0)

        let movedPastLast = flow.advance()
        #expect(!movedPastLast)
        #expect(flow.current == 2)
        #expect(flow.isFinished)
        #expect(flow.progress == 1)
    }

    @Test func goBackKeepsCompletedSteps() {
        var flow = StepFlow(count: 3)
        flow.advance()
        flow.advance()
        let wentBackOnce = flow.goBack()
        #expect(wentBackOnce)
        #expect(flow.current == 1)
        #expect(flow.completed == [0, 1])
        let wentBackTwice = flow.goBack()
        #expect(wentBackTwice)
        let wentBeforeFirst = flow.goBack()
        #expect(!wentBeforeFirst)
    }

    @Test func jumpOnlyReachesStepsWhosePredecessorsAreDone() {
        var flow = StepFlow(count: 4)
        #expect(!flow.canJump(to: 2))
        let jumpedEarly = flow.jump(to: 2)
        #expect(!jumpedEarly)
        flow.advance()
        flow.advance()
        flow.goBack()
        flow.goBack()
        let jumpedAfterCompleting = flow.jump(to: 2)
        #expect(jumpedAfterCompleting)
        #expect(flow.current == 2)
        #expect(!flow.canJump(to: 3))
        #expect(!flow.canJump(to: 4))
        #expect(!flow.canJump(to: -1))
    }

    @Test func restartClearsProgress() {
        var flow = StepFlow(count: 2)
        flow.advance()
        flow.advance()
        flow.restart()
        #expect(flow == StepFlow(count: 2))
    }
}
