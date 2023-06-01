class_name Vungle
extends MobileSingletonPlugin

static var _plugin : Object
const PLUGIN_NAME := "PoingGodotAdMobVungle"

enum Consent {
	OPTED_IN,
	OPTED_OUT
}

static func _static_init() -> void:
	_plugin = _get_plugin(PLUGIN_NAME)

static func update_consent_status(consent : Consent, consent_message_version : String) -> void:
	if _plugin:
		_plugin.update_consent_status(consent, consent_message_version)

static func update_ccpa_status(consent : Consent) -> void:
	if _plugin:
		_plugin.update_ccpa_status(consent)
