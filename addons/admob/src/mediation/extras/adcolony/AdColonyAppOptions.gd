class_name AdColonyAppOptions
extends MobileSingletonPlugin

const CCPA := "CCPA"
const GDPR := "GDPR"

const PLUGIN_NAME := "PoingGodotAdMobAdColonyAppOptions"
var _plugin : Object

func _init() -> void:
	_plugin = _get_plugin(PLUGIN_NAME)

func set_privacy_framework_required(type : String, required : bool) -> void:
	if _plugin:
		_plugin.set_privacy_framework_required(type, required)

func get_privacy_framework_required(type : String) -> bool:
	if _plugin:
		return _plugin.get_privacy_framework_required(type)
	return false

func set_privacy_consent_string(type : String, consent_string : String) -> void :
	if _plugin:
		_plugin.set_privacy_consent_string(type, consent_string)

func get_privacy_consent_string(type : String) -> String:
	if _plugin:
		return _plugin.get_privacy_consent_string(type)
	return ""

func set_user_id(user_id : String) -> void:
	if _plugin:
		_plugin.set_user_id(user_id)


func get_user_id() -> String:
	if _plugin:
		return _plugin.get_user_id()
	return ""
