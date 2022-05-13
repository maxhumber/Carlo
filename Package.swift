// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Carlo",
    products: [
        .library(name: "Carlo", targets: ["Carlo", "TicTacToe"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Carlo", dependencies: []),
        .target(name: "TicTacToe", dependencies: ["Carlo"]),
        .testTarget(name: "CarloTests", dependencies: ["Carlo", "TicTacToe"]),
        .testTarget(name: "TicTacToeTests", dependencies: ["TicTacToe"]),
    ]
)
