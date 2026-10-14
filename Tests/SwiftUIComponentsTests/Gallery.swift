import SwiftUI
@testable import SwiftUIComponents

/// Static compositions of components, used for the README screenshots and render smoke tests.
/// Animations are disabled so the first rendered frame shows the final state.
enum Gallery: String, CaseIterable {
    case buttons
    case cards
    case charts
    case indicators

    @MainActor @ViewBuilder
    var view: some View {
        switch self {
        case .buttons: ButtonsGallery()
        case .cards: CardsGallery()
        case .charts: ChartsGallery()
        case .indicators: IndicatorsGallery()
        }
    }
}

private struct ButtonsGallery: View {
    var body: some View {
        VStack(spacing: 14) {
            PrimaryButton("Continue") {}
            HStack(spacing: 12) {
                SecondaryButton("Outline", style: .outline) {}
                SecondaryButton("Subtle", style: .subtle) {}
            }
            GradientButton("Upgrade", preset: .sunrise, icon: Image(systemName: "crown.fill")) {}
            HStack(spacing: 12) {
                PillButton("Follow", icon: "plus") {}
                IconButton(systemName: "heart.fill") {}
                IconButton(systemName: "square.and.arrow.up") {}
            }
            DestructiveButton("Delete account") {}
        }
    }
}

private struct CardsGallery: View {
    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Revenue",
                    value: "$12.4k",
                    icon: "dollarsign.circle.fill",
                    trend: .init(value: 8.2, isPositive: true),
                    color: .green
                )
                StatCard(
                    title: "Churn",
                    value: "2.1%",
                    icon: "person.crop.circle.badge.minus",
                    trend: .init(value: 0.4, isPositive: false),
                    color: .orange
                )
            }
            PricingCard(
                name: "Pro",
                price: "$9",
                description: "For small teams",
                features: [
                    .init("Unlimited projects"),
                    .init("Priority support"),
                    .init("SSO", included: false),
                ],
                isPopular: true
            ) {}
        }
    }
}

private struct ChartsGallery: View {
    var body: some View {
        VStack(spacing: 18) {
            BarChart(
                data: [
                    .init(value: 32, label: "Mon"),
                    .init(value: 45, label: "Tue"),
                    .init(value: 28, label: "Wed"),
                    .init(value: 52, label: "Thu"),
                    .init(value: 40, label: "Fri"),
                ],
                animate: false
            )
            .frame(height: 170)
            HStack(spacing: 16) {
                PieChart(
                    slices: [
                        .init(value: 45, label: "iOS", color: .blue),
                        .init(value: 35, label: "Android", color: .green),
                        .init(value: 20, label: "Web", color: .orange),
                    ],
                    showLegend: false,
                    innerRadius: 0.55,
                    animate: false
                )
                .frame(width: 140, height: 140)
                GaugeChart(value: 72, label: "CPU", animate: false)
                    .frame(width: 150, height: 120)
            }
            SparklineChart(data: [3, 5, 4, 7, 6, 9, 8, 11], style: .gradient, lineColor: .purple, animated: false)
                .frame(height: 60)
        }
    }
}

private struct IndicatorsGallery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            StepsIndicator(
                steps: [.init(title: "Cart"), .init(title: "Address"), .init(title: "Payment")],
                currentStep: 1
            )
            HStack(spacing: 14) {
                Avatar(initials: "MC", size: .large, showOnlineIndicator: true, isOnline: true)
                Avatar(initials: "JD", size: .large, backgroundColor: .purple)
                Badge("New", color: .green)
                Badge(count: 128)
            }
            FlowLayout(spacing: 8) {
                ForEach(["SwiftUI", "iOS", "macOS", "Accessibility", "Charts", "Forms"], id: \.self) {
                    Tag($0)
                }
            }
            HStack(spacing: 20) {
                ProgressRing(progress: 0.68)
                    .frame(width: 64, height: 64)
                RatingDisplay(rating: 4.5)
            }
            ToastView(message: "Profile saved", style: .success)
        }
    }
}

extension Gallery {
    /// Wraps a gallery page in a fixed-width, padded canvas for the given color scheme.
    @MainActor
    func canvas(colorScheme: ColorScheme) -> some View {
        view
            .padding(20)
            .frame(width: 390)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .environment(\.colorScheme, colorScheme)
    }
}
