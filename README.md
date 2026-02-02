# SwiftUIComponents

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%20%7C%20macOS%2013-blue.svg)](https://developer.apple.com/swift/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

A collection of reusable, customizable SwiftUI components designed to speed up your development workflow. Built with performance and accessibility in mind.

---

## ✨ Features

| Category | Components | Description |
|----------|-----------|-------------|
| **Buttons** | `PrimaryButton`, `IconButton` | Customizable buttons with loading states and icon support |
| **Cards** | `CardView`, `ExpandableCard` | Flexible card layouts with shadow, corner radius, expand/collapse |
| **Text** | `GradientText`, `AnimatedCounter` | Eye-catching text effects and animated number transitions |
| **Inputs** | `SearchBar`, `TagInput` | Search with debounce, multi-tag input with removal |
| **Loading** | `ShimmerView`, `ProgressRing` | Skeleton loading placeholders and circular progress indicators |
| **Toast** | `ToastView`, `ToastModifier` | Non-intrusive toast notifications with multiple styles |
| **Modifiers** | `ConditionalModifier` | Apply modifiers conditionally without breaking the chain |
| **Extensions** | `View+Extensions` | Handy view extensions for common patterns |

---

## 📦 Installation

### Swift Package Manager

Add SwiftUIComponents to your project through Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/muhittincamdali/SwiftUI-Components.git
   ```
3. Select **Up to Next Major Version** starting from `1.0.0`
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "1.0.0")
]
```

Then add `SwiftUIComponents` to your target dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftUIComponents"]
)
```

---

## 🚀 Quick Start

```swift
import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            GradientText(
                "Welcome Back",
                colors: [.purple, .blue]
            )
            .font(.largeTitle)

            PrimaryButton(
                "Get Started",
                isLoading: isLoading
            ) {
                isLoading = true
            }
        }
    }
}
```

---

## 📖 Usage Examples

### PrimaryButton

A fully customizable button with built-in loading state support.

```swift
PrimaryButton(
    "Submit",
    backgroundColor: .blue,
    foregroundColor: .white,
    cornerRadius: 12,
    isLoading: isLoading
) {
    performAction()
}

// Disabled state
PrimaryButton("Disabled", isDisabled: true) { }
```

### IconButton

Compact button with SF Symbol icon support.

```swift
IconButton(systemName: "heart.fill", size: 44, color: .red) {
    toggleFavorite()
}
```

### CardView

A container with customizable shadow, corner radius, and padding.

```swift
CardView(cornerRadius: 16, shadowRadius: 8, shadowColor: .black.opacity(0.1)) {
    VStack(alignment: .leading, spacing: 8) {
        Text("Card Title")
            .font(.headline)
        Text("Card description goes here.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
```

### ExpandableCard

An animated card that expands and collapses on tap.

```swift
ExpandableCard(
    title: "More Details",
    subtitle: "Tap to expand"
) {
    Text("This content is revealed when the card is expanded.")
        .padding(.top, 8)
}
```

### GradientText

Apply gradient colors to any text.

```swift
GradientText("Hello World", colors: [.red, .orange, .yellow])
    .font(.title)
```

### AnimatedCounter

Smoothly animate between number values.

```swift
@State private var count: Double = 0

AnimatedCounter(value: count, format: "%.0f")
    .font(.system(size: 48, weight: .bold))

Button("Increment") { count += 100 }
```

### SearchBar

A search bar with customizable placeholder and clear button.

```swift
@State private var query = ""

SearchBar(text: $query, placeholder: "Search products...")
```

### TagInput

Multi-tag input field with add/remove functionality.

```swift
@State private var tags: [String] = ["Swift", "iOS"]

TagInput(tags: $tags, placeholder: "Add tag...")
```

### ShimmerView

Skeleton loading placeholder with animated shimmer effect.

```swift
ShimmerView()
    .frame(height: 200)
    .clipShape(RoundedRectangle(cornerRadius: 12))
```

### ProgressRing

Circular progress indicator with customizable colors and line width.

```swift
ProgressRing(progress: 0.75, lineWidth: 8, gradient: [.blue, .purple])
    .frame(width: 100, height: 100)
```

### Toast Notifications

Display non-intrusive toast messages.

```swift
@State private var showToast = false

VStack {
    Button("Show Toast") { showToast = true }
}
.toast(isPresenting: $showToast, message: "Saved successfully!", style: .success)
```

### ConditionalModifier

Apply modifiers conditionally.

```swift
Text("Hello")
    .conditionalModifier(isHighlighted) { view in
        view.foregroundStyle(.red).bold()
    }
```

### View Extensions

```swift
// Corner radius with specific corners
Text("Rounded")
    .cornerRadius(12, corners: [.topLeft, .topRight])

// Visible/hidden toggle
Text("Maybe visible")
    .visible(shouldShow)

// Read geometry
Text("Measured")
    .readSize { size in
        print("Size: \(size)")
    }
```

---

## 📚 API Reference

### Buttons

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `PrimaryButton` | `title`, `backgroundColor`, `foregroundColor`, `cornerRadius`, `isLoading`, `isDisabled`, `action` | Customizable button with loading spinner |
| `IconButton` | `systemName`, `size`, `color`, `backgroundColor`, `action` | SF Symbol icon button |

### Cards

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `CardView` | `cornerRadius`, `shadowRadius`, `shadowColor`, `backgroundColor`, `padding`, `content` | Container card with shadow |
| `ExpandableCard` | `title`, `subtitle`, `headerColor`, `content` | Animated expand/collapse card |

### Text

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `GradientText` | `text`, `colors`, `startPoint`, `endPoint` | Text with gradient overlay |
| `AnimatedCounter` | `value`, `format`, `duration` | Smooth number animation |

### Inputs

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `SearchBar` | `text`, `placeholder`, `backgroundColor` | Search input with clear button |
| `TagInput` | `tags`, `placeholder`, `tagColor`, `maxTags` | Multi-tag input with chips |

### Loading

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `ShimmerView` | `baseColor`, `highlightColor`, `speed` | Skeleton loading shimmer |
| `ProgressRing` | `progress`, `lineWidth`, `gradient`, `backgroundColor` | Circular progress ring |

### Toast

| Component | Parameters | Description |
|-----------|-----------|-------------|
| `ToastView` | `message`, `style`, `icon` | Toast notification view |
| `.toast()` | `isPresenting`, `message`, `style`, `duration` | View modifier for toasts |

---

## 🎨 Customization

All components support extensive customization through initializer parameters. Colors, sizes, animations, and behaviors can be adjusted to match your design system.

```swift
// Example: Fully themed PrimaryButton
PrimaryButton(
    "Custom Button",
    backgroundColor: .init(red: 0.2, green: 0.5, blue: 0.9),
    foregroundColor: .white,
    cornerRadius: 24,
    isLoading: false
) {
    // action
}
```

---

## 🏗️ Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/new-component`)
3. Commit your changes (`git commit -m 'feat: add new component'`)
4. Push to the branch (`git push origin feature/new-component`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Apple's SwiftUI framework and documentation
- The Swift community for inspiration and feedback

---

Made with ❤️ by [Muhittin Camdali](https://github.com/muhittincamdali)
