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

extends EditorExportPlugin

const Library := preload("res://addons/admob/internal/exporters/android/library.gd")
const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")
const ProjectSettingsService := preload(
	"res://addons/admob/internal/services/project_settings_service.gd"
)


func _get_name() -> String:
	return "PoingAdMobAndroid"


func _supports_platform(platform: EditorExportPlatform) -> bool:
	var ads_enabled := _get_setting(ProjectSettingsService.ANDROID_ENABLED, true) as bool
	return platform is EditorExportPlatformAndroid and ads_enabled


func _get_setting(setting_name: String, default_value):
	if ProjectSettings.has_setting(setting_name):
		return ProjectSettings.get_setting(setting_name)
	return default_value


func _get_plugins() -> Array[EditorExportPlugin]:
	var plugins: Array[EditorExportPlugin] = []
	var root_bin_path := Library.ROOT_BIN_PATH

	var ads_enabled := _get_setting(ProjectSettingsService.ANDROID_ENABLED, true) as bool
	if not ads_enabled:
		return plugins

	var known_libs: Array[String] = ["ads", "meta", "vungle"]
	var libs: Array[Library] = []

	libs.append(Library.new("ads", true))

	var mediation_libs: Array[String] = ["meta", "vungle"]
	for lib_name in mediation_libs:
		var setting_name := ProjectSettingsService.ANDROID_MEDIATION_PREFIX + lib_name
		var is_enabled := _get_setting(setting_name, false) as bool
		if is_enabled:
			libs.append(Library.new(lib_name, true))

	var dir_access := DirAccess.open(root_bin_path)
	if dir_access:
		dir_access.list_dir_begin()
		var dir_name := dir_access.get_next()
		while dir_name != "":
			if dir_access.current_is_dir() and not dir_name.begins_with("."):
				if not dir_name in known_libs:
					var gd_path := root_bin_path.path_join(dir_name).path_join(
						"poing_godot_admob_" + dir_name + ".gd"
					)
					if FileAccess.file_exists(gd_path):
						var setting_name := (
							ProjectSettingsService.ANDROID_MEDIATION_PREFIX + dir_name
						)
						var is_enabled := _get_setting(setting_name, false) as bool
						if is_enabled:
							libs.append(Library.new(dir_name, true))
			dir_name = dir_access.get_next()

	for lib in libs:
		if not FileAccess.file_exists(lib.get_full_path()):
			push_error("AdMob: Android library not found at " + lib.get_full_path())
			continue
		plugins.append(lib.get_plugin())
	return plugins


func _get_android_libraries(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
	var libraries := PackedStringArray()

	for plugin in _get_plugins():
		libraries.append_array(plugin._get_android_libraries(platform, debug))

	return libraries


func _get_android_dependencies(platform: EditorExportPlatform, debug: bool) -> PackedStringArray:
	var dependencies := PackedStringArray()

	for plugin in _get_plugins():
		dependencies.append_array(plugin._get_android_dependencies(platform, debug))

	return dependencies


func _get_android_manifest_application_element_contents(
	_platform: EditorExportPlatform, _debug: bool
) -> String:
	var ads_enabled := _get_setting(ProjectSettingsService.ANDROID_ENABLED, true) as bool
	if not ads_enabled:
		return ""

	var content := PackedStringArray()
	var known_libs: Array[String] = ["ads", "meta", "vungle"]
	var enabled_libs: Array[String] = []

	enabled_libs.append("ads")

	var mediation_libs: Array[String] = ["meta", "vungle"]
	for lib_name in mediation_libs:
		var setting_name := ProjectSettingsService.ANDROID_MEDIATION_PREFIX + lib_name
		var is_enabled := _get_setting(setting_name, false) as bool
		if is_enabled:
			enabled_libs.append(lib_name)

	var root_bin_path := Library.ROOT_BIN_PATH
	var dir_access := DirAccess.open(root_bin_path)
	if dir_access:
		dir_access.list_dir_begin()
		var dir_name := dir_access.get_next()
		while dir_name != "":
			if dir_access.current_is_dir() and not dir_name.begins_with("."):
				if not dir_name in known_libs:
					var gd_path := root_bin_path.path_join(dir_name).path_join(
						"poing_godot_admob_" + dir_name + ".gd"
					)
					if FileAccess.file_exists(gd_path):
						var setting_name := (
							ProjectSettingsService.ANDROID_MEDIATION_PREFIX + dir_name
						)
						var is_enabled := _get_setting(setting_name, false) as bool
						if is_enabled:
							enabled_libs.append(dir_name)
			dir_name = dir_access.get_next()

	for lib_name in enabled_libs:
		var lib := Library.new(lib_name, true)
		if FileAccess.file_exists(lib.get_full_path()):
			continue

		(
			content
			. append(
				(
					"""
		<meta-data
			android:name="%s_CONFIGURATION_ERROR"
			android:value="%s doesn't exists, please check your addons/admob/android/bin folder or disable in Project Settings"/>
		"""
					% [lib_name, lib.get_full_path()]
				)
			)
		)

	var app_id := (
		_get_setting(
			ProjectSettingsService.ANDROID_APP_ID, "ca-app-pub-3940256099942544~3347511713"
		)
		as String
	)
	(
		content
		. append(
			(
				"""
	<meta-data
		android:name="com.google.android.gms.ads.APPLICATION_ID"
		android:value="%s"/>
	"""
				% app_id
			)
		)
	)

	return "\n".join(content)
