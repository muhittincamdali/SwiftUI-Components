<!-- i18n-source: README.md@1c867e74d41d7dd0e85e44e3b06a9c1bfcae625c status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-es-light.svg" alt="SwiftUI Components: Vistas de SwiftUI listas para usar en iOS y macOS: botones, tarjetas, gráficos, formularios y más."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="Estado de CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Última versión: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatibles: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Versión del lenguaje: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Licencia: MIT"></picture></a>
</p>

<p align="center">
<a href="#inicio-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-es-light.svg" alt="Empezar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-es-light.svg" alt="Documentación"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-es-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-es-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-es-light.svg" alt="Ejemplos"></picture></a>
</p>

> Esta es una traducción del README en inglés. Si hay diferencias, la versión en inglés es la vigente.

<!-- brand:end -->

Un paquete de Swift con vistas de SwiftUI listas para usar en iOS 17+ y macOS 14+: botones,
tarjetas, gráficos, campos de formulario con validación, gestos, listas, superposiciones,
indicadores de carga y avisos. Está pensado para desarrolladores de apps que quieren un componente
que funcione hoy en lugar de escribirlo desde cero. Cada componente es una `View` de SwiftUI normal
que se configura con su inicializador, así que puedes usar uno o dos sin adoptar un sistema de temas
ni una arquitectura. El paquete no tiene dependencias.

## Lo más destacado

- **223 vistas, 12 modifiers de vista y 5 modifiers de gestos**: contados en el código fuente y
  repartidos en las 14 categorías de abajo, desde `PrimaryButton` hasta `CreditCardInput`,
  `SchemaForm` y `ShapeDrawingPad`.
- **Formularios que se comprueban solos**: validadores componibles, errores que aparecen tras la
  primera edición, comprobaciones en el servidor con debounce, formularios generados a partir de
  JSON y flujos de varios pasos. Los patrones de un esquema JSON se ejecutan con un límite de
  tiempo: uno lento hace fallar el valor en lugar de bloquear la app.
- **Gestos accesibles**: deslizamientos, deslizamientos desde el borde, secuencias de
  deslizamientos, pellizcar-girar-arrastrar y dibujo de formas, cada uno con una acción de
  accesibilidad para usuarios de VoiceOver y Switch Control.
- **iOS y macOS con el mismo código**: los detalles que solo existen en UIKit recurren al
  comportamiento más parecido de AppKit; las
  [notas de plataforma](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  enumeran cada uno.
- **Modo de lenguaje Swift 6**: el paquete compila con la comprobación estricta de concurrencia y
  sin advertencias.
- **Lógica con pruebas**: la detección del número de tarjeta y la comprobación de Luhn, las fechas
  de caducidad, el formato de teléfonos, los validadores, los esquemas JSON, los flujos por pasos,
  el reconocimiento de deslizamientos y formas, las relaciones de contraste, el salto de línea de
  `FlowLayout`, la geometría de los gráficos, la paginación y las colas de avisos están cubiertos
  por 158 pruebas de Swift Testing que se ejecutan en macOS y en un simulador de iPhone.
- **Ejemplos de uso que compilan**: cada ejemplo de la sección «Uso» procede de la
  [app de ejemplo](Examples/ComponentGallery), que la CI compila para iOS y macOS.

### Qué incluye

| Categoría            | Ejemplos                                                                                                                                        |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Botones (25)         | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Tarjetas (27)        | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Gráficos (19)        | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formularios (23)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Entradas (13)        | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listas (18)          | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Carga (16)           | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navegación (19)      | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Superposiciones (13) | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Texto (17)           | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Avisos (4)           | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Varios (27)          | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Estados vacíos (1)   | `EmptyStateView`                                                                                                                                |
| Gestos (1)           | `ShapeDrawingPad`, más los modifiers de abajo y `UnistrokeRecognizer`                                                                           |

Disposición y modifiers: `FlowLayout` (disposición que salta de línea), `.surface()`,
`.shimmer()`, `.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Modifiers de gestos: `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)` y `.boundedDrag(offset:in:)`.

Validación (no son vistas): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`,
`StepFlow` y `ColorContrast` (relaciones de contraste WCAG).

## Inicio rápido

**1. Añade el paquete**

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Pégala en el campo de búsqueda de la esquina superior derecha de la ventana. Deja
**Dependency Rule** en **Up to Next Major Version** desde `2.1.0` y haz clic en **Add Package**.
En la siguiente ventana, elige el target de tu app junto a **SwiftUIComponents** y vuelve a hacer
clic en **Add Package**.

