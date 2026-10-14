<!-- i18n-source: README.md@81a0529e2214c577e9e6fdc13d1be417a380b8f6 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ko-light.svg" alt="SwiftUI Components: iOS와 macOS용 기성 SwiftUI 뷰: 버튼, 카드, 차트, 폼 등."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="최신 버전: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

iOS 17 이상과 macOS 14 이상에서 바로 쓸 수 있는 SwiftUI 뷰를 모은 Swift 패키지입니다. 버튼, 카드,
차트, 검증이 있는 폼 입력, 제스처, 목록, 오버레이, 로딩 표시, 토스트가 들어 있습니다. 컴포넌트를
처음부터 만드는 대신 지금 바로 동작하는 것을 쓰고 싶은 앱 개발자를 위한 패키지입니다. 모든
컴포넌트는 이니셜라이저로 설정하는 평범한 SwiftUI `View`이므로, 테마 시스템이나 특정 아키텍처를
도입하지 않고도 필요한 한두 개만 골라 쓸 수 있습니다. 패키지에는 의존성이 없습니다.

## 주요 기능

- **뷰 223개, 뷰 modifier 12개, 제스처 modifier 5개** — 소스 코드에서 센 숫자이며 아래 14개 카테고리로 나뉘어
  있습니다. `PrimaryButton`부터 `CreditCardInput`, `SchemaForm`, `ShapeDrawingPad`까지 있습니다.
- **스스로 검사하는 폼** — 조합할 수 있는 검증기, 처음 편집한 뒤에 나타나는 오류, 디바운스된 서버
  확인, JSON으로 그리는 폼, 여러 단계로 된 흐름. JSON 스키마의 패턴은 시간 제한 안에서 실행되므로, 느린 패턴은
  앱을 멈추게 하는 대신 해당 값을 실패로 처리합니다.
- **손쉬운 사용을 지원하는 제스처** — 스와이프, 가장자리 스와이프, 스와이프 순서, 핀치·회전·드래그,
  도형 그리기를 지원하며, 각각 VoiceOver와 Switch Control 사용자를 위한 손쉬운 사용 동작이 있습니다.
- **하나의 코드로 iOS와 macOS 지원** — UIKit에만 있는 세부 기능은 가장 가까운 AppKit 동작으로
  대체됩니다. [플랫폼별 차이](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)에
  하나하나 정리되어 있습니다.
- **Swift 6 언어 모드** — 엄격한 동시성 검사 아래에서 경고 없이 빌드됩니다.
- **테스트된 로직** — 카드 번호 판별과 Luhn 검사, 유효 기간, 전화번호 형식, 검증기, JSON 스키마,
  단계 흐름, 스와이프와 도형 인식, 명암비, `FlowLayout` 줄바꿈, 차트 기하 계산, 페이지네이션, 토스트
  대기열을 macOS와 iPhone 시뮬레이터에서 실행되는 Swift Testing 테스트 163개로 확인합니다.
- **컴파일되는 사용 예제** — ‘사용법’ 섹션의 모든 예제는 CI가 iOS와 macOS용으로 빌드하는
  [예제 앱](Examples/ComponentGallery)에서 가져왔습니다.

### 포함된 내용

| 분류         | 예시                                                                                                                                              |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 버튼 (25)    | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| 카드 (27)    | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| 차트 (19)    | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| 폼 (23)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| 입력 (13)    | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| 목록 (18)    | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| 로딩 (16)    | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| 내비게이션 (19) | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| 오버레이 (13)  | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| 텍스트 (17)   | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| 토스트 (4)    | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| 기타 (27)    | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| 빈 상태 (1)   | `EmptyStateView`                                                                                                                                |
| 제스처 (1)    | `ShapeDrawingPad`, 그리고 아래의 modifier와 `UnistrokeRecognizer`                                                                                      |

레이아웃과 modifier: `FlowLayout`(줄바꿈 레이아웃), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

제스처 modifier: `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)`, `.boundedDrag(offset:in:)`.

