# Architecture Guide

This document describes the architecture and design principles behind SwiftUI-Components.

## Design Principles

### 1. Composability

Components are designed to be composable and work well together.

```swift
Card {
    VStack {
        AsyncImage(url: imageURL)
        Text("Title")
        PrimaryButton(title: "Action") { }
    }
}
```

### 2. Customizability

Every component supports extensive customization through style objects.

```swift
// Using style presets
PrimaryButton(title: "Submit", style: .large)

// Custom styles
PrimaryButton(
    title: "Submit",
    style: ButtonStyle(
        backgroundColor: .purple,
        foregroundColor: .white,
        cornerRadius: 16,
        padding: .init(horizontal: 24, vertical: 12)
    )
)
```

### 3. Accessibility First

All components are accessible by default.

- VoiceOver support
- Dynamic Type support
- Reduce Motion support
- High Contrast support

### 4. Performance

Components are optimized for performance.

- Lazy loading where applicable
- Efficient view updates
- Memory management
- Image caching

## Component Structure

Each component follows a consistent structure:

```
ComponentName/
├── ComponentName.swift          # Main component
├── ComponentNameStyle.swift     # Style configuration
├── ComponentName+Modifiers.swift # View modifiers
├── ComponentName+Previews.swift # SwiftUI previews
└── README.md                    # Component documentation
```

### Main Component File

```swift
import SwiftUI

/// A brief description of the component.
public struct ComponentName<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let style: ComponentStyle
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory
    
    // MARK: - Initialization
    
    public init(
        style: ComponentStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .modifier(ComponentModifier(style: style))
    }
}
```

### Style Configuration

```swift
public struct ComponentStyle {
    public let backgroundColor: Color
    public let foregroundColor: Color
    public let cornerRadius: CGFloat
    public let padding: EdgeInsets
    public let font: Font
    
    public static let `default` = ComponentStyle(
        backgroundColor: .white,
        foregroundColor: .primary,
        cornerRadius: 12,
        padding: .init(all: 16),
        font: .body
    )
}
```

## Theming System

### Theme Protocol

```swift
public protocol Themeable {
    var colors: ColorPalette { get }
    var typography: Typography { get }
    var spacing: Spacing { get }
    var corners: CornerRadii { get }
}
```

### Using Themes

```swift
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.theme, CustomTheme())
        }
    }
}
```

## State Management

### Local State

For component-local state, use `@State`:

```swift
struct ExpandableCard: View {
    @State private var isExpanded = false
    
    var body: some View {
        // ...
    }
}
```

### External State

For state shared with parent views, use `@Binding`:

```swift
struct ExpandableCard: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        // ...
    }
}
```

### Environment Values

For app-wide configuration:

```swift
struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
```

## Testing Strategy

### Unit Tests

Test component logic in isolation:

```swift
final class CardStyleTests: XCTestCase {
    func testDefaultStyle() {
        let style = CardStyle.default
        XCTAssertEqual(style.cornerRadius, 12)
    }
}
```

### Snapshot Tests

Test component appearance:

```swift
func testPrimaryButtonAppearance() {
    let button = PrimaryButton(title: "Test") { }
    assertSnapshot(matching: button, as: .image)
}
```

### Accessibility Tests

Test accessibility features:

```swift
func testButtonAccessibility() {
    let button = PrimaryButton(title: "Submit") { }
    XCTAssertTrue(button.isAccessibilityElement)
    XCTAssertEqual(button.accessibilityLabel, "Submit")
}
```

## Performance Considerations

### Lazy Loading

Use lazy containers for lists:

```swift
LazyVStack {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}
```

### Image Caching

Images are cached automatically:

```swift
CachedAsyncImage(url: imageURL)
    // Uses URLCache and in-memory cache
```

### View Identity

Maintain stable view identity:

```swift
ForEach(items, id: \.id) { item in
    // Stable identity prevents unnecessary rebuilds
}
```

## Error Handling

### Graceful Degradation

Components handle errors gracefully:

```swift
CachedAsyncImage(url: url)
    .placeholder {
        Image(systemName: "photo")
    }
    .errorView { error in
        Text("Failed to load image")
    }
```

### Validation

Form components provide validation:

```swift
TextField("Email", text: $email)
    .validation(.email)
    .onValidationChange { isValid in
        submitButton.isEnabled = isValid
    }
```

## Best Practices

1. **Use View Composition** - Combine simple components to build complex UIs
2. **Leverage Environment** - Use environment values for theme and configuration
3. **Optimize for Performance** - Use lazy loading and avoid unnecessary state updates
4. **Test Thoroughly** - Write unit, snapshot, and accessibility tests
5. **Document Everything** - All public APIs should have DocC documentation

## Directory Structure

```
Sources/
└── SwiftUI-Components/
    ├── Core/
    │   ├── Theme/
    │   ├── Extensions/
    │   └── Utilities/
    ├── Components/
    │   ├── Buttons/
    │   ├── Cards/
    │   ├── Forms/
    │   ├── Lists/
    │   ├── Navigation/
    │   ├── Feedback/
    │   ├── Media/
    │   └── Layout/
    └── Modifiers/
        ├── Shimmer.swift
        ├── Neumorphism.swift
        └── Glassmorphism.swift
```