**2. Importa el módulo**

```swift
import SwiftUIComponents
```

Pon esta línea al principio del archivo Swift donde uses un componente, debajo de
`import SwiftUI`.

**3. Úsalo**

En una app nueva de Xcode (**File › New › Project… › App**), sustituye todo el contenido de
`ContentView.swift` por:

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

Pulsa **Run** (⌘R). La app muestra cinco estrellas y un botón azul; toca una estrella para cambiar
la valoración y toca el botón para imprimirla en la consola de Xcode.

## Instalación

### Swift Package Manager

En Xcode, elige **File › Add Package Dependencies…** e introduce la URL del repositorio:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

O añádelo a las `dependencies` de tu `Package.swift`:

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

La versión 2.0.0 (octubre de 2026) es la primera que incluye los componentes actuales. La
versión anterior, 1.0.0 (febrero de 2026), es anterior a ellos: en junio de 2026 se sustituyeron
por código provisional, y en octubre de 2026 se restauraron, se adaptaron para compilar en iOS y
macOS en el modo de lenguaje Swift 6 y se corrigieron los errores que encontraron las nuevas
pruebas. [CHANGELOG.md](CHANGELOG.md) recoge los cambios, incluidos los incompatibles.

## Uso

Los ejemplos siguientes están copiados de
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift).
Tanto la app de ejemplo como las pruebas compilan ese archivo.

### Botones

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

### Gráficos

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

### Formulario de pago

`CreditCardInput` da formato al número mientras escribes, detecta la red de la tarjeta y valida el
número (Luhn), la fecha de caducidad, la longitud del CVV y el nombre del titular.

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

Las funciones de formato y validación son públicas por si las necesitas en otro sitio:

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

Los snackbars se ponen en cola y se muestran de uno en uno; `BannerManager` funciona igual con
`.bannerHost()`, salvo que un banner nuevo sustituye al actual.

### Disposición en flujo

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

### Formulario validado

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

`ValidatedValue` muestra un error solo después de que el usuario edita el campo o pulsa el botón, y
los validadores se combinan con `.and(_:)`. Los validadores de texto incluyen `required`,
`minLength`, `email`, `url`, `phone`, `digits` y `matches` (una expresión regular);
`AsyncValidation` aplica debounce a una comprobación en el servidor, como “¿ya está en uso este
nombre de usuario?”.

### Formulario desde JSON

Describe los campos como datos, por ejemplo en una respuesta de tu servidor:

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

Decodifícalo; así también se rechaza un esquema con ids duplicados, límites imposibles, una
expresión regular no válida o más campos, patrones u opciones de los que permiten sus límites de
tamaño:

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Después muéstralo y guarda los valores en tu propio estado:

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

Los patrones usan la sintaxis de `NSRegularExpression`. Una comparación que dura más de 20 ms se
detiene y hace fallar el valor, el texto de más de 1000 unidades de código UTF-16 falla sin
compararse y una llamada a `errors(in:)` dedica como máximo 100 ms a los patrones, así que un
patrón lento enviado por un servidor no puede bloquear el formulario.

`MultiStepForm` con `StepFlow` divide un formulario largo en pasos y mantiene desactivado **Next**
hasta que el paso actual es válido.

### Gestos

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

Cada gesto tiene también una acción de accesibilidad: los usuarios de VoiceOver obtienen **Swipe
left** y **Swipe right** en el rotor de acciones, el mapa se puede ampliar con la acción de zoom del
sistema y `ShapeDrawingPad(accessibilityAlternatives:)` añade acciones con nombre para las formas.
`onEdgeSwipe`, `onSwipeSequence` y `boundedDrag` cubren el resto de los casos.

