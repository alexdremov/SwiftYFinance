// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftYFinance",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v12),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftYFinance",
            targets: ["SwiftYFinance"]
        )
    ],

    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftYFinance",
            dependencies: ["SwiftyJSON"], path: "Sources"),
        .testTarget(
            name: "SwiftYFinanceTests",
            dependencies: ["SwiftYFinance", "SwiftyJSON"], path: "Tests/SwiftYFinanceTests")
    ]
)
