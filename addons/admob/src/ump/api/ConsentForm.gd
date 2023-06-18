class_name ConsentForm
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobUserMessagingPlatform")

var _uid : int

func _init(UID : int):
	self._uid = UID

func show(on_consent_form_dismissed := func(form_error : FormError) : pass) -> void:
	if _plugin:
		_plugin.show(_uid)

		_plugin.connect("on_consent_form_dismissed", func(uid : int, form_error_dictionary : Dictionary) :
			if uid == _uid:
				var formError : FormError = FormError.create(form_error_dictionary) if not form_error_dictionary.is_empty() else null
				on_consent_form_dismissed.call(formError)
			)

