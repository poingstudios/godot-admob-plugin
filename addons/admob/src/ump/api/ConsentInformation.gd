class_name ConsentInformation
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobConsentInformation")

enum ConsentStatus {
	UNKNOWN,
	NOT_REQUIRED,
	REQUIRED,
	OBTAINED
}

func get_consent_status() -> ConsentStatus:
	if _plugin:
		return _plugin.get_consent_status()
	return ConsentStatus.UNKNOWN

func get_is_consent_form_available() -> bool:
	if _plugin:
		return _plugin.get_is_consent_form_available()
	return false

func update(consent_request : ConsentRequestParameters, 
			on_consent_info_updated_success := func() : pass,
			on_consent_info_updated_failure := func(form_error : FormError) : pass,
			) -> void:
	if _plugin:
		_plugin.update(consent_request.convert_to_dictionary())
		
		_plugin.connect("on_consent_info_updated_success", func(): 
			on_consent_info_updated_success.call()
		)
		_plugin.connect("on_consent_info_updated_failure", func(form_error_dictionary : Dictionary): 
			on_consent_info_updated_failure.call(FormError.create(form_error_dictionary))
		)

func reset():
	if _plugin:
		_plugin.reset()
