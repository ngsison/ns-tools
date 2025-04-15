// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NSTools",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "NSTools",
            targets: ["NSTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift", .upToNextMajor(from: "24.0.0")),
    ],
    targets: [
        .target(
            name: "NSTools",
            dependencies: [
                .product(name: "KeychainSwift", package: "keychain-swift")
            ]
        ),
        .testTarget(
            name: "NSToolsTests",
            dependencies: ["NSTools"]
        ),
    ]
)
