<!-- i18n-source: README.md@f9ea8cfd6c57a4c3a58efdefc90078b858041d3f status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-light.svg" alt="SwiftUI Components: Fertige SwiftUI-Views für iOS und macOS: Buttons, Karten, Diagramme, Formulare und mehr."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket mit fertigen SwiftUI-Views für iOS 17+ und macOS 14+: Buttons, Karten, Diagramme,
Formulareingaben mit Validierung, Gesten, Listen, Overlays, Ladeanzeigen und Toasts. Es richtet sich
an App-Entwickler, die heute eine funktionierende Komponente brauchen, statt sie selbst zu bauen.
Jede Komponente ist eine gewöhnliche SwiftUI-`View`, die über ihren Initializer konfiguriert wird.
Du kannst also ein oder zwei davon verwenden, ohne ein Theme-System oder eine Architektur zu
übernehmen. Das Paket hat keine Abhängigkeiten.

## Highlights

- **223 Views, 12 View-Modifier und 5 Gesten-Modifier** – aus dem Quellcode gezählt und auf die 14
  Kategorien unten verteilt, von `PrimaryButton` bis `CreditCardInput`, `SchemaForm` und
  `ShapeDrawingPad`.
- **Formulare, die sich selbst prüfen** – kombinierbare Validatoren, Fehler, die erst nach der
  ersten Bearbeitung erscheinen, entprellte Serverprüfungen, aus JSON gerenderte Formulare und
  mehrstufige Abläufe. Muster in einem JSON-Schema laufen mit einem Zeitlimit; ein langsames Muster
  lässt den Wert durchfallen, statt die App einzufrieren.
- **Barrierefreie Gesten** – Wischen, Wischen vom Rand, Wischsequenzen, Zoomen-Drehen-Ziehen und
  Formzeichnen, jeweils mit einer Bedienungshilfen-Aktion für VoiceOver- und Switch-Control-Nutzer.
