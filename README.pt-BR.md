<!-- i18n-source: README.md@9069cf84f8474e68967f33b61ce51eb4407ad285 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-pt-BR-light.svg" alt="SwiftUI Components: Views SwiftUI prontas para iOS e macOS: botões, cards, gráficos, formulários e mais."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="Status da CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Versão mais recente: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Plataformas compatíveis: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Versão da linguagem: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Licença: MIT"></picture></a>
</p>

<p align="center">
<a href="#início-rápido"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-pt-BR-light.svg" alt="Começar"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-pt-BR-light.svg" alt="Documentação"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-pt-BR-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-pt-BR-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-pt-BR-light.svg" alt="Exemplos"></picture></a>
</p>

> Esta é uma tradução do README em inglês. Se houver diferença, vale a versão em inglês.

<!-- brand:end -->

Um pacote Swift com views SwiftUI prontas para iOS 17+ e macOS 14+: botões, cards, gráficos, campos
de formulário com validação, gestos, listas, sobreposições, indicadores de carregamento e avisos.
Ele é para desenvolvedores de apps que querem um componente funcionando hoje em vez de escrevê-lo do
zero. Cada componente é uma `View` comum do SwiftUI configurada pelo inicializador, então você pode
usar um ou dois sem adotar um sistema de temas ou uma arquitetura. O pacote não tem dependências.

## Destaques

- **223 views, 12 modifiers de view e 5 modifiers de gestos**: contados no código-fonte e
  organizados nas 14 categorias abaixo, de `PrimaryButton` a `CreditCardInput`, `SchemaForm` e
  `ShapeDrawingPad`.
- **Formulários que se verificam sozinhos**: validadores combináveis, erros que aparecem só depois
  da primeira edição, verificações no servidor com debounce, formulários gerados a partir de JSON e
  fluxos em várias etapas. Os padrões de um esquema JSON rodam com limite de tempo: um padrão
  lento reprova o valor em vez de travar o app.
- **Gestos acessíveis**: deslizes, deslizes a partir da borda, sequências de deslizes,
  pinçar-girar-arrastar e desenho de formas, cada um com uma ação de acessibilidade para usuários do
  VoiceOver e do Switch Control.
