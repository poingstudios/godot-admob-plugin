# MIT License

# Copyright (c) 2025-present Poing Studios

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

const Library := preload("res://addons/admob/internal/exporters/android/library.gd")
const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")


func _get_name() -> String:
	return "PoingAdMobAndroid"


func _supports_platform(platform: EditorExportPlatform) -> bool:
	var ads_enabled := _get_setting(ProjectSettingsService.get_android_setting_path("enabled"), true) as bool
	return platform is EditorExportPlatformAndroid and ads_enabled


func _get_enabled_libs_list() -> Array[String]:
	return _discover_enabled_libs(Library.ROOT_BIN_PATH)


func _get_plugins() -> Array[EditorExportPlugin]:
	var plugins: Array[EditorExportPlugin] = []

	var ads_enabled := _get_setting(ProjectSettingsService.get_android_setting_path("enabled"), true) as bool
	if not ads_enabled:
		return plugins

	for lib_name in _get_enabled_libs_list():
		var lib := Library.new(lib_name, true)
		if not FileAccess.file_exists(lib.get_full_path()):
			push_error("AdMob: Android library not found at " + lib.get_full_path())
			continue
		plugins.append(lib.get_plugin())
	return plugins


func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
	var libraries := PackedStringArray()

	for plugin in _get_plugins():
		if plugin.has_method("_get_android_libraries"):
			libraries.append_array(plugin._get_android_libraries(platform, debug))

	return libraries


func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
	var dependencies := PackedStringArray()

	for plugin in _get_plugins():
		if plugin.has_method("_get_android_dependencies"):
			dependencies.append_array(plugin._get_android_dependencies(platform, debug))

	return dependencies


func _get_android_dependencies_maven_repos(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
	var maven_repos := PackedStringArray()

	for plugin in _get_plugins():
		if plugin.has_method("_get_android_dependencies_maven_repos"):
			maven_repos.append_array(plugin._get_android_dependencies_maven_repos(platform, debug))

	return maven_repos


func _get_android_manifest_application_element_contents(
	_platform: EditorExportPlatform, _debug: bool
) -> String:
	var ads_enabled := _get_setting(ProjectSettingsService.get_android_setting_path("enabled"), true) as bool
	if not ads_enabled:
		return ""

	var content := PackedStringArray()
	var enabled_libs := _get_enabled_libs_list()

	for lib_name in enabled_libs:
		var lib := Library.new(lib_name, true)
		if FileAccess.file_exists(lib.get_full_path()):
			continue

		content.append(
			"""
		<meta-data
			android:name="%s_CONFIGURATION_ERROR"
			android:value="%s doesn't exists, please check your addons/admob/android/bin folder or disable in Project Settings"/>
		"""
			% [lib_name, lib.get_full_path()]
		)

	var app_id := (
		_get_setting(
			ProjectSettingsService.get_android_setting_path("app_id"),
			ProjectSettingsService.ANDROID_DEFAULT_APP_ID
		)
		as String
	)
	content.append(
		"""
	<meta-data
		android:name="com.google.android.gms.ads.APPLICATION_ID"
		android:value="%s"/>
	"""
		% app_id
	)

	var disable_init_opt := _get_setting(
		ProjectSettingsService.get_android_setting_path("disable_initialization_optimization"),
		false
	) as bool
	if disable_init_opt:
		content.append(
			"""
	<meta-data
		android:name="com.google.android.gms.ads.flag.OPTIMIZE_INITIALIZATION"
		android:value="false"/>
	"""
		)

	var disable_load_opt := _get_setting(
		ProjectSettingsService.get_android_setting_path("disable_ad_loading_optimization"),
		false
	) as bool
	if disable_load_opt:
		content.append(
			"""
	<meta-data
		android:name="com.google.android.gms.ads.flag.OPTIMIZE_AD_LOADING"
		android:value="false"/>
	"""
		)

	return "\n".join(content)


func _export_begin(_features: PackedStringArray, _is_debug: bool, _path: String, _flags: int) -> void:
	if not _features.has("android"):
		return
	PluginVersion.check_version_mismatch(PluginVersion.android_version, "Android")
	_patch_android_gradle_file()


func _patch_android_gradle_file() -> void:
	var gradle_path := "res://android/build/app/build.gradle"
	if not FileAccess.file_exists(gradle_path):
		gradle_path = "res://android/build/build.gradle"
		if not FileAccess.file_exists(gradle_path):
			return

	var content := FileAccess.get_file_as_string(gradle_path)
	if content.is_empty():
		return

	if 'exclude group: "com.google.android.gms", module: "play-services-ads"' in content:
		return

	var patch := """
// Added by Poing Godot AdMob Plugin to support GMA Next-Gen SDK
configurations.configureEach {
    exclude group: "com.google.android.gms", module: "play-services-ads"
    exclude group: "com.google.android.gms", module: "play-services-ads-lite"
}
"""
	content += patch

	var file := FileAccess.open(gradle_path, FileAccess.WRITE)
	if file:
		file.store_string(content)
		file.close()
