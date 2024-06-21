// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Fuse",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Fuse", targets: ["Fuse"]),
        .executable(name: "FuseApp", targets: ["FuseApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/carton", from: "1.1.1"),
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", from: "0.19.3"),
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
            ]
        ),
        .executableTarget(name: "FuseApp", dependencies: ["Fuse"]),
        .testTarget(name: "FuseTests", dependencies: ["Fuse"]),
    ]
)
