// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]
        )
    ],
    targets: [
        .target(
            name: "SwiftUIComponents",
            path: "Sources/SwiftUIComponents"
        ),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: ["SwiftUIComponents"],
            path: "Tests/SwiftUIComponentsTests"
        )
    ]
)
