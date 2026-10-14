// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "SwiftUIComponents", targets: ["SwiftUIComponents"])
    ],
    targets: [
        .target(
            name: "SwiftUIComponents",
            path: "Sources/SwiftUIComponents"
        ),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: ["SwiftUIComponents"]
        )
    ]
)
