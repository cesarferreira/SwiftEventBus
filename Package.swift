// swift-tools-version:5.0

import PackageDescription

let package = Package(name: "SwiftEventBus",
                      platforms: [.macOS(.v10_10),
                                  .iOS(.v8)],
                      
                      products: [.library(name: "SwiftEventBus",
                                          targets: ["SwiftEventBus"])],
                      
                      targets: [.target(name: "SwiftEventBus",
                                        path: "SwiftEventBus")],
                      
                      swiftLanguageVersions: [.v5]
)
