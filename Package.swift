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
        .package(path: "../swift-storage-primitives"),
        .package(path: "../swift-test-primitives"),
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

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety(),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
