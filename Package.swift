// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Carlo",
    products: [
        .library(name: "Carlo", targets: ["Carlo"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Carlo", dependencies: []),
        .testTarget(name: "CarloTests", dependencies: ["Carlo"])
    ]
)
