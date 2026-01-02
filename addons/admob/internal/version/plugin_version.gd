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

const PLUGIN_CONFIG_PATH := "res://addons/admob/plugin.cfg"
const FALLBACK_PLUGIN_VERSION := "v4.0.0"

const ANDROID_PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const IOS_PACKAGE_PATH := "res://addons/admob/ios/bin/package.gd" # Placeholder for future

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

static var formatted: String:
	get:
		return current.trim_prefix("v")

static var godot: String:
	get:
		var info := Engine.get_version_info()
		return "v%d.%d.%d" % [info.major, info.minor, info.patch]

static func _get_local_version(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	
	var script := load(path)
	if script and "VERSION" in script:
		return str(script.get("VERSION"))
	
	return ""

class PlatformSupport:
	# These versions are used as a fallback if the remote 'versions.json' cannot be fetched.
	# Reference: https://github.com/poingstudios/godot-admob-versions/
	const FALLBACK_ANDROID_VERSION := "v3.0.6"
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
