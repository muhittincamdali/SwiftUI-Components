# SwiftUI Components

[![CI](https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg)](https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml)

A Swift package of ready-made SwiftUI views — buttons, cards, charts, form inputs, lists,
overlays, loaders and toasts — for iOS 17+ and macOS 14+. No dependencies.

Every component is a plain SwiftUI `View` configured through its initializer, so you can use
one or two of them without adopting a theme system or an architecture.

| Light                                                  | Dark                                                 |
| ------------------------------------------------------ | ---------------------------------------------------- |
| ![Buttons, light](docs/images/buttons-light.png)       | ![Buttons, dark](docs/images/buttons-dark.png)       |
| ![Cards, light](docs/images/cards-light.png)           | ![Cards, dark](docs/images/cards-dark.png)           |
| ![Charts, light](docs/images/charts-light.png)         | ![Charts, dark](docs/images/charts-dark.png)         |
| ![Indicators, light](docs/images/indicators-light.png) | ![Indicators, dark](docs/images/indicators-dark.png) |

The screenshots are rendered on the iOS simulator from
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
by [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

## What's included

The package has 220 public view types and 12 view modifiers (counted from the sources),
grouped by folder:

| Category         | Examples                                                                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Buttons (25)     | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Cards (27)       | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Charts (19)      | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Forms (21)       | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `MultiSelectField`, `SliderField`, `RangeSlider`, `OTPField`, `DateField`        |
| Inputs (13)      | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Lists (18)       | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Loading (16)     | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navigation (19)  | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Overlays (13)    | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Text (17)        | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Toasts (4)       | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Misc (27)        | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Empty states (1) | `EmptyStateView`                                                                                                                                |

Layout and modifiers: `FlowLayout` (wrapping layout), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

## Requirements

- iOS 17 or macOS 14
- `swift-tools-version` 6.0; the package builds in the Swift 6 language mode. Developed with
  Xcode 27; CI uses the default Xcode of GitHub's `macos-26` runner

A few UIKit-only details (haptics, keyboard type, wheel pickers, paged `TabView`) fall back to
the nearest AppKit behaviour on macOS. The DocC article _Platform Differences_ lists them.

## Installation

Swift Package Manager, in Xcode via **File > Add Package Dependencies…** with
`https://github.com/muhittincamdali/SwiftUI-Components.git`, or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", branch: "main")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [.product(name: "SwiftUIComponents", package: "SwiftUI-Components")]
    )
]
```

## Usage

The samples below are copied from
[`Tests/SwiftUIComponentsTests/ReadmeExamples.swift`](Tests/SwiftUIComponentsTests/ReadmeExamples.swift),
so they are compiled on every test run.

### Buttons

```swift
import SwiftUI
import SwiftUIComponents

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
```

### Charts

```swift
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
```

### Payment form

`CreditCardInput` formats the number as you type, detects the card network and validates the
number (Luhn), expiry date, CVV length and cardholder name.

```swift
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
```

The formatting and validation helpers are public if you need them elsewhere:

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### Snackbars

```swift
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
```

Snackbars are queued and shown one at a time; `BannerManager` works the same way with
`.bannerHost()`, except that a new banner replaces the current one.

### Flow layout

```swift
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
```

## Documentation

API documentation is written as a DocC catalog in
[`Sources/SwiftUIComponents/SwiftUIComponents.docc`](Sources/SwiftUIComponents/SwiftUIComponents.docc).
Build it in Xcode with **Product > Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=iOS'
```

## How it is built and tested

- `Sources/SwiftUIComponents/<Category>/` holds one file per component family. Components keep
  their state in `@State`/`@Binding`; the only reference types are `SnackBarManager`,
  `BannerManager` and `PaginatedListViewModel`, all `@MainActor`.
- Logic that can be tested without a screen — card-number detection and formatting, the Luhn
  and expiry checks, phone formatting, rating hit-testing, highlight matching, `FlowLayout`
  line breaking, chart geometry, pagination and the toast queues — lives in static functions
  or the manager classes and is covered by Swift Testing suites in `Tests/`.
- `RenderTests` renders the gallery pages with `ImageRenderer` in light and dark mode, which
  catches views that crash or collapse to an empty size. Most individual views do not have
  their own tests.
- CI runs `swift test` on macOS and `xcodebuild test` on an iPhone simulator.

Run the tests locally:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## History

The components were first published in February 2026. A June 2026 cleanup replaced them with
placeholder code; they were restored in October 2026, made to compile for iOS and macOS in the
Swift 6 language mode, and several bugs found while adding tests were fixed. See
[CHANGELOG.md](CHANGELOG.md).

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
