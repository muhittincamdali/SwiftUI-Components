<!-- i18n-source: README.md@1c867e74d41d7dd0e85e44e3b06a9c1bfcae625c status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-ru-light.svg" alt="SwiftUI Components: Готовые SwiftUI-представления для iOS и macOS: кнопки, карточки, графики, формы и не только."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Последняя версия: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

Swift-пакет с готовыми SwiftUI-представлениями для iOS 17+ и macOS 14+: кнопки, карточки, графики,
поля форм с проверкой, жесты, списки, оверлеи, индикаторы загрузки и уведомления. Он предназначен
для разработчиков приложений, которым нужен работающий компонент сегодня, а не написанный с нуля.
Каждый компонент — это обычный SwiftUI `View`, который настраивается через инициализатор, поэтому
можно взять один-два компонента, не внедряя систему тем или архитектуру. У пакета нет зависимостей.

## Основные возможности

- **223 представления, 12 modifier для представлений и 5 modifier для жестов** — подсчитаны по
  исходному коду и разложены по 14 категориям ниже, от `PrimaryButton` до `CreditCardInput`,
  `SchemaForm` и `ShapeDrawingPad`.
- **Формы, которые проверяют себя сами** — составные валидаторы, ошибки, появляющиеся после первого
  изменения, проверки на сервере с debounce, формы, собираемые из JSON, и многошаговые сценарии.
  Шаблоны из JSON-схемы выполняются с ограничением по времени: медленный шаблон не подвешивает
  приложение, а отклоняет значение.
- **Доступные жесты** — свайпы, свайпы от края, последовательности свайпов,
  сведение-поворот-перетаскивание и рисование фигур; у каждого есть действие универсального доступа
  для пользователей VoiceOver и Switch Control.
