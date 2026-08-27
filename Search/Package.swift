// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Search",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Search",
            targets: ["Search"]
        ),
    ],
    dependencies: [
        .package(name: "NetworkService", path: "../NetworkService"),
        .package(name: "MoviesApi", path: "../MoviesApi"),
        .package(name: "MoviesCore", path: "../MoviesCore"),

        .package(url: "https://github.com/kean/Nuke", from: "13.0.1"),
        .package(url: "https://github.com/EmergeTools/SnapshotPreviews", from: "0.12.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.0"),
        .package(url: "https://github.com/hmlongco/Factory", from: "3.2.1")
    ],
    targets: [
        .target(
            name: "Search",
            dependencies: [
                "MoviesApi",
                "NetworkService",
                "MoviesCore",
                .product(name: "NukeUI", package: "Nuke"),
                .product(name: "FactoryKit", package: "Factory"),
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "SearchTests",
            dependencies: [
                "Search",
                "MoviesApi",
                "MoviesCore",
                .product(name: "MoviesApiMocks", package: "MoviesApi"),
                "NetworkService",
                .product(name: "NetworkServiceMocks", package: "NetworkService"),
                .product(name: "SnapshotPreviewsCore", package: "SnapshotPreviews"),
                .product(name: "SnapshottingTests", package: "SnapshotPreviews"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]),
    ]
)
