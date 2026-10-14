<!-- i18n-source: README.md@32c9a3e0b7d98fdff756d5ac98cf73c83cb0c76c status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-zh-CN-light.svg" alt="SwiftUI Components: 适用于 iOS 和 macOS 的现成 SwiftUI 视图：按钮、卡片、图表、表单等。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI 状态"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="最新版本: v1.0.0 · predates main"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="支持的平台: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="语言版本: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="许可证: MIT"></picture></a>
</p>

<p align="center">
<a href="#快速开始"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-zh-CN-light.svg" alt="开始使用"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-zh-CN-light.svg" alt="文档"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-zh-CN-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-zh-CN-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-zh-CN-light.svg" alt="示例"></picture></a>
</p>

> 本文是英文 README 的译文。如两者内容不一致，以英文版为准。

<!-- brand:end -->

一个面向 iOS 17+ 和 macOS 14+ 的 Swift 软件包，提供现成的 SwiftUI 视图：按钮、卡片、图表、表单输入、列表、浮层、加载指示器和提示。它适合希望直接使用可运行组件、而不是从零编写的应用开发者。每个组件都是通过初始化方法配置的普通 SwiftUI `View`，因此你可以只用其中一两个，而无需引入主题系统或特定架构。该软件包没有任何依赖。

## 亮点

- **220 个视图，12 个 modifier**：数量由源代码统计，分布在 13 个文件夹中，从 `PrimaryButton` 到 `CreditCardInput` 和 `GaugeChart`。
- **一套代码同时支持 iOS 和 macOS**：仅 UIKit 提供的细节会退回到最接近的 AppKit 行为；[平台说明](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)逐项列出。
- **Swift 6 语言模式**：软件包在严格并发检查下编译，且没有警告。
- **经过测试的逻辑**：卡号识别与 Luhn 校验、有效期、电话号码格式化、`FlowLayout` 换行、图表几何、分页以及提示队列，由 56 个 Swift Testing 测试覆盖，在 macOS 和 iPhone 模拟器上运行。
- **可编译的用法示例**：“使用方法”一节中的每段示例代码都来自[示例应用](Examples/ComponentGallery)，CI 会为 iOS 和 macOS 构建它。

### 包含的内容

| 类别      | 示例                                                                                                                                              |
| ------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 按钮 (25) | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| 卡片 (27) | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| 图表 (19) | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| 表单 (21) | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `MultiSelectField`, `SliderField`, `RangeSlider`, `OTPField`, `DateField`        |
| 输入 (13) | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| 列表 (18) | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| 加载 (16) | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| 导航 (19) | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| 浮层 (13) | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| 文本 (17) | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| 提示 (4)  | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| 其他 (27) | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| 空状态 (1) | `EmptyStateView`                                                                                                                                |

布局与 modifier：`FlowLayout`（自动换行布局）、`.surface()`、`.shimmer()`、`.toast(isPresenting:message:)`、`.snackBarHost()`、`.bannerHost()`。

## 快速开始

**1. 添加软件包**

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

把地址粘贴到窗口右上角的搜索框中。将 **Dependency Rule** 设为 **Branch** 并输入 `main`，然后点击 **Add Package**。在下一个窗口中，在 **SwiftUIComponents** 旁边选择你的应用 target，再次点击 **Add Package**。

**2. 导入模块**

```swift
import SwiftUIComponents
```

把这一行放在使用组件的 Swift 文件顶部，位于 `import SwiftUI` 之下。

**3. 开始使用**

在一个新的 Xcode 应用（**File › New › Project… › App**）中，把 `ContentView.swift` 的全部内容替换为：

```swift
import SwiftUI
import SwiftUIComponents

struct ContentView: View {
    @State private var rating = 3.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Rate this app")
                .font(.headline)
            RatingInput(rating: $rating)
            PrimaryButton("Send rating") {
                print("Rating: \(rating)")
            }
        }
        .padding()
    }
}
```

按下 **Run**（⌘R）。应用会显示五颗星和一个蓝色按钮；点按星星可以修改评分，点按按钮会把评分打印到 Xcode 控制台。

## 安装

### Swift Package Manager

在 Xcode 中选择 **File › Add Package Dependencies…**，然后输入仓库地址：

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

或者将其添加到 `Package.swift` 的 `dependencies` 中：

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

目前请使用 `main` 分支。唯一的版本 1.0.0（2026 年 2 月）早于现在的组件：2026 年 6 月这些组件曾被占位代码替换，2026 年 10 月又被恢复，改为在 Swift 6 语言模式下为 iOS 和 macOS 编译，并修复了新测试发现的缺陷。详情见 [CHANGELOG.md](CHANGELOG.md)。

## 使用方法

以下示例复制自 [`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift)。示例应用和测试套件都会编译这个文件。

### 按钮

```swift
struct CheckoutButtons: View {
    @State private var payState: LoadingButton.LoadingState = .idle

    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton("Continue") {
                print("Continue tapped")
            }

            LoadingButton("Pay $9.99", state: $payState) {
                try? await Task.sleep(for: .seconds(1))
                return true // false shows the failure state
            }
        }
        .padding()
    }
}
```

### 图表

```swift
struct WeeklyStats: View {
    var body: some View {
        VStack(spacing: 24) {
            BarChart(data: [
                .init(value: 32, label: "Mon"),
                .init(value: 45, label: "Tue"),
                .init(value: 28, label: "Wed"),
            ])
            .frame(height: 180)

            SparklineChart(data: [3, 5, 4, 7, 6, 9], style: .gradient, lineColor: .purple)
                .frame(height: 50)
        }
        .padding()
    }
}
```

### 支付表单

`CreditCardInput` 会在输入时格式化卡号、识别卡组织，并校验卡号（Luhn）、有效期、CVV 长度和持卡人姓名。

```swift
struct PaymentForm: View {
    @State private var number = ""
    @State private var expiry = ""
    @State private var cvv = ""
    @State private var name = ""
    @State private var canPay = false

