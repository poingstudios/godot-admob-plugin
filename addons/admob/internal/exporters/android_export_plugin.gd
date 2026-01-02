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

const CONFIG_PATH := "res://addons/admob/android/config.gd"
const Config := preload(CONFIG_PATH)

func _get_plugins() -> Array[EditorExportPlugin]:
	var plugins: Array[EditorExportPlugin]
	var root_bin_path := Config.AndroidAdMobLibrary.ROOT_BIN_PATH
	var dir_access := DirAccess.open(root_bin_path)

	if not dir_access:
		push_error("Failed to open AdMob directory: " + root_bin_path)
		return plugins

	for lib in Config.new().libraries:
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
	
	for lib in Config.new().libraries:
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
	""" % Config.APPLICATION_ID)
	
	return "\n".join(content)

func _supports_platform(platform: EditorExportPlatform) -> bool:
	return platform is EditorExportPlatformAndroid and Config.new().is_ads_enabled()

func _get_name() -> String:
	return "PoingAdMobAndroid"
