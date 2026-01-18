// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-container-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(
            name: "Container Primitives",
            targets: ["Container Primitives"]
        )
    ],
    dependencies: [
        .package(path: "../swift-storage-primitives")
    ],
    targets: [
        .target(
            name: "Container Primitives",
            dependencies: [
                .product(name: "Storage Primitives", package: "swift-storage-primitives")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety()
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
