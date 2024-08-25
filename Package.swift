// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "EasyMetalShader",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "EasyMetalShader",
            targets: ["EasyMetalShader"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "510.0.3"),
    ],
    targets: [
        .macro(
            name: "EasyMetalShaderMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "EasyMetalShader",
            dependencies: [
                "EasyMetalShaderMacro"
            ]
        ),
        .testTarget(
            name: "EasyMetalShaderTests",
            dependencies: [
                "EasyMetalShader"
            ]
        )
    ]
)
