// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Peppermint",
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
