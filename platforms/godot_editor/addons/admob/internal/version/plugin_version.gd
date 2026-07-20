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

const FALLBACK_PLUGIN_VERSION := "v5.0.0"

const PLUGIN_CONFIG_PATH := "res://addons/admob/plugin.cfg"
const ANDROID_PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const IOS_PACKAGE_PATH := "res://addons/admob/ios/bin/package.gd"

static var _cached_version := ""

static var is_android_installed: bool:
	get:
		return FileAccess.file_exists(ANDROID_PACKAGE_PATH)

static var is_ios_installed: bool:
	get:
		return FileAccess.file_exists(IOS_PACKAGE_PATH)

static var current: String:
	get:
		if not _cached_version.is_empty():
			return _cached_version

		var plugin_config_file := ConfigFile.new()
		if plugin_config_file.load(PLUGIN_CONFIG_PATH) == OK:
			var raw_version: String = plugin_config_file.get_value(
				"plugin", "version", FALLBACK_PLUGIN_VERSION
			)
			_cached_version = "v" + raw_version.trim_prefix("v")
		else:
			push_error("AdMob: Failed to load plugin.cfg at " + PLUGIN_CONFIG_PATH)
			_cached_version = FALLBACK_PLUGIN_VERSION
		return _cached_version

static var formatted: String:
	get:
		return current.trim_prefix("v")

static var godot: String:
	get:
		var info := Engine.get_version_info()
		return "v%d.%d.%d" % [info.major, info.minor, info.patch]


static func get_installed_version(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	var content := FileAccess.get_file_as_string(path)
	var regex := RegEx.new()
	if regex.compile('const\\s+VERSION\\s*:=\\s*"([^"]*)"') == OK:
		var result := regex.search(content)
		if result:
			return result.get_string(1)
	return ""


static var android_version: String:
	get:
		return get_installed_version(ANDROID_PACKAGE_PATH)


static var ios_version: String:
	get:
		return get_installed_version(IOS_PACKAGE_PATH)


static func is_major_version_compatible(installed: String) -> bool:
	if installed.is_empty():
		return true # Handled by missing file checks
	var clean_inst := installed.trim_prefix("v").split("-")[0]
	var clean_curr := current.trim_prefix("v").split("-")[0]
	var inst_parts := clean_inst.split(".")
	var curr_parts := clean_curr.split(".")
	if inst_parts.size() > 0 and curr_parts.size() > 0:
		return inst_parts[0] == curr_parts[0]
	return false


static func check_version_mismatch(installed: String, platform: String) -> void:
	if installed.is_empty():
		return
	if not is_major_version_compatible(installed):
		push_error("AdMob %s Export Error: Major version mismatch. Installed %s binaries are version %s, but editor plugin requires version %s. Please open the AdMob Manager inside the editor and re-download/re-install the %s platform binaries." % [platform, platform, installed, current, platform])
	elif installed.trim_prefix("v") != current.trim_prefix("v"):
		push_warning("AdMob %s Export Warning: Version mismatch. Installed %s binaries are version %s, but editor plugin version is %s. You may want to update the platform binaries." % [platform, platform, installed, current])


