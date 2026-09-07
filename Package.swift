// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-magnitude",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Magnitude", targets: ["Magnitude"]),
        .library(name: "Magnitude Standard Library Integration", targets: ["Magnitude Standard Library Integration"]),
        .library(name: "Magnitude Foundation Library Integration", targets: ["Magnitude Foundation Library Integration"]),
        .library(name: "Magnitude Test Support", targets: ["Magnitude Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Magnitude",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Sources/Magnitude"
        ),
        .target(
            name: "Magnitude Standard Library Integration",
            dependencies: [
                .target(name: "Magnitude"),
            ],
            path: "Sources/Magnitude Standard Library Integration"
        ),
        .target(
            name: "Magnitude Foundation Library Integration",
            dependencies: [
                .target(name: "Magnitude"),
                .target(name: "Magnitude Standard Library Integration"),
            ],
            path: "Sources/Magnitude Foundation Library Integration"
        ),
        .target(
            name: "Magnitude Test Support",
            dependencies: [
                .target(name: "Magnitude"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Magnitude Tests",
            dependencies: [
                .target(name: "Magnitude"),
                .target(name: "Magnitude Test Support"),
                .target(name: "Magnitude Standard Library Integration"),
                .target(name: "Magnitude Foundation Library Integration"),
            ],
            path: "Tests/Magnitude Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
