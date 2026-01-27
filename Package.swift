// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConsentUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ConsentUI",
            targets: ["ConsentUI"]
        ),
    ],
    targets: [
        .target(
            name: "ConsentUI",
            dependencies: [],
            path: "ios/Sources/ConsentUI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ConsentUITests",
            dependencies: ["ConsentUI"],
            path: "ios/Tests/ConsentUITests"
        ),
    ]
)
