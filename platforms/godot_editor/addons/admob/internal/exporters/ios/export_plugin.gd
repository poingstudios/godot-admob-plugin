# MIT License

# Copyright (c) 2026-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends "res://addons/admob/internal/exporters/base_export_plugin.gd"

const Library := preload("res://addons/admob/internal/exporters/ios/library.gd")
const PbxprojService := preload("res://addons/admob/internal/services/pbxproj_service.gd")
const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")

var _spm_applied := false
var _pending_export_path := ""
var _spm_dependencies: Array[Dictionary] = []


func _get_name() -> String:
	return "PoingAdMobIOS"


func _supports_platform(platform: EditorExportPlatform) -> bool:
	var ios_enabled := _get_setting(ProjectSettingsService.get_ios_setting_path("enabled"), true) as bool
	return platform is EditorExportPlatformIOS and ios_enabled


func _get_enabled_libs() -> Array[Library]:
	var enabled_libs: Array[Library] = []
	var ios_enabled := _get_setting(ProjectSettingsService.get_ios_setting_path("enabled"), true) as bool
	if not ios_enabled:
		return enabled_libs

	for lib_name in _discover_enabled_libs(Library.ROOT_BIN_PATH):
		enabled_libs.append(Library.new(lib_name, true))

	return enabled_libs


func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	_spm_applied = false
	_pending_export_path = path
	_spm_dependencies.clear()

	if not features.has("ios"):
		return

	var ios_enabled := _get_setting(ProjectSettingsService.get_ios_setting_path("enabled"), true) as bool
	if not ios_enabled:
		return

	_check_legacy_gdip_files()
	PluginVersion.check_version_mismatch(PluginVersion.ios_version, "iOS")

	var enabled_libs := _get_enabled_libs()
	if enabled_libs.is_empty():
		return

	for lib in enabled_libs:
		var config := lib.get_config()
		if config:
			_export_library(lib, config, is_debug)

	var app_id := _get_setting(
		ProjectSettingsService.get_ios_setting_path("app_id"),
		ProjectSettingsService.IOS_DEFAULT_APP_ID
	) as String
	_add_plist_content("<key>GADApplicationIdentifier</key><string>%s</string>\n" % app_id)

	_register_cpp_initialization(enabled_libs)


func _export_library(lib: Library, config: EditorExportPlugin, is_debug: bool) -> void:
	var binary_base := config.get_binary_path() as String
	var base_dir := Library.ROOT_BIN_PATH.path_join(lib.path)
	var file_path := base_dir.path_join(binary_base.get_base_dir())
	var file_name := binary_base.get_file().get_basename()
	var extension := binary_base.get_extension()
	var target_framework := base_dir.path_join(binary_base)
	if DirAccess.dir_exists_absolute(target_framework):
		_add_framework(target_framework)
	else:
		var target_variant := file_path.path_join(file_name + "." + ("debug" if is_debug else "release") + "." + extension)
		if DirAccess.dir_exists_absolute(target_variant):
			_add_framework(target_variant)
		else:
			push_error("AdMob: iOS library binary not found: " + target_framework)

	if config.has_method("get_system_dependencies"):
		for system_dep in config.get_system_dependencies():
			_add_framework(system_dep)

	if config.has_method("get_files_to_copy"):
		for file_to_copy in config.get_files_to_copy():
			var full_file_path := base_dir.path_join(file_to_copy)
			if FileAccess.file_exists(full_file_path):
				_add_bundle_file(full_file_path)
			else:
				push_error("AdMob: iOS resource file not found: " + full_file_path)

	if config.has_method("get_linker_flags"):
		for flag in config.get_linker_flags():
			_add_linker_flags(flag)

	if config.has_method("get_plist_content"):
		_add_plist_content(config.get_plist_content())

	if config.has_method("get_spm_packages"):
		var packages = config.get_spm_packages()
		if has_method("add_apple_embedded_platform_spm_package"):
			for pkg in packages:
				var url: String = pkg.get("url", "")
				var version: String = pkg.get("version", "")
				var products: Array = pkg.get("products", [])
				call("add_apple_embedded_platform_spm_package", url, version, PackedStringArray(products))
		else:
			for pkg in packages:
				var url: String = pkg.get("url", "")
				var version: String = pkg.get("version", "")
				var products: Array = pkg.get("products", [])
				for product: String in products:
					_spm_dependencies.append({
						"url": url,
						"version": version,
						"product": product
					})


