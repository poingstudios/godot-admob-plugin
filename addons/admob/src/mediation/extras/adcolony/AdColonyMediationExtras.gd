class_name AdColonyMediationExtras
extends MediationExtras

const SHOW_PRE_POPUP_KEY  = "SHOW_PRE_POPUP_KEY"
const SHOW_POST_POPUP_KEY = "SHOW_POST_POPUP_KEY"

var show_pre_popup : bool : 
	set(value):
		extras[SHOW_PRE_POPUP_KEY] = value

var show_post_popup : bool : 
	set(value):
		extras[SHOW_POST_POPUP_KEY] = value

func _get_android_mediation_extra_class_name() -> String:
	return "com.poingstudios.godot.admob.mediation.adcolony.AdColonyExtrasBuilder"
