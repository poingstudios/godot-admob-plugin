static func save_config(p_path : String, p_config : Dictionary) -> void:
	ProjectSettings.set_setting(p_path, p_config)
	ProjectSettings.save()
