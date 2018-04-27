// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "DeflateSwift",
    products: [
    	.library(name: "DeflateSwift", targets: ["DeflateSwift"])
    ],
    dependencies: [
    	// Dummy package to add zlib support in linux
       .package(url: "https://github.com/apple/swift-nio-zlib-support.git", from: "1.0.0"),
    ],
    targets: [
    	.target(name: "DeflateSwift"),
	]
)
