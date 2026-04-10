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
        .package(name: "Features", path: "../Features"),
    ],
    targets: [
        .target(
            name: "MainNavigation",
            dependencies: [
                "MoviesApi",
                "Features"
            ]),
        .testTarget(
            name: "MainNavigationTests",
            dependencies: [
                "MainNavigation",
            ]),
    ]
)
