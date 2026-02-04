<p align="center">
  <img src="Assets/logo.png" alt="SwiftUI Components" width="200"/>
</p>

<h1 align="center">SwiftUI Components</h1>

<p align="center">
  <strong>🎯 100+ production-ready SwiftUI components for modern iOS apps</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift"/>
  <img src="https://img.shields.io/badge/iOS-17.0+-blue.svg" alt="iOS"/>
</p>

---

## Component Categories

| Category | Count |
|----------|-------|
| **Buttons** | 15+ |
| **Cards** | 10+ |
| **Lists** | 12+ |
| **Inputs** | 20+ |
| **Navigation** | 8+ |
| **Feedback** | 15+ |
| **Media** | 10+ |
| **Layout** | 10+ |

## Usage

```swift
import SwiftUIComponents

// Buttons
PrimaryButton("Submit", action: submit)
GhostButton("Cancel", action: cancel)
IconButton(.heart, action: like)

// Cards
ProductCard(product: product)
ProfileCard(user: user)
StatCard(title: "Revenue", value: "$12,345")

// Lists
InfiniteList(items: items) { item in
    ItemRow(item: item)
}

// Inputs
SearchBar(text: $query)
RatingInput(value: $rating)
TagInput(tags: $tags)

// Feedback
Toast("Saved!", type: .success)
Skeleton()
EmptyState(message: "No items")
```

## Customization

All components support:
- Custom colors
- Custom fonts
- Custom spacing
- Dark mode
- Accessibility

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License

---

## 📈 Star History

<a href="https://star-history.com/#muhittincamdali/SwiftUI-Components&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=muhittincamdali/SwiftUI-Components&type=Date" />
 </picture>
</a>
