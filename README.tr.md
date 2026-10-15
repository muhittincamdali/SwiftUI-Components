<!-- i18n-source: README.md@9069cf84f8474e68967f33b61ce51eb4407ad285 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-light.svg" alt="SwiftUI Components: iOS ve macOS için hazır SwiftUI görünümleri: düğmeler, kartlar, grafikler, formlar ve daha fazlası."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v2.1.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-platforms-light.svg" alt="Desteklenen platformlar: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-language-light.svg" alt="Dil sürümü: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/blob/main/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-license-light.svg" alt="Lisans: MIT"></picture></a>
</p>

<p align="center">
<a href="#hızlı-başlangıç"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-start-tr-light.svg" alt="Başlayın"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-docs-tr-light.svg" alt="Dokümantasyon"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/tree/main/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/button-examples-tr-light.svg" alt="Örnekler"></picture></a>
</p>

> Bu belge İngilizce README'nin çevirisidir. İkisi arasında fark varsa güncel olan İngilizce sürümdür.

<!-- brand:end -->

iOS 17+ ve macOS 14+ için hazır SwiftUI görünümlerinden oluşan bir Swift paketi: düğmeler, kartlar,
grafikler, doğrulamalı form girdileri, hareketler, listeler, katmanlar, yükleme göstergeleri ve
bildirimler. Bir bileşeni sıfırdan yazmak yerine bugün çalışan bir tanesini kullanmak isteyen
uygulama geliştiricileri için hazırlandı. Her bileşen, başlatıcısıyla (initializer) yapılandırılan
sade bir SwiftUI `View`'dur; bu yüzden bir tema sistemi ya da mimari benimsemeden bir veya iki
tanesini kullanabilirsiniz. Paketin hiçbir bağımlılığı yoktur.

## Öne çıkanlar

- **223 görünüm, 12 görünüm modifier'ı ve 5 hareket modifier'ı** — kaynak koddan sayıldı ve aşağıdaki
  14 kategoride gruplandı; `PrimaryButton`'dan `CreditCardInput`, `SchemaForm` ve `ShapeDrawingPad`'e
  kadar.
- **Kendini denetleyen formlar** — birleştirilebilir doğrulayıcılar (validator), ilk düzenlemeden
  sonra beliren hatalar, geciktirmeli (debounce) sunucu denetimleri, JSON'dan oluşturulan formlar ve
  çok adımlı akışlar. JSON şemasındaki desenler (pattern) bir süre sınırıyla çalışır;
  yavaş bir desen uygulamayı dondurmak yerine değeri geçersiz sayar.
- **Erişilebilir hareketler** — kaydırmalar, kenardan kaydırmalar, kaydırma dizileri,
  sıkıştır-döndür-sürükle ve şekil çizimi; her birinin VoiceOver ve Switch Control kullanıcıları
  için bir erişilebilirlik eylemi vardır.