### Comprobación de contraste

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast` calcula la relación de contraste WCAG 2 entre dos colores y el nivel que cumple (AA,
AA para texto grande o AAA).

## Demo

| Claro                                                   | Oscuro                                                  |
| ------------------------------------------------------- | ------------------------------------------------------- |
| ![Botones, claro](docs/images/buttons-light.png)        | ![Botones, oscuro](docs/images/buttons-dark.png)        |
| ![Tarjetas, claro](docs/images/cards-light.png)         | ![Tarjetas, oscuro](docs/images/cards-dark.png)         |
| ![Gráficos, claro](docs/images/charts-light.png)        | ![Gráficos, oscuro](docs/images/charts-dark.png)        |
| ![Indicadores, claro](docs/images/indicators-light.png) | ![Indicadores, oscuro](docs/images/indicators-dark.png) |

Las capturas se renderizan en el simulador de iOS a partir de
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
con [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Los formularios y gestos de la sección Uso, capturados desde la app de ejemplo en un simulador de
iPhone con [`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Formulario validado                                                 | Formulario desde JSON                                                      | Gestos                                                   |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------- |
| ![Formulario validado, claro](docs/images/example-signUp-light.png) | ![Formulario desde JSON, claro](docs/images/example-contactForm-light.png) | ![Gestos, claro](docs/images/example-gestures-light.png) |
| ![Formulario validado, oscuro](docs/images/example-signUp-dark.png) | ![Formulario desde JSON, oscuro](docs/images/example-contactForm-dark.png) | ![Gestos, oscuro](docs/images/example-gestures-dark.png) |

Para probar los componentes tú mismo, abre `ComponentGallery.xcodeproj` en
[`Examples/ComponentGallery`](Examples/ComponentGallery) con Xcode, elige un simulador de iPhone
o **My Mac** y pulsa **Run**. La app tiene una pantalla por cada ejemplo de arriba;
[Examples/README.md](Examples/README.md) tiene los detalles.

## Documentación

Referencia de la API y artículos:

- [Referencia de la API](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, publicada en GitHub Pages desde `main`)
- Para generarla en local, usa **Product › Build Documentation** en Xcode o la línea de comandos:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Guías

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — añadir el paquete, colocar un componente, mostrar snackbars y paginar una lista
  ([fuente](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — un formulario de pago con validación, y qué cubren y qué no cubren las comprobaciones
  ([fuente](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — validadores, errores en el momento adecuado, comprobaciones en el servidor, formularios desde JSON y formularios de varios pasos
  ([fuente](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — deslizamientos, pellizcar-girar-arrastrar y reconocimiento de formas, con sus acciones de accesibilidad
  ([fuente](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — qué cambia en macOS
  ([fuente](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Los artículos están en inglés.

## Requisitos

| Plataforma   | Versión mínima        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| Herramientas | Swift 6.2 · Xcode 26+ |

La CI compila con el Xcode predeterminado de la imagen `macos-26` de los runners de GitHub. El
paquete se desarrolla con Xcode 27.

## Arquitectura

- `Sources/SwiftUIComponents/<Category>/` contiene un archivo por familia de componentes. Los
  componentes guardan su estado en `@State` y `@Binding`; los únicos tipos por referencia son
  `SnackBarManager`, `BannerManager`, `PaginatedListViewModel` y `AsyncValidation`, todos
  `@MainActor`.
- Las decisiones de validación y de gestos son tipos por valor sin código de vista (`Validator`,
  `FormSchema`, `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`,
  `UnistrokeRecognizer`), de modo que los modifiers se mantienen delgados y las reglas tienen
  pruebas unitarias.
- `Extensions/Platform.swift` traslada las pocas API exclusivas de UIKit (colores del sistema,
  respuesta háptica, tipo de teclado, mayúsculas automáticas, selectores de rueda, `TabView`
  paginada) a AppKit o a operaciones vacías, de modo que los componentes casi no contienen
  `#if os(...)`.
- La lógica que se puede probar sin pantalla está en funciones estáticas o en las clases gestoras
  y la cubren suites de Swift Testing en `Tests/`. `RenderTests` y `GaugeNeedleTests` dibujan
  vistas con `ImageRenderer`: las páginas de la galería en modo claro y oscuro (lo que detecta
  vistas que fallan o se quedan sin tamaño) y la dirección de la aguja del indicador. La mayoría
  de las vistas no tienen pruebas propias.
- La CI ejecuta `swift test` en macOS y `xcodebuild test` en un simulador de iPhone, compila la
  app de ejemplo para iOS y macOS y publica la documentación DocC.

Ejecuta las pruebas en local:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Hoja de ruta

- Añadir el paquete al Swift Package Index; `.spi.yml` ya está en el repositorio.
- Escribir pruebas para más vistas concretas, empezando por los campos de formulario.
- Añadir campos condicionales a `FormSchema` (mostrar un campo según el valor de otro).

## Contribuir

Las contribuciones son bienvenidas. Lee la [guía de contribución](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) y el [código de conducta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir una pull request. Informa de los problemas de seguridad de forma privada, como se describe en la [política de seguridad](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licencia

Publicado bajo la licencia MIT. Consulta [LICENSE](LICENSE).
