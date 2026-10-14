<!-- i18n-source: README.md@170490313adf5a011360b370574d4b810b0fe1ff status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-fr-light.svg" alt="SwiftUI Components: Des vues SwiftUI prêtes à l’emploi pour iOS et macOS : boutons, cartes, graphiques, formulaires et plus."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Dernière version: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

Un paquet Swift de vues SwiftUI prêtes à l’emploi pour iOS 17+ et macOS 14+ : boutons, cartes,
graphiques, champs de formulaire avec validation, gestes, listes, superpositions, indicateurs de
chargement et notifications. Il s’adresse aux développeurs d’apps qui veulent un composant qui
fonctionne dès aujourd’hui plutôt que de l’écrire de zéro. Chaque composant est une `View` SwiftUI
ordinaire, configurée par son initialiseur : vous pouvez donc en utiliser un ou deux sans adopter de
système de thèmes ni d’architecture. Le paquet n’a aucune dépendance.

## Points forts

- **223 vues, 12 modifiers de vue et 5 modifiers de geste** : comptés dans le code source et
  répartis dans les 14 catégories ci-dessous, de `PrimaryButton` à `CreditCardInput`,
  `SchemaForm` et `ShapeDrawingPad`.
- **Des formulaires qui se vérifient eux-mêmes** : validateurs composables, erreurs qui
  n’apparaissent qu’après la première modification, vérifications côté serveur avec debounce,
  formulaires générés depuis du JSON et parcours en plusieurs étapes. Les motifs d’un schéma JSON
  s’exécutent avec une limite de temps : un motif lent fait échouer la valeur au lieu de
  figer l’app.
- **Des gestes accessibles** : balayages, balayages depuis le bord, séquences de balayages,
  pincement-rotation-glissement et tracé de formes, chacun avec une action d’accessibilité pour les
  utilisateurs de VoiceOver et de Switch Control.