- **Tek kod tabanından iOS ve macOS** — yalnızca UIKit'te olan ayrıntılar en yakın AppKit
  davranışına düşer; [platform notları](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  her birini listeler.
- **Swift 6 dil modu** — paket sıkı eşzamanlılık denetimiyle ve uyarısız derlenir.
- **Test edilen mantık** — kart numarası tanıma ve Luhn denetimi, son kullanma tarihleri, telefon
  biçimlendirme, doğrulayıcılar, JSON şemaları, adım akışları, kaydırma ve şekil tanıma, kontrast
  oranları, `FlowLayout` satır kırma, grafik geometrisi, sayfalama ve bildirim kuyrukları, macOS'ta
  ve bir iPhone simülatöründe çalışan 163 Swift Testing testiyle kapsanıyor.
- **Derlenen kullanım örnekleri** — “Kullanım” bölümündeki her örnek, CI'ın iOS ve macOS
  için derlediği [örnek uygulamadan](Examples/ComponentGallery) alınmıştır.

### Neler var

| Kategori         | Örnekler                                                                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Düğmeler (25)    | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Kartlar (27)     | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Grafikler (19)   | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formlar (23)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `SliderField`, `OTPField`, `FileUploadField`, `SchemaForm`, `MultiStepForm`      |
| Girdiler (13)    | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listeler (18)    | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Yükleme (16)     | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Gezinme (19)     | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Katmanlar (13)   | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Metin (17)       | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Bildirimler (4)  | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Diğer (27)       | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Boş durumlar (1) | `EmptyStateView`                                                                                                                                |
| Hareketler (1)   | `ShapeDrawingPad`, aşağıdaki modifier'lar ve `UnistrokeRecognizer`                                                                              |

Yerleşim ve modifier'lar: `FlowLayout` (satır kaydıran yerleşim), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

Hareket modifier'ları: `.onSwipe(_:perform:)`,
`.onEdgeSwipe(from:accessibilityActionName:perform:)`, `.onSwipeSequence(_:within:perform:)`,
`.transformable(_:scaleRange:)` ve `.boundedDrag(offset:in:)`.

Doğrulama (görünüm değil): `Validator`, `ValidatedValue`, `AsyncValidation`, `FormSchema`,
`StepFlow` ve `ColorContrast` (WCAG kontrast oranları).

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Adresi pencerenin sağ üstündeki arama alanına yapıştırın. **Dependency Rule** ayarını
**Up to Next Major Version** ve `2.1.0` olarak bırakıp **Add Package**'a tıklayın. Sonraki
pencerede **SwiftUIComponents** satırının yanından uygulama hedefinizi (target) seçin ve yeniden
**Add Package**'a tıklayın.

**2. Modülü içe aktarın**

```swift
import SwiftUIComponents
```

Bu satırı, bileşeni kullandığınız Swift dosyasının en üstüne, `import SwiftUI` satırının altına
koyun.

**3. Kullanın**

Yeni bir Xcode uygulamasında (**File › New › Project… › App**) `ContentView.swift` dosyasının
tüm içeriğini şununla değiştirin:

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

**Run**'a basın (⌘R). Uygulama beş yıldız ve mavi bir düğme gösterir; puanı değiştirmek için
bir yıldıza, puanı Xcode konsoluna yazdırmak için düğmeye dokunun.

## Kurulum

### Swift Package Manager

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Ya da `Package.swift` dosyanızdaki `dependencies` listesine ekleyin:

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

2.0.0 sürümü (Ekim 2026) bugünkü bileşenleri içeren ilk sürümdür. Önceki sürüm olan 1.0.0
(Şubat 2026) bu bileşenlerden öncesine ait: Haziran 2026'da bileşenlerin yerine yer tutucu kod
konmuş, Ekim 2026'da geri getirilip Swift 6 dil modunda iOS ve macOS için derlenir hale
getirilmiş ve yeni testlerin bulduğu hatalar düzeltilmiştir. Uyumsuz değişiklikler dahil tüm
ayrıntılar [CHANGELOG.md](CHANGELOG.md) dosyasında.

## Kullanım

Aşağıdaki örnekler
[`Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift`](Examples/ComponentGallery/ComponentGallery/ReadmeSamples.swift)
dosyasından kopyalanmıştır. Bu dosyayı hem örnek uygulama hem de test paketi derler.

### Düğmeler

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

### Grafikler

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

### Ödeme formu

`CreditCardInput` numarayı siz yazarken biçimlendirir, kart ağını tanır ve numarayı (Luhn),
son kullanma tarihini, CVV uzunluğunu ve kart sahibinin adını doğrular.

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

Biçimlendirme ve doğrulama yardımcıları başka yerde gerekirse diye public'tir:

```swift
let type = CreditCardInput.CardType.detect(from: "3782 822463 10005") // .amex
let pretty = CreditCardInput.formatCardNumber("378282246310005")     // "3782 822463 10005"
let valid = CreditCardInput.isLuhnValid("378282246310005")           // true
```

### Snackbar'lar

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

Snackbar'lar kuyruğa alınır ve teker teker gösterilir; `BannerManager` da `.bannerHost()` ile
aynı şekilde çalışır, tek farkı yeni bir banner'ın mevcut olanın yerini almasıdır.

### Akış yerleşimi

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

### Doğrulamalı form

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

`ValidatedValue`, bir hatayı yalnızca kullanıcı alanı düzenledikten ya da düğmeye bastıktan sonra
gösterir; doğrulayıcılar `.and(_:)` ile birleştirilir. Metin doğrulayıcıları arasında `required`,
`minLength`, `email`, `url`, `phone`, `digits` ve `matches` (düzenli ifade) bulunur;
`AsyncValidation`, “bu kullanıcı adı alınmış mı” gibi bir sunucu denetimini geciktirerek (debounce)
çalıştırır.

### JSON'dan form

Alanları veri olarak tanımlayın, örneğin sunucunuzdan gelen bir yanıtta:

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

Çözümleyin; bu işlem yinelenen kimlikler (id), imkânsız sınırlar, geçersiz bir düzenli ifade ya da
boyut sınırlarının izin verdiğinden fazla alan, desen veya seçenek içeren şemayı da reddeder:

```swift
func loadContactSchema() throws -> FormSchema {
    try FormSchema.decode(from: Data(contactFormJSON.utf8)) // throws for malformed JSON
}
```

Sonra görüntüleyin ve değerleri kendi durumunuzda (state) tutun:

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

Desenler `NSRegularExpression` söz dizimini kullanır. 20 ms'den uzun süren bir eşleştirme durdurulur
ve değer geçersiz sayılır; 1.000 UTF-16 kod biriminden uzun metin eşleştirilmeden geçersiz sayılır;
tek bir `errors(in:)` çağrısı desenlere en fazla 100 ms harcar. Böylece sunucudan gelen yavaş bir
desen formu donduramaz.

`StepFlow` ile `MultiStepForm`, uzun bir formu adımlara böler ve geçerli adım doğrulanana kadar
**Next** düğmesini devre dışı tutar.

### Hareketler

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

Her hareketin ayrıca bir erişilebilirlik eylemi vardır: VoiceOver kullanıcıları eylemler rotorunda
**Swipe left** ve **Swipe right** eylemlerini alır, harita sistemin yakınlaştırma eylemiyle
yakınlaştırılabilir ve `ShapeDrawingPad(accessibilityAlternatives:)` şekiller için adlandırılmış
eylemler ekler. Kalan durumları `onEdgeSwipe`, `onSwipeSequence` ve `boundedDrag` karşılar.

### Kontrast denetimi

```swift
func contrastCheck() {
    let ratio = ColorContrast.ratio(.white, Color(red: 0, green: 0.443, blue: 0.890)) // #0071E3
    let level = ColorContrast.level(for: ratio) // .aa: fine for body text
    print(ratio, level)
}
```

`ColorContrast`, iki renk arasındaki WCAG 2 kontrast oranını ve karşıladığı düzeyi (AA, büyük metin
için AA ya da AAA) hesaplar.

## Demo

| Açık                                                   | Koyu                                                  |
| ------------------------------------------------------ | ----------------------------------------------------- |
| ![Düğmeler, açık](docs/images/buttons-light.png)       | ![Düğmeler, koyu](docs/images/buttons-dark.png)       |
| ![Kartlar, açık](docs/images/cards-light.png)          | ![Kartlar, koyu](docs/images/cards-dark.png)          |
| ![Grafikler, açık](docs/images/charts-light.png)       | ![Grafikler, koyu](docs/images/charts-dark.png)       |
| ![Göstergeler, açık](docs/images/indicators-light.png) | ![Göstergeler, koyu](docs/images/indicators-dark.png) |

Ekran görüntüleri iOS simülatöründe
[`Tests/SwiftUIComponentsTests/Gallery.swift`](Tests/SwiftUIComponentsTests/Gallery.swift)
dosyasından [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) betiğiyle
üretilir.

Kullanım bölümündeki formlar ve hareketler, örnek uygulamadan bir iPhone simülatöründe
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) betiğiyle yakalanmıştır:

