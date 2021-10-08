// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PockKit",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .library(name: "PockKit", targets: ["PockKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/roberthein/TinyConstraints.git", .upToNextMajor(from: "4.0.2"))
    ],
    targets: [
        .target(
            name: "PockKit",
            dependencies: ["TinyConstraints"],
            path: "PockKit"
        )
    ],
    swiftLanguageVersions: [.v5]
)
