class_name MediationExtras

var extras : Dictionary

func get_class_name() -> String:
	match OS.get_name():
		"Android":
			return _get_android_mediation_extra_class_name()
		"iOS":
			return _get_ios_mediation_extra_class_name()
		_:
			return ""

func _get_android_mediation_extra_class_name() -> String:
	push_error("Method not implemented")
	assert(false)
	return ""

func _get_ios_mediation_extra_class_name() -> String:
	push_error("Method not implemented")
	assert(false)
	return ""
