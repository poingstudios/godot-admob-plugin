class_name MobileSingletonPlugin

static func _get_plugin(plugin_name : String) -> Object:
	if (Engine.has_singleton(plugin_name)):
		return Engine.get_singleton(plugin_name)

	push_warning("Doesn't has plugin:", plugin_name)
	return null
