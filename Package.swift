// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyMetalShader",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "EasyMetalShader",
            targets: ["EasyMetalShader"]
        ),
    ],
    targets: [
        .target(
            name: "EasyMetalShader"
        ),
        .testTarget(
            name: "EasyMetalShaderTests",
            dependencies: [
                "EasyMetalShader"
            ]
        )
    ]
)
