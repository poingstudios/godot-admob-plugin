// swift-tools-version:5.9
// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import PackageDescription
import Foundation

struct SPMPackageInfo {
    let url: String
    let version: String
    let products: [String]
}

func parseGDFile(at path: String) -> [SPMPackageInfo] {
    let fileURL = URL(fileURLWithPath: path)
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return []
    }

    let dictPattern = #"\{([^}]+)\}"#
    guard let dictRegex = try? NSRegularExpression(pattern: dictPattern) else { return [] }

    let dictRange = NSRange(content.startIndex..., in: content)
    let dictMatches = dictRegex.matches(in: content, options: [], range: dictRange)

    var packages: [SPMPackageInfo] = []

    for dictMatch in dictMatches {
        let dictContent = String(content[Range(dictMatch.range(at: 1), in: content)!])

        let url = extractValue(from: dictContent, key: "url")
        let version = extractValue(from: dictContent, key: "version")
        let products = extractArray(from: dictContent, key: "products")

        if !url.isEmpty && !version.isEmpty {
            packages.append(SPMPackageInfo(url: url, version: version, products: products))
        }
    }

    return packages
}

func extractValue(from text: String, key: String) -> String {
    let pattern = #""\#(key)"\s*:\s*"([^"]+)""#
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return "" }
    let range = NSRange(text.startIndex..., in: text)
    guard let match = regex.firstMatch(in: text, options: [], range: range) else { return "" }
    return String(text[Range(match.range(at: 1), in: text)!])
}

func extractArray(from text: String, key: String) -> [String] {
    let pattern = #""\#(key)"\s*:\s*\[([^\]]*)\]"#
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
    let range = NSRange(text.startIndex..., in: text)
    guard let match = regex.firstMatch(in: text, options: [], range: range) else { return [] }

    let arrayContent = String(text[Range(match.range(at: 1), in: text)!])
    return arrayContent.components(separatedBy: ",")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "\"")) }
        .filter { !$0.isEmpty }
}

var packageDependencies: [Package.Dependency] = []
var targetDependencies: [Target.Dependency] = []
var seenURLs = Set<String>()
var seenProducts = Set<String>()

let fileManager = FileManager.default
let packagePath = URL(fileURLWithPath: #file).deletingLastPathComponent().path

let searchPaths = [
    "\(packagePath)/src/ads/config",
    "\(packagePath)/src/mediation"
]

var gdFiles: [String] = []

for searchPath in searchPaths {
    if let enumerator = fileManager.enumerator(atPath: searchPath) {
        for case let file as String in enumerator {
            if file.hasSuffix(".gd") {
                gdFiles.append("\(searchPath)/\(file)")
            }
        }
    }
}

if gdFiles.isEmpty {
    print("PoingAdMob: WARNING - No .gd files found in \(searchPaths)")
}

for gdFile in gdFiles {
    print("PoingAdMob: Parsing \(gdFile)")
    let spmPackages = parseGDFile(at: gdFile)
    for package in spmPackages {
        print("PoingAdMob: Found package \(package.url) v\(package.version) → \(package.products)")
        if !seenURLs.contains(package.url) {
            packageDependencies.append(.package(url: package.url, exact: Version(stringLiteral: package.version)))
            seenURLs.insert(package.url)
        }

        let packageName = package.url.components(separatedBy: "/").last?
            .replacingOccurrences(of: ".git", with: "") ?? ""
        for product in package.products {
            if !seenProducts.contains(product) {
                targetDependencies.append(.product(name: product, package: packageName))
                seenProducts.insert(product)
            }
        }
    }
}

let package = Package(
    name: "PoingGodotAdMobDeps",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PoingGodotAdMobDeps",
            targets: ["PoingGodotAdMobDeps"]),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "PoingGodotAdMobDeps",
            dependencies: targetDependencies,
            path: "scripts/spm",
            exclude: [
                "../../godot",
                "../../bin",
                "../../.build"
            ]
        )
    ]
)
// cache_bust: 1
