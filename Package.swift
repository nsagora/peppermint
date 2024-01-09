// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Peppermint",
    products: [
        .library(
            name: "Peppermint",
            targets: ["Peppermint"])
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
