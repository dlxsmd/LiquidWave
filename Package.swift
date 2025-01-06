// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiquidWave",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "LiquidWave",
            targets: ["LiquidWave"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LiquidWave",
            dependencies: []
        ),
        .testTarget(
            name: "LiquidWaveTests",
            dependencies: ["LiquidWave"]
        ),
    ]
)
