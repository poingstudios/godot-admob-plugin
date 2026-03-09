# MIT License
# Copyright (c) 2026-present Poing Studios

const FALLBACK_PLUGIN_VERSION := "v4.0.0"

const PLUGIN_CONFIG_PATH := "res://addons/admob/plugin.cfg"
const ANDROID_PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const IOS_PACKAGE_PATH := "res://ios/plugins/package.gd"

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
