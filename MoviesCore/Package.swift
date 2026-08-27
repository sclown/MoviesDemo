// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MoviesCore",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MoviesCore",
            targets: ["MoviesCore"]
        ),
    ],
    dependencies: [
        .package(name: "MoviesApi", path: "../MoviesApi"),
        .package(url: "https://github.com/hmlongco/Factory", from: "3.2.1"),
    ],
    targets: [
        .target(
            name: "MoviesCore",
            dependencies: [
                "MoviesApi",
                .product(name: "FactoryKit", package: "Factory"),
            ]),
        .testTarget(
            name: "MoviesCoreTests",
            dependencies: [
                "MoviesCore",
                .product(name: "MoviesApiMocks", package: "MoviesApi"),
            ]),
    ]
)
