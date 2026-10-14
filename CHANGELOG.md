# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2026-10-14

Form validation, gestures and a contrast checker, merged from three of the author's packages
that are being archived: SwiftUI-Forms-Kit, SwiftUI-Gesture-Library and iOSUIComponents. The
code was rewritten for this package's style and tests rather than copied. No existing API
changed in a breaking way.

### Added

- Validation: `Validator` with `required`, `minLength`, `maxLength`, `email`, `url`, `phone`,
  `digits`, `matches`, `equals`, `range`, `atLeast`, `atMost`, `notEmpty`, `count`, `custom`
  and the combinators `and`, `or` and `all`; `ValidationResult`; `ValidatedValue`, which shows
  an error only after an edit or a submit; `AsyncValidation`, a debounced check that ignores
  answers for outdated values.
- `FormSchema`, `FormValue` and `SchemaForm`: forms described in JSON, checked on decoding
  (duplicate ids, choices without options, impossible limits, invalid regular expressions,
  more fields, patterns or options than the size limits allow) and rendered with the package's
  fields. Every regular expression, in a schema or in `Validator.matches`, runs on
  `NSRegularExpression` with a 20 ms limit per match, a 1,000 UTF-16 code unit input limit and a
  100 ms budget per `errors(in:)` call.
- `StepFlow` and `MultiStepForm` for forms split into steps.
- Gestures: `.onSwipe`, `.onSwipeSequence`, `.onEdgeSwipe`, `.transformable` (pinch, rotate,
  drag and double-tap reset), `.boundedDrag`, `ShapeDrawingPad` and `UnistrokeRecognizer`
  (the $1 recognizer with $N's handling of straight lines), with the testable rules
  `SwipeDirection`, `SwipeSequenceMatcher`, `EdgeSwipe`, `TransformState` and `DragBounds`.
  Each gesture has an accessibility action.
- `ColorContrast`: WCAG 2 contrast ratio and AA/AAA level for SwiftUI colors and hex codes.
- `FileUploadField.UploadedFile.url`, public `name`, `size` and `type`, the
  `FileUploadField.Rejection` reasons and an `onRejected` callback.
- Example app screens for the validated form, the JSON form and the gestures; a `-sample`
  launch argument that opens one of them; `scripts/capture-example-screens.sh`, which captures
  them on a simulator for the README; and the DocC articles "Validating Forms" and "Adding
  Gestures".

### Changed

- `OTPField`, `SecurePINField` and `PinInput` keep only ASCII digits (or ASCII letters and
  digits for `PinInput(inputType: .alphanumeric)`) and filter pasted text before cutting it
  to length, so `"123-456"` fills all six cells.

### Fixed

- `FileUploadField` added made-up demo files instead of opening a file picker. It now opens
  the system file importer, accepts dropped files and enforces `allowedTypes`, `maxFileSize`
  and `maxFiles`.
- `PinInput` with `.numeric` input undid its own length limit, so pasted text longer than
  `length` stayed in the binding and `onComplete` never ran; `OTPField` and `SecurePINField`
  could call `onComplete` twice for one paste.
- `PinInput(isSecure: true)` masked the boxes but kept the PIN in a plain text field, where
  keyboard suggestions and VoiceOver could still reach it. It now uses a secure field, as
  `SecurePINField` does.
- NaN, infinite or very large values no longer stop the app in `ProgressCard`,
  `ProgressRingChart`, `CountdownTimer`, `Stopwatch`, `ProgressTimer`, `DurationPicker`,
  `ReorderableList`, the toast, snackbar and banner durations, `LoadingButton` and
  `VerticalMarqueeText`. A zero or negative interval no longer makes a repeating animation
  spin.
- Zero or negative counts no longer stop the app in `DotLoader`, `SkeletonView`,
  `PageIndicator`, `ScrollingPageIndicator`, `CheckboxGroup`, `TimeSlotPicker`, `StatGrid`,
  `OTPField`, `SecurePINField`, `PinInput` and `PasscodeInput`.
- A `maxRating` below 1 in `RatingInput` and `RatingDisplay`, and a `maxItems` or `maxVisible`
  below 3 in `BreadcrumbView` and `DropdownBreadcrumb`, no longer stop the app; they are raised
  to those minimums.
- A negative `maxVisible` in `AvatarGroup` or `maxPoints` in `LiveSparklineChart` no longer
  stops the app; it is treated as 0.
- `ReadingTimeText` with a `wordsPerMinute` of 0 divided by zero; the speed is now at least 1.
- A `step` that is zero, negative, NaN, infinite or larger than the range no longer stops the
  app in `SliderField` and `SliderRatingInput`, including `SliderRatingInput(range: 5...5)` with
  its default step; the slider then moves without steps. The pill and gradient `SliderField`
  styles count steps from the lower bound and stay inside the range.
- `TexturedGlassCard` drew one noise dot per ten square points without limit; it now draws at
  most 4,000.

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

[Unreleased]: https://github.com/muhittincamdali/SwiftUI-Components/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/muhittincamdali/SwiftUI-Components/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/muhittincamdali/SwiftUI-Components/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/SwiftUI-Components/releases/tag/v1.0.0
