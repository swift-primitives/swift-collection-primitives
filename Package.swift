// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-collection-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Sub-targets
        .library(
            name: "Collection Access Random Primitives",
            targets: ["Collection Access Random Primitives"]
        ),
        .library(
            name: "Collection Bidirectional Primitives",
            targets: ["Collection Bidirectional Primitives"]
        ),
        .library(
            name: "Collection Clearable Primitives",
            targets: ["Collection Clearable Primitives"]
        ),
        .library(
            name: "Collection ForEach Primitives",
            targets: ["Collection ForEach Primitives"]
        ),
        .library(
            name: "Collection Indexed Primitives",
            targets: ["Collection Indexed Primitives"]
        ),
        .library(
            name: "Collection Max Primitives",
            targets: ["Collection Max Primitives"]
        ),
        .library(
            name: "Collection Min Primitives",
            targets: ["Collection Min Primitives"]
        ),
        .library(
            name: "Collection Namespace Primitives",
            targets: ["Collection Namespace Primitives"]
        ),
        .library(
            name: "Collection Primitives Standard Library Integration",
            targets: ["Collection Primitives Standard Library Integration"]
        ),
        .library(
            name: "Collection Protocol Primitives",
            targets: ["Collection Protocol Primitives"]
        ),
        .library(
            name: "Collection Remove Primitives",
            targets: ["Collection Remove Primitives"]
        ),
        .library(
            name: "Collection Rotated Primitives",
            targets: ["Collection Rotated Primitives"]
        ),
        .library(
            name: "Collection Slice Primitives",
            targets: ["Collection Slice Primitives"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Collection Primitives",
            targets: ["Collection Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Collection Primitives Test Support",
            targets: ["Collection Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-index-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-order-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-property-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Namespace
        .target(
            name: "Collection Namespace Primitives"
        ),

        // MARK: - Protocol
        .target(
            name: "Collection Protocol Primitives",
            dependencies: [
                "Collection Namespace Primitives",
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),

        // MARK: - Indexed
        .target(
            name: "Collection Indexed Primitives",
            dependencies: [
                "Collection Namespace Primitives",
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),

        // MARK: - Bidirectional
        .target(
            name: "Collection Bidirectional Primitives",
            dependencies: [
                "Collection Namespace Primitives",
                "Collection Protocol Primitives",
            ]
        ),

        // MARK: - Access.Random
        .target(
            name: "Collection Access Random Primitives",
            dependencies: [
                "Collection Bidirectional Primitives",
                "Collection Namespace Primitives",
                "Collection Protocol Primitives",
            ]
        ),

        // MARK: - Clearable
        .target(
            name: "Collection Clearable Primitives",
            dependencies: [
                "Collection Namespace Primitives",
                "Collection Protocol Primitives",
            ]
        ),

        // MARK: - ForEach
        .target(
            name: "Collection ForEach Primitives",
            dependencies: [
                "Collection Clearable Primitives",
                "Collection Protocol Primitives",
                .product(name: "Property Primitives", package: "swift-property-primitives"),
            ]
        ),

        // MARK: - Max
        .target(
            name: "Collection Max Primitives",
            dependencies: [
                "Collection Protocol Primitives",
                .product(name: "Order Primitives", package: "swift-order-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
            ]
        ),

        // MARK: - Min
        .target(
            name: "Collection Min Primitives",
            dependencies: [
                "Collection Protocol Primitives",
                .product(name: "Order Primitives", package: "swift-order-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
            ]
        ),

        // MARK: - Remove
        .target(
            name: "Collection Remove Primitives",
            dependencies: [
                "Collection Clearable Primitives",
                "Collection Protocol Primitives",
            ]
        ),

        // MARK: - Rotated
        .target(
            name: "Collection Rotated Primitives",
            dependencies: [
                "Collection Namespace Primitives",
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),

        // MARK: - Slice
        .target(
            name: "Collection Slice Primitives",
            dependencies: [
                "Collection Protocol Primitives",
                .product(name: "Property Primitives", package: "swift-property-primitives"),
            ]
        ),

        // MARK: - Standard Library Integration
        .target(
            name: "Collection Primitives Standard Library Integration",
            dependencies: [
                "Collection Access Random Primitives",
                "Collection Bidirectional Primitives",
                "Collection Protocol Primitives",
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Collection Primitives",
            dependencies: [
                "Collection Access Random Primitives",
                "Collection Bidirectional Primitives",
                "Collection Clearable Primitives",
                "Collection ForEach Primitives",
                "Collection Indexed Primitives",
                "Collection Max Primitives",
                "Collection Min Primitives",
                "Collection Namespace Primitives",
                "Collection Primitives Standard Library Integration",
                "Collection Protocol Primitives",
                "Collection Remove Primitives",
                "Collection Rotated Primitives",
                "Collection Slice Primitives",
            ]
        ),

        // MARK: - Test Support
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
                "Collection Primitives Test Support",
            ]
        ),
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
