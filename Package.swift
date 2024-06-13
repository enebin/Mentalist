// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Mentalist",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Mentalist",
            targets: ["Mentalist"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Mentalist",
            dependencies: [],
            resources: [
                .process("Resources/FacialExpressionModel.mlpackage")
            ]
        ),
        .testTarget(
            name: "MentalistTests",
            dependencies: ["Mentalist"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
