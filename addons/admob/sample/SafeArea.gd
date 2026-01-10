extends MarginContainer

func _ready() -> void:
	_update_safe_area()
	get_viewport().size_changed.connect(_update_safe_area)

func _update_safe_area() -> void:
	var platform := OS.get_name()
	if platform != "iOS" and platform != "Android":
		add_theme_constant_override("margin_top", 0)
		add_theme_constant_override("margin_left", 0)
		add_theme_constant_override("margin_bottom", 0)
		add_theme_constant_override("margin_right", 0)
		return

	var safe_area := DisplayServer.get_display_safe_area()
	var window_size := DisplayServer.window_get_size()
	
	if window_size.x == 0 or window_size.y == 0:
		return
		
	add_theme_constant_override("margin_top", safe_area.position.y)
	add_theme_constant_override("margin_left", safe_area.position.x)
	add_theme_constant_override("margin_bottom", window_size.y - (safe_area.position.y + safe_area.size.y))
	add_theme_constant_override("margin_right", window_size.x - (safe_area.position.x + safe_area.size.x))
