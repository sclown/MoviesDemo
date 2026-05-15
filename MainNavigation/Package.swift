// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainNavigation",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "MainNavigation",
            targets: ["MainNavigation"]
        ),
    ],
    dependencies: [
        .package(name: "MoviesApi", path: "../MoviesApi"),
        .package(name: "MoviesCore", path: "../MoviesCore"),
        .package(name: "Movies", path: "../Movies"),
        .package(name: "Search", path: "../Search"),
    ],
    targets: [
        .target(
            name: "MainNavigation",
            dependencies: [
                "MoviesApi",
                "MoviesCore",
                "Movies",
                "Search",
            ]),
        .testTarget(
            name: "MainNavigationTests",
            dependencies: [
                "MainNavigation",
                "MoviesCore",
            ]),
    ]
)
