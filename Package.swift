// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "whenami",
    dependencies: [],
    targets: [
        .target(
            name: "whenami", dependencies: []),
        .testTarget(
            name: "WhenamiTests", dependencies: ["whenami"])
    ]
)
