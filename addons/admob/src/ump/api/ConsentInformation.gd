class_name ConsentInformation
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobConsentInformation")

static func update(consent_request : ConsentRequestParameters, 
			consent_info_updated_success_callable := func() : pass,
			consent_info_updated_failure_callable := func(form_error : FormError) : pass,
			) -> void:
	if _plugin:
		_plugin.update(consent_request.convert_to_dictionary())

		_plugin.connect("on_consent_info_updated_success", func(): 
			consent_info_updated_success_callable.call()
		)
		_plugin.connect("on_consent_info_updated_failure", func(form_error_dictionary : Dictionary): 
			consent_info_updated_failure_callable.call(FormError.create(form_error_dictionary))
		)
