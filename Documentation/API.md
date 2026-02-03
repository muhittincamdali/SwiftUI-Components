# SwiftUI-Components API Documentation

Complete API reference for all components in the SwiftUI-Components library.

## Table of Contents

- [Buttons](#buttons)
- [Cards](#cards)
- [Forms](#forms)
- [Lists](#lists)
- [Navigation](#navigation)
- [Feedback](#feedback)
- [Media](#media)
- [Layout](#layout)

---

## Buttons

### PrimaryButton

A prominent button for primary actions.

```swift
PrimaryButton(
    title: String,
    icon: Image? = nil,
    isLoading: Bool = false,
    action: @escaping () -> Void
)
```

**Parameters:**
- `title`: The button's text label
- `icon`: Optional leading icon
- `isLoading`: Shows loading spinner when true
- `action`: Closure executed on tap

**Example:**
```swift
PrimaryButton(title: "Continue", icon: Image(systemName: "arrow.right")) {
    navigateToNextScreen()
}
```

### SecondaryButton

A less prominent button for secondary actions.

```swift
SecondaryButton(
    title: String,
    style: SecondaryButtonStyle = .default,
    action: @escaping () -> Void
)
```

### IconButton

A circular button with an icon.

```swift
IconButton(
    icon: Image,
    size: CGFloat = 44,
    backgroundColor: Color = .accentColor,
    action: @escaping () -> Void
)
```

### GhostButton

A button with no background, only text.

```swift
GhostButton(
    title: String,
    foregroundColor: Color = .accentColor,
    action: @escaping () -> Void
)
```

---

## Cards

### Card

A container with rounded corners and optional shadow.

```swift
Card<Content: View>(
    style: CardStyle = .default,
    @ViewBuilder content: () -> Content
)
```

**CardStyle Properties:**
- `backgroundColor: Color`
- `cornerRadius: CGFloat`
- `shadowRadius: CGFloat`
- `shadowColor: Color`
- `padding: EdgeInsets`

### ExpandableCard

A card that expands to show more content.

```swift
ExpandableCard<Header: View, Content: View>(
    isExpanded: Binding<Bool>,
    @ViewBuilder header: () -> Header,
    @ViewBuilder content: () -> Content
)
```

### AnimatedCard

A card with entrance animations.

```swift
AnimatedCard<Content: View>(
    animation: CardAnimation = .spring,
    delay: Double = 0,
    @ViewBuilder content: () -> Content
)
```

**CardAnimation Options:**
- `.spring` - Bouncy spring animation
- `.fade` - Fade in
- `.slide` - Slide from bottom
- `.scale` - Scale from 0 to 1

---

## Forms

### TextField

An enhanced text field with validation.

```swift
EnhancedTextField(
    placeholder: String,
    text: Binding<String>,
    validation: ValidationRule? = nil,
    keyboardType: UIKeyboardType = .default,
    isSecure: Bool = false
)
```

**ValidationRule:**
```swift
enum ValidationRule {
    case email
    case phone
    case minLength(Int)
    case maxLength(Int)
    case regex(String)
    case custom((String) -> Bool)
}
```

### TextArea

A multi-line text input.

```swift
TextArea(
    placeholder: String,
    text: Binding<String>,
    minHeight: CGFloat = 100,
    maxHeight: CGFloat = 300
)
```

### Picker

A customizable picker component.

```swift
EnhancedPicker<T: Identifiable>(
    selection: Binding<T>,
    options: [T],
    style: PickerStyle = .menu
)
```

### Toggle

A styled toggle switch.

```swift
StyledToggle(
    isOn: Binding<Bool>,
    label: String,
    style: ToggleStyle = .default
)
```

---

## Lists

### InfiniteList

A list with infinite scroll pagination.

```swift
InfiniteList<Item: Identifiable, Content: View>(
    items: [Item],
    isLoading: Bool,
    loadMore: @escaping () async -> Void,
    @ViewBuilder content: (Item) -> Content
)
```

### GroupedList

A list with section headers.

```swift
GroupedList<Section: Identifiable, Item: Identifiable, Header: View, Content: View>(
    sections: [Section],
    items: (Section) -> [Item],
    @ViewBuilder header: (Section) -> Header,
    @ViewBuilder content: (Item) -> Content
)
```

### SwipeableList

A list with swipe actions.

```swift
SwipeableList<Item: Identifiable, Content: View>(
    items: [Item],
    leadingActions: [SwipeAction],
    trailingActions: [SwipeAction],
    @ViewBuilder content: (Item) -> Content
)
```

---

## Navigation

### TabBar

A customizable bottom tab bar.

```swift
CustomTabBar<Content: View>(
    selectedIndex: Binding<Int>,
    tabs: [TabItem],
    @ViewBuilder content: () -> Content
)
```

**TabItem:**
```swift
struct TabItem {
    let icon: Image
    let title: String
    let badge: Int?
}
```

### Sidebar

A sidebar navigation component.

```swift
Sidebar<Content: View>(
    items: [SidebarItem],
    selectedItem: Binding<SidebarItem?>,
    @ViewBuilder content: () -> Content
)
```

### Breadcrumb

A breadcrumb navigation trail.

```swift
Breadcrumb(
    items: [BreadcrumbItem],
    separator: String = "›"
)
```

---

## Feedback

### Toast

A temporary notification message.

```swift
Toast(
    message: String,
    type: ToastType = .info,
    duration: Double = 3.0,
    position: ToastPosition = .bottom
)
```

**ToastType:**
- `.success` - Green with checkmark
- `.error` - Red with X
- `.warning` - Yellow with exclamation
- `.info` - Blue with info icon

### Alert

A modal alert dialog.

```swift
StyledAlert(
    title: String,
    message: String,
    primaryButton: AlertButton,
    secondaryButton: AlertButton? = nil
)
```

### Progress

A progress indicator.

```swift
ProgressView(
    progress: Double,
    style: ProgressStyle = .linear,
    showPercentage: Bool = true
)
```

**ProgressStyle:**
- `.linear` - Horizontal bar
- `.circular` - Circular ring
- `.steps` - Step indicator

### Spinner

A loading spinner.

```swift
Spinner(
    style: SpinnerStyle = .default,
    size: CGFloat = 40,
    color: Color = .accentColor
)
```

---

## Media

### AsyncImage

An image that loads asynchronously.

```swift
CachedAsyncImage(
    url: URL,
    placeholder: Image = Image(systemName: "photo"),
    contentMode: ContentMode = .fill,
    transition: AnyTransition = .opacity
)
```

### VideoPlayer

A customizable video player.

```swift
EnhancedVideoPlayer(
    url: URL,
    autoPlay: Bool = false,
    showControls: Bool = true,
    loop: Bool = false
)
```

### AudioWaveform

An audio waveform visualization.

```swift
AudioWaveform(
    url: URL,
    barCount: Int = 50,
    activeColor: Color = .accentColor,
    inactiveColor: Color = .gray
)
```

---

## Layout

### Grid

A flexible grid layout.

```swift
FlexibleGrid<Item: Identifiable, Content: View>(
    items: [Item],
    columns: Int = 2,
    spacing: CGFloat = 16,
    @ViewBuilder content: (Item) -> Content
)
```

### Spacer

A flexible space.

```swift
FlexSpacer(
    minLength: CGFloat = 0,
    maxLength: CGFloat = .infinity
)
```

### Divider

A styled divider line.

```swift
StyledDivider(
    style: DividerStyle = .solid,
    color: Color = .gray.opacity(0.3),
    thickness: CGFloat = 1
)
```

**DividerStyle:**
- `.solid` - Continuous line
- `.dashed` - Dashed line
- `.dotted` - Dotted line

---

## Modifiers

### Shimmer

Adds a shimmer loading effect.

```swift
view.shimmer(isActive: Bool)
```

### Neumorphism

Adds a neumorphic shadow effect.

```swift
view.neumorphic(
    lightColor: Color,
    darkColor: Color,
    radius: CGFloat
)
```

### Glassmorphism

Adds a glass blur effect.

```swift
view.glass(
    radius: CGFloat = 20,
    opacity: Double = 0.1
)
```

---

## Accessibility

All components support:

- VoiceOver labels
- Dynamic Type
- Reduce Motion
- High Contrast mode

Example:
```swift
PrimaryButton(title: "Submit") { }
    .accessibilityLabel("Submit form")
    .accessibilityHint("Double tap to submit your information")
```

---

## Theming

### Theme Configuration

```swift
struct Theme {
    var primaryColor: Color
    var secondaryColor: Color
    var backgroundColor: Color
    var textColor: Color
    var font: Font
    var cornerRadius: CGFloat
    var shadowRadius: CGFloat
}
```

### Using Themes

```swift
ComponentsTheme.configure(Theme(
    primaryColor: .blue,
    secondaryColor: .gray,
    backgroundColor: .white,
    textColor: .black,
    font: .system(.body),
    cornerRadius: 12,
    shadowRadius: 8
))
```

---

## Migration Guide

### From v1.1 to v1.2

```swift
// Old
Button(title: "Submit", action: submit)

// New
PrimaryButton(title: "Submit", action: submit)
```

### From v1.0 to v1.1

No breaking changes.

---

For more examples, see the [Examples](../Examples) directory.
