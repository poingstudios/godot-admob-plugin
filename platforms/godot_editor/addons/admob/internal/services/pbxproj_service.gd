# MIT License
#
# Copyright (c) 2026-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

static func patch(path: String) -> void:
	var content := FileAccess.get_file_as_string(path)
	if content.is_empty():
		return
	
	if content.contains("AD0000000000000000000001"):
		return

	var local_ref_id := "AD0000000000000000000001"
	var product_dep_id := "AD0000000000000000000002"
	var build_file_id := "AD0000000000000000000003"

	if not content.contains("/* Begin XCLocalSwiftPackageReference section */"):
		content = content.replace("/* End PBXGroup section */", "/* End PBXGroup section */\n\n/* Begin XCLocalSwiftPackageReference section */\n/* End XCLocalSwiftPackageReference section */")
	
	if not content.contains("/* Begin XCSwiftPackageProductDependency section */"):
		content = content.replace("/* End XCLocalSwiftPackageReference section */", "/* End XCLocalSwiftPackageReference section */\n\n/* Begin XCSwiftPackageProductDependency section */\n/* End XCSwiftPackageProductDependency section */")

	var local_ref_def := "		" + local_ref_id + ' /* XCLocalSwiftPackageReference "." */ = {\n			isa = XCLocalSwiftPackageReference;\n			relativePath = ".";\n		};\n'
	content = content.replace("/* End XCLocalSwiftPackageReference section */", local_ref_def + "/* End XCLocalSwiftPackageReference section */")

	var product_dep_def := "		" + product_dep_id + ' /* PoingGodotAdMobDeps */ = {\n			isa = XCSwiftPackageProductDependency;\n			package = ' + local_ref_id + ' /* XCLocalSwiftPackageReference "." */;\n			productName = "PoingGodotAdMobDeps";\n		};\n'
	content = content.replace("/* End XCSwiftPackageProductDependency section */", product_dep_def + "/* End XCSwiftPackageProductDependency section */")

	var build_file_def := "		" + build_file_id + ' /* PoingGodotAdMobDeps in Frameworks */ = {isa = PBXBuildFile; productRef = ' + product_dep_id + " /* PoingGodotAdMobDeps */; };\n"
	content = content.replace("/* Begin PBXBuildFile section */", "/* Begin PBXBuildFile section */\n" + build_file_def)

	if content.contains("packageReferences = ("):
		content = content.replace("packageReferences = (", "packageReferences = (\n				" + local_ref_id + ' /* XCLocalSwiftPackageReference "." */,')
	else:
		content = content.replace("productRefGroup =", "packageReferences = (\n				" + local_ref_id + ' /* XCLocalSwiftPackageReference "." */,\n			);\n			productRefGroup =')

	if content.contains("packageProductDependencies = ("):
		content = content.replace("packageProductDependencies = (", "packageProductDependencies = (\n				" + product_dep_id + " /* PoingGodotAdMobDeps */,")
	else:
		content = content.replace("buildRules = (", "packageProductDependencies = (\n				" + product_dep_id + " /* PoingGodotAdMobDeps */,\n			);\n			buildRules = (")

	var framework_section_start := content.find("isa = PBXFrameworksBuildPhase;")
	if framework_section_start != -1:
		var files_start := content.find("files = (", framework_section_start)
		if files_start != -1:
			content = content.insert(files_start + 9, "\n				" + build_file_id + " /* PoingGodotAdMobDeps in Frameworks */,")

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
		print("AdMob: Patched project.pbxproj with SPM dependencies")
