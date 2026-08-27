// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkService",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "NetworkServiceMocks",
            targets: ["NetworkServiceMocks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "3.2.1"),
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory"),
            ]),
        .target(
            name: "NetworkServiceMocks",
            dependencies: ["NetworkService"]
        ),
        .testTarget(
            name: "NetworkServiceTests",
            dependencies: [
                "NetworkService",
            ]),
    ]
)