- **iOS und macOS aus einer Codebasis** – Details, die es nur in UIKit gibt, fallen auf das
  nächstliegende AppKit-Verhalten zurück; die
  [Plattformhinweise](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  führen jedes einzeln auf.
- **Swift-6-Sprachmodus** – das Paket baut mit strikter Concurrency-Prüfung und ohne Warnungen.
- **Getestete Logik** – Kartennummernerkennung und Luhn-Prüfung, Ablaufdaten,
  Telefonnummernformatierung, Validatoren, JSON-Schemas, Schrittfolgen, Wisch- und Formerkennung,
  Kontrastverhältnisse, der Zeilenumbruch von `FlowLayout`, Diagrammgeometrie, Paginierung und die
  Toast-Warteschlangen sind durch 155 Swift-Testing-Tests abgedeckt, die auf macOS und einem
  iPhone-Simulator laufen.
- **Verwendungsbeispiele, die kompilieren** – jedes Beispiel im Abschnitt „Verwendung“
  stammt aus der [Beispiel-App](Examples/ComponentGallery), die die CI für iOS und macOS baut.

### Was enthalten ist

| Kategorie          | Beispiele                                                                                                                                       |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Buttons (25)       | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Karten (27)        | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Diagramme (19)     | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formulare (23)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Eingaben (13)      | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listen (18)        | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Laden (16)         | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navigation (19)    | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Overlays (13)      | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Text (17)          | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Toasts (4)         | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Sonstiges (27)     | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Leere Zustände (1) | `EmptyStateView`                                                                                                                                |
| Gesten (1)         | `ShapeDrawingPad`, dazu die Modifier unten und `UnistrokeRecognizer`                                                                            |

Layout und Modifier: `FlowLayout` (umbrechendes Layout), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Gesten-Modifier: `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)` und
`.boundedDrag(offset:in:)`.

Validierung (keine Views): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`,
`StepFlow` und `ColorContrast` (WCAG-Kontrastverhältnisse).

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Füge sie in das Suchfeld oben rechts im Fenster ein. Lass **Dependency Rule** auf
**Up to Next Major Version** ab `2.1.0` und klicke auf **Add Package**. Wähle im nächsten Fenster
neben **SwiftUIComponents** dein App-Target aus und klicke noch einmal auf **Add Package**.

**2. Modul importieren**

```swift
import SwiftUIComponents
```

Schreib diese Zeile an den Anfang der Swift-Datei, in der du eine Komponente verwendest, unter
`import SwiftUI`.

**3. Verwenden**

Ersetze in einer neuen Xcode-App (**File › New › Project… › App**) den gesamten Inhalt von
`ContentView.swift` durch:

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

Drück auf **Run** (⌘R). Die App zeigt fünf Sterne und einen blauen Button; tippe auf einen Stern,
um die Bewertung zu ändern, und auf den Button, um sie in der Xcode-Konsole auszugeben.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

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

Version 2.0.0 (Oktober 2026) ist das erste Release mit den heutigen Komponenten. Das frühere
Release 1.0.0 (Februar 2026) ist älter als sie: Im Juni 2026 wurden die Komponenten durch
Platzhaltercode ersetzt, im Oktober 2026 wiederhergestellt, für iOS und macOS im
Swift-6-Sprachmodus baubar gemacht und dort korrigiert, wo die neuen Tests Fehler gefunden haben.
[CHANGELOG.md](CHANGELOG.md) listet die Änderungen auf, auch die inkompatiblen.

## Verwendung

Die folgenden Beispiele sind aus
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift)
kopiert. Sowohl die Beispiel-App als auch die Test-Suite kompilieren diese Datei.

### Buttons

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

### Diagramme

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

### Zahlungsformular

`CreditCardInput` formatiert die Nummer während der Eingabe, erkennt das Kartennetz und prüft die
Nummer (Luhn), das Ablaufdatum, die Länge der CVV und den Namen des Karteninhabers.

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

Die Hilfsfunktionen für Formatierung und Prüfung sind public, falls du sie anderswo brauchst:

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### Snackbars

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

Snackbars werden in eine Warteschlange gestellt und nacheinander angezeigt; `BannerManager`
funktioniert genauso mit `.bannerHost()`, nur ersetzt ein neues Banner das aktuelle.

### Fließendes Layout

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

### Validiertes Formular

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

`ValidatedValue` zeigt einen Fehler erst an, nachdem der Nutzer das Feld bearbeitet oder den Button
getippt hat, und Validatoren lassen sich mit `.and(_:)` kombinieren. Zu den Textvalidatoren gehören
`required`, `minLength`, `email`, `url`, `phone`, `digits` und `matches` (ein regulärer Ausdruck);
`AsyncValidation` entprellt eine Serverprüfung wie „Ist dieser Benutzername schon vergeben?“.

### Formular aus JSON

Beschreibe die Felder als Daten, zum Beispiel in einer Antwort deines Servers:

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

Dekodiere es; dabei wird auch ein Schema abgelehnt, das doppelte IDs, unmögliche Grenzen, einen
ungültigen regulären Ausdruck oder mehr Felder, Muster oder Optionen enthält, als seine
Größengrenzen erlauben:

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Zeige das Formular dann an und halte die Werte in deinem eigenen State:

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

Muster verwenden die Syntax von `NSRegularExpression`. Ein Abgleich, der länger als 20 ms läuft,
wird abgebrochen und lässt den Wert durchfallen; Text mit mehr als 1.000 UTF-16-Codeeinheiten
fällt durch, ohne abgeglichen zu werden; und ein Aufruf von `errors(in:)` verbraucht höchstens
100 ms für Muster. So kann ein langsames Muster vom Server das Formular nicht einfrieren.

`MultiStepForm` mit `StepFlow` teilt ein langes Formular in Schritte auf und lässt **Next**
deaktiviert, bis der aktuelle Schritt gültig ist.

### Gesten

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

Jede Geste hat außerdem eine Bedienungshilfen-Aktion: VoiceOver-Nutzer finden **Swipe left** und
**Swipe right** im Aktionen-Rotor, die Karte lässt sich mit der System-Zoom-Aktion vergrößern, und
`ShapeDrawingPad(accessibilityAlternatives:)` ergänzt benannte Aktionen für Formen. `onEdgeSwipe`,
`onSwipeSequence` und `boundedDrag` decken die übrigen Fälle ab.

### Kontrastprüfung

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast` berechnet das WCAG-2-Kontrastverhältnis zwischen zwei Farben und die Stufe, die es
erreicht (AA, AA für großen Text oder AAA).

## Demo

| Hell                                                   | Dunkel                                                  |
| ------------------------------------------------------ | ------------------------------------------------------- |
| ![Buttons, hell](docs/images/buttons-light.png)        | ![Buttons, dunkel](docs/images/buttons-dark.png)        |
| ![Karten, hell](docs/images/cards-light.png)           | ![Karten, dunkel](docs/images/cards-dark.png)           |
| ![Diagramme, hell](docs/images/charts-light.png)       | ![Diagramme, dunkel](docs/images/charts-dark.png)       |
| ![Indikatoren, hell](docs/images/indicators-light.png) | ![Indikatoren, dunkel](docs/images/indicators-dark.png) |

Die Screenshots werden im iOS-Simulator aus
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
mit [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) gerendert.

Die Formulare und Gesten aus dem Abschnitt „Verwendung“, aufgenommen aus der Beispiel-App auf einem
iPhone-Simulator mit [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Validiertes Formular                                                 | Formular aus JSON                                                      | Gesten                                                   |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------------------------- |
| ![Validiertes Formular, hell](docs/images/example-signUp-light.png)  | ![Formular aus JSON, hell](docs/images/example-contactForm-light.png)  | ![Gesten, hell](docs/images/example-gestures-light.png)  |
| ![Validiertes Formular, dunkel](docs/images/example-signUp-dark.png) | ![Formular aus JSON, dunkel](docs/images/example-contactForm-dark.png) | ![Gesten, dunkel](docs/images/example-gestures-dark.png) |

Um die Komponenten selbst auszuprobieren, öffne `ComponentGallery.xcodeproj` in
[`Examples/ComponentGallery`](Examples/ComponentGallery) mit Xcode, wähle einen iPhone-Simulator
oder **My Mac** und drück auf **Run**. Die App hat für jedes Beispiel oben einen eigenen
Bildschirm; Details stehen in [Examples/README.md](Examples/README.md).

## Dokumentation

API-Referenz und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, aus `main` auf GitHub Pages veröffentlicht)
- Lokal baust du sie in Xcode mit **Product › Build Documentation** oder auf der Kommandozeile:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  – Paket hinzufügen, eine Komponente platzieren, Snackbars anzeigen und eine Liste paginieren
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  – ein Zahlungsformular mit Prüfung, und was die Prüfungen abdecken und was nicht
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  – Validatoren, Fehler zum richtigen Zeitpunkt, Serverprüfungen, Formulare aus JSON und mehrstufige Formulare
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  – Wischgesten, Zoomen-Drehen-Ziehen und Formerkennung samt ihren Bedienungshilfen-Aktionen
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  – was sich auf macOS ändert
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Die Artikel sind auf Englisch.

## Voraussetzungen

| Plattform | Mindestversion        |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

Die CI baut mit dem Standard-Xcode des `macos-26`-Runner-Images von GitHub. Entwickelt wird das
Paket mit Xcode 27.

## Architektur

- `Sources/SwiftUIComponents/<Category>/` enthält eine Datei pro Komponentenfamilie. Komponenten
  halten ihren Zustand in `@State` und `@Binding`; die einzigen Referenztypen sind
  `SnackBarManager`, `BannerManager`, `PaginatedListViewModel` und `AsyncValidation`, alle
  `@MainActor`.
- Entscheidungen zu Validierung und Gesten sind Werttypen ohne View-Code (`Validator`, `FormSchema`,
  `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`, `UnistrokeRecognizer`),
  sodass die Modifier schlank bleiben und die Regeln per Unit-Test geprüft werden.
- `Extensions/Platform.swift` bildet die wenigen reinen UIKit-APIs (Systemfarben, haptisches
  Feedback, Tastaturtyp, automatische Großschreibung, Rad-Picker, seitenweise `TabView`) auf
  AppKit oder auf No-ops ab, sodass die Komponenten selbst fast kein `#if os(...)` enthalten.
- Logik, die sich ohne Bildschirm testen lässt, steckt in statischen Funktionen oder den
  Manager-Klassen und ist durch Swift-Testing-Suites in `Tests/` abgedeckt. `RenderTests` und
  `GaugeNeedleTests` zeichnen Views mit `ImageRenderer`: die Galerieseiten im hellen und dunklen
  Modus (das fängt Views ab, die abstürzen oder auf eine leere Größe schrumpfen) und die Richtung
  der Tachonadel. Die meisten einzelnen Views haben keine eigenen Tests.
- Die CI führt `swift test` auf macOS und `xcodebuild test` auf einem iPhone-Simulator aus, baut
  die Beispiel-App für iOS und macOS und veröffentlicht die DocC-Dokumentation.

Tests lokal ausführen:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roadmap

- Das Paket im Swift Package Index eintragen; `.spi.yml` liegt bereits im Repository.
- Tests für weitere einzelne Views schreiben, angefangen bei den Formulareingaben.
- Bedingte Felder in `FormSchema` unterstützen (ein Feld abhängig vom Wert eines anderen Felds
  anzeigen).

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
