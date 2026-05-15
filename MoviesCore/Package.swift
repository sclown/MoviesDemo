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
    ],
    targets: [
        .target(
            name: "MoviesCore",
            dependencies: [
                "MoviesApi"
            ]),
        .testTarget(
            name: "MoviesCoreTests",
            dependencies: [
                "MoviesCore",
                .product(name: "MoviesApiMocks", package: "MoviesApi"),
            ]),
    ]
)
