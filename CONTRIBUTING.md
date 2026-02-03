# Contributing to SwiftUI-Components

First off, thank you for considering contributing to SwiftUI-Components! 🎉

It's people like you that make SwiftUI-Components such a great library. We welcome contributions from the community and are grateful for any time you can dedicate.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to muhittincamdali@gmail.com.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a branch** for your changes
4. **Make your changes** with good commit messages
5. **Push to your fork** and submit a pull request

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues as you might find that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples** (code snippets, screenshots)
- **Describe the behavior you observed** and what you expected
- **Include your environment** (Xcode version, iOS version, device)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description** of the suggested enhancement
- **Explain why this enhancement would be useful**
- **Include mockups or examples** if applicable

### Adding New Components

We love new components! When proposing a new component:

1. Open an issue describing the component
2. Wait for approval before starting work
3. Follow our component guidelines (see below)
4. Include tests and documentation

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/SwiftUI-Components.git
cd SwiftUI-Components

# Open in Xcode
open Package.swift

# Build the project
swift build

# Run tests
swift test
```

### Requirements

- Xcode 15.0+
- Swift 5.9+
- macOS 14.0+

## Style Guidelines

### Swift Style

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and use SwiftLint to enforce style.

```swift
// ✅ Good
public struct PrimaryButton: View {
    private let title: String
    private let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
        }
    }
}

// ❌ Bad
struct primaryButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) { Text(title).font(.headline).foregroundColor(.white).padding().background(Color.accentColor).cornerRadius(12) }
    }
}
```

### Documentation

All public APIs must be documented using DocC format:

```swift
/// A customizable primary button for SwiftUI applications.
///
/// Use `PrimaryButton` when you need a prominent call-to-action button.
///
/// ```swift
/// PrimaryButton(title: "Continue") {
///     print("Button tapped!")
/// }
/// ```
///
/// - Parameters:
///   - title: The text displayed on the button.
///   - action: The closure executed when the button is tapped.
public struct PrimaryButton: View { ... }
```

### Testing

All new features must include unit tests:

```swift
final class PrimaryButtonTests: XCTestCase {
    func testButtonRendersTitle() {
        let button = PrimaryButton(title: "Test", action: {})
        XCTAssertNotNil(button)
    }
    
    func testButtonCallsAction() {
        var actionCalled = false
        let button = PrimaryButton(title: "Test") {
            actionCalled = true
        }
        // Simulate tap...
        XCTAssertTrue(actionCalled)
    }
}
```

## Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(button): add gradient background option
fix(card): resolve shadow rendering on iOS 17
docs: update installation guide
test(toast): add accessibility tests
refactor(core): simplify animation system
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding missing tests
- `chore`: Changes to build process or auxiliary tools

## Pull Request Process

1. **Update the README.md** with details of changes if needed
2. **Update the CHANGELOG.md** with your changes
3. **Ensure all tests pass** and coverage doesn't decrease
4. **Request review** from maintainers
5. **Address feedback** and make requested changes
6. **Wait for approval** before merging

### PR Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] Any dependent changes have been merged and published

## Component Guidelines

When creating a new component:

### File Structure

```
Sources/SwiftUI-Components/
└── Components/
    └── YourComponent/
        ├── YourComponent.swift        # Main component
        ├── YourComponentStyle.swift   # Styling options
        ├── YourComponent+Modifiers.swift  # View modifiers
        └── README.md                  # Component docs
```

### Required Features

- [ ] Public initializer with sensible defaults
- [ ] Customizable styling
- [ ] Accessibility support (VoiceOver labels, dynamic type)
- [ ] Dark mode support
- [ ] SwiftUI previews
- [ ] Unit tests

### Example Component

```swift
import SwiftUI

/// A beautiful card component with shadow and rounded corners.
public struct Card<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let style: CardStyle
    
    // MARK: - Initialization
    
    public init(
        style: CardStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .padding(style.padding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                x: style.shadowOffset.width,
                y: style.shadowOffset.height
            )
    }
}

// MARK: - Previews

#Preview {
    Card {
        Text("Hello, World!")
    }
    .padding()
}
```

## Questions?

Feel free to open an issue with the `question` label or reach out directly.

Thank you for contributing! 🙏
