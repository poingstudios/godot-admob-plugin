extends MarginContainer

var ad_margin_top := 0.0
var ad_margin_bottom := 0.0

func _ready() -> void:
	add_to_group("SafeArea")
	_update_safe_area()
	get_viewport().size_changed.connect(_update_safe_area)

func update_ad_overlap(ad_view: AdView) -> void:
	reset_ad_overlap()
	
	if !ad_view:
		return
		
	var pos := ad_view.ad_position
	var height := ad_view.get_height_in_pixels()
	
	# TOP (0), TOP_LEFT (4), TOP_RIGHT (5)
	if pos == 0 or pos == 4 or pos == 5:
		ad_margin_top = height
	# BOTTOM (1), BOTTOM_LEFT (6), BOTTOM_RIGHT (7)
	elif pos == 1 or pos == 6 or pos == 7:
		ad_margin_bottom = height
		
	_update_safe_area()

func reset_ad_overlap() -> void:
	ad_margin_top = 0.0
	ad_margin_bottom = 0.0
	_update_safe_area()

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
	var screen_size := DisplayServer.screen_get_size()
	
	if window_size.x == 0 or window_size.y == 0:
		return
		
	# On mobile, DisplayServer returns physical pixels.
	# Control nodes use logical pixels (defined in project settings).
	# We need to scale physical to logical.
	var viewport_size := Vector2(get_viewport().get_visible_rect().size)
	var scale_factor := viewport_size.y / window_size.y
	
	var m_top = (safe_area.position.y + ad_margin_top) * scale_factor
	var m_left = safe_area.position.x * scale_factor
	var m_bottom = (window_size.y - (safe_area.position.y + safe_area.size.y) + ad_margin_bottom) * scale_factor
	var m_right = (window_size.x - (safe_area.position.x + safe_area.size.x)) * scale_factor
	
	add_theme_constant_override("margin_top", m_top)
	add_theme_constant_override("margin_left", m_left)
	add_theme_constant_override("margin_bottom", m_bottom)
	add_theme_constant_override("margin_right", m_right)
