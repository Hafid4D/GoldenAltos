// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "4d-for-ios-form-list-Profile",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v13)
    ],
    products: [
        .library(name: "___PRODUCT___", targets: ["___PRODUCT___"])
    ],
    dependencies: [
       .package(url: "https://github.com/4d-for-ios/QMobileUI.git", .revision("HEAD"))
    ],
    targets: [
        .target(name: "___PRODUCT___", dependencies: ["QMobileUI"], path: "Sources")
    ]
)
