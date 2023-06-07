class_name ConsentRequestParameters

var tag_for_under_age_of_consent : bool
var consent_debug_settings : ConsentDebugSettings

func convert_to_dictionary() -> Dictionary:
	consent_debug_settings.test_device_hashed_ids.append("DAISODJOIADJI")
	return {
		"tag_for_under_age_of_consent" : tag_for_under_age_of_consent,
		"consent_debug_settings" : consent_debug_settings.convert_to_dictionary() if consent_debug_settings else null
	}
