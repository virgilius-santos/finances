// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FinancesApp",
    platforms: [.iOS("17.2"), .macOS("14.2")],
    products: [
        .library(
            name: "FinancesApp",
            targets: ["FinancesApp"]),
    ],
    dependencies: [
        .package(name: "FinancesCore", path: "FinancesCore"),
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.8"),
        .package(name: "Utils", path: "Utils"),
    ],
    targets: [
        .target(
            name: "FinancesApp",
            dependencies: [
                .product(name: "FinancesCore", package: "FinancesCore"),
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
            ]),
        .testTarget(
            name: "FinancesAppTests",
            dependencies: [
                "FinancesApp",
                "ViewInspector",
                .product(name: "FinancesCoreSharedTests", package: "FinancesCore"),
            ]
        ),
    ]
)