func _register_cpp_initialization(enabled_libs: Array[Library]) -> void:
	var definition_code := ""
	var init_calls := ""
	var deinit_calls := ""

	for lib in enabled_libs:
		var config := lib.get_config()
		if not config:
			continue
		var init_method := config.get_initialization_method() as String
		var deinit_method := config.get_deinitialization_method() as String

		definition_code += "extern void %s();\n" % init_method
		definition_code += "extern void %s();\n" % deinit_method

		init_calls += "\t%s();\n" % init_method
		deinit_calls += "\t%s();\n" % deinit_method

	var cpp_code := """
{definition_code}

void godot_apple_embedded_plugins_initialize() {{
{init_calls}
    extern void godot_apple_embedded_plugins_initialize_admob();
    godot_apple_embedded_plugins_initialize_admob();
}}

void godot_apple_embedded_plugins_deinitialize() {{
{deinit_calls}
    extern void godot_apple_embedded_plugins_deinitialize_admob();
    godot_apple_embedded_plugins_deinitialize_admob();
}}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmacro-redefined"
#define godot_apple_embedded_plugins_initialize godot_apple_embedded_plugins_initialize_admob
#define godot_apple_embedded_plugins_deinitialize godot_apple_embedded_plugins_deinitialize_admob
#pragma clang diagnostic pop
""".format({
		"definition_code": definition_code,
		"init_calls": init_calls,
		"deinit_calls": deinit_calls
	})

	_add_cpp_code(cpp_code)


func _end_generate_apple_embedded_project(path: String, _will_build_archive: bool) -> void:
	_apply_spm(path, false)


func _export_end() -> void:
	if _spm_applied or _pending_export_path.is_empty():
		return
	_apply_spm(_pending_export_path, true)


func _apply_spm(path: String, defer_patch: bool) -> void:
	var version_info := Engine.get_version_info()
	var is_lower_than_4_8: bool = (version_info.major < 4) or (version_info.major == 4 and version_info.minor < 8)
	if not is_lower_than_4_8:
		return

	_spm_applied = true
	if _spm_dependencies.is_empty():
		return

	var export_dir := path.get_base_dir()
	_generate_package_swift(export_dir, _spm_dependencies)
	_generate_dummy_source(export_dir)

	if defer_patch:
		_defer_pbxproj_patch.call_deferred(export_dir, path)
	else:
		_patch_xcodeproj(export_dir, path)
		_spm_dependencies.clear()


func _defer_pbxproj_patch(export_dir: String, path: String) -> void:
	_patch_xcodeproj(export_dir, path)
	_spm_dependencies.clear()


func _patch_xcodeproj(export_dir: String, path: String) -> void:
	var project_name := path.get_file().get_basename()
	var pbxproj_path := export_dir.path_join(project_name + ".xcodeproj/project.pbxproj")

	if FileAccess.file_exists(pbxproj_path):
		PbxprojService.patch(pbxproj_path)
		return

	var dir := DirAccess.open(export_dir)
	if not dir:
		push_warning("AdMob: Could not open export directory: %s" % export_dir)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".xcodeproj"):
			var found_path := export_dir.path_join(file_name).path_join("project.pbxproj")
			if FileAccess.file_exists(found_path):
				PbxprojService.patch(found_path)
			else:
				push_warning("AdMob: project.pbxproj not found at: %s" % found_path)
			break
		file_name = dir.get_next()


