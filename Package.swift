// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftEventBus",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v10)
    ],
    
    products: [.library(
                name: "SwiftEventBus",
                targets: ["SwiftEventBus"])
    ],
    
    targets: [.target(
                name: "SwiftEventBus",
                path: "SwiftEventBus",
                exclude: [
                    "Info.plist",
                ])
    ],
    
    swiftLanguageVersions: [.v5]
)
