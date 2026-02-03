# SwiftUIComponents

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%20%7C%20macOS%2013-blue.svg)](https://developer.apple.com/swift/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)
[![Components](https://img.shields.io/badge/Components-100%2B-blueviolet.svg)](#-features)

A comprehensive collection of **100+ production-ready** SwiftUI components designed to accelerate your iOS development. Every component features full customization, accessibility support, and beautiful animations.

---

## ✨ Features

### 🔘 Buttons
| Component | Description |
|-----------|-------------|
| `PrimaryButton` | Customizable CTA button with loading states |
| `SecondaryButton` | Outline, subtle, ghost, and tinted variants |
| `IconButton` | Compact SF Symbol buttons |
| `LoadingButton` | Async action with success/failure states |
| `GradientButton` | Beautiful gradient backgrounds with shimmer |
| `FloatingActionButton` | Material Design FAB with expansion support |

### 🃏 Cards
| Component | Description |
|-----------|-------------|
| `CardView` | Flexible container with shadow and borders |
| `ExpandableCard` | Animated expand/collapse functionality |
| `FlipCard` | 3D flip animation between front/back |
| `GlassCard` | Glassmorphism effect with blur |
| `ActionCard` | Cards with integrated action buttons |

### ✏️ Text
| Component | Description |
|-----------|-------------|
| `GradientText` | Text with gradient color overlay |
| `AnimatedCounter` | Smooth number transitions |
| `TypewriterText` | Character-by-character typing animation |
| `HighlightedText` | Search result highlighting |
| `MarqueeText` | Auto-scrolling overflow text |

### 📝 Inputs
| Component | Description |
|-----------|-------------|
| `SearchBar` | Search with debounce support |
| `TagInput` | Multi-tag input with chips |
| `RatingInput` | Star ratings with half-star support |
| `PinInput` | OTP/PIN code entry fields |
| `PhoneInput` | International phone with country picker |
| `CreditCardInput` | Card entry with type detection |

### ⏳ Loading
| Component | Description |
|-----------|-------------|
| `ShimmerView` | Skeleton loading shimmer effect |
| `ProgressRing` | Circular progress indicators |
| `PulseLoader` | Animated pulse effects |
| `SkeletonView` | Pre-built skeleton templates |
| `DotLoader` | Multiple dot animation styles |

### 🔔 Toast & Notifications
| Component | Description |
|-----------|-------------|
| `ToastView` | Non-intrusive toast messages |
| `SnackBar` | Material Design snackbars |
| `Banner` | Full-width notification banners |

### 📋 Lists
| Component | Description |
|-----------|-------------|
| `SwipeableRow` | iOS-style swipe actions |
| `ExpandableList` | Collapsible sections |
| `ReorderableList` | Drag-to-reorder functionality |
| `InfiniteScrollList` | Automatic pagination |

### 📊 Charts
| Component | Description |
|-----------|-------------|
| `SparklineChart` | Compact inline line charts |
| `MiniBarChart` | Small bar visualizations |
| `RingChart` | Circular progress/proportion charts |

### 🧭 Navigation
| Component | Description |
|-----------|-------------|
| `TabBarView` | Custom tab bars with 4 styles |
| `SegmentedControl` | Enhanced segmented controls |
| `PageIndicator` | Page dots with 5 styles |
| `BreadcrumbView` | Hierarchical navigation paths |

### 🎭 Overlays
| Component | Description |
|-----------|-------------|
| `BottomSheet` | Draggable sheets with snap points |
| `Tooltip` | Contextual help tooltips |
| `ModalView` | Customizable modal presentations |

### 🎨 Miscellaneous
| Component | Description |
|-----------|-------------|
| `Badge` | Notification badges and labels |
| `Avatar` | User profile images/initials |
| `Chip` | Selectable/dismissible chips |
| `CustomDivider` | Styled dividers with labels |

---

## 📦 Installation

### Swift Package Manager

Add to your project through Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/muhittincamdali/SwiftUI-Components.git
   ```
3. Select **Up to Next Major Version** from `1.0.0`
4. Click **Add Package**

Or add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "1.0.0")
]
```

---

## 🚀 Quick Start

```swift
import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    @State private var rating: Double = 4.0
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 24) {
            GradientText("Welcome Back", colors: [.purple, .blue])
                .font(.largeTitle)
            
            RatingInput(rating: $rating, precision: .half)
            
            GradientButton("Get Started", gradient: .sunrise) {
                // Action
            }
        }
        .padding()
    }
}
```

---

## 📖 Component Examples

### Buttons

```swift
// Primary Button with loading state
PrimaryButton("Submit", isLoading: isLoading) {
    await performAction()
}

// Gradient Button with shimmer
GradientButton("Premium", gradient: .ocean, hasShimmer: true) { }

// Floating Action Button with sub-actions
FloatingActionButton(
    icon: Image(systemName: "plus"),
    actions: [
        .init(icon: Image(systemName: "camera"), label: "Camera") { },
        .init(icon: Image(systemName: "photo"), label: "Gallery") { }
    ]
)
```

### Cards

```swift
// Glass Card with blur effect
GlassCard(style: .frosted) {
    Text("Beautiful glassmorphism")
}

// Flip Card
FlipCard(isFlipped: $isFlipped) {
    Text("Front")
} back: {
    Text("Back")
}
```

### Inputs

```swift
// Star Rating
RatingInput(rating: $rating, precision: .half, symbolStyle: .heart)

// PIN Input
PinInput(code: $code, length: 6) { completed in
    verifyCode(completed)
}

// Credit Card
CreditCardInput(
    cardNumber: $number,
    expiryDate: $expiry,
    cvv: $cvv,
    cardholderName: $name
)
```

### Charts

```swift
// Sparkline
SparklineChart(data: [10, 25, 15, 30, 20], style: .gradient)
    .frame(width: 100, height: 30)

// Ring Chart
RingChart(segments: [
    .init(value: 60, color: .blue),
    .init(value: 40, color: .green)
]) {
    Text("Total").font(.caption)
}
```

### Navigation

```swift
// Custom Tab Bar
TabBarView(selectedIndex: $tab, items: [
    .init(icon: Image(systemName: "house"), title: "Home"),
    .init(icon: Image(systemName: "gear"), title: "Settings")
], style: .pill)

// Segmented Control
SegmentedControl(selectedIndex: $index, segments: ["Day", "Week", "Month"])
```

### Overlays

```swift
// Bottom Sheet
.bottomSheet(isPresented: $showSheet, detents: [.medium, .large]) {
    SheetContent()
}

// Tooltip
Text("Info")
    .tooltip("Helpful information appears here")
```

---

## 🎨 Customization

All components support extensive theming:

```swift
// Themed button
PrimaryButton(
    "Custom",
    backgroundColor: .brand,
    foregroundColor: .white,
    cornerRadius: 24,
    height: 56,
    font: .headline
) { }

// Custom glass card
GlassCard(
    style: .colorful(.purple),
    cornerRadius: 24,
    shadowRadius: 15
) { }
```

---

## 🏗️ Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

---

## 📁 Project Structure

```
Sources/SwiftUIComponents/
├── Buttons/          # Button components
├── Cards/            # Card layouts
├── Text/             # Text effects
├── Inputs/           # Form inputs
├── Loading/          # Loading indicators
├── Toast/            # Notifications
├── Lists/            # List components
├── Charts/           # Data visualization
├── Navigation/       # Nav components
├── Overlays/         # Sheets & modals
├── Misc/             # Badges, avatars, etc.
├── Modifiers/        # View modifiers
└── Extensions/       # SwiftUI extensions
```

---

## 🧪 Testing

Run the test suite:

```bash
swift test
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-component`)
3. Commit changes (`git commit -m 'feat: add amazing component'`)
4. Push to branch (`git push origin feature/amazing-component`)
5. Open a Pull Request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- Apple's SwiftUI framework
- The Swift community

---

Made with ❤️ by [Muhittin Camdali](https://github.com/muhittincamdali)
