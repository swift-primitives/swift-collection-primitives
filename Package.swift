// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-collection-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Collection Primitives",
            targets: ["Collection Primitives"]
        ),
        .library(
            name: "Collection Primitives Test Support",
            targets: ["Collection Primitives Test Support"]
        )
    ],
    dependencies: [
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-index-primitives"),
        .package(path: "../swift-ordering-primitives"),
        .package(path: "../swift-property-primitives"),
        .package(path: "../swift-sequence-primitives"),
    ],
    targets: [
        .target(
            name: "Collection Primitives",
            dependencies: [
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Ordering Primitives", package: "swift-ordering-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Sequence Primitives", package: "swift-sequence-primitives"),
            ]
        ),
        .target(
            name: "Collection Primitives Test Support",
            dependencies: [
                "Collection Primitives",
                .product(name: "Index Primitives Test Support", package: "swift-index-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Collection Primitives Tests",
            dependencies: [
                "Collection Primitives",
                "Collection Primitives Test Support"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