검증(뷰 아님): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`, `StepFlow`,
`ColorContrast`(WCAG 명암비).

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

URL을 창 오른쪽 위의 검색 필드에 붙여 넣습니다. **Dependency Rule**은 **Up to Next Major Version**,
버전은 `2.1.0`으로 그대로 두고 **Add Package**를 클릭합니다. 다음 창에서 **SwiftUIComponents**
옆에 있는 앱 타깃을 선택하고 **Add Package**를 한 번 더 클릭합니다.

**2. 모듈 가져오기**

```swift
import SwiftUIComponents
```

이 줄은 컴포넌트를 쓰는 Swift 파일의 맨 위, `import SwiftUI` 아래에 넣습니다.

**3. 사용하기**

새 Xcode 앱(**File › New › Project… › App**)에서 `ContentView.swift`의 내용을 모두 다음 코드로
바꿉니다.

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

**Run**(⌘R)을 누릅니다. 별 다섯 개와 파란 버튼이 나타납니다. 별을 탭하면 평점이 바뀌고, 버튼을
탭하면 평점이 Xcode 콘솔에 출력됩니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "2.1.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

버전 2.0.0(2026년 10월)은 현재 컴포넌트가 들어 있는 첫 릴리스입니다. 이전 릴리스인
1.0.0(2026년 2월)은 현재 컴포넌트보다 이전 버전입니다. 2026년 6월에 컴포넌트가 플레이스홀더
코드로 바뀌었고, 2026년 10월에 복원되면서 Swift 6 언어 모드에서 iOS와 macOS용으로 빌드되도록
고쳤고 새 테스트가 찾아낸 버그도 수정했습니다. 호환되지 않는 변경을 포함한 자세한 내용은
[CHANGELOG.md](CHANGELOG.md)를 참고하세요.

## 사용법

아래 예제는
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift)에서
복사한 것입니다. 이 파일은 예제 앱과 테스트 스위트 양쪽에서 컴파일됩니다.

### 버튼

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

### 차트

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

### 결제 폼

`CreditCardInput`은 입력하는 동안 번호 형식을 맞추고, 카드 브랜드를 판별하며, 번호(Luhn),
유효 기간, CVV 길이, 카드 소유자 이름을 검증합니다.

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

형식 지정과 검증 헬퍼는 public이므로 다른 곳에서도 쓸 수 있습니다.

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### 스낵바

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

스낵바는 대기열에 들어가 하나씩 표시됩니다. `BannerManager`도 `.bannerHost()`와 함께 같은
방식으로 동작하지만, 새 배너는 현재 배너를 대체합니다.

### 플로 레이아웃

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

### 검증이 있는 폼

```swift
struct SignUpForm: View {
    @State private var email = ValidatedValue("", .required().and(.email()))
    @State private var password = ValidatedValue("", .required().and(.minLength(8)))

    var body: some View {
        VStack(spacing: 16) {
            FormField(label: "Email", errorMessage: email.visibleError) {
                TextInputField(text: $email.value, placeholder: "you@example.com", keyboardType: .email)
            }
            FormField(label: "Password", errorMessage: password.visibleError) {
                PasswordField(password: $password.value)
            }
            PrimaryButton("Create account") {
                let emailIsValid = email.validate()     // shows the errors of untouched fields
                let passwordIsValid = password.validate()
                if emailIsValid && passwordIsValid {
                    print("Signing up \(email.value)")
                }
            }
        }
        .padding()
    }
}
```

`ValidatedValue`는 사용자가 필드를 편집하거나 버튼을 누른 뒤에만 오류를 표시하며, 검증기는
`.and(_:)`로 결합합니다. 텍스트 검증기에는 `required`, `minLength`, `email`, `url`, `phone`,
`digits`, `matches`(정규 표현식)가 있고, `AsyncValidation`은 “이 사용자 이름이 이미 사용 중인가”
같은 서버 확인을 디바운스합니다.

### JSON으로 만든 폼

필드를 데이터로 기술합니다. 예를 들어 서버 응답에 담을 수 있습니다.

```swift
let contactFormJSON = """
{
  "title": "Contact us",
  "fields": [
    { "id": "email", "label": "Email", "kind": "email", "required": true },
    { "id": "topic", "label": "Topic", "kind": "choice", "options": ["Sales", "Support"], "required": true },
    { "id": "message", "label": "Message", "kind": "multiline", "minLength": 10 }
  ]
}
"""
```

디코딩합니다. 이때 ID가 중복되었거나, 불가능한 제한이 있거나, 잘못된 정규 표현식이 들어 있거나,
필드·패턴·옵션 수가 크기 제한을 넘는 스키마는 거부됩니다.

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

그런 다음 화면에 그리고, 값은 직접 만든 상태(state)에 보관합니다.

```swift
struct ContactForm: View {
    let schema: FormSchema
    @State private var values: [String: FormValue]
    @State private var submitted = false

