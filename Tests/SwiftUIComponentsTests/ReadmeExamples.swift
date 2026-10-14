// The code samples in README.md are copied from this file, so every sample is
// compiled by `swift test`. Keep the two in sync when changing either.

import SwiftUI
import SwiftUIComponents

// README: Buttons
struct CheckoutButtons: View {
    @State private var payState: LoadingButton.LoadingState = .idle

    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton("Continue") {
                print("Continue tapped")
            }

            LoadingButton("Pay $9.99", state: $payState) {
                try? await Task.sleep(for: .seconds(1))
                return true // false shows the failure state
            }
        }
        .padding()
    }
}

// README: Charts
struct WeeklyStats: View {
    var body: some View {
        VStack(spacing: 24) {
            BarChart(data: [
                .init(value: 32, label: "Mon"),
                .init(value: 45, label: "Tue"),
                .init(value: 28, label: "Wed"),
            ])
            .frame(height: 180)

            SparklineChart(data: [3, 5, 4, 7, 6, 9], style: .gradient, lineColor: .purple)
                .frame(height: 50)
        }
        .padding()
    }
}

// README: Payment form
struct PaymentForm: View {
    @State private var number = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var canPay = false

    var body: some View {
        VStack {
            CreditCardInput(
                cardNumber: $number,
                expiryDate: $expiry,
                cvv: $cvv,
                cardholderName: $name,
                onValidationChange: { canPay = $0 }
            )
            PrimaryButton("Pay", isDisabled: !canPay) {}
        }
        .padding()
    }
}

// README: Card helpers
func cardHelpers() {
    let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
    let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
    let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
    print(type, pretty, valid)
}

// README: Snackbars
struct InboxScreen: View {
    var body: some View {
        List {
            Button("Archive") {
                SnackBarManager.shared.show(message: "Conversation archived", style: .success)
            }
        }
        .snackBarHost()
    }
}

// README: Flow layout
struct TopicPicker: View {
    let topics = ["SwiftUI", "Combine", "Concurrency", "Testing", "Accessibility"]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(topics, id: \.self) { topic in
                Tag(topic)
            }
        }
    }
}

/// Renderable subset used by `RenderTests.readmeExamplesRender`.
struct ReadmeExamples: View {
    var body: some View {
        VStack {
            CheckoutButtons()
            WeeklyStats()
            TopicPicker()
        }
    }
}
