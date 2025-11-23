// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaseModule",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "BaseModule",
            targets: ["BaseModule"]),
    ],
    targets: [
        .target(
            name: "BaseModule",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "BaseModuleTests",
            dependencies: ["BaseModule"]),
    ]
)