    init(schema: FormSchema) {
        self.schema = schema
        _values = State(initialValue: schema.initialValues())
    }

    var body: some View {
        VStack(spacing: 20) {
            SchemaForm(schema: schema, values: $values, showsAllErrors: submitted)
            PrimaryButton("Send") {
                submitted = true
                if schema.errors(in: values).isEmpty {
                    print(values) // ["email": .text("ada@example.com"), ...]
                }
            }
        }
        .padding()
    }
}
```

패턴은 `NSRegularExpression` 문법을 씁니다. 20 ms보다 오래 걸리는 매칭은 중단되고 값은 실패로
처리되며, UTF-16 코드 단위로 1,000개를 넘는 텍스트는 매칭 없이 실패합니다. 또 `errors(in:)` 한 번이
패턴에 쓰는 시간은 최대 100 ms이므로, 서버에서 온 느린 패턴도 폼을 멈추게 할 수 없습니다.

`StepFlow`와 함께 쓰는 `MultiStepForm`은 긴 폼을 여러 단계로 나누고, 현재 단계가 유효해질 때까지
**Next**를 비활성 상태로 유지합니다.

### 제스처

```swift
struct GestureDemo: View {
    @State private var card = 1
    @State private var zoom = TransformState.identity
    @State private var drawing = "Draw a circle, a check mark or a star"

    var body: some View {
        VStack(spacing: 24) {
            Text("Card \(card) · swipe left or right")
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(.blue.opacity(0.15), in: .rect(cornerRadius: 16))
                .onSwipe([.left, .right]) { direction in
                    card += direction == .left ? 1 : -1
                }

            Image(systemName: "map")
                .font(.system(size: 64))
                .transformable($zoom, scaleRange: 1...5) // pinch, rotate, drag; double tap resets

            ShapeDrawingPad { match in
                drawing = match.map { "That looks like a \($0.name)" } ?? "Not sure, try again"
            }
            .frame(height: 200)
            .background(.blue.opacity(0.06), in: .rect(cornerRadius: 16))
            Text(drawing)
        }
        .padding()
    }
}
```

모든 제스처에는 손쉬운 사용 동작도 있습니다. VoiceOver 사용자는 동작 로터에서 **Swipe left**와
**Swipe right**를 쓸 수 있고, 지도는 시스템 확대/축소 동작으로 확대할 수 있으며,
`ShapeDrawingPad(accessibilityAlternatives:)`는 도형마다 이름이 붙은 동작을 추가합니다. 나머지
경우는 `onEdgeSwipe`, `onSwipeSequence`, `boundedDrag`가 맡습니다.

### 대비 확인

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast`는 두 색 사이의 WCAG 2 명암비와 그 비율이 충족하는 등급(AA, 큰 글씨용 AA, AAA)을
계산합니다.

## 데모

| 라이트                                             | 다크                                            |
| ----------------------------------------------- | --------------------------------------------- |
| ![버튼, 라이트](docs/images/buttons-light.png)       | ![버튼, 다크](docs/images/buttons-dark.png)       |
| ![카드, 라이트](docs/images/cards-light.png)         | ![카드, 다크](docs/images/cards-dark.png)         |
| ![차트, 라이트](docs/images/charts-light.png)        | ![차트, 다크](docs/images/charts-dark.png)        |
| ![인디케이터, 라이트](docs/images/indicators-light.png) | ![인디케이터, 다크](docs/images/indicators-dark.png) |

스크린샷은 [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh)가 iOS
시뮬레이터에서
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)를
렌더링해 만든 것입니다.

‘사용법’ 섹션의 폼과 제스처를
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh)로 iPhone 시뮬레이터의
예제 앱에서 캡처한 화면입니다.

