// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftUIComponents", targets: ["SwiftUIComponents"]),
    ],
    targets: [
        .target(
            name: "SwiftUIComponents",
            path: "Sources/SwiftUIComponents",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SwiftUIComponentsTests",
            dependencies: ["SwiftUIComponents"]
        )
    ]
)