| Doğrulamalı form                                                | JSON'dan form                                                     | Hareketler                                                  |
| --------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------- |
| ![Doğrulamalı form, açık](docs/images/example-signUp-light.png) | ![JSON'dan form, açık](docs/images/example-contactForm-light.png) | ![Hareketler, açık](docs/images/example-gestures-light.png) |
| ![Doğrulamalı form, koyu](docs/images/example-signUp-dark.png)  | ![JSON'dan form, koyu](docs/images/example-contactForm-dark.png)  | ![Hareketler, koyu](docs/images/example-gestures-dark.png)  |

Bileşenleri kendiniz denemek için [`Examples/ComponentGallery`](Examples/ComponentGallery)
klasöründeki `ComponentGallery.xcodeproj` dosyasını Xcode ile açın, bir iPhone simülatörü ya da
**My Mac** seçin ve **Run**'a basın. Uygulamada yukarıdaki her örnek için bir ekran vardır;
ayrıntılar [Examples/README.md](Examples/README.md) dosyasında.

## Dokümantasyon

API başvuru belgeleri ve makaleler:

- [API başvurusu](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/)
  (DocC, `main` dalından GitHub Pages'e yayımlanır)
- Yerelde Xcode'da **Product › Build Documentation** ile ya da komut satırından derleyin:

```sh
xcodebuild docbuild -scheme SwiftUIComponents -destination 'generic/platform=macOS'
```

## Rehberler

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/gettingstarted)
  — paketi ekleme, bir bileşen yerleştirme, snackbar gösterme ve bir listeyi sayfalama
  ([kaynak](Sources/SwiftUIComponents/SwiftUIComponents.docc/GettingStarted.md)).
- [Collecting Card Details](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/collectingcarddetails)
  — doğrulamalı bir ödeme formu; denetimlerin neyi kapsayıp neyi kapsamadığı
  ([kaynak](Sources/SwiftUIComponents/SwiftUIComponents.docc/CollectingCardDetails.md)).
- [Validating Forms](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/validatingforms)
  — doğrulayıcılar, hataların doğru zamanda gösterilmesi, sunucu denetimleri, JSON'dan formlar ve çok adımlı formlar
  ([kaynak](Sources/SwiftUIComponents/SwiftUIComponents.docc/ValidatingForms.md)).
- [Adding Gestures](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/addinggestures)
  — kaydırmalar, sıkıştır-döndür-sürükle ve şekil tanıma; erişilebilirlik eylemleriyle birlikte
  ([kaynak](Sources/SwiftUIComponents/SwiftUIComponents.docc/AddingGestures.md)).
- [Platform Differences](https://muhittincamdali.github.io/SwiftUI-Components/documentation/swiftuicomponents/platformdifferences)
  — macOS'ta nelerin değiştiği
  ([kaynak](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)).

Makaleler İngilizcedir.

## Gereksinimler

| Platform     | En düşük sürüm        |
| ------------ | --------------------- |
| iOS          | 17                    |
| macOS        | 14                    |
| Araç zinciri | Swift 6.2 · Xcode 26+ |

CI, GitHub'ın `macos-26` runner imajındaki varsayılan Xcode ile derler. Paket Xcode 27 ile
geliştiriliyor.

## Mimari

- `Sources/SwiftUIComponents/<Category>/` her bileşen ailesi için bir dosya içerir. Bileşenler
  durumlarını `@State` ve `@Binding` içinde tutar; tek referans tipleri `SnackBarManager`,
  `BannerManager`, `PaginatedListViewModel` ve `AsyncValidation`'dır ve dördü de `@MainActor`'dır.
- Doğrulama ve hareket kararları görünüm kodu içermeyen değer tipleridir (`Validator`, `FormSchema`,
  `StepFlow`, `SwipeDirection`, `SwipeSequenceMatcher`, `TransformState`, `UnistrokeRecognizer`);
  böylece modifier'lar ince kalır ve kurallar birim testleriyle denenir.
- `Extensions/Platform.swift`, yalnızca UIKit'te olan birkaç API'yi (sistem renkleri, haptik
  geri bildirim, klavye tipi, büyük harf ayarı, tekerlek seçiciler, sayfalı `TabView`)
  AppKit'e ya da hiçbir şey yapmayan karşılıklara eşler; bu sayede bileşenlerin kendisinde
  neredeyse hiç `#if os(...)` yoktur.
- Ekran olmadan test edilebilen mantık statik fonksiyonlarda ya da yönetici sınıflarda durur ve
  `Tests/` altındaki Swift Testing paketleriyle kapsanır. `RenderTests` ve `GaugeNeedleTests`
  görünümleri `ImageRenderer` ile çizer: galeri sayfalarını açık ve koyu modda (çöken ya da
  boş boyuta küçülen görünümleri yakalar) ve gösterge ibresinin yönünü. Tek tek görünümlerin
  çoğunun kendi testi yoktur.
- CI, macOS'ta `swift test`, bir iPhone simülatöründe `xcodebuild test` çalıştırır, örnek
  uygulamayı iOS ve macOS için derler ve DocC belgelerini yayımlar.

Testleri yerelde çalıştırın:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIComponents \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Yol haritası

- Paketi Swift Package Index'e eklemek; `.spi.yml` depoda zaten var.
- Form girdilerinden başlayarak tek tek görünümler için daha fazla test yazmak.
- `FormSchema` içine koşullu alanlar eklemek (bir alanı başka bir alanın değerine göre göstermek).

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
