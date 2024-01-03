// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyMetalShader",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
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
    ]
)
