// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(name: "NetworkService", path: "../NetworkService"),
        .package(name: "MoviesApi", path: "../MoviesApi"),

        .package(url: "https://github.com/kean/Nuke", from: "13.0.1")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                "MoviesApi",
                "NetworkService",
                .product(name: "NukeUI", package: "Nuke"),
            ]),
        .testTarget(
            name: "FeaturesTests",
            dependencies: [
                "Features",
                "MoviesApi",
                .product(name: "MoviesApiMocks", package: "MoviesApi"),
                "NetworkService",
                .product(name: "NetworkServiceMocks", package: "NetworkService")
            ]),
    ]
)
