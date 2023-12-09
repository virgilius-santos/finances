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
         .package(url: "https://github.com/nalexn/ViewInspector", from: "0.9.8"),
         .package(name: "FinancesCoreSharedTests", path: "FinancesCore"),
    ],
    targets: [
        .target(
            name: "FinancesApp",
            dependencies: [
                .productItem(name: "FinancesCore", package: "FinancesCoreSharedTests", moduleAliases: nil, condition: .when(platforms: [.iOS, .macOS]))
            ]),
        .testTarget(
            name: "FinancesAppTests",
            dependencies: [
                "FinancesApp",
                "ViewInspector",
                "FinancesCoreSharedTests",
            ]
        ),
    ]
)
