# ``SwiftUIComponents``

Ready-made SwiftUI views for buttons, cards, charts, forms, lists, overlays and feedback, for iOS 17 and macOS 14.

## Overview

SwiftUIComponents is a single Swift package with no dependencies. Each component is a plain
SwiftUI `View` (or a `ViewModifier`) configured through its initializer, so you can drop it
into an existing screen without adopting an architecture or a theme system.

```swift
import SwiftUI
import SwiftUIComponents

struct SettingsFooter: View {
    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton("Save") { }
            DestructiveButton("Delete account") { }
        }
    }
}
```

Some components contain logic that is worth calling directly, for example
``CreditCardInput/formatCardNumber(_:)``, ``CreditCardInput/isLuhnValid(_:)`` or
``FlowLayout/arrange(sizes:maxWidth:spacing:)``. These are static functions and are covered
by the package's unit tests.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:CollectingCardDetails>
- <doc:PlatformDifferences>

### Buttons

- ``PrimaryButton``
- ``SecondaryButton``
- ``LoadingButton``
- ``GradientButton``
- ``PillButton``
- ``IconButton``
- ``DestructiveButton``
- ``FloatingActionButton``
- ``SplitButton``
- ``ToggleButton``

### Cards

- ``CardView``
- ``StatCard``
- ``PricingCard``
- ``ProfileCard``
- ``ProductCard``
- ``FlipCard``
- ``ExpandableCard``
- ``GlassCard``

### Charts

- ``BarChart``
- ``PieChart``
- ``SparklineChart``
- ``GaugeChart``
- ``RingChart``
- ``AreaChart``
- ``MiniBarChart``

### Forms and Inputs

- ``CreditCardInput``
- ``PhoneInput``
- ``PinInput``
- ``OTPField``
- ``RatingInput``
- ``SearchBar``
- ``TagInput``
- ``TextInputField``
- ``SelectField``
- ``SliderField``
- ``CheckboxGroup``
- ``RadioGroup``
- ``KeyboardKind``

### Lists

- ``InfiniteScrollList``
- ``PaginatedListViewModel``
- ``ExpandableList``
- ``SwipeableRow``
- ``ReorderableList``
- ``GroupedList``

### Navigation

- ``SegmentedControl``
- ``StepsIndicator``
- ``PageIndicator``
- ``BreadcrumbView``
- ``CustomTabBar``

### Overlays and Feedback

- ``BottomSheet``
- ``AlertDialog``
- ``Tooltip``
- ``ToastView``
- ``SnackBarManager``
- ``BannerManager``

### Loading and Empty States

- ``ProgressRing``
- ``SkeletonView``
- ``ShimmerView``
- ``DotLoader``
- ``EmptyStateView``

### Text and Display

- ``HighlightedText``
- ``ExpandableText``
- ``TypewriterText``
- ``MarqueeText``
- ``AnimatedCounter``
- ``Avatar``
- ``Badge``
- ``Chip``
- ``Tag``

### Layout and Modifiers

- ``FlowLayout``
- ``SurfaceModifier``
