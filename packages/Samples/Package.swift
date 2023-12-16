// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Samples",
    platforms: [.iOS("17.2"), .macOS("14.2")],
    products: [
        .library(
            name: "AppPromo",
            targets: ["AppPromo"]
        ),
        .library(
            name: "CloudApp",
            targets: ["CloudApp"]
        ),
        .library(
            name: "ExpenseTrackerDesignCode",
            targets: ["ExpenseTrackerDesignCode"]
        ),
        .library(
            name: "ExpenseTrackerKavsoft",
            targets: ["ExpenseTrackerKavsoft"]
        ),
        .library(
            name: "Wallet",
            targets: ["Wallet"]
        ),
    ],
    dependencies: [
        .package(name: "Utils", path: "Utils"),
        .package(url: "https://github.com/huybuidac/SwiftUIFontIcon", from: "2.1.0"),
        .package(url: "https://github.com/apple/swift-collections", branch: "release/1.1"),
    ],
    targets: [
        .target(
            name: "AppPromo",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
            ]
        ),
        .target(
            name: "CloudApp",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
            ]
        ),
        .target(
            name: "ExpenseTrackerDesignCode",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "SwiftUIFontIcon", package: "SwiftUIFontIcon"),
            ]
        ),
        .target(
            name: "ExpenseTrackerKavsoft",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
            ]
        ),
        .target(
            name: "Wallet",
            dependencies: [
                .product(name: "SwiftUIComponents", package: "Utils"),
                .product(name: "FoundationUtils", package: "Utils"),
            ]
        ),
    ]
)
