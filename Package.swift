// swift-tools-version:5.5
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
