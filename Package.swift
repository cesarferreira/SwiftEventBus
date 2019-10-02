// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftEventBus",
    products: [
        .library(
            name: "SwiftEventBus",
            targets: ["SwiftEventBus"]
        )
    ],
    dependencies: [],
    targets: [SwiftEventBus
        .target(
            name: "SwiftEventBus",
            dependencies: [],
            path: "SwiftEventBus"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
