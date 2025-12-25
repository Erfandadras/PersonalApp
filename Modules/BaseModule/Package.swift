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
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "26.0.0"),
    ],
    targets: [
        .target(
            name: "BaseModule",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "BaseModuleTests",
            dependencies: ["BaseModule"]),
    ]
)