- **iOS et macOS avec le même code** : les détails propres à UIKit se rabattent sur le
  comportement AppKit le plus proche ; les
  [notes sur les plateformes](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  les listent un par un.
- **Mode de langage Swift 6** : le paquet compile avec la vérification stricte de la concurrence
  et sans avertissement.
- **Logique testée** : la détection du numéro de carte et le contrôle de Luhn, les dates
  d’expiration, le formatage des numéros de téléphone, les validateurs, les schémas JSON, les
  parcours par étapes, la reconnaissance des balayages et des formes, les rapports de contraste, le
  retour à la ligne de `FlowLayout`, la géométrie des graphiques, la pagination et les files de
  notifications sont couverts par 150 tests Swift Testing exécutés sur macOS et sur un simulateur
  d’iPhone.
- **Des exemples d’utilisation qui compilent** : chaque exemple de la section « Utilisation »
  provient de l’[app d’exemple](Examples/ComponentGallery), que la CI compile pour iOS et macOS.

### Contenu

| Catégorie           | Exemples                                                                                                                                        |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Boutons (25)        | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Cartes (27)         | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Graphiques (19)     | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formulaires (23)    | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Saisies (13)        | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listes (18)         | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Chargement (16)     | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navigation (19)     | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Superpositions (13) | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Texte (17)          | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Notifications (4)   | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Divers (27)         | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| États vides (1)     | `EmptyStateView`                                                                                                                                |
| Gestes (1)          | `ShapeDrawingPad`, plus les modifiers ci-dessous et `UnistrokeRecognizer`                                                                       |

Mise en page et modifiers : `FlowLayout` (mise en page avec retour à la ligne), `.surface()`,
`.shimmer()`, `.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Modifiers de gestes : `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)` et
`.boundedDrag(offset:in:)`.

Validation (ce ne sont pas des vues) : `Validator`, `ValidatedValue`, `AsyncValidation`,
`FormSchema`, `StepFlow` et `ColorContrast` (rapports de contraste WCAG).

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Collez-la dans le champ de recherche en haut à droite de la fenêtre. Laissez **Dependency Rule**
sur **Up to Next Major Version** à partir de `2.0.0`, puis cliquez sur **Add Package**. Dans la
fenêtre suivante, choisissez la cible de votre app à côté de **SwiftUIComponents** et cliquez de
nouveau sur **Add Package**.

**2. Importer le module**

```swift
import SwiftUIComponents
```

Placez cette ligne en haut du fichier Swift où vous utilisez un composant, sous
`import SwiftUI`.

**3. L’utiliser**

Dans une nouvelle app Xcode (**File › New › Project… › App**), remplacez tout le contenu de
`ContentView.swift` par :

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

Appuyez sur **Run** (⌘R). L’app affiche cinq étoiles et un bouton bleu ; touchez une étoile pour
changer la note, puis le bouton pour l’afficher dans la console de Xcode.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

La version 2.0.0 (octobre 2026) est la première à contenir les composants actuels. La version
précédente, 1.0.0 (février 2026), leur est antérieure : en juin 2026, ils ont été remplacés par
du code provisoire, puis, en octobre 2026, restaurés, rendus compilables pour iOS et macOS en mode
de langage Swift 6 et corrigés là où les nouveaux tests ont trouvé des bugs.
[CHANGELOG.md](CHANGELOG.md) liste les changements, y compris ceux qui cassent la compatibilité.

## Utilisation

Les exemples ci-dessous sont copiés de
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift).
L’app d’exemple et la suite de tests compilent toutes deux ce fichier.

### Boutons

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

### Graphiques

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

### Formulaire de paiement

`CreditCardInput` formate le numéro pendant la saisie, détecte le réseau de la carte et valide le
numéro (Luhn), la date d’expiration, la longueur du CVV et le nom du titulaire.

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

Les fonctions de formatage et de validation sont publiques si vous en avez besoin ailleurs :

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

Les snackbars sont mis en file d’attente et affichés un par un ; `BannerManager` fonctionne de la
même façon avec `.bannerHost()`, sauf qu’une nouvelle bannière remplace celle qui est affichée.

### Mise en page fluide

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

### Formulaire validé

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

`ValidatedValue` n’affiche une erreur qu’après que l’utilisateur a modifié le champ ou touché le
bouton, et les validateurs se combinent avec `.and(_:)`. Les validateurs de texte comprennent
`required`, `minLength`, `email`, `url`, `phone`, `digits` et `matches` (une expression régulière) ;
`AsyncValidation` applique un debounce à une vérification côté serveur, comme « ce nom d’utilisateur
est-il déjà pris ? ».

### Formulaire depuis JSON

Décrivez les champs sous forme de données, par exemple dans une réponse de votre serveur :

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

Décodez-le ; cela rejette aussi un schéma contenant des identifiants en double, des limites
impossibles, une expression régulière invalide, ou plus de champs, de motifs ou d’options que
ses limites de taille ne l’autorisent :

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Affichez-le ensuite et gardez les valeurs dans votre propre état :

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

Les motifs utilisent la syntaxe de `NSRegularExpression`. Une correspondance qui dure plus de
20 ms est interrompue et fait échouer la valeur, un texte de plus de 1 000 unités de code
UTF-16 échoue sans être comparé, et un appel à `errors(in:)` consacre au plus 100 ms aux
motifs : un motif lent envoyé par un serveur ne peut donc pas figer le formulaire.

`MultiStepForm` avec `StepFlow` découpe un long formulaire en étapes et garde **Next** désactivé
tant que l’étape en cours n’est pas valide.

### Gestes

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

Chaque geste a aussi une action d’accessibilité : les utilisateurs de VoiceOver obtiennent **Swipe
left** et **Swipe right** dans le rotor d’actions, la carte peut être zoomée avec l’action de zoom
du système, et `ShapeDrawingPad(accessibilityAlternatives:)` ajoute des actions nommées pour les
formes. `onEdgeSwipe`, `onSwipeSequence` et `boundedDrag` couvrent les autres cas.

### Contrôle du contraste

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast` calcule le rapport de contraste WCAG 2 entre deux couleurs et le niveau qu’il
atteint (AA, AA pour le grand texte ou AAA).

## Démo

| Clair                                                   | Sombre                                                  |
| ------------------------------------------------------- | ------------------------------------------------------- |
| ![Boutons, clair](docs/images/buttons-light.png)        | ![Boutons, sombre](docs/images/buttons-dark.png)        |
| ![Cartes, clair](docs/images/cards-light.png)           | ![Cartes, sombre](docs/images/cards-dark.png)           |
| ![Graphiques, clair](docs/images/charts-light.png)      | ![Graphiques, sombre](docs/images/charts-dark.png)      |
| ![Indicateurs, clair](docs/images/indicators-light.png) | ![Indicateurs, sombre](docs/images/indicators-dark.png) |

