// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Benchmarks",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark.git", .upToNextMajor(from: "1.0.0")),
        .package(path: "../../Fuse"),
    ],
    targets: [
        .executableTarget(
            name: "RenderToString",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "Fuse", package: "Fuse"),
            ],
            path: "Benchmarks/RenderToString",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
    ]
)
