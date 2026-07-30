// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftEventBus",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15),
        .tvOS(.v12),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "SwiftEventBus",
            targets: ["SwiftEventBus"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftEventBus",
            path: "SwiftEventBus",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SwiftEventBusTests",
            dependencies: ["SwiftEventBus"]
        ),
    ]
)
