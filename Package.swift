// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UIKitPresentationModifier",
	platforms: [
		.iOS(.v14)
	],
	products: [
		.library(
			name: "UIKitPresentationModifier",
			targets: ["UIKitPresentationModifier"]),
	],
	targets: [
		.target(
			name: "UIKitPresentationModifier",
			dependencies: []),
	]
)
