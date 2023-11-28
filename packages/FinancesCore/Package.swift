// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FinancesCore",
    platforms: [.iOS("17.2"), .macOS("14.2")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FinancesCore",
            targets: ["FinancesCore"]),
        .library(
            name: "FinancesCoreSharedTests",
            targets: ["FinancesCoreSharedTests"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FinancesCore",
            dependencies: []),
        .target(
            name: "FinancesCoreSharedTests",
            dependencies: ["FinancesCore"]),
        .testTarget(
            name: "FinancesCoreTests",
            dependencies: ["FinancesCore", "FinancesCoreSharedTests"]),
    ]
)
