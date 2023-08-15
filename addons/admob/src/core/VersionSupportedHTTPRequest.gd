tool
extends HTTPRequest

signal supported_version_changed(value_dictionary)

var AdMobGlobals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	request("https://raw.githubusercontent.com/Poing-Studios/godot-admob-versions/" + AdMobGlobals.get_plugin_version() + "/versions.json")


func _on_VersionSupportedHTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	
	var version_support : Dictionary = json.result
	emit_signal("supported_version_changed", version_support)
