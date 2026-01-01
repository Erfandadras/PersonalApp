// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ServiceModule",
            targets: ["ServiceModule"]),
    ],
    dependencies: [
        .package(path: "../BaseModule"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0")
    ],
    targets: [
        .target(
            name: "ServiceModule",
            dependencies: [
                "BaseModule",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "ServiceModuleTests",
            dependencies: ["ServiceModule"]),
    ]
)

