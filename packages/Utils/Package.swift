// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [.iOS("17.2"), .macOS("14.2")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FoundationUtils",
            targets: ["FoundationUtils"]
        ),
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]
        ),
    ],
    dependencies: [
//        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.8"),
        .package(url: "https://github.com/huybuidac/SwiftUIFontIcon", from: "2.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FoundationUtils"
        ),
        .target(
            name: "SwiftUIComponents",
            dependencies: [
                .product(name: "SwiftUIFontIcon", package: "SwiftUIFontIcon"),
            ]
        ),
    ]
)
