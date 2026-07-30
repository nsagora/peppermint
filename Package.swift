// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Peppermint",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Peppermint",
            targets: ["Peppermint"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "Peppermint",
            path:"Sources"),
        .testTarget(
            name: "PeppermintTests",
            dependencies: ["Peppermint"],
            path:"Tests")
    ]
)
