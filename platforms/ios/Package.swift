// swift-tools-version:5.9
import PackageDescription
import Foundation

struct SPMPackageInfo {
    let url: String
    let version: String
    let products: [String]
}

func parseGDIPFile(at path: String) -> [SPMPackageInfo] {
    let fileURL = URL(fileURLWithPath: path)
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return []
    }

    guard let spmStart = content.range(of: "spm_packages") else { return [] }
    let afterSpm = String(content[spmStart.upperBound...])

    let sectionPattern = #"\n\s*\[[a-zA-Z]"#
    let nextSection: String
    if let sectionRegex = try? NSRegularExpression(pattern: sectionPattern),
       let sectionMatch = sectionRegex.firstMatch(in: afterSpm, range: NSRange(afterSpm.startIndex..., in: afterSpm)) {
        nextSection = String(afterSpm[afterSpm.startIndex..<Range(sectionMatch.range, in: afterSpm)!.lowerBound])
    } else {
        nextSection = afterSpm
    }

    let dictPattern = #"\{([^}]+)\}"#
    guard let dictRegex = try? NSRegularExpression(pattern: dictPattern) else { return [] }

    let dictRange = NSRange(nextSection.startIndex..., in: nextSection)
    let dictMatches = dictRegex.matches(in: nextSection, options: [], range: dictRange)

    var packages: [SPMPackageInfo] = []

    for dictMatch in dictMatches {
        let dictContent = String(nextSection[Range(dictMatch.range(at: 1), in: nextSection)!])

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

var gdipFiles: [String] = []

for searchPath in searchPaths {
    if let enumerator = fileManager.enumerator(atPath: searchPath) {
        for case let file as String in enumerator {
            if file.hasSuffix(".gdip") {
                gdipFiles.append("\(searchPath)/\(file)")
            }
        }
    }
}

if gdipFiles.isEmpty {
    print("PoingAdMob: WARNING - No .gdip files found in \(searchPaths)")
}

for gdipFile in gdipFiles {
    print("PoingAdMob: Parsing \(gdipFile)")
    let spmPackages = parseGDIPFile(at: gdipFile)
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
    platforms: [.iOS(.v13)],
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
