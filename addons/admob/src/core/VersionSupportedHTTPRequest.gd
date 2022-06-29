tool
extends HTTPRequest

signal supported_version_changed(value_dictionary)

var AdMobGlobals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	request("https://gist.githubusercontent.com/gumaciel/ba15bd85ebcc87866c24a819de37cc9a/raw/admob_editor_versions_supported.json")


func _on_VersionSupportedHTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	
	var version_support : Dictionary = json.result[AdMobGlobals.get_plugin_version()]
	emit_signal("supported_version_changed", version_support)
