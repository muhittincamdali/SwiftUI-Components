# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-14

The component library that was removed in June 2026 (commit `c7b3799`) is back, now building
for iOS 17 and macOS 14 in the Swift 6 language mode, with real tests and CI.

### Added

- Restored the components from `a1c7bb0`: 220 public views and 12 view modifiers across
  buttons, cards, charts, forms, inputs, lists, loading, navigation, overlays, text, toasts and
  miscellaneous views.
- macOS 14 support through small platform shims (system colors, haptics, keyboard type,
  capitalization, wheel pickers, paged `TabView`).
- `KeyboardKind` to choose the software keyboard of `TextInputField` without UIKit types.
- Public static helpers: `CreditCardInput.CardType.detect(from:)`,
  `CreditCardInput.formatCardNumber(_:)`, `formatExpiry(_:)`, `checkExpiry(_:now:calendar:)`,
  `isLuhnValid(_:)`, `PhoneInput.format(_:pattern:)`, `PhoneInput.hasValidLength(_:)`,
  `HighlightedText.matchRanges(in:terms:caseSensitive:)`, `FlowLayout.arrange(sizes:maxWidth:spacing:)`.
- Public initializers for `SnackBarManager` and `BannerManager`, and `SnackBarManager.pendingCount`.
- Swift Testing suites for the logic above, pagination, the toast managers, and render tests
  for four gallery pages in light and dark mode.
- README screenshots rendered on the iOS simulator, and `scripts/generate-screenshots.sh`.
- DocC catalog with an overview, a getting-started article, an article on collecting card
  details and platform notes, published to GitHub Pages by the `Documentation` workflow. The
  site leaves out the SwiftUI `View` members each view inherits.
- `Examples/ComponentGallery`, an iOS and macOS app with one screen per README sample; the
  README samples are compiled by the app and by the tests.
- README translations into Turkish, Simplified Chinese, Japanese, Korean, Spanish, German,
  French, Brazilian Portuguese and Russian, and a generated banner, badges and buttons.
- `.spi.yml` for the Swift Package Index.

### Changed

- **Breaking:** minimum platforms are now iOS 17 and macOS 14 (was iOS 16 / macOS 13 in 1.0.0).
- `swift-tools-version` 6.2 (Xcode 26, the version CI builds with) and Swift 6 language
  mode; the restored code uses iOS 17 APIs such as `onChange(of:initial:_:)`. tvOS, watchOS
  and visionOS were removed from the manifest because the package was never built for them.
- `TextInputField(keyboardType:)` now takes a `KeyboardKind` instead of `UIKeyboardType`.
- `FlowLayout` is a single public type in `Layout/FlowLayout.swift` (three copies existed).
- `HighlightedText` builds an `AttributedString`, so highlight backgrounds actually render.
- CI runs through the shared workflows in `muhittincamdali/.github`: `swift test` on macOS,
  `xcodebuild` builds for iOS and macOS, `xcodebuild test` on an iPhone simulator, DocC to
  GitHub Pages, link, wording and translation checks. A repository workflow builds the example
  app. All actions are pinned to commit SHAs, with no `continue-on-error`.
- The code of conduct, security policy and issue forms come from `muhittincamdali/.github`
  instead of local copies.

### Fixed

- Repeating timers in `InlineLoader`, `LoadingText`, `TimedPinInput`, `TypewriterText`,
  `Carousel` and `VerticalMarqueeText` kept running after the view disappeared.
- `BannerManager.show(_:)` cleared the new banner about 0.25 s after showing it;
  `SnackBarManager` had the same race when a snackbar was shown during the exit animation.
- `PaginatedListViewModel.refresh()` did nothing while a page was loading.
- `.toast(isPresenting:)` could be hidden early by the timer of a previous toast.
- `CreditCardInput` crashed on input such as "½" in the Luhn check, did not recognise
  Mastercard 2-series or Diners Club 300–305/39 numbers, and grouped Amex numbers as 4-4-4-4.
- `RatingInput` in `.exact` mode reported half a star too much while dragging.
- `GaugeChart` needle pointed away from the value.
- `SparklineChart` with one value and `PieChart` with a zero total produced NaN geometry.
- `PricingCard` period label was unreadable on the highlighted header.
- `SnapCarousel` used `UIScreen` bounds instead of its own viewport; `ExpandableText`
  measured truncation with a fixed body font.

### Removed

- Placeholder `Enterprise/` utilities (circuit breaker, retry policy, event bus, metrics) and
  `GlassLibrary`, which only printed a message.
- `Documentation/`, `Examples/` and `Templates/`, which described APIs that do not exist or
  did not compile.
- The CocoaPods podspec (it declared iOS 15 and was never validated).
- Placeholder tests that only asserted values were non-nil, and the unused SwiftLint config.

## [1.0.0] - 2026-02-03

First tagged version: 14 source files (buttons, cards, inputs, loading views, text effects and
toasts) for iOS 16 and macOS 13. Most of the components listed above were added after this
tag: 37 source files later on 2026-02-03 (`ca55bc5`) and 49 on 2026-02-05 (`80e7649`).

[Unreleased]: https://github.com/muhittincamdali/SwiftUI-Components/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/muhittincamdali/SwiftUI-Components/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/SwiftUI-Components/releases/tag/v1.0.0
