// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-container-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Container Primitives",
            targets: ["Container Primitives"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-storage-primitives.git", from: "0.0.1"),
        .package(url: "https://github.com/swift-primitives/swift-test-primitives.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "Container Primitives",
            dependencies: [
                .product(name: "Storage Primitives", package: "swift-storage-primitives"),
            ]
        ),
        .testTarget(
            name: "Container Primitives Tests",
            dependencies: [
                "Container Primitives",
                .product(name: "Test Primitives", package: "swift-test-primitives"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
