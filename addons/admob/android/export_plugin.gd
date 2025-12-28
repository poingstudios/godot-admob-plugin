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

const Config := preload("res://addons/admob/android/config.gd")

func _get_plugins() -> Array[EditorExportPlugin]:
	var plugins: Array[EditorExportPlugin]
	var root_path := "res://addons/admob/android/bin"

	var dir_access := DirAccess.open(root_path)
	if not dir_access:
		push_error("Failed to open AdMob directory: " + root_path)
		return plugins

	for file_name in dir_access.get_files():
		if file_name.ends_with(".gd"):
			var plugin_path := root_path + "/" + file_name
			var plugin: EditorExportPlugin = load(plugin_path).new()
			plugins.append(plugin)
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
	return """
	<meta-data
		android:name="com.google.android.gms.ads.APPLICATION_ID"
		android:value="%s"/>
	""" % Config.APPLICATION_ID

func _supports_platform(platform: EditorExportPlatform) -> bool:
	return platform is EditorExportPlatformAndroid and Config.IS_ENABLED

func _get_name() -> String:
	return "PoingAdMobAndroid"