# MIT License
# 
# Copyright (c) 2023-present Poing Studios
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

tool
extends EditorPlugin

var _ad_mob_editor: Control
var _exporter := PoingAdMobEditorExportPlugin.new()

class PoingAdMobEditorExportPlugin extends EditorExportPlugin:
	const CFG_FILE_PATH := "res://addons/admob/plugin.cfg"
	const PLUGIN_CONFIG_DIR := "res://ios/plugins/"

	var _export_path := ""
	var _is_ios := false

	func _export_begin(features: PoolStringArray, _is_debug: bool, path: String, _flags: int) -> void:
		print("AdMob Exporter: _export_begin started. Path: ", path, " Features: ", features)
		var file := File.new()

		if file.open(CFG_FILE_PATH, File.READ) == OK:
			print("Exporting Poing AdMob '.cfg' file")
			add_file(CFG_FILE_PATH, file.get_buffer(file.get_len()), false)
		file.close()

		_export_path = path
		_is_ios = false
		for feature in features:
			if feature.to_lower() == "ios" or feature.to_lower() == "iphone":
				_is_ios = true
				break


	func _export_end() -> void:
		if _is_ios:
			_process_ios_spm()

	func _process_ios_spm() -> void:
		if _export_path.empty():
			return

		var spm_dependencies = _collect_spm_dependencies()

		if spm_dependencies.empty():
			return

		var export_dir = _export_path.get_base_dir()

		_generate_package_swift(export_dir, spm_dependencies)
		_generate_dummy_source(export_dir)
		_patch_xcodeproj(export_dir)

	func _collect_spm_dependencies() -> Array:
		var deps := []
		var dir = Directory.new()

		if dir.open(PLUGIN_CONFIG_DIR) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and file_name.ends_with(".gdip"):
					var config = ConfigFile.new()
					var err = config.load(PLUGIN_CONFIG_DIR + file_name)
					if err == OK:
						if config.has_section_key("dependencies", "admob_packages"):
							var packages = config.get_value("dependencies", "admob_packages", [])

							for pkg_str in packages:
								var main_parts = pkg_str.split("|")
								var product = main_parts[1] if main_parts.size() > 1 else ""

								var url_and_rules = main_parts[0].split("@")
								var url = url_and_rules[0]

								if url_and_rules.size() > 1:
									var rules = url_and_rules[1].split(":")
									if rules.size() > 1:
										var dep = {
											"url": url,
											"version": rules[1],
											"kind": rules[0],
											"product": product
										}
										deps.append(dep)
				file_name = dir.get_next()

		return deps

	func _generate_package_swift(export_dir: String, dependencies: Array) -> void:
		var package_dir = export_dir + "/admob_spm"
		var dir = Directory.new()
		if not dir.dir_exists(package_dir):
			dir.make_dir_recursive(package_dir)

		var package_deps_str := ""
		var target_deps_str := ""
		var processed_urls := []
		var processed_products := []

		for dep in dependencies:
			var url = dep.url
			var product = dep.product
			var package_name = url.get_file().replace(".git", "")

			if not processed_urls.has(url):
				processed_urls.append(url)
				var version_rule = ""
				if dep.kind == "exact":
					version_rule = 'exact: "%s"' % dep.version
				else:
					version_rule = 'from: "%s"' % dep.version
				package_deps_str += '        .package(url: "%s", %s),\n' % [url, version_rule]

				if not processed_products.has(product):
					processed_products.append(product)
					target_deps_str += (
						'                .product(name: "%s", package: "%s"),\n'
						% [product, package_name]
					)

		var content := (
			'// swift-tools-version:5.9\n'
			+ 'import PackageDescription\n\n'
			+ 'let package = Package(\n'
			+ '    name: "PoingGodotAdMobDeps",\n'
			+ '    platforms: [.iOS(.v14)],\n'
			+ '    products: [\n'
			+ '        .library(\n'
			+ '            name: "PoingGodotAdMobDeps",\n'
			+ '            targets: ["PoingGodotAdMobDeps"]),\n'
			+ '    ],\n'
			+ '    dependencies: [\n'
			+ package_deps_str
			+ '    ],\n'
			+ '    targets: [\n'
			+ '        .target(\n'
			+ '            name: "PoingGodotAdMobDeps",\n'
			+ '            dependencies: [\n'
			+ target_deps_str
			+ '            ],\n'
			+ '            path: "PoingGodotAdMobDeps"\n'
			+ '        )\n'
			+ '    ]\n'
			+ ')\n'
		)

		var file = File.new()
		if file.open(package_dir + "/Package.swift", File.WRITE) == OK:
			file.store_string(content)
			file.close()
			print("AdMob: Generated Package.swift at " + package_dir)

	func _generate_dummy_source(export_dir: String) -> void:
		var source_dir = export_dir + "/admob_spm/PoingGodotAdMobDeps"
		var dir = Directory.new()
		if not dir.dir_exists(source_dir):
			dir.make_dir_recursive(source_dir)

		var content := (
			"// Dummy\n"
			+ "import Foundation\n\n"
			+ "public struct PoingGodotAdMobDeps {\n"
			+ "    public init() {}\n"
			+ "}\n"
		)
		var file = File.new()
		if file.open(source_dir + "/Dummy.swift", File.WRITE) == OK:
			file.store_string(content)
			file.close()

	func _patch_xcodeproj(export_dir: String) -> void:
		var project_name = _export_path.get_file().get_basename()
		var pbxproj_path = export_dir + "/" + project_name + ".xcodeproj/project.pbxproj"

		var dir = Directory.new()
		if dir.file_exists(pbxproj_path):
			_patch_pbxproj_file(pbxproj_path)
			return

		if dir.open(export_dir) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".xcodeproj"):
					var found_path = export_dir + "/" + file_name + "/project.pbxproj"
					if dir.file_exists(found_path):
						_patch_pbxproj_file(found_path)
					break
				file_name = dir.get_next()

	func _patch_pbxproj_file(path: String) -> void:
		var file = File.new()
		if file.open(path, File.READ) != OK:
			return
		var content = file.get_as_text()
		file.close()

		if content.empty() or content.find("admob_spm") != -1:
			return

		randomize()
		var local_ref_id := _generate_uuid("01")
		var product_dep_id := _generate_uuid("02")
		var build_file_id := _generate_uuid("03")

		if content.find("/* Begin XCLocalSwiftPackageReference section */") == -1:
			content = content.replace(
				"/* End PBXGroup section */",
				"/* End PBXGroup section */\n\n"
				+ "/* Begin XCLocalSwiftPackageReference section */\n"
				+ "/* End XCLocalSwiftPackageReference section */"
			)

		if content.find("/* Begin XCSwiftPackageProductDependency section */") == -1:
			content = content.replace(
				"/* End XCLocalSwiftPackageReference section */",
				"/* End XCLocalSwiftPackageReference section */\n\n"
				+ "/* Begin XCSwiftPackageProductDependency section */\n"
				+ "/* End XCSwiftPackageProductDependency section */"
			)

		var local_ref_def := (
			"		" + local_ref_id
			+ ' /* XCLocalSwiftPackageReference "admob_spm" */ = {\n'
			+ '\t\t\tisa = XCLocalSwiftPackageReference;\n'
			+ '\t\t\trelativePath = "admob_spm";\n'
			+ '\t\t};\n'
		)
		content = content.replace(
			"/* End XCLocalSwiftPackageReference section */",
			local_ref_def + "/* End XCLocalSwiftPackageReference section */"
		)

		var product_dep_def := (
			"		" + product_dep_id
			+ " /* PoingGodotAdMobDeps */ = {\n"
			+ '\t\t\tisa = XCSwiftPackageProductDependency;\n'
			+ '\t\t\tpackage = ' + local_ref_id
			+ ' /* XCLocalSwiftPackageReference "admob_spm" */;\n'
			+ '\t\t\tproductName = "PoingGodotAdMobDeps";\n'
			+ '\t\t};\n'
		)
		content = content.replace(
			"/* End XCSwiftPackageProductDependency section */",
			product_dep_def + "/* End XCSwiftPackageProductDependency section */"
		)

		var build_file_def := (
			"		" + build_file_id
			+ " /* PoingGodotAdMobDeps in Frameworks */"
			+ " = {isa = PBXBuildFile; productRef = "
			+ product_dep_id
			+ " /* PoingGodotAdMobDeps */; };\n"
		)
		content = content.replace(
			"/* Begin PBXBuildFile section */", "/* Begin PBXBuildFile section */\n" + build_file_def
		)

		if content.find("packageReferences = (") != -1:
			content = content.replace(
				"packageReferences = (",
				(
					"packageReferences = (\n				"
					+ local_ref_id
					+' /* XCLocalSwiftPackageReference "admob_spm" */,'
				)
			)
		else:
			content = content.replace(
				"productRefGroup =",
				(
					"packageReferences = (\n				"
					+ local_ref_id
					+' /* XCLocalSwiftPackageReference "admob_spm" */,\n			);\n			productRefGroup ='
				)
			)

		if content.find("packageProductDependencies = (") != -1:
			content = content.replace(
				"packageProductDependencies = (",
				(
					"packageProductDependencies = (\n				"
					+ product_dep_id
					+" /* PoingGodotAdMobDeps */,"
				)
			)
		else:
			content = content.replace(
				"buildRules = (",
				(
					"packageProductDependencies = (\n				"
					+ product_dep_id
					+" /* PoingGodotAdMobDeps */,\n			);\n			buildRules = ("
				)
			)

		var framework_section_start = content.find("isa = PBXFrameworksBuildPhase;")
		if framework_section_start != -1:
			var files_start = content.find("files = (", framework_section_start)
			if files_start != -1:
				content = content.insert(
					files_start + 9,
					"\n				" + build_file_id + " /* PoingGodotAdMobDeps in Frameworks */,"
				)

		if file.open(path, File.WRITE) == OK:
			file.store_string(content)
			file.close()
			print("AdMob: Patched project.pbxproj with SPM dependencies")

	func _generate_uuid(suffix: String) -> String:
		var chars = "0123456789ABCDEF"
		var uuid = "AD110B" + suffix
		while uuid.length() < 24:
			uuid += chars[randi() % 16]
		return uuid

	func _get_name() -> String:
		return "PoingAdMob"

func _enter_tree():
	add_export_plugin(_exporter)

	add_autoload_singleton("MobileAds", "res://addons/admob/src/singletons/MobileAds.gd")
	_ad_mob_editor = load("res://addons/admob/src/core/AdMobEditor.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(_ad_mob_editor)
	_ad_mob_editor.hide()

func _exit_tree():
	remove_export_plugin(_exporter)

	remove_autoload_singleton("MobileAds")
	get_editor_interface().get_editor_viewport().remove_child(_ad_mob_editor)
	_ad_mob_editor.queue_free()

func has_main_screen():
	return true

func make_visible(visible):
	_ad_mob_editor.visible = visible

func get_plugin_name():
	return "AdMob"

func get_plugin_icon():
	return load("res://addons/admob/assets/icon-15.png")
