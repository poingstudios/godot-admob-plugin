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

const FALLBACK_PLUGIN_VERSION := "v4.0.0"

const PLUGIN_CONFIG_PATH := "res://addons/admob/plugin.cfg"
const ANDROID_PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const IOS_PACKAGE_PATH := "res://ios/plugins/admob_package.gd"

static var _cached_version := ""
static var _remote_support: PlatformSupport = null

static var support: PlatformSupport:
	get:
		if _remote_support == null:
			_remote_support = PlatformSupport.new(
				PlatformSupport.FALLBACK_ANDROID_VERSION,
				PlatformSupport.FALLBACK_IOS_VERSION
			)
		return _remote_support
	set(value):
		_remote_support = value

static var installed: PlatformSupport:
	get:
		return PlatformSupport.new(
			_get_local_version(ANDROID_PACKAGE_PATH),
			_get_local_version(IOS_PACKAGE_PATH)
		)

static var current: String:
	get:
		if not _cached_version.is_empty():
			return _cached_version
		
		var plugin_config_file := ConfigFile.new()
		if plugin_config_file.load(PLUGIN_CONFIG_PATH) == OK:
			_cached_version = plugin_config_file.get_value("plugin", "version", FALLBACK_PLUGIN_VERSION)
		else:
			push_error("AdMob: Failed to load plugin.cfg at " + PLUGIN_CONFIG_PATH)
			_cached_version = FALLBACK_PLUGIN_VERSION
		return _cached_version

static var is_android_outdated: bool:
	get:
		return installed.android.is_empty() or not is_at_least(installed.android, support.android)

static var is_ios_outdated: bool:
	get:
		return installed.ios.is_empty() or not is_at_least(installed.ios, support.ios)

static var formatted: String:
	get:
		return current.trim_prefix("v")

static var godot: String:
	get:
		var info := Engine.get_version_info()
		return "v%d.%d.%d" % [info.major, info.minor, info.patch]

static func is_at_least(current_version: String, target_version: String) -> bool:
	var v1 := current_version.trim_prefix("v").split(".")
	var v2 := target_version.trim_prefix("v").split(".")
	
	for i in range(max(v1.size(), v2.size())):
		var s1 := v1[i] if i < v1.size() else "0"
		var s2 := v2[i] if i < v2.size() else "0"
		
		var n1 := s1.to_int()
		var n2 := s2.to_int()
		
		if n1 > n2: return true
		if n1 < n2: return false
	return true

static func _get_local_version(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	
	var script := load(path)
	if script and "VERSION" in script:
		var version_val = script.get("VERSION")
		return str(version_val)
	
	return ""

class PlatformSupport:
	# These versions are used as a fallback if the remote 'versions.json' cannot be fetched.
	# Reference: https://github.com/poingstudios/godot-admob-versions/
	const FALLBACK_ANDROID_VERSION := "v4.0.0"
	const FALLBACK_IOS_VERSION := "v3.1.3"

	var android := ""
	var ios := ""

	func _init(p_android := "", p_ios := ""):
		android = p_android
		ios = p_ios

	static func create(data := {}) -> PlatformSupport:
		return PlatformSupport.new(
			data.get("android", ""),
			data.get("ios", "")
		)

	func is_empty() -> bool:
		return android.is_empty() and ios.is_empty()
