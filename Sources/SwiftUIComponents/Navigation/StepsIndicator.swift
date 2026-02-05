import SwiftUI

/// A steps/progress indicator
public struct StepsIndicator: View {
    let steps: [Step]
    let currentStep: Int
    let style: StepsStyle
    
    public struct Step: Identifiable {
        public let id = UUID()
        let title: String
        let subtitle: String?
        let icon: String?
        
        public init(title: String, subtitle: String? = nil, icon: String? = nil) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
        }
    }
    
    public enum StepsStyle {
        case horizontal
        case vertical
        case numbered
        case icons
    }
    
    public init(steps: [Step], currentStep: Int, style: StepsStyle = .horizontal) {
        self.steps = steps
        self.currentStep = currentStep
        self.style = style
    }
    
    public var body: some View {
        switch style {
        case .horizontal:
            horizontalSteps
        case .vertical:
            verticalSteps
        case .numbered:
            numberedSteps
        case .icons:
            iconSteps
        }
    }
    
    private var horizontalSteps: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(spacing: 0) {
                    // Step circle
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(stepColor(for: index))
                                .frame(width: 32, height: 32)
                            
                            if index < currentStep {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(index == currentStep ? .white : .secondary)
                            }
                        }
                        
                        Text(step.title)
                            .font(.system(size: 11))
                            .foregroundColor(index <= currentStep ? .primary : .secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Connector line
                    if index < steps.count - 1 {
                        Rectangle()
                            .fill(index < currentStep ? Color.accentColor : Color(.systemGray4))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                            .offset(y: -12)
                    }
                }
            }
        }
    }
    
    private var verticalSteps: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 16) {
                    // Step indicator with line
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(stepColor(for: index))
                                .frame(width: 32, height: 32)
                            
                            if index < currentStep {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(index == currentStep ? .white : .secondary)
                            }
                        }
                        
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(index < currentStep ? Color.accentColor : Color(.systemGray4))
                                .frame(width: 2)
                                .frame(height: 40)
                        }
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(index <= currentStep ? .primary : .secondary)
                        
                        if let subtitle = step.subtitle {
                            Text(subtitle)
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var numberedSteps: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                VStack(spacing: 8) {
                    ZStack {
                        if index < currentStep {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Circle()
                                .stroke(index == currentStep ? Color.accentColor : Color(.systemGray4), lineWidth: 2)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(index == currentStep ? Color.accentColor.opacity(0.1) : Color.clear)
                                )
                            
                            Text("\(index + 1)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(index == currentStep ? .accentColor : .secondary)
                        }
                    }
                    
                    VStack(spacing: 2) {
                        Text(step.title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(index <= currentStep ? .primary : .secondary)
                        
                        if let subtitle = step.subtitle {
                            Text(subtitle)
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                    }
                    .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color.green : Color(.systemGray4))
                        .frame(height: 2)
                        .frame(maxWidth: 40)
                        .offset(y: -20)
                }
            }
        }
    }
    
    private var iconSteps: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(index <= currentStep ? Color.accentColor : Color(.systemGray5))
                            .frame(width: 48, height: 48)
                        
                        if let icon = step.icon {
                            Image(systemName: index < currentStep ? "checkmark" : icon)
                                .font(.system(size: 20))
                                .foregroundColor(index <= currentStep ? .white : .secondary)
                        } else {
                            Text("\(index + 1)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(index <= currentStep ? .white : .secondary)
                        }
                    }
                    
                    Text(step.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(index <= currentStep ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
                
                if index < steps.count - 1 {
                    VStack {
                        Rectangle()
                            .fill(index < currentStep ? Color.accentColor : Color(.systemGray4))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    .offset(y: -16)
                }
            }
        }
    }
    
    private func stepColor(for index: Int) -> Color {
        if index < currentStep {
            return .green
        } else if index == currentStep {
            return .accentColor
        } else {
            return Color(.systemGray4)
        }
    }
}

/// A wizard/stepper navigation
public struct WizardNavigation: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let onPrevious: (() -> Void)?
    let onNext: (() -> Void)?
    let onFinish: (() -> Void)?
    let previousLabel: String
    let nextLabel: String
    let finishLabel: String
    
    public init(
        currentStep: Binding<Int>,
        totalSteps: Int,
        onPrevious: (() -> Void)? = nil,
        onNext: (() -> Void)? = nil,
        onFinish: (() -> Void)? = nil,
        previousLabel: String = "Previous",
        nextLabel: String = "Next",
        finishLabel: String = "Finish"
    ) {
        self._currentStep = currentStep
        self.totalSteps = totalSteps
        self.onPrevious = onPrevious
        self.onNext = onNext
        self.onFinish = onFinish
        self.previousLabel = previousLabel
        self.nextLabel = nextLabel
        self.finishLabel = finishLabel
    }
    
    public var body: some View {
        HStack {
            // Previous button
            Button {
                if currentStep > 0 {
                    withAnimation {
                        currentStep -= 1
                    }
                    onPrevious?()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                    Text(previousLabel)
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(currentStep > 0 ? .accentColor : .secondary)
            }
            .disabled(currentStep == 0)
            
            Spacer()
            
            // Progress indicator
            Text("\(currentStep + 1) of \(totalSteps)")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Next/Finish button
            if currentStep < totalSteps - 1 {
                Button {
                    withAnimation {
                        currentStep += 1
                    }
                    onNext?()
                } label: {
                    HStack(spacing: 6) {
                        Text(nextLabel)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                }
            } else {
                Button(action: { onFinish?() }) {
                    Text(finishLabel)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

#Preview("Steps Indicators") {
    struct PreviewWrapper: View {
        @State private var currentStep = 1
        
        let steps: [StepsIndicator.Step] = [
            .init(title: "Details", icon: "person.fill"),
            .init(title: "Shipping", icon: "shippingbox.fill"),
            .init(title: "Payment", icon: "creditcard.fill"),
            .init(title: "Review", icon: "checkmark.circle.fill")
        ]
        
        var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Horizontal")
                            .font(.headline)
                        StepsIndicator(steps: steps, currentStep: currentStep, style: .horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Numbered")
                            .font(.headline)
                        StepsIndicator(steps: steps, currentStep: currentStep, style: .numbered)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Icons")
                            .font(.headline)
                        StepsIndicator(steps: steps, currentStep: currentStep, style: .icons)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Vertical")
                            .font(.headline)
                        StepsIndicator(
                            steps: [
                                .init(title: "Account Created", subtitle: "Your account has been set up"),
                                .init(title: "Verify Email", subtitle: "Check your inbox"),
                                .init(title: "Complete Profile", subtitle: "Add your details"),
                                .init(title: "Get Started", subtitle: "You're all set!")
                            ],
                            currentStep: currentStep,
                            style: .vertical
                        )
                    }
                    
                    Divider()
                    
                    WizardNavigation(
                        currentStep: $currentStep,
                        totalSteps: 4,
                        onFinish: {}
                    )
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
