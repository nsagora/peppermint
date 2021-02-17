// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ValidationToolkit",
    products: [
        .library(
            name: "ValidationToolkit",
            targets: ["ValidationToolkit"])
    ],
    targets: [
        .target(
            name: "ValidationToolkit"
        ),
        .testTarget(
            name: "ValidationToolkitTests",
            dependencies: ["ValidationToolkit"]
        ),
    ]
)