Les captures d’écran sont rendues sur le simulateur iOS à partir de
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
par [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Les formulaires et les gestes de la section Utilisation, capturés depuis l’app d’exemple sur un
simulateur d’iPhone par [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) :

| Formulaire validé                                                 | Formulaire depuis JSON                                                      | Gestes                                                   |
| ----------------------------------------------------------------- | --------------------------------------------------------------------------- | -------------------------------------------------------- |
| ![Formulaire validé, clair](docs/images/example-signUp-light.png) | ![Formulaire depuis JSON, clair](docs/images/example-contactForm-light.png) | ![Gestes, clair](docs/images/example-gestures-light.png) |
| ![Formulaire validé, sombre](docs/images/example-signUp-dark.png) | ![Formulaire depuis JSON, sombre](docs/images/example-contactForm-dark.png) | ![Gestes, sombre](docs/images/example-gestures-dark.png) |

Pour essayer les composants vous-même, ouvrez `ComponentGallery.xcodeproj` dans
[`Examples/ComponentGallery`](Examples/ComponentGallery) avec Xcode, choisissez un simulateur
d’iPhone ou **My Mac**, puis appuyez sur **Run**. L’app a un écran par exemple ci-dessus ;
[Examples/README.md](Examples/README.md) donne les détails.

## Documentation

Référence de l’API et articles :

- [Référence de l’API](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, publiée sur GitHub Pages depuis `main`)
- Pour la générer en local, utilisez **Product › Build Documentation** dans Xcode, ou la ligne de
  commande :

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — ajouter le paquet, placer un composant, afficher des snackbars et paginer une liste
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — un formulaire de paiement avec validation, et ce que les contrôles couvrent ou non
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — validateurs, erreurs au bon moment, vérifications côté serveur, formulaires depuis JSON et formulaires en plusieurs étapes
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — balayages, pincement-rotation-glissement et reconnaissance de formes, avec leurs actions d’accessibilité
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — ce qui change sur macOS
  ([source](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Les articles sont en anglais.

## Prérequis

| Plateforme      | Version minimale      |
| --------------- | --------------------- |
| iOS             | 17                    |
| macOS           | 14                    |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |

La CI compile avec le Xcode par défaut de l’image `macos-26` des runners GitHub. Le paquet est
développé avec Xcode 27.

## Architecture

- `Sources/SwiftUIComponents/<Category>/` contient un fichier par famille de composants. Les
  composants gardent leur état dans `@State` et `@Binding` ; les seuls types référence sont
  `SnackBarManager`, `BannerManager`, `PaginatedListViewModel` et `AsyncValidation`, tous
  `@MainActor`.
- Les décisions de validation et de gestes sont des types valeur sans code de vue (`Validator`,
  `FormSchema`, `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`,
  `UnistrokeRecognizer`), si bien que les modifiers restent minces et que les règles sont testées
  unitairement.
- `Extensions/Platform.swift` fait correspondre les quelques API propres à UIKit (couleurs
  système, retour haptique, type de clavier, majuscules automatiques, sélecteurs à molette,
  `TabView` paginée) à AppKit ou à des opérations vides, si bien que les composants eux-mêmes ne
  contiennent presque aucun `#if os(...)`.
- La logique testable sans écran se trouve dans des fonctions statiques ou dans les classes de
  gestion, et des suites Swift Testing dans `Tests/` la couvrent. `RenderTests` et
  `GaugeNeedleTests` dessinent des vues avec `ImageRenderer` : les pages de la galerie en mode
  clair et sombre (ce qui détecte les vues qui plantent ou se réduisent à une taille nulle) et la
  direction de l’aiguille de la jauge. La plupart des vues n’ont pas de tests propres.
- La CI exécute `swift test` sur macOS et `xcodebuild test` sur un simulateur d’iPhone, compile
  l’app d’exemple pour iOS et macOS et publie la documentation DocC.

Lancer les tests en local :

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Feuille de route

- Ajouter le paquet au Swift Package Index ; `.spi.yml` est déjà dans le dépôt.
- Écrire des tests pour davantage de vues, en commençant par les champs de formulaire.
- Ajouter des champs conditionnels à `FormSchema` (afficher un champ selon la valeur d’un autre).

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
