static func load_config(p_path) -> Dictionary:
	if ProjectSettings.has_setting(p_path):
		return ProjectSettings.get_setting(p_path)
	return {}
