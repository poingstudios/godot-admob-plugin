@tool
extends HTTPRequest

signal supported_version_changed(value_dictionary)

var AdMobGlobals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	request("https://gist.githubusercontent.com/gumaciel/ba15bd85ebcc87866c24a819de37cc9a/raw/admob_editor_versions_supported.json")


func _on_VersionSupportedHTTPRequest_request_completed(result, response_code, headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var json = test_json_conv.get_data()

	var version_support : Dictionary = json[AdMobGlobals.get_plugin_version()]
	emit_signal("supported_version_changed", version_support)
