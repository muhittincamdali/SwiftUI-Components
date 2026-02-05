<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift"/>
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS"/>
  <img src="https://img.shields.io/badge/macOS-14.0+-purple.svg" alt="macOS"/>
  <img src="https://img.shields.io/badge/Components-100+-green.svg" alt="Components"/>
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="License"/>
</p>

<h1 align="center">🎨 SwiftUI Components</h1>

<p align="center">
  <strong>A comprehensive library of 100+ production-ready SwiftUI components</strong><br/>
  Build beautiful iOS & macOS apps faster with pre-built, customizable UI components
</p>

---

## ✨ Features

- 🎯 **100+ Real Components** - No placeholders, every component is fully functional
- 🌙 **Dark Mode Support** - All components adapt to light/dark mode automatically
- ♿️ **Accessibility Ready** - VoiceOver and Dynamic Type support built-in
- 📱 **iOS & macOS** - Works on all Apple platforms
- 🎨 **Highly Customizable** - Every component supports extensive customization
- 📖 **SwiftUI Previews** - Live previews for every component
- 🧪 **Well Tested** - Comprehensive test coverage

---

## 📦 Component Categories

| Category | Components | Description |
|----------|------------|-------------|
| **Buttons** | 17 | Primary, Secondary, Ghost, Icon, Social, Animated, Toggle, Split, Neumorphic, and more |
| **Cards** | 15 | Profile, Product, Stat, Pricing, Feature, Testimonial, Media, Notification, Event, Dashboard |
| **Forms** | 8 | FormField, SelectField, CheckboxGroup, RadioGroup, SliderField, DateTimeField, FileUpload, OTPField |
| **Charts** | 7 | Area, Line, Bar, Pie, Donut, Gauge, MultiRing Progress |
| **Navigation** | 7 | NavigationBar, TabBar, Steps, Breadcrumb, Menu, Sidebar, Pagination |
| **Loading** | 7 | Skeleton, Shimmer, Pulse, Dot, Progress Ring, Content Loader, State View |
| **Misc** | 9 | Avatar, Badge, Chip, Timer, Countdown, Carousel, Accordion, Quote, Tag |
| **Lists** | 6 | Grouped, Selectable, Collapsible, Swipeable, Horizontal, Snap |
| **Text** | 6 | Gradient, Animated Counter, Typewriter, Highlighted, Marquee, Expandable |
| **Inputs** | 6 | Search, Rating, Tag, Phone, Credit Card, PIN |
| **Overlays** | 5 | Bottom Sheet, Modal, Tooltip, Alert Dialog, Popover |
| **Toast** | 4 | Toast, Snackbar, Banner, Notification |
| **Empty States** | 1 | Comprehensive empty state with multiple styles |

---

## 🚀 Installation

### Swift Package Manager

Add SwiftUI Components to your project through Xcode:

1. File → Add Packages...
2. Enter the repository URL:
```
https://github.com/muhittincamdali/SwiftUI-Components.git
```
3. Select "Up to Next Major Version" with "1.0.0"

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "1.0.0")
]
```

---

## 📖 Usage

### Import the library

```swift
import SwiftUIComponents
```

### Buttons

```swift
// Primary button with loading state
PrimaryButton("Submit", isLoading: $isLoading) {
    await submitForm()
}

// Social login buttons
SocialButton(.apple) { await signInWithApple() }
SocialButton(.google) { await signInWithGoogle() }

// Animated buttons
AnimatedButton("Save", icon: "checkmark", animation: .bounce) {
    save()
}

// Toggle button
ToggleButton(
    isOn: $isFollowing,
    onLabel: "Following",
    offLabel: "Follow"
)
```

### Cards

```swift
// Profile card with stats
ProfileCard(
    name: "John Doe",
    subtitle: "iOS Developer",
    stats: [
        .init(value: "1.2K", label: "Posts"),
        .init(value: "45K", label: "Followers")
    ],
    style: .expanded
)

// Product card
ProductCard(
    title: "MacBook Pro",
    price: "$2,499",
    originalPrice: "$2,799",
    rating: 4.9,
    badge: "SALE",
    onAddToCart: { }
)

// Stat cards for dashboards
StatCard(
    title: "Revenue",
    value: "$124,500",
    icon: "dollarsign.circle",
    trend: .init(value: 12.5, isPositive: true)
)
```

### Forms

```swift
// Form field with validation
FormField(label: "Email", isRequired: true, errorMessage: emailError) {
    TextInputField(text: $email, placeholder: "Enter email", icon: "envelope")
}

// OTP input
OTPField(code: $otpCode, length: 6, style: .boxes) { code in
    verifyCode(code)
}

// Multi-select
MultiSelectField(
    selections: $selectedTags,
    options: [("swift", "Swift"), ("swiftui", "SwiftUI"), ("ios", "iOS")],
    placeholder: "Select tags"
)
```

### Charts

```swift
// Area chart
AreaChart(
    data: [10, 25, 15, 40, 30, 55],
    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
    color: .blue
)

// Pie/Donut chart
DonutChart(
    slices: [
        .init(value: 60, label: "Complete", color: .green),
        .init(value: 25, label: "In Progress", color: .blue),
        .init(value: 15, label: "Pending", color: .orange)
    ],
    centerValue: "85%",
    centerLabel: "Done"
)

// Gauge
GaugeChart(value: 72, maxValue: 100, label: "Speed")
```

### Empty States

```swift
// No results
EmptyStateView.noResults(action: .init("Clear Search") { clearSearch() })

// No connection
EmptyStateView.noConnection(action: .init("Retry") { retry() })

// Custom empty state
EmptyStateView(
    title: "No Messages",
    message: "Start a conversation",
    illustration: .messages,
    action: .init("New Message", icon: "plus") { }
)
```

### Loading States

```swift
// Content loader
ContentLoader(style: .card)
ContentLoader(style: .list)
ContentLoader(style: .profile)

// Loading overlay
ZStack {
    YourContent()
    LoadingOverlay(isLoading: $isLoading, message: "Saving...")
}
```

---

## 🎨 Customization

All components support extensive customization through initializer parameters:

```swift
// Custom colors
PrimaryButton("Submit", color: .purple) { }

// Custom styles
Tag("Swift", style: .outlined, color: .orange)

// Custom sizes
CircleButton(icon: "plus", size: .large, style: .filled(.blue)) { }
```

---

## 📱 Requirements

- iOS 17.0+
- macOS 14.0+
- Xcode 15.0+
- Swift 6.0+

---

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/SwiftUI-Components&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date" />
 </picture>
</a>

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/muhittincamdali">Muhittin Camdali</a>
</p>
