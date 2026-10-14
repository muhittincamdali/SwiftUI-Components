<!-- i18n-source: README.md@b3060b934d1a6adf2c92170f49d67bcc526f6038 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-de-light.svg" alt="SwiftUI Components: Fertige SwiftUI-Views für iOS und macOS: Buttons, Karten, Diagramme, Formulare und mehr."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.0+"></picture></a>
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
Formulareingaben, Listen, Overlays, Ladeanzeigen und Toasts. Es richtet sich an App-Entwickler, die
heute eine funktionierende Komponente brauchen, statt sie selbst zu bauen. Jede Komponente ist eine
gewöhnliche SwiftUI-`View`, die über ihren Initializer konfiguriert wird. Du kannst also ein oder
zwei davon verwenden, ohne ein Theme-System oder eine Architektur zu übernehmen. Das Paket hat keine
Abhängigkeiten.

## Highlights

- **220 Views, 12 Modifier** – aus dem Quellcode gezählt und auf 13 Ordner verteilt, von
  `PrimaryButton` bis `CreditCardInput` und `GaugeChart`.
- **iOS und macOS aus einer Codebasis** – Details, die es nur in UIKit gibt, fallen auf das
  nächstliegende AppKit-Verhalten zurück; die
  [Plattformhinweise](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  führen jedes einzeln auf.
- **Swift-6-Sprachmodus** – das Paket baut mit strikter Concurrency-Prüfung und ohne Warnungen.
- **Getestete Logik** – Kartennummernerkennung und Luhn-Prüfung, Ablaufdaten,
  Telefonnummernformatierung, der Zeilenumbruch von `FlowLayout`, Diagrammgeometrie, Paginierung
  und die Toast-Warteschlangen sind durch 56 Swift-Testing-Tests abgedeckt, die auf macOS und
  einem iPhone-Simulator laufen.
- **Beispiele, die kompilieren** – jedes Codebeispiel unten stammt aus der
  [Beispiel-App](Examples/ComponentGallery), die die CI für iOS und macOS baut.

### Was enthalten ist

| Kategorie          | Beispiele                                                                                                                                       |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Buttons (25)       | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Karten (27)        | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Diagramme (19)     | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formulare (21)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `MultiSelectField`, `SliderField`, `RangeSlider`, `OTPField`, `DateField`        |
| Eingaben (13)      | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listen (18)        | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Laden (16)         | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navigation (19)    | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Overlays (13)      | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Text (17)          | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Toasts (4)         | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Sonstiges (27)     | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Leere Zustände (1) | `EmptyStateView`                                                                                                                                |

Layout und Modifier: `FlowLayout` (umbrechendes Layout), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Füge sie in das Suchfeld oben rechts im Fenster ein. Stelle **Dependency Rule** auf **Branch**,
gib `main` ein und klicke auf **Add Package**. Wähle im nächsten Fenster neben
**SwiftUIComponents** dein App-Target aus und klicke noch einmal auf **Add Package**.

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
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

Verwende vorerst den Branch `main`. Das einzige Release, 1.0.0 (Februar 2026), ist älter als die
heutigen Komponenten: Im Juni 2026 wurden sie durch Platzhaltercode ersetzt, im Oktober 2026
wiederhergestellt, für iOS und macOS im Swift-6-Sprachmodus baubar gemacht und dort korrigiert,
wo die neuen Tests Fehler gefunden haben. Details stehen in [CHANGELOG.md](CHANGELOG.md).

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
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  – was sich auf macOS ändert
  ([Quelle](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Die Artikel sind auf Englisch.

## Voraussetzungen

| Plattform | Mindestversion        |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.0 · Xcode 16+ |

Die CI baut mit dem Standard-Xcode des `macos-26`-Runner-Images von GitHub. Entwickelt wird das
Paket mit Xcode 27.

## Architektur

- `Sources/SwiftUIComponents/<Category>/` enthält eine Datei pro Komponentenfamilie. Komponenten
  halten ihren Zustand in `@State` und `@Binding`; die einzigen Referenztypen sind
  `SnackBarManager`, `BannerManager` und `PaginatedListViewModel`, alle `@MainActor`.
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

- Ein Release der wiederhergestellten Komponenten taggen, damit sich das Paket mit einer
  Versionsregel statt über den Branch `main` hinzufügen lässt.
- Das Paket im Swift Package Index eintragen; `.spi.yml` liegt bereits im Repository.
- Tests für weitere einzelne Views schreiben, angefangen bei den Formulareingaben.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
