import SwiftUI
import SwiftUIComponents

/// One screen per README sample, so each sample can be tried on a device or the simulator.
struct GalleryView: View {
    private enum Sample: String, CaseIterable, Identifiable {
        case quickStart = "Quick start"
        case buttons = "Buttons"
        case charts = "Charts"
        case paymentForm = "Payment form"
        case snackbars = "Snackbars"
        case flowLayout = "Flow layout"

        var id: Self { self }

        var systemImage: String {
            switch self {
            case .quickStart: "star"
            case .buttons: "button.horizontal"
            case .charts: "chart.bar"
            case .paymentForm: "creditcard"
            case .snackbars: "text.bubble"
            case .flowLayout: "square.grid.3x2"
            }
        }

        /// InboxScreen is a List, which has no height of its own inside a ScrollView.
        var scrolls: Bool { self != .snackbars }

        @MainActor @ViewBuilder
        var screen: some View {
            switch self {
            case .quickStart: ContentView()
            case .buttons: CheckoutButtons()
            case .charts: WeeklyStats()
            case .paymentForm: PaymentForm()
            case .snackbars: InboxScreen()
            case .flowLayout: TopicPicker().padding()
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(Sample.allCases) { sample in
                NavigationLink(value: sample) {
                    Label(sample.rawValue, systemImage: sample.systemImage)
                }
            }
            .navigationTitle("SwiftUIComponents")
            .navigationDestination(for: Sample.self) { sample in
                Group {
                    if sample.scrolls {
                        ScrollView {
                            sample.screen
                                .frame(maxWidth: 600)
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        sample.screen
                    }
                }
                .navigationTitle(sample.rawValue)
            }
        }
    }
}

#Preview {
    GalleryView()
}