func _generate_package_swift(export_dir: String, dependencies: Array[Dictionary]) -> void:
	var package_dir := export_dir.path_join("admob_spm")
	if not DirAccess.dir_exists_absolute(package_dir):
		DirAccess.make_dir_recursive_absolute(package_dir)

	var package_deps_str := ""
	var target_deps_str := ""
	var processed_urls := []
	var processed_products := []

	for dep in dependencies:
		var url: String = dep.url
		var product: String = dep.product
		var package_name: String = url.get_file().trim_suffix(".git")

		if not processed_urls.has(url):
			processed_urls.append(url)
			var version_rule := 'exact: "%s"' % dep.version
			package_deps_str += '        .package(url: "%s", %s),\n' % [url, version_rule]

		if not processed_products.has(product):
			processed_products.append(product)
			target_deps_str += (
				'                .product(name: "%s", package: "%s"),\n' % [product, package_name]
			)

	var template := """// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PoingGodotAdMobDeps",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PoingGodotAdMobDeps",
            targets: ["PoingGodotAdMobDeps"]),
    ],
    dependencies: [
%s    ],
    targets: [
        .target(
            name: "PoingGodotAdMobDeps",
            dependencies: [
%s            ],
            path: "PoingGodotAdMobDeps"
        )
    ]
)
"""
	var content := template % [package_deps_str, target_deps_str]

	var file := FileAccess.open(package_dir.path_join("Package.swift"), FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()


func _generate_dummy_source(export_dir: String) -> void:
	var source_dir := export_dir.path_join("admob_spm/PoingGodotAdMobDeps")
	if not DirAccess.dir_exists_absolute(source_dir):
		DirAccess.make_dir_recursive_absolute(source_dir)

	var content := """// Dummy
import Foundation

public struct PoingGodotAdMobDeps {
    public init() {}
}
"""
	var file := FileAccess.open(source_dir.path_join("Dummy.swift"), FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()


func _add_framework(path: String) -> void:
	if has_method("add_apple_embedded_platform_framework"):
		call("add_apple_embedded_platform_framework", path)
	elif has_method("add_ios_framework"):
		call("add_ios_framework", path)


func _add_linker_flags(flags: String) -> void:
	if has_method("add_apple_embedded_platform_linker_flags"):
		call("add_apple_embedded_platform_linker_flags", flags)
	elif has_method("add_ios_linker_flags"):
		call("add_ios_linker_flags", flags)


func _add_bundle_file(path: String) -> void:
	if has_method("add_apple_embedded_platform_bundle_file"):
		call("add_apple_embedded_platform_bundle_file", path)
	elif has_method("add_ios_bundle_file"):
		call("add_ios_bundle_file", path)


func _add_plist_content(content: String) -> void:
	if has_method("add_apple_embedded_platform_plist_content"):
		call("add_apple_embedded_platform_plist_content", content)
	elif has_method("add_ios_plist_content"):
		call("add_ios_plist_content", content)


func _add_cpp_code(code: String) -> void:
	if has_method("add_apple_embedded_platform_cpp_code"):
		call("add_apple_embedded_platform_cpp_code", code)
	elif has_method("add_ios_cpp_code"):
		call("add_ios_cpp_code", code)


func _check_legacy_gdip_files() -> void:
	var legacy_dir := "res://ios/plugins"
	if DirAccess.dir_exists_absolute(legacy_dir):
		var dir := DirAccess.open(legacy_dir)
		if dir:
			dir.list_dir_begin()
			var file_name := dir.get_next()
			while file_name != "":
				if (file_name.begins_with("poing-godot-admob") and file_name.ends_with(".gdip")) or file_name == "poing-godot-admob":
					push_error("AdMob iOS Migration Error: Found legacy v4 plugin file/folder '%s'. Please delete all 'poing-godot-admob*.gdip' files and the 'res://ios/plugins/poing-godot-admob/' folder to avoid Xcode build conflicts." % [legacy_dir.path_join(file_name)])
				file_name = dir.get_next()
