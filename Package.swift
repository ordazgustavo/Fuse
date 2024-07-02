// swift-tools-version: 5.10

import PackageDescription

let swiftSettings: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency=complete")]

let package = Package(
    name: "Fuse",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Fuse", targets: ["Fuse"]),
        .executable(name: "Server", targets: ["Server"]),
        .executable(name: "Client", targets: ["Client"]),
        .library(name: "App", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/carton", from: "1.1.2"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", from: "0.19.3"),
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", branch: "main"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-compression.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Fuse",
            dependencies: [
                .product(
                    name: "JavaScriptKit",
                    package: "JavaScriptKit"
                    // condition: .when(platforms: [.wasi])
                ),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "App",
            dependencies: ["Fuse"],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "Server",
            dependencies: [
                "Fuse",
                "App",
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdCompression", package: "hummingbird-compression"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "Client",
            dependencies: ["Fuse", "App"],
            swiftSettings: swiftSettings
        ),
        .testTarget(name: "FuseTests", dependencies: ["Fuse"]),
    ]
)
