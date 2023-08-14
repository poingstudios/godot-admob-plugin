const SAVE_ADMOB_GLOBALS_PATH := "user://admob_globals.tres"


static func get_plugin_version() -> String:
	var plugin_config_file := ConfigFile.new()
	plugin_config_file.load("res://addons/admob/plugin.cfg")
	var version : String = plugin_config_file.get_value("plugin", "version")
	return version