| 검증이 있는 폼                                               | JSON으로 만든 폼                                                    | 제스처                                                 |
| ------------------------------------------------------ | -------------------------------------------------------------- | --------------------------------------------------- |
| ![검증이 있는 폼, 라이트](docs/images/example-signUp-light.png) | ![JSON으로 만든 폼, 라이트](docs/images/example-contactForm-light.png) | ![제스처, 라이트](docs/images/example-gestures-light.png) |
| ![검증이 있는 폼, 다크](docs/images/example-signUp-dark.png)   | ![JSON으로 만든 폼, 다크](docs/images/example-contactForm-dark.png)   | ![제스처, 다크](docs/images/example-gestures-dark.png)   |

직접 써 보려면 [`Examples/ComponentGallery`](Examples/ComponentGallery)에 있는
`ComponentGallery.xcodeproj`를 Xcode로 열고, iPhone 시뮬레이터나 **My Mac**을 고른 다음
**Run**을 누르세요. 앱에는 위의 예제마다 화면이 하나씩 있습니다. 자세한 내용은
[Examples/README.md](Examples/README.md)를 참고하세요.

## 문서

API 레퍼런스와 문서:

- [API 레퍼런스](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, `main` 브랜치에서 GitHub Pages로 게시)
- 로컬에서는 Xcode의 **Product › Build Documentation** 또는 명령줄로 빌드할 수 있습니다.

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — 패키지 추가, 컴포넌트 배치, 스낵바 표시, 목록 페이지네이션
  ([소스](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — 검증이 있는 결제 폼, 그리고 검사가 확인하는 것과 확인하지 못하는 것
  ([소스](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — 검증기, 알맞은 시점에 나타나는 오류, 서버 확인, JSON으로 만든 폼, 여러 단계로 된 폼
  ([소스](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — 스와이프, 핀치·회전·드래그, 도형 인식과 이들의 손쉬운 사용 동작
  ([소스](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — macOS에서 달라지는 점
  ([소스](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

문서는 영어로 되어 있습니다.

## 요구 사항

| 플랫폼   | 최소 버전                 |
| ----- | --------------------- |
| iOS   | 17                    |
| macOS | 14                    |
| 툴체인   | Swift 6.2 · Xcode 26+ |

CI는 GitHub `macos-26` runner 이미지의 기본 Xcode로 빌드합니다. 패키지 개발에는 Xcode 27을
사용합니다.

## 아키텍처

- `Sources/SwiftUIComponents/<Category>/`에는 컴포넌트 계열마다 파일이 하나씩 있습니다. 컴포넌트는
  상태를 `@State`와 `@Binding`에 보관합니다. 참조 타입은 `SnackBarManager`, `BannerManager`,
  `PaginatedListViewModel`, `AsyncValidation` 네 개뿐이며 모두 `@MainActor`입니다.
- 검증과 제스처 판단은 뷰 코드가 없는 값 타입(`Validator`, `FormSchema`, `StepFlow`,
  `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`, `UnistrokeRecognizer`)이 맡기 때문에
  modifier는 얇게 유지되고 규칙은 단위 테스트로 확인합니다.
- `Extensions/Platform.swift`는 UIKit에만 있는 몇 가지 API(시스템 색상, 햅틱, 키보드 종류,
  자동 대문자, 휠 피커, 페이지형 `TabView`)를 AppKit 기능이나 아무것도 하지 않는 동작으로
  연결합니다. 그래서 컴포넌트 코드 자체에는 `#if os(...)`가 거의 없습니다.
- 화면 없이 테스트할 수 있는 로직은 static 함수나 매니저 클래스에 두고, `Tests/`의
  Swift Testing 스위트로 확인합니다. `RenderTests`와 `GaugeNeedleTests`는 `ImageRenderer`로
  뷰를 그립니다. 갤러리 페이지를 라이트 모드와 다크 모드로 그리고(충돌하거나 크기가 0이 되는 뷰를
  잡아냄), 게이지 바늘의 방향도 확인합니다. 개별 뷰 대부분에는 전용 테스트가 없습니다.
- CI는 macOS에서 `swift test`를, iPhone 시뮬레이터에서 `xcodebuild test`를 실행하고, 예제 앱을
  iOS와 macOS용으로 빌드하며, DocC 문서를 게시합니다.

로컬에서 테스트 실행:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 로드맵

- 패키지를 Swift Package Index에 등록하기. `.spi.yml`은 이미 저장소에 있습니다.
- 폼 입력부터 시작해 개별 뷰의 테스트 늘리기.
- `FormSchema`에 조건부 필드 추가하기(다른 필드의 값에 따라 필드 표시).

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