- **iOS и macOS из одной кодовой базы** — то, что есть только в UIKit, заменяется ближайшим
  поведением AppKit;
  [заметки о платформах](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  перечисляют каждый случай.
- **Языковой режим Swift 6** — пакет собирается со строгой проверкой конкурентности и без
  предупреждений.
- **Протестированная логика** — определение номера карты и проверка Луна, сроки действия,
  форматирование телефонных номеров, валидаторы, JSON-схемы, пошаговые сценарии, распознавание
  свайпов и фигур, коэффициенты контраста, перенос строк в `FlowLayout`, геометрия графиков,
  постраничная загрузка и очереди уведомлений покрыты 158 тестами Swift Testing, которые запускаются
  на macOS и в симуляторе iPhone.
- **Примеры использования, которые компилируются** — каждый пример из раздела
  «Использование» взят из [примера приложения](Examples/ComponentGallery), который CI собирает для iOS и macOS.

### Что входит в пакет

| Категория            | Примеры                                                                                                                                         |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Кнопки (25)          | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Карточки (27)        | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Графики (19)         | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Формы (23)           | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Поля ввода (13)      | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Списки (18)          | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Загрузка (16)        | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Навигация (19)       | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Оверлеи (13)         | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Текст (17)           | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Уведомления (4)      | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Разное (27)          | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Пустые состояния (1) | `EmptyStateView`                                                                                                                                |
| Жесты (1)            | `ShapeDrawingPad`, а также modifier ниже и `UnistrokeRecognizer`                                                                                |

Раскладка и modifier: `FlowLayout` (раскладка с переносом строк), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Modifier для жестов: `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)` и `.boundedDrag(offset:in:)`.

Проверка (не представления): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`,
`StepFlow` и `ColorContrast` (коэффициенты контраста WCAG).

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Вставьте адрес в поле поиска в правом верхнем углу окна. Оставьте для **Dependency Rule**
значение **Up to Next Major Version** с версии `2.1.0` и нажмите **Add Package**. В следующем окне
выберите target своего приложения рядом с **SwiftUIComponents** и снова нажмите **Add Package**.

**2. Импортируйте модуль**

```swift
import SwiftUIComponents
```

Поставьте эту строку в начало Swift-файла, где используется компонент, под `import SwiftUI`.

**3. Используйте**

В новом приложении Xcode (**File › New › Project… › App**) замените всё содержимое
`ContentView.swift` на:

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

Нажмите **Run** (⌘R). Приложение покажет пять звёзд и синюю кнопку; коснитесь звезды, чтобы
изменить оценку, и кнопки, чтобы вывести её в консоль Xcode.

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

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

Версия 2.0.0 (октябрь 2026 года) — первый релиз с нынешними компонентами. Предыдущий релиз,
1.0.0 (февраль 2026 года), старше их: в июне 2026 года компоненты заменили кодом-заглушкой, а в
октябре 2026 года восстановили, сделали собираемыми для iOS и macOS в языковом режиме Swift 6 и
исправили ошибки, найденные новыми тестами. Все изменения, включая несовместимые, — в
[CHANGELOG.md](CHANGELOG.md).

## Использование

Примеры ниже скопированы из
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift).
Этот файл компилируют и пример приложения, и набор тестов.

### Кнопки

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

### Графики

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

### Платёжная форма

`CreditCardInput` форматирует номер по мере ввода, определяет платёжную систему и проверяет номер
(алгоритм Луна), срок действия, длину CVV и имя владельца карты.

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

Функции форматирования и проверки публичные, если они понадобятся в другом месте:

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### Снекбары

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

Снекбары ставятся в очередь и показываются по одному; `BannerManager` работает так же вместе с
`.bannerHost()`, только новый баннер заменяет текущий.

### Потоковая раскладка

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

### Форма с проверкой

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

`ValidatedValue` показывает ошибку только после того, как пользователь изменил поле или нажал
кнопку, а валидаторы объединяются через `.and(_:)`. Текстовые валидаторы: `required`, `minLength`,
`email`, `url`, `phone`, `digits` и `matches` (регулярное выражение); `AsyncValidation` откладывает
(debounce) проверку на сервере, например «занято ли это имя пользователя».

### Форма из JSON

Опишите поля как данные, например в ответе вашего сервера:

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

Декодируйте его; при этом отклоняется и схема с повторяющимися id, невыполнимыми ограничениями,
недопустимым регулярным выражением или числом полей, шаблонов или вариантов сверх её лимитов
размера:

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Затем отобразите форму и храните значения в собственном состоянии:

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

Шаблоны используют синтаксис `NSRegularExpression`. Сопоставление дольше 20 мс прерывается, и
значение не проходит проверку; текст длиннее 1000 единиц кода UTF-16 отклоняется без
сопоставления; один вызов `errors(in:)` тратит на шаблоны не больше 100 мс. Поэтому медленный
шаблон с сервера не может подвесить форму.

`MultiStepForm` вместе с `StepFlow` делит длинную форму на шаги и не разрешает нажимать **Next**,
пока текущий шаг не пройдёт проверку.

### Жесты

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

У каждого жеста есть и действие универсального доступа: пользователи VoiceOver получают **Swipe
left** и **Swipe right** в роторе действий, карту можно масштабировать системным действием
масштабирования, а `ShapeDrawingPad(accessibilityAlternatives:)` добавляет именованные действия для
фигур. Остальные случаи закрывают `onEdgeSwipe`, `onSwipeSequence` и `boundedDrag`.

### Проверка контраста

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast` вычисляет контраст по WCAG 2 между двумя цветами и уровень, которому он
соответствует (AA, AA для крупного текста или AAA).

## Демо

| Светлая тема                                                  | Тёмная тема                                                 |
| ------------------------------------------------------------- | ----------------------------------------------------------- |
| ![Кнопки, светлая тема](docs/images/buttons-light.png)        | ![Кнопки, тёмная тема](docs/images/buttons-dark.png)        |
| ![Карточки, светлая тема](docs/images/cards-light.png)        | ![Карточки, тёмная тема](docs/images/cards-dark.png)        |
| ![Графики, светлая тема](docs/images/charts-light.png)        | ![Графики, тёмная тема](docs/images/charts-dark.png)        |
| ![Индикаторы, светлая тема](docs/images/indicators-light.png) | ![Индикаторы, тёмная тема](docs/images/indicators-dark.png) |

Скриншоты отрисовываются в симуляторе iOS из
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
скриптом [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Формы и жесты из раздела «Использование», снятые в примере приложения на симуляторе iPhone скриптом
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Форма с проверкой                                                        | Форма из JSON                                                             | Жесты                                                          |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------- | -------------------------------------------------------------- |
| ![Форма с проверкой, светлая тема](docs/images/example-signUp-light.png) | ![Форма из JSON, светлая тема](docs/images/example-contactForm-light.png) | ![Жесты, светлая тема](docs/images/example-gestures-light.png) |
| ![Форма с проверкой, тёмная тема](docs/images/example-signUp-dark.png)   | ![Форма из JSON, тёмная тема](docs/images/example-contactForm-dark.png)   | ![Жесты, тёмная тема](docs/images/example-gestures-dark.png)   |

Чтобы попробовать компоненты самостоятельно, откройте `ComponentGallery.xcodeproj` из
[`Examples/ComponentGallery`](Examples/ComponentGallery) в Xcode, выберите симулятор iPhone или
**My Mac** и нажмите **Run**. В приложении есть отдельный экран для каждого примера выше;
подробности — в [Examples/README.md](Examples/README.md).

## Документация

Справочник API и статьи:

- [Справочник API](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, публикуется на GitHub Pages из `main`)
- Локально документацию можно собрать в Xcode через **Product › Build Documentation** или из
  командной строки:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Руководства

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — добавить пакет, разместить компонент, показать снекбары и сделать постраничный список
  ([исходник](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — платёжная форма с проверкой и то, что проверки покрывают, а что нет
  ([исходник](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — валидаторы, ошибки в нужный момент, проверки на сервере, формы из JSON и многошаговые формы
  ([исходник](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — свайпы, масштабирование-поворот-перетаскивание и распознавание фигур, с их действиями универсального доступа
  ([исходник](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — что меняется на macOS
  ([исходник](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Статьи написаны на английском языке.

## Требования

| Платформа   | Минимальная версия    |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| Инструменты | Swift 6.2 · Xcode 26+ |

CI собирает пакет Xcode по умолчанию из образа раннера GitHub `macos-26`. Разработка ведётся в
Xcode 27.

## Архитектура

- В `Sources/SwiftUIComponents/<Category>/` по одному файлу на семейство компонентов. Компоненты
  хранят состояние в `@State` и `@Binding`; единственные ссылочные типы — `SnackBarManager`,
  `BannerManager`, `PaginatedListViewModel` и `AsyncValidation`, все с `@MainActor`.
- Решения по проверке и жестам — это типы-значения без кода представлений (`Validator`,
  `FormSchema`, `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`,
  `UnistrokeRecognizer`), поэтому modifier остаются тонкими, а правила покрыты модульными тестами.
- `Extensions/Platform.swift` сопоставляет немногие API, существующие только в UIKit (системные
  цвета, тактильный отклик, тип клавиатуры, автоматические заглавные буквы, колёсные пикеры,
  постраничный `TabView`), с AppKit или с пустыми операциями, поэтому в самих компонентах почти нет
  `#if os(...)`.
- Логика, которую можно проверить без экрана, вынесена в статические функции или классы-менеджеры
  и покрыта наборами Swift Testing в `Tests/`. `RenderTests` и `GaugeNeedleTests` отрисовывают
  представления через `ImageRenderer`: страницы галереи в светлой и тёмной теме (так ловятся
  представления, которые падают или сжимаются до нулевого размера) и направление стрелки
  индикатора. У большинства отдельных представлений собственных тестов нет.
- CI запускает `swift test` на macOS и `xcodebuild test` в симуляторе iPhone, собирает пример
  приложения для iOS и macOS и публикует документацию DocC.

Запуск тестов локально:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## План развития

- Добавить пакет в Swift Package Index; `.spi.yml` уже есть в репозитории.
- Написать тесты для большего числа отдельных представлений, начиная с полей форм.
- Добавить в `FormSchema` условные поля (показывать поле в зависимости от значения другого поля).

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
