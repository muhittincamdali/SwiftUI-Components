# Getting Started

Add the package, place a component, and wire up the shared toast managers.

## Add the package

In Xcode choose **File > Add Package Dependencies…**, paste
`https://github.com/muhittincamdali/SwiftUI-Components.git` into the search field at the top
right, leave **Dependency Rule** at **Up to Next Major Version** from `2.0.0`, choose
**Add Package**, and in the next sheet add the **SwiftUIComponents** library to your app target.
Use 2.0.0 or later: the earlier 1.0.0 release predates the current components. In a package,
add it to `Package.swift` instead:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Components.git", from: "2.0.0")
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SwiftUIComponents", package: "SwiftUI-Components")
    ])
]
```

The package requires Swift 6 tools, iOS 17 or macOS 14.

## Place a component

Import the module in the file where you use a component:

```swift
import SwiftUI
import SwiftUIComponents
```

Components are configured through their initializers. Controls that change state take a
`Binding`:

```swift
struct ReviewForm: View {
    @State private var rating = 0.0

    var body: some View {
        RatingInput(rating: $rating, precision: .half)
    }
}
```

Views that animate on appear, such as ``BarChart`` and ``PieChart``, accept an `animate`
parameter. Pass `false` when the first frame must already show the final state, for example
in snapshot tests.

## Show snackbars and banners

``SnackBarManager`` and ``BannerManager`` hold what is currently on screen. Attach the host
modifier once near the root of a screen, then call `show` from anywhere on the main actor:

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

Snackbars are queued and shown one after another; a new banner replaces the current one.
Both managers have a public initializer if you prefer to inject an instance instead of using
`shared`.

## Paginate a list

``PaginatedListViewModel`` loads pages through an async closure and tracks loading, error and
end-of-list state. Calling `refresh()` while a page is still loading discards that page's result.

```swift
let model = PaginatedListViewModel<Article>(pageSize: 20) { page, size in
    try await api.articles(page: page, limit: size)
}
```

## Next steps

- <doc:CollectingCardDetails> builds a payment form with validation.
- <doc:PlatformDifferences> lists what behaves differently on macOS.
- The `Examples/ComponentGallery` app in the repository shows every README sample on iOS and
  macOS.
