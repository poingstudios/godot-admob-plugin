// swift-tools-version:5.9
import PackageDescription
import Foundation

struct DependencyInfo {
    let url: String
    let version: String
    let mode: String
    let product: String
}

func parseGDIPFile(at path: String) -> [DependencyInfo] {
    let fileURL = URL(fileURLWithPath: path)
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return []
    }
    
    // Regex to find admob_packages array content
    let pattern = #"admob_packages\s*=\s*\[\s*([\s\S]*?)\s*\]"#
    guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
    
    let range = NSRange(content.startIndex..., in: content)
    guard let match = regex.firstMatch(in: content, options: [], range: range) else { return [] }
    
    let arrayContent = String(content[Range(match.range(at: 1), in: content)!])
    
    // Parse each line in the array: "url@mode:version|product"
    let lines = arrayContent.components(separatedBy: ",")
    var dependencies: [DependencyInfo] = []
    
    for line in lines {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        
        if trimmedLine.isEmpty { continue }
        
        // Split by @ and |
        let mainParts = trimmedLine.components(separatedBy: "|")
        let product = mainParts.count > 1 ? mainParts[1] : ""
        
        let urlAndRules = mainParts[0].components(separatedBy: "@")
        let url = urlAndRules[0]
        
        if urlAndRules.count > 1 {
            let rules = urlAndRules[1].components(separatedBy: ":")
            if rules.count > 1 {
                dependencies.append(DependencyInfo(
                    url: url,
                    version: rules[1],
                    mode: rules[0],
                    product: product
                ))
            }
        }
    }
    
    return dependencies
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
    let deps = parseGDIPFile(at: gdipFile)
    for dep in deps {
        print("PoingAdMob: Found dependency \(dep.product) from \(dep.url)")
        if !seenURLs.contains(dep.url) {
            if dep.mode == "exact" {
                packageDependencies.append(.package(url: dep.url, exact: Version(stringLiteral: dep.version)))
            } else if dep.mode == "from" {
                packageDependencies.append(.package(url: dep.url, from: Version(stringLiteral: dep.version)))
            } else if dep.mode == "branch" {
                packageDependencies.append(.package(url: dep.url, branch: dep.version))
            }
            seenURLs.insert(dep.url)
        }
        
        if !seenProducts.contains(dep.product) && !dep.product.isEmpty {
            let packageName = dep.url.components(separatedBy: "/").last?
                .replacingOccurrences(of: ".git", with: "") ?? ""
            targetDependencies.append(.product(name: dep.product, package: packageName))
            seenProducts.insert(dep.product)
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
