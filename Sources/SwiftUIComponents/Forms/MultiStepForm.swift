import SwiftUI

/// A form split into steps, with a step indicator on top and Back / Next buttons below.
///
/// The Next button stays disabled while `canAdvance` returns `false` for the current step, so
/// the user cannot skip a step with invalid input. On the last step the button reads
/// `finishTitle` and calls `onFinish`.
///
/// ```swift
/// @State private var flow = StepFlow(count: 2)
///
/// MultiStepForm(
///     flow: $flow,
///     steps: [.init(title: "Account"), .init(title: "Profile")],
///     canAdvance: { step in step == 0 ? email.isValid : name.isValid },
///     onFinish: { submit() }
/// ) { step in
///     if step == 0 { AccountStep(email: $email) } else { ProfileStep(name: $name) }
/// }
/// ```
public struct MultiStepForm<Content: View>: View {
    @Binding private var flow: StepFlow
    private let steps: [StepsIndicator.Step]
    private let canAdvance: (Int) -> Bool
    private let onFinish: () -> Void
    private let backTitle: String
    private let nextTitle: String
    private let finishTitle: String
    private let content: (Int) -> Content

    /// Creates a multi-step form.
    ///
    /// - Parameters:
    ///   - flow: The step state. Its `count` should match `steps.count`.
    ///   - steps: Titles (and optional subtitles and icons) for the step indicator.
    ///   - canAdvance: Whether the user may leave the given step with Next or Finish.
    ///   - backTitle: The title of the button that returns to the previous step.
    ///   - nextTitle: The title of the button that moves to the next step.
    ///   - finishTitle: The title of that button on the last step.
    ///   - onFinish: Called when the user taps Finish on the last step.
    ///   - content: The view for the given step index.
    public init(
        flow: Binding<StepFlow>,
        steps: [StepsIndicator.Step],
        canAdvance: @escaping (Int) -> Bool = { _ in true },
        backTitle: String = "Back",
        nextTitle: String = "Next",
        finishTitle: String = "Finish",
        onFinish: @escaping () -> Void,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self._flow = flow
        self.steps = steps
        self.canAdvance = canAdvance
        self.backTitle = backTitle
        self.nextTitle = nextTitle
        self.finishTitle = finishTitle
        self.onFinish = onFinish
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 24) {
            StepsIndicator(steps: steps, currentStep: flow.current, style: .horizontal)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(stepLabel)

            content(flow.current)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .id(flow.current)
                .transition(.opacity)

            HStack(spacing: 12) {
                if !flow.isFirst {
                    SecondaryButton(backTitle, isFullWidth: true) {
                        withAnimation { _ = flow.goBack() }
                    }
                }
                PrimaryButton(
                    flow.isLast ? finishTitle : nextTitle,
                    isDisabled: !canAdvance(flow.current)
                ) {
                    advance()
                }
            }
        }
    }

    private var stepLabel: String {
        let title = steps.indices.contains(flow.current) ? steps[flow.current].title : ""
        return "Step \(flow.current + 1) of \(flow.count): \(title)"
    }

    private func advance() {
        guard canAdvance(flow.current) else { return }
        if flow.isLast {
            flow.advance()
            onFinish()
        } else {
            withAnimation { _ = flow.advance() }
        }
    }
}
