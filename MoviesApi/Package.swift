// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoviesApi",
    platforms: [
        .iOS(.v18),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MoviesApi",
            targets: ["MoviesApi"]
        ),
        .library(
            name: "MoviesApiMocks",
            targets: ["MoviesApiMocks"]
        ),
    ],
    dependencies: [
        .package(name: "NetworkService", path: "../NetworkService"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.0"),
    ],
    targets: [
        .target(
            name: "MoviesApi",
            dependencies: [
                "NetworkService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "MoviesApiMocks",
            dependencies: [
                "MoviesApi"
            ]),
        .testTarget(
            name: "MoviesApiTests",
            dependencies: [
                "MoviesApi",
                "MoviesApiMocks",
                "NetworkService",
                .product(name: "NetworkServiceMocks", package: "NetworkService"),
            ]),
    ]
)