- **iOS e macOS com o mesmo código**: detalhes que só existem no UIKit usam o comportamento mais
  próximo do AppKit; as
  [notas de plataforma](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  listam cada um.
- **Modo de linguagem Swift 6**: o pacote compila com verificação estrita de concorrência e sem
  avisos.
- **Lógica testada**: detecção do número do cartão e verificação de Luhn, datas de validade,
  formatação de telefone, validadores, esquemas JSON, fluxos em etapas, reconhecimento de deslizes e
  formas, taxas de contraste, quebra de linha do `FlowLayout`, geometria dos gráficos, paginação e
  as filas de avisos são cobertas por 163 testes do Swift Testing que rodam no macOS e em um
  simulador de iPhone.
- **Exemplos de uso que compilam**: todo exemplo da seção “Uso” vem do
  [app de exemplo](Examples/ComponentGallery), que a CI compila para iOS e macOS.

### O que está incluído

| Categoria          | Exemplos                                                                                                                                        |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Botões (25)        | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Cards (27)         | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Gráficos (19)      | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formulários (23)   | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Entradas (13)      | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listas (18)        | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Carregamento (16)  | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Navegação (19)     | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Sobreposições (13) | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Texto (17)         | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Avisos (4)         | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Diversos (27)      | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Estados vazios (1) | `EmptyStateView`                                                                                                                                |
| Gestos (1)         | `ShapeDrawingPad`, mais os modifiers abaixo e `UnistrokeRecognizer`                                                                             |

Layout e modifiers: `FlowLayout` (layout com quebra de linha), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Modifiers de gestos: `.onSwipe(_:perform:)`, `.onEdgeSwipe(from:accessibilityActionName:perform:)`,
`.onSwipeSequence(_:within:perform:)`, `.transformable(_:scaleRange:)` e `.boundedDrag(offset:in:)`.

Validação (não são views): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`,
`StepFlow` e `ColorContrast` (taxas de contraste WCAG).

## Início rápido

**1. Adicione o pacote**

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Cole a URL no campo de busca no canto superior direito da janela. Deixe **Dependency Rule** em
**Up to Next Major Version** a partir de `2.1.0` e clique em **Add Package**. Na janela seguinte,
escolha o target do seu app ao lado de **SwiftUIComponents** e clique em **Add Package** de novo.

**2. Importe o módulo**

```swift
import SwiftUIComponents
```

Coloque esta linha no topo do arquivo Swift em que você usa um componente, abaixo de
`import SwiftUI`.

**3. Use**

Em um app novo do Xcode (**File › New › Project… › App**), substitua todo o conteúdo de
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

Pressione **Run** (⌘R). O app mostra cinco estrelas e um botão azul; toque em uma estrela para
mudar a nota e toque no botão para imprimi-la no console do Xcode.

## Instalação

### Swift Package Manager

No Xcode, escolha **File › Add Package Dependencies…** e informe a URL do repositório:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Ou adicione-o às `dependencies` do seu `Package.swift`:

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

A versão 2.0.0 (outubro de 2026) é a primeira com os componentes atuais. A versão anterior,
1.0.0 (fevereiro de 2026), é anterior a eles: em junho de 2026 os componentes foram substituídos
por código provisório e, em outubro de 2026, foram restaurados, ajustados para compilar no iOS e
no macOS no modo de linguagem Swift 6 e corrigidos onde os novos testes encontraram bugs.
[CHANGELOG.md](CHANGELOG.md) lista as mudanças, inclusive as incompatíveis.

## Uso

Os exemplos abaixo foram copiados de
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift).
Tanto o app de exemplo quanto a suíte de testes compilam esse arquivo.

### Botões

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

### Formulário de pagamento

`CreditCardInput` formata o número enquanto você digita, detecta a bandeira do cartão e valida o
número (Luhn), a data de validade, o tamanho do CVV e o nome do titular.

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

As funções de formatação e validação são públicas, caso você precise delas em outro lugar:

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

Os snackbars entram em uma fila e aparecem um de cada vez; `BannerManager` funciona do mesmo jeito
com `.bannerHost()`, só que um banner novo substitui o atual.

### Layout em fluxo

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

### Formulário validado

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

`ValidatedValue` mostra um erro só depois que o usuário edita o campo ou toca no botão, e os
validadores se combinam com `.and(_:)`. Os validadores de texto incluem `required`, `minLength`,
`email`, `url`, `phone`, `digits` e `matches` (uma expressão regular); `AsyncValidation` aplica
debounce a uma verificação no servidor, como “esse nome de usuário já está em uso?”.

### Formulário a partir de JSON

Descreva os campos como dados, por exemplo em uma resposta do seu servidor:

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

Decodifique-o; isso também rejeita um esquema com ids duplicados, limites impossíveis, uma
expressão regular inválida ou mais campos, padrões ou opções do que seus limites de tamanho
permitem:

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Depois exiba-o e mantenha os valores no seu próprio estado:

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

Os padrões usam a sintaxe de `NSRegularExpression`. Uma comparação que passa de 20 ms é
interrompida e reprova o valor, um texto com mais de 1.000 unidades de código UTF-16 é reprovado
sem ser comparado, e uma chamada a `errors(in:)` gasta no máximo 100 ms com padrões; assim, um
padrão lento vindo de um servidor não consegue travar o formulário.

`MultiStepForm` com `StepFlow` divide um formulário longo em etapas e mantém **Next** desativado até
que a etapa atual seja válida.

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

Todo gesto também tem uma ação de acessibilidade: usuários do VoiceOver recebem **Swipe left** e
**Swipe right** no rotor de ações, o mapa pode ser ampliado com a ação de zoom do sistema, e
`ShapeDrawingPad(accessibilityAlternatives:)` adiciona ações nomeadas para formas. `onEdgeSwipe`,
`onSwipeSequence` e `boundedDrag` cobrem os demais casos.

### Verificação de contraste

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast` calcula a taxa de contraste WCAG 2 entre duas cores e o nível que ela atende (AA, AA
para texto grande ou AAA).

## Demonstração

| Claro                                                   | Escuro                                                  |
| ------------------------------------------------------- | ------------------------------------------------------- |
| ![Botões, claro](docs/images/buttons-light.png)         | ![Botões, escuro](docs/images/buttons-dark.png)         |
| ![Cards, claro](docs/images/cards-light.png)            | ![Cards, escuro](docs/images/cards-dark.png)            |
| ![Gráficos, claro](docs/images/charts-light.png)        | ![Gráficos, escuro](docs/images/charts-dark.png)        |
| ![Indicadores, claro](docs/images/indicators-light.png) | ![Indicadores, escuro](docs/images/indicators-dark.png) |

As capturas de tela são renderizadas no simulador de iOS a partir de
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
por [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Os formulários e gestos da seção Uso, capturados do app de exemplo em um simulador de iPhone por
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Formulário validado                                                 | Formulário a partir de JSON                                                      | Gestos                                                   |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------------- | -------------------------------------------------------- |
| ![Formulário validado, claro](docs/images/example-signUp-light.png) | ![Formulário a partir de JSON, claro](docs/images/example-contactForm-light.png) | ![Gestos, claro](docs/images/example-gestures-light.png) |
| ![Formulário validado, escuro](docs/images/example-signUp-dark.png) | ![Formulário a partir de JSON, escuro](docs/images/example-contactForm-dark.png) | ![Gestos, escuro](docs/images/example-gestures-dark.png) |

Para testar os componentes você mesmo, abra `ComponentGallery.xcodeproj` em
[`Examples/ComponentGallery`](Examples/ComponentGallery) no Xcode, escolha um simulador de iPhone
ou **My Mac** e pressione **Run**. O app tem uma tela para cada exemplo acima;
[Examples/README.md](Examples/README.md) traz os detalhes.

## Documentação

Referência da API e artigos:

- [Referência da API](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, publicada no GitHub Pages a partir do `main`)
- Para gerar localmente, use **Product › Build Documentation** no Xcode ou a linha de comando:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Guias

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — adicionar o pacote, posicionar um componente, mostrar snackbars e paginar uma lista
  ([código-fonte](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — um formulário de pagamento com validação, e o que as verificações cobrem ou não
  ([código-fonte](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — validadores, erros no momento certo, verificações no servidor, formulários a partir de JSON e formulários de várias etapas
  ([código-fonte](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — deslizes, pinçar-girar-arrastar e reconhecimento de formas, com as respectivas ações de acessibilidade
  ([código-fonte](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — o que muda no macOS
  ([código-fonte](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Os artigos estão em inglês.

## Requisitos

| Plataforma  | Versão mínima         |
| ----------- | --------------------- |
| iOS         | 17                    |
| macOS       | 14                    |
| Ferramentas | Swift 6.2 · Xcode 26+ |

A CI compila com o Xcode padrão da imagem `macos-26` dos runners do GitHub. O pacote é
desenvolvido com o Xcode 27.

## Arquitetura

- `Sources/SwiftUIComponents/<Category>/` tem um arquivo por família de componentes. Os componentes
  guardam o estado em `@State` e `@Binding`; os únicos tipos por referência são `SnackBarManager`,
  `BannerManager`, `PaginatedListViewModel` e `AsyncValidation`, todos `@MainActor`.
- As decisões de validação e de gestos são tipos por valor sem código de view (`Validator`,
  `FormSchema`, `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`,
  `UnistrokeRecognizer`), então os modifiers ficam enxutos e as regras têm testes unitários.
- `Extensions/Platform.swift` mapeia as poucas APIs exclusivas do UIKit (cores do sistema,
  feedback háptico, tipo de teclado, maiúsculas automáticas, seletores de roda, `TabView`
  paginada) para o AppKit ou para operações vazias, de modo que os componentes quase não têm
  `#if os(...)`.
- A lógica que pode ser testada sem tela fica em funções estáticas ou nas classes gerenciadoras e
  é coberta por suítes do Swift Testing em `Tests/`. `RenderTests` e `GaugeNeedleTests` desenham
  views com `ImageRenderer`: as páginas da galeria nos modos claro e escuro (o que pega views que
  travam ou ficam com tamanho zero) e a direção do ponteiro do medidor. A maioria das views não
  tem testes próprios.
- A CI roda `swift test` no macOS e `xcodebuild test` em um simulador de iPhone, compila o app de
  exemplo para iOS e macOS e publica a documentação DocC.

Rode os testes localmente:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roteiro

- Adicionar o pacote ao Swift Package Index; o `.spi.yml` já está no repositório.
- Escrever testes para mais views individuais, começando pelos campos de formulário.
- Adicionar campos condicionais ao `FormSchema` (mostrar um campo conforme o valor de outro).

## Como contribuir

Contribuições são bem-vindas. Leia o [guia de contribuição](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) e o [código de conduta](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) antes de abrir um pull request. Relate problemas de segurança de forma privada, como descrito na [política de segurança](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licença

Publicado sob a licença MIT. Veja [LICENSE](LICENSE).
