<!-- i18n-source: README.md@32c9a3e0b7d98fdff756d5ac98cf73c83cb0c76c status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/banner-tr-light.svg" alt="SwiftUI Components: iOS ve macOS için hazır SwiftUI görünümleri: düğmeler, kartlar, grafikler, formlar ve daha fazlası."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Components/actions/workflows/ci.yml/badge.svg" alt="CI durumu"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Components/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Components/main/.github/brand/badge-version-light.svg" alt="Son sürüm: v1.0.0 · predates main"></picture></a>
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

iOS 17+ ve macOS 14+ için hazır SwiftUI görünümlerinden oluşan bir Swift paketi: düğmeler,
kartlar, grafikler, form girdileri, listeler, katmanlar, yükleme göstergeleri ve bildirimler.
Bir bileşeni sıfırdan yazmak yerine bugün çalışan bir tanesini kullanmak isteyen uygulama
geliştiricileri için hazırlandı. Her bileşen, başlatıcısıyla (initializer) yapılandırılan sade
bir SwiftUI `View`'dur; bu yüzden bir tema sistemi ya da mimari benimsemeden bir veya iki
tanesini kullanabilirsiniz. Paketin hiçbir bağımlılığı yoktur.

## Öne çıkanlar

- **220 görünüm, 12 modifier** — kaynak koddan sayıldı ve 13 klasörde gruplandı;
  `PrimaryButton`'dan `CreditCardInput` ve `GaugeChart`'a kadar.
- **Tek kod tabanından iOS ve macOS** — yalnızca UIKit'te olan ayrıntılar en yakın AppKit
  davranışına düşer; [platform notları](Sources/SwiftUIComponents/SwiftUIComponents.docc/PlatformDifferences.md)
  her birini listeler.
- **Swift 6 dil modu** — paket sıkı eşzamanlılık denetimiyle ve uyarısız derlenir.
- **Test edilen mantık** — kart numarası tanıma ve Luhn denetimi, son kullanma tarihleri,
  telefon biçimlendirme, `FlowLayout` satır kırma, grafik geometrisi, sayfalama ve bildirim
  kuyrukları, macOS'ta ve bir iPhone simülatöründe çalışan 56 Swift Testing testiyle
  kapsanıyor.
- **Derlenen kullanım örnekleri** — “Kullanım” bölümündeki her örnek, CI'ın iOS ve macOS
  için derlediği [örnek uygulamadan](Examples/ComponentGallery) alınmıştır.

### Neler var

| Kategori         | Örnekler                                                                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Düğmeler (25)    | `PrimaryButton`, `SecondaryButton`, `LoadingButton`, `GradientButton`, `PillButton`, `FloatingActionButton`, `SplitButton`, `ToggleButtonGroup` |
| Kartlar (27)     | `CardView`, `StatCard`, `PricingCard`, `ProfileCard`, `ProductCard`, `FlipCard`, `ExpandableCard`, `TestimonialCarousel`                        |
| Grafikler (19)   | `BarChart`, `LineChart`, `AreaChart`, `PieChart`, `DonutChart`, `GaugeChart`, `RingChart`, `SparklineChart`                                     |
| Formlar (21)     | `FormField`, `TextInputField`, `PasswordField`, `SelectField`, `MultiSelectField`, `SliderField`, `RangeSlider`, `OTPField`, `DateField`        |
| Girdiler (13)    | `CreditCardInput`, `PhoneInput`, `PinInput`, `TimedPinInput`, `RatingInput`, `SearchBar`, `TagInput`                                            |
| Listeler (18)    | `InfiniteScrollList` + `PaginatedListViewModel`, `ExpandableList`, `TreeView`, `SwipeableRow`, `ReorderableList`                                |
| Yükleme (16)     | `ProgressRing`, `SkeletonView`, `ShimmerView`, `DotLoader`, `PulseLoader`, `StateView`, `AsyncContentView`                                      |
| Gezinme (19)     | `SegmentedControl`, `StepsIndicator`, `PageIndicator`, `BreadcrumbView`, `CustomTabBar`, `SideMenu`                                             |
| Katmanlar (13)   | `BottomSheet`, `AlertDialog`, `ConfirmationDialog`, `ModalView`, `Tooltip`, `PopoverView`                                                       |
| Metin (17)       | `HighlightedText`, `ExpandableText`, `TypewriterText`, `MarqueeText`, `AnimatedCounter`, `GradientText`                                         |
| Bildirimler (4)  | `ToastView`, `SnackBar` + `SnackBarManager`, `Banner` + `BannerManager`                                                                         |
| Diğer (27)       | `Avatar`, `Badge`, `Chip`, `Tag`, `Carousel`, `Accordion`, `CountdownTimer`, `Stopwatch`                                                        |
| Boş durumlar (1) | `EmptyStateView`                                                                                                                                |

Yerleşim ve modifier'lar: `FlowLayout` (satır kaydıran yerleşim), `.surface()`, `.shimmer()`,
`.toast(isPresenting:message:)`, `.snackBarHost()`, `.bannerHost()`.

## Hızlı başlangıç

**1. Paketi ekleyin**

Xcode'da **File › Add Package Dependencies…** menüsünü seçin ve depo adresini girin:

```text
https://github.com/muhittincamdali/SwiftUI-Components.git
```

Adresi pencerenin sağ üstündeki arama alanına yapıştırın. **Dependency Rule** ayarını
**Branch** yapıp `main` yazın, ardından **Add Package**'a tıklayın. Sonraki pencerede
**SwiftUIComponents** satırının yanından uygulama hedefinizi (target) seçin ve yeniden
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
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", branch: "main")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

Şimdilik `main` dalını kullanın. Tek sürüm olan 1.0.0 (Şubat 2026) bugünkü bileşenlerden
öncesine ait: Haziran 2026'da bileşenlerin yerine yer tutucu kod konmuş, Ekim 2026'da geri
getirilip Swift 6 dil modunda iOS ve macOS için derlenir hale getirilmiş ve yeni testlerin
bulduğu hatalar düzeltilmiştir. Ayrıntılar [CHANGELOG.md](CHANGELOG.md) dosyasında.

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
  `BannerManager` ve `PaginatedListViewModel`'dır ve üçü de `@MainActor`'dır.
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

- Geri getirilen bileşenlerin bir sürümünü etiketlemek; böylece paket `main` dalı yerine bir
  sürüm kuralıyla eklenebilir.
- Paketi Swift Package Index'e eklemek; `.spi.yml` depoda zaten var.
- Form girdilerinden başlayarak tek tek görünümler için daha fazla test yazmak.

## Katkıda bulunma

Katkılarınızı bekliyoruz. Pull request açmadan önce [katkı rehberini](https://github.com/muhittincamdali/SwiftUI-Components/blob/main/CONTRIBUTING.md) ve [davranış kurallarını](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) okuyun. Güvenlik açıklarını [güvenlik politikasında](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) anlatıldığı gibi gizli olarak bildirin.

## Lisans

MIT lisansıyla yayımlanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına bakın.
