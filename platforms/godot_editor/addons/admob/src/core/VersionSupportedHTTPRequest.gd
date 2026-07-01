tool
extends HTTPRequest

signal supported_version_changed(value_dictionary)

var ad_mob_globals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	var plugin_version = ad_mob_globals.get_plugin_version() + "-godot3"
	var version_support := {
		"android": plugin_version,
		"ios": plugin_version
	}
	call_deferred("emit_signal", "supported_version_changed", version_support)
