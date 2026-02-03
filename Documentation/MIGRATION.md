# Migration Guide

This guide helps you migrate between major versions of SwiftUI-Components.

## Migrating from v1.x to v2.0

### Breaking Changes

#### 1. Button API Changes

**Before (v1.x):**
```swift
Button(title: "Submit", action: submit)
```

**After (v2.0):**
```swift
PrimaryButton(title: "Submit", action: submit)
// or
SecondaryButton(title: "Cancel", action: cancel)
```

#### 2. Card Style Properties

**Before (v1.x):**
```swift
Card(radius: 12, shadow: 8) {
    content
}
```

**After (v2.0):**
```swift
Card(style: .init(cornerRadius: 12, shadowRadius: 8)) {
    content
}
```

#### 3. Theme Configuration

**Before (v1.x):**
```swift
ComponentsConfig.primaryColor = .blue
ComponentsConfig.secondaryColor = .gray
```

**After (v2.0):**
```swift
ComponentsTheme.configure(Theme(
    colors: ColorPalette(
        primary: .blue,
        secondary: .gray
    )
))
```

### Deprecated APIs

The following APIs are deprecated in v2.0 and will be removed in v3.0:

| Deprecated | Replacement |
|------------|-------------|
| `SimpleButton` | `PrimaryButton` |
| `BasicCard` | `Card` |
| `LoadingView` | `Spinner` |
| `AlertView` | `StyledAlert` |

### New Features in v2.0

- Glassmorphism effects
- New animation system
- iOS 26 Liquid Glass support
- Enhanced accessibility
- Performance improvements

## Migrating from v0.x to v1.0

### Package Name Change

**Before (v0.x):**
```swift
import SwiftUIComponents
```

**After (v1.0):**
```swift
import SwiftUI_Components
```

### Initialization Changes

All components now require explicit initialization:

**Before:**
```swift
ButtonView("Submit")
```

**After:**
```swift
PrimaryButton(title: "Submit", action: { })
```

## Compatibility Matrix

| SwiftUI-Components | iOS | macOS | Xcode | Swift |
|-------------------|-----|-------|-------|-------|
| 2.0.x | 17.0+ | 14.0+ | 16.0+ | 5.9+ |
| 1.2.x | 16.0+ | 13.0+ | 15.0+ | 5.8+ |
| 1.1.x | 15.0+ | 12.0+ | 14.0+ | 5.7+ |
| 1.0.x | 15.0+ | 12.0+ | 14.0+ | 5.7+ |

## Getting Help

If you encounter issues during migration:

1. Check the [CHANGELOG](../CHANGELOG.md) for detailed changes
2. Search existing [GitHub Issues](https://github.com/muhittincamdali/SwiftUI-Components/issues)
3. Open a new issue with the `migration` label
