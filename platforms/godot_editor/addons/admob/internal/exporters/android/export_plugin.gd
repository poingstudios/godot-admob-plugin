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
const Config := preload("res://addons/admob/android/config.gd")

func _get_plugins() -> Array[EditorExportPlugin]:
	var plugins: Array[EditorExportPlugin]
	var config := _create_config()
	var root_bin_path := Library.ROOT_BIN_PATH
	var dir_access := DirAccess.open(root_bin_path)

	if not dir_access:
		push_error("Failed to open AdMob directory: " + root_bin_path)
		return plugins

	for lib in config.libraries:
		if not lib.is_enabled:
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

func _get_android_manifest_application_element_contents(platform: EditorExportPlatform, debug: bool) -> String:
	var content := PackedStringArray()
	var config := _create_config()
	
	for lib in config.libraries:
		if not lib.is_enabled:
			continue
			
		if FileAccess.file_exists(lib.get_full_path()):
			continue

		content.append("""
		<meta-data
			android:name="%s_CONFIGURATION_ERROR"
			android:enabled="%s doesn't exists, please check your addons/admob/android/bin folder or disable in addons/admob/android/config.gd"/>
		""" % [lib.path, lib.get_full_path()])
		
	content.append("""
	<meta-data
		android:name="com.google.android.gms.ads.APPLICATION_ID"
		android:value="%s"/>
	""" % config.APPLICATION_ID)
	
	return "\n".join(content)

func _is_ads_enabled() -> bool:
	var config := _create_config()
	for lib in config.libraries:
		if lib.path == "ads":
			return lib.is_enabled
	return false

func _supports_platform(platform: EditorExportPlatform) -> bool:
	return platform is EditorExportPlatformAndroid and _is_ads_enabled()

func _get_name() -> String:
	return "PoingAdMobAndroid"

# Development override config
func _create_config() -> Config:
	const OVERRIDE_CONFIG_PATH := "res://config/admob_android_config_override_1337.gd" # Development override config

	if FileAccess.file_exists(OVERRIDE_CONFIG_PATH):
		var script = load(OVERRIDE_CONFIG_PATH)
		if script:
			return script.new()
	return Config.new()
