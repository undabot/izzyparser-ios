// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IzzyParser",
    platforms: [.iOS(.v9), .macOS(.v10_15)],
    products: [
        .library(
            name: "IzzyParser",
            targets: ["IzzyParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "3.1.2")
    ],
    targets: [
        .target(
            name: "IzzyParser",
            dependencies: [],
            path: "IzzyParser",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "IzzyParserTests",
            dependencies: ["IzzyParser", "Quick", "Nimble"],
            path: "IzzyParserTests",
            exclude: ["Info.plist"],
            resources: [.process("JSONExamples")]
        ),
    ]
)