    var body: some View {
        VStack {
            CreditCardInput(
                cardNumber: $number,
                expiryDate: $expiry,
                cvv: $cvv,
                cardholderName: $name,
                onValidationChange: { canPay = $0 }
            )
            PrimaryButton("Pay", isDisabled: !canPay) {}
        }
        .padding()
    }
}
```

格式化和校验辅助方法是公开的，可以在其他地方使用：

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### Snackbar

```swift
struct InboxScreen: View {
    var body: some View {
        List {
            Button("Archive") {
                SnackBarManager.shared.show(message: "Conversation archived", style: .success)
            }
        }
        .snackBarHost()
    }
}
```

Snackbar 会排队并逐个显示；`BannerManager` 配合 `.bannerHost()` 的用法相同，区别在于新的 banner 会替换当前的 banner。

### 流式布局

```swift
struct TopicPicker: View {
    let topics = ["SwiftUI", "Combine", "Concurrency", "Testing", "Accessibility"]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(topics, id: \.self) { topic in
                Tag(topic)
            }
        }
    }
}
```

## 演示

| 浅色                                           | 深色                                          |
| -------------------------------------------- | ------------------------------------------- |
| ![按钮, 浅色](docs/images/buttons-light.png)     | ![按钮, 深色](docs/images/buttons-dark.png)     |
| ![卡片, 浅色](docs/images/cards-light.png)       | ![卡片, 深色](docs/images/cards-dark.png)       |
| ![图表, 浅色](docs/images/charts-light.png)      | ![图表, 深色](docs/images/charts-dark.png)      |
| ![指示器, 浅色](docs/images/indicators-light.png) | ![指示器, 深色](docs/images/indicators-dark.png) |

截图由 [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) 在 iOS 模拟器上根据 [`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift) 渲染生成。

想亲自试用这些组件，请用 Xcode 打开 [`Examples/ComponentGallery`](Examples/ComponentGallery) 中的 `ComponentGallery.xcodeproj`，选择一个 iPhone 模拟器或 **My Mac**，然后按 **Run**。应用为上面的每个示例提供一个页面；详情见 [Examples/README.md](Examples/README.md)。

## 文档

API 参考文档与文章：

- [API 参考](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)（DocC，从 `main` 分支发布到 GitHub Pages）
- 也可以在本地构建：在 Xcode 中选择 **Product › Build Documentation**，或在命令行中运行：

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## 指南

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)：添加软件包、放置组件、显示 snackbar 以及为列表分页（[源文件](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)）。
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)：带校验的支付表单，以及这些校验能覆盖和不能覆盖的内容（[源文件](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)）。
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)：在 macOS 上有哪些不同（[源文件](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)）。

这些文章为英文。

## 系统要求

| 平台    | 最低版本                  |
| ----- | --------------------- |
| iOS   | 17                    |
| macOS | 14                    |
| 工具链   | Swift 6.2 · Xcode 26+ |

CI 使用 GitHub `macos-26` runner 镜像中的默认 Xcode 构建。本软件包使用 Xcode 27 开发。

## 架构

- `Sources/SwiftUIComponents/<Category>/` 中每个组件系列对应一个文件。组件把状态保存在 `@State` 和 `@Binding` 中；仅有的引用类型是 `SnackBarManager`、`BannerManager` 和 `PaginatedListViewModel`，它们都标注了 `@MainActor`。
- `Extensions/Platform.swift` 把少数仅 UIKit 提供的 API（系统颜色、触感反馈、键盘类型、自动大写、滚轮选择器、分页 `TabView`）映射到 AppKit 或空操作，因此组件本身几乎不包含 `#if os(...)`。
- 无需屏幕即可测试的逻辑放在静态函数或管理类中，并由 `Tests/` 中的 Swift Testing 测试套件覆盖。`RenderTests` 和 `GaugeNeedleTests` 使用 `ImageRenderer` 渲染视图：以浅色和深色模式渲染图库页面（可发现崩溃或尺寸塌缩为空的视图），以及检查仪表指针的方向。大多数单个视图没有自己的测试。
- CI 在 macOS 上运行 `swift test`，在 iPhone 模拟器上运行 `xcodebuild test`，为 iOS 和 macOS 构建示例应用，并发布 DocC 文档。

在本地运行测试：

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 路线图

- 为恢复后的组件打一个版本标签，这样添加软件包时就可以使用版本规则，而不是 `main` 分支。
- 将软件包加入 Swift Package Index；仓库中已经有 `.spi.yml`。
- 为更多单个视图编写测试，从表单输入开始。

## 参与贡献

欢迎参与贡献。提交 pull request 之前，请先阅读[贡献指南](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md)和[行为准则](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)。如发现安全问题，请按照[安全策略](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)私下报告。

## 许可证

基于 MIT 许可证发布。详见 [LICENSE](LICENSE)。
