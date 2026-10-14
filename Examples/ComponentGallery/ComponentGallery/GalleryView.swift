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
        case signUp = "Validated form"
        case contactForm = "Form from JSON"
        case gestures = "Gestures"

        var id: Self { self }

        var systemImage: String {
            switch self {
            case .quickStart: "star"
            case .buttons: "button.horizontal"
            case .charts: "chart.bar"
            case .paymentForm: "creditcard"
            case .snackbars: "text.bubble"
            case .flowLayout: "square.grid.3x2"
            case .signUp: "checkmark.shield"
            case .contactForm: "doc.text"
            case .gestures: "hand.draw"
            }
        }

        /// InboxScreen is a List, which has no height of its own inside a ScrollView, and the
        /// gesture screen needs drags for itself rather than for scrolling.
        var scrolls: Bool { self != .snackbars && self != .gestures }

        @MainActor @ViewBuilder
        var screen: some View {
            switch self {
            case .quickStart: ContentView()
            case .buttons: CheckoutButtons()
            case .charts: WeeklyStats()
            case .paymentForm: PaymentForm()
            case .snackbars: InboxScreen()
            case .flowLayout: TopicPicker().padding()
            case .signUp: SignUpForm()
            case .contactForm:
                if let schema = try? loadContactSchema() {
                    ContactForm(schema: schema)
                } else {
                    Text("The form description could not be read.")
                }
            case .gestures: GestureDemo()
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
