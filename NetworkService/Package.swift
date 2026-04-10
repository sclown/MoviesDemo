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
    ],
    targets: [
        .target(
            name: "NetworkService",
            dependencies: [
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
