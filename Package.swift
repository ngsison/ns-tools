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
    targets: [
        .target(
            name: "NSTools"),
        .testTarget(
            name: "NSToolsTests",
            dependencies: ["NSTools"]
        ),
    ]
)
