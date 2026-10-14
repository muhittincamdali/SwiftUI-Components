<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-light.svg" alt="SwiftUI Components: Ready-made SwiftUI views for iOS and macOS: buttons, cards, charts, forms and more."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Latest version: v1.0.0 · predates main"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Supported platforms: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Language version: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="License: MIT"></picture></a>
</p>

<p align="center">
<a href="#quick-start"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-en-light.svg" alt="Get started"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-en-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-en-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-en-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-en-light.svg" alt="Examples"></picture></a>
</p>

<!-- brand:end -->

A Swift package of ready-made SwiftUI views for iOS 17+ and macOS 14+: buttons, cards, charts,
form inputs, lists, overlays, loaders and toasts. It is for app developers who want a working
component today instead of building it from scratch. Every component is a plain SwiftUI
`View` configured through its initializer, so you can use one or two of them without adopting
a theme system or an architecture. The package has no dependencies.

## Highlights

- **220 views, 12 modifiers** — counted from the sources and grouped in 13 folders, from
  `PrimaryButton` to `CreditCardInput` and `GaugeChart`.
- **iOS and macOS from one code base** — UIKit-only details fall back to the closest AppKit
  behaviour; the [platform notes](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  list each one.
- **Swift 6 language mode** — the package builds with strict concurrency checking and no
  warnings.
- **Tested logic** — card-number detection and the Luhn check, expiry dates, phone formatting,
  `FlowLayout` line breaking, chart geometry, pagination and the toast queues are covered by
  56 Swift Testing tests that run on macOS and an iPhone simulator.
- **Usage samples that compile** — every sample in the Usage section comes from the
  [example app](Examples/ComponentGallery), which CI builds for iOS and macOS.

### What's included

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

## Quick start

**1. Add the package**

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Paste it into the search field at the top right of the window. Set **Dependency Rule** to
**Branch** and type `main`, then click **Add Package**. In the next window, choose your app
target next to **SwiftUIComponents** and click **Add Package** again.

**2. Import the module**

```swift
import SwiftUIComponents
```

Put this line at the top of the Swift file where you use a component, below `import SwiftUI`.

**3. Use it**

In a new Xcode app (**File › New › Project… › App**), replace everything in `ContentView.swift`
with:

```swift
import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    @State private var rating = 3.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Rate this app")
                .font(.headline)
            RatingInput(rating: $rating)
            PrimaryButton("Send rating") {
                print("Rating: \(rating)")
            }
        }
        .padding()
    }
}
```

Press **Run** (⌘R). The app shows five stars and a blue button; tap a star to change the
rating, and tap the button to print it in Xcode's console.

## Installation

### Swift Package Manager

In Xcode, choose **File › Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Or add it to the `dependencies` in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

Use the `main` branch for now. The only release, 1.0.0 (February 2026), predates the current
components: in June 2026 they were replaced with placeholder code, and in October 2026 they
were restored, made to build for iOS and macOS in the Swift 6 language mode, and fixed where
the new tests found bugs. [CHANGELOG.md](CHANGELOG.md) has the details.

## Usage

The samples below are copied from
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift).
The example app and the test suite both compile that file.

### Buttons

```swift
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

## Demo

| Light                                                  | Dark                                                 |
| ------------------------------------------------------ | ---------------------------------------------------- |
| ![Buttons, light](docs/images/buttons-light.png)       | ![Buttons, dark](docs/images/buttons-dark.png)       |
| ![Cards, light](docs/images/cards-light.png)           | ![Cards, dark](docs/images/cards-dark.png)           |
| ![Charts, light](docs/images/charts-light.png)         | ![Charts, dark](docs/images/charts-dark.png)         |
| ![Indicators, light](docs/images/indicators-light.png) | ![Indicators, dark](docs/images/indicators-dark.png) |

The screenshots are rendered on the iOS simulator from
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
by [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

To try the components yourself, open `ComponentGallery.xcodeproj` in
[`Examples/ComponentGallery`](Examples/ComponentGallery) with Xcode, choose an iPhone simulator
or **My Mac**, and press **Run**. The app has one screen per sample
above; [Examples/README.md](Examples/README.md) has the details.

## Documentation

Reference documentation and articles:

- [API reference](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, published to GitHub Pages from `main`)
- Build it locally in Xcode with **Product › Build Documentation**, or from the command line:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — add the package, place a component, show snackbars and paginate a list
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — a payment form with validation, and what the checks do and do not cover
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — what changes on macOS
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

## Requirements

| Platform  | Minimum version       |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

CI builds with the default Xcode of GitHub's `macos-26` runner image. The package is developed
with Xcode 27.

## Architecture

- `Sources/SwiftUIComponents/<Category>/` holds one file per component family. Components keep
  their state in `@State` and `@Binding`; the only reference types are `SnackBarManager`,
  `BannerManager` and `PaginatedListViewModel`, all `@MainActor`.
- `Extensions/Platform.swift` maps the few UIKit-only APIs (system colors, haptics, keyboard
  type, capitalization, wheel pickers, paged `TabView`) to AppKit or to no-ops, so the
  components themselves contain almost no `#if os(...)`.
- Logic that can be tested without a screen lives in static functions or in the manager
  classes and is covered by Swift Testing suites in `Tests/`. `RenderTests` and
  `GaugeNeedleTests` render views with `ImageRenderer`: the gallery pages in light and dark
  mode (which catches views that crash or collapse to an empty size) and the gauge needle
  direction. Most individual views do not have their own tests.
- CI runs `swift test` on macOS, `xcodebuild test` on an iPhone simulator, builds the example
  app for iOS and macOS, and publishes the DocC documentation.

Run the tests locally:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roadmap

- Tag a release of the restored components, so the package can be added with a version rule
  instead of the `main` branch.
- Add the package to the Swift Package Index; `.spi.yml` is already in the repository.
- Write tests for more individual views, starting with the form inputs.

## Contributing

Contributions are welcome. Read the [contributing guide](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) and the [code of conduct](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) before opening a pull request. Report security issues privately as described in the [security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## License

Released under the MIT license. See [LICENSE](LICENSE).
