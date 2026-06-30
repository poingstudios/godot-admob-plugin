# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Node

const _FLOOD_IT_ICON := preload("res://addons/admob/assets/flood_it_icon.svg")

signal on_app_open_ad_clicked(uid: int)
signal on_app_open_ad_dismissed_full_screen_content(uid: int)
signal on_app_open_ad_failed_to_show_full_screen_content(uid: int, error: Dictionary)
signal on_app_open_ad_impression(uid: int)
signal on_app_open_ad_showed_full_screen_content(uid: int)
signal on_app_open_ad_loaded(uid: int)
signal on_app_open_ad_failed_to_load(uid: int, error: Dictionary)
signal on_app_open_ad_paid(uid: int, ad_value: Dictionary)

var _uid_counter := 0
var _ads: Dictionary = {}


func _ready() -> void:
	Engine.get_main_loop().root.size_changed.connect(_on_window_size_changed)


func _on_window_size_changed() -> void:
	for uid in _ads.keys():
		_update_ui(uid)


func create() -> int:
	_uid_counter += 1
	var uid := _uid_counter

	var ui := ColorRect.new()
	ui.color = Color(0.0, 0.0, 0.0, 0.45)
	ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.hide()

	_ads[uid] = {
		"ui": ui
	}

	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.add_child(ui)
	add_child(canvas)

	return uid


func load(ad_unit_id: String, _ad_request_dictionary: Dictionary, _keywords: Array, uid: int) -> void:
	if not _ads.has(uid):
		return
	_ads[uid]["ad_unit_id"] = ad_unit_id
	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func() -> void:
		on_app_open_ad_loaded.emit(uid)
	)


func get_ad_unit_id(uid: int) -> String:
	if _ads.has(uid):
		return _ads[uid].get("ad_unit_id", "")
	return ""


func _update_ui(uid: int) -> void:
	if not _ads.has(uid):
		return
	var ad: Dictionary = _ads[uid]
	var ui: ColorRect = ad["ui"]
	if not is_instance_valid(ui):
		return

	var viewport := get_viewport()
	if not viewport:
		return
	var viewport_size := viewport.get_visible_rect().size
	viewport_size.x = max(1.0, viewport_size.x)
	viewport_size.y = max(1.0, viewport_size.y)

	var scale_factor: float = min(viewport_size.x / 360.0, viewport_size.y / 640.0)
	if scale_factor <= 0.0:
		scale_factor = 1.0

	var scale_factor_x := scale_factor
	var scale_factor_y := scale_factor

	for child in ui.get_children():
		child.queue_free()

	ui.color = Color.WHITE

	var main_vbox := VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 0)
	ui.add_child(main_vbox)

	# 1. Top Bar
	var top_margin := MarginContainer.new()
	top_margin.add_theme_constant_override("margin_left", int(16 * scale_factor_x))
	top_margin.add_theme_constant_override("margin_right", int(16 * scale_factor_x))
	top_margin.add_theme_constant_override("margin_top", int(16 * scale_factor_y))
	top_margin.add_theme_constant_override("margin_bottom", int(16 * scale_factor_y))
	main_vbox.add_child(top_margin)

	var top_hbox := HBoxContainer.new()
	top_hbox.add_theme_constant_override("separation", int(8 * scale_factor_x))
	top_margin.add_child(top_hbox)

	var ad_badge_panel := Panel.new()
	ad_badge_panel.custom_minimum_size = Vector2(24 * scale_factor_x, 16 * scale_factor_y)
	ad_badge_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var ad_badge_style := StyleBoxFlat.new()
	ad_badge_style.bg_color = Color(0.2, 0.2, 0.2)
	ad_badge_style.corner_radius_top_left = int(3 * scale_factor_y)
	ad_badge_style.corner_radius_top_right = int(3 * scale_factor_y)
	ad_badge_style.corner_radius_bottom_left = int(3 * scale_factor_y)
	ad_badge_style.corner_radius_bottom_right = int(3 * scale_factor_y)
	ad_badge_panel.add_theme_stylebox_override("panel", ad_badge_style)
	top_hbox.add_child(ad_badge_panel)

	var ad_badge_lbl := Label.new()
	ad_badge_lbl.text = "Ad"
	ad_badge_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ad_badge_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ad_badge_lbl.add_theme_color_override("font_color", Color.WHITE)
	ad_badge_lbl.add_theme_font_size_override("font_size", max(1, int(round(10 * scale_factor_y))))
	ad_badge_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	ad_badge_panel.add_child(ad_badge_lbl)

	var top_icon := TextureRect.new()
	top_icon.texture = _FLOOD_IT_ICON
	top_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	top_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	top_icon.custom_minimum_size = Vector2(20 * scale_factor_y, 20 * scale_factor_y)
	top_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top_hbox.add_child(top_icon)

	var top_title := Label.new()
	top_title.text = "Flood-It!"
	top_title.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	top_title.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	top_title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top_hbox.add_child(top_title)

	var top_spacer := Control.new()
	top_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(top_spacer)

	var continue_container := MarginContainer.new()
	continue_container.mouse_filter = Control.MOUSE_FILTER_PASS
	top_hbox.add_child(continue_container)

	var continue_btn := Button.new()
	continue_btn.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	continue_btn.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	continue_btn.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	continue_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	continue_container.add_child(continue_btn)

	var continue_hbox := HBoxContainer.new()
	continue_hbox.add_theme_constant_override("separation", int(4 * scale_factor_x))
	continue_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	continue_container.add_child(continue_hbox)

	var continue_lbl := Label.new()
	continue_lbl.text = "Continue to app"
	continue_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	continue_lbl.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	continue_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	continue_hbox.add_child(continue_lbl)

	var continue_arrow := Label.new()
	continue_arrow.text = ">"
	continue_arrow.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	continue_arrow.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	continue_arrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	continue_hbox.add_child(continue_arrow)

	continue_btn.pressed.connect(func() -> void:
		ui.hide()
		on_app_open_ad_dismissed_full_screen_content.emit(uid)
	)

	# 2. Media View (Fills remaining space)
	var media_container := Panel.new()
	media_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var media_style := StyleBoxFlat.new()
	media_style.bg_color = Color(0.9, 0.9, 0.9)
	media_container.add_theme_stylebox_override("panel", media_style)
	main_vbox.add_child(media_container)

	var grad := Gradient.new()
	grad.offsets = [0.0, 1.0]
	grad.colors = [Color(1.0, 0.65, 0.1), Color(1.0, 0.4, 0.0)]
	var grad_tex := GradientTexture2D.new()
	grad_tex.gradient = grad
	grad_tex.fill = GradientTexture2D.FILL_RADIAL
	grad_tex.fill_from = Vector2(0.5, 0.5)
	grad_tex.fill_to = Vector2(1.0, 1.0)

	var media_bg_tex := TextureRect.new()
	media_bg_tex.texture = grad_tex
	media_bg_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	media_bg_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
	media_container.add_child(media_bg_tex)

	var media_hbox := HBoxContainer.new()
	media_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	media_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	media_hbox.add_theme_constant_override("separation", int(12 * scale_factor_x))
	media_container.add_child(media_hbox)

	var media_icon := TextureRect.new()
	media_icon.texture = _FLOOD_IT_ICON
	media_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	media_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	media_icon.custom_minimum_size = Vector2(70 * scale_factor_y, 70 * scale_factor_y)
	media_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	media_hbox.add_child(media_icon)

	var phone_frame := Panel.new()
	phone_frame.custom_minimum_size = Vector2(50 * scale_factor_x, 90 * scale_factor_y)
	phone_frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var phone_style := StyleBoxFlat.new()
	phone_style.bg_color = Color(0.12, 0.12, 0.12)
	phone_style.border_color = Color(0.7, 0.7, 0.7)
	phone_style.border_width_left = 2
	phone_style.border_width_right = 2
	phone_style.border_width_top = 2
	phone_style.border_width_bottom = 2
	phone_style.corner_radius_top_left = int(8 * scale_factor_y)
	phone_style.corner_radius_top_right = int(8 * scale_factor_y)
	phone_style.corner_radius_bottom_left = int(8 * scale_factor_y)
	phone_style.corner_radius_bottom_right = int(8 * scale_factor_y)
	phone_frame.add_theme_stylebox_override("panel", phone_style)
	media_hbox.add_child(phone_frame)

	var phone_screen := Panel.new()
	phone_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	phone_screen.anchor_left = 0.08
	phone_screen.anchor_right = 0.92
	phone_screen.anchor_top = 0.08
	phone_screen.anchor_bottom = 0.92
	var screen_style := StyleBoxFlat.new()
	screen_style.bg_color = Color(0.95, 0.95, 0.95)
	phone_screen.add_theme_stylebox_override("panel", screen_style)
	phone_frame.add_child(phone_screen)

	var phone_grid := GridContainer.new()
	phone_grid.columns = 6
	phone_grid.set_anchors_preset(Control.PRESET_FULL_RECT)
	phone_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_grid.add_theme_constant_override("h_separation", int(1 * scale_factor_x))
	phone_grid.add_theme_constant_override("v_separation", int(1 * scale_factor_y))
	phone_screen.add_child(phone_grid)

	var phone_colors := [
		Color.AQUA, Color.GREEN, Color.YELLOW, Color.DEEP_PINK, Color.BLUE, Color.RED,
		Color.YELLOW, Color.DEEP_PINK, Color.BLUE, Color.RED, Color.AQUA, Color.GREEN,
		Color.RED, Color.GREEN, Color.AQUA, Color.YELLOW, Color.DEEP_PINK, Color.BLUE,
		Color.BLUE, Color.RED, Color.YELLOW, Color.GREEN, Color.DEEP_PINK, Color.AQUA,
		Color.AQUA, Color.GREEN, Color.YELLOW, Color.DEEP_PINK, Color.BLUE, Color.RED
	]
	for c in phone_colors:
		var sq := ColorRect.new()
		sq.color = c
		sq.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sq.size_flags_vertical = Control.SIZE_EXPAND_FILL
		phone_grid.add_child(sq)

	# 3. Bottom Details Section
	var bottom_margin := MarginContainer.new()
	bottom_margin.add_theme_constant_override("margin_left", int(20 * scale_factor_x))
	bottom_margin.add_theme_constant_override("margin_right", int(20 * scale_factor_x))
	bottom_margin.add_theme_constant_override("margin_top", int(20 * scale_factor_y))
	bottom_margin.add_theme_constant_override("margin_bottom", int(20 * scale_factor_y))
	main_vbox.add_child(bottom_margin)

	var bottom_vbox := VBoxContainer.new()
	bottom_vbox.add_theme_constant_override("separation", int(16 * scale_factor_y))
	bottom_margin.add_child(bottom_vbox)

	var info_hbox := HBoxContainer.new()
	info_hbox.add_theme_constant_override("separation", int(16 * scale_factor_x))
	bottom_vbox.add_child(info_hbox)

	var app_icon := TextureRect.new()
	app_icon.texture = _FLOOD_IT_ICON
	app_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	app_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	app_icon.custom_minimum_size = Vector2(64 * scale_factor_y, 64 * scale_factor_y)
	app_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	var app_icon_bg := Panel.new()
	app_icon_bg.custom_minimum_size = app_icon.custom_minimum_size
	app_icon_bg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var app_icon_style := StyleBoxFlat.new()
	app_icon_style.bg_color = Color.TRANSPARENT
	app_icon_style.border_color = Color(0.9, 0.9, 0.9)
	app_icon_style.border_width_left = 1
	app_icon_style.border_width_right = 1
	app_icon_style.border_width_top = 1
	app_icon_style.border_width_bottom = 1
	app_icon_style.corner_radius_top_left = int(12 * scale_factor_y)
	app_icon_style.corner_radius_top_right = int(12 * scale_factor_y)
	app_icon_style.corner_radius_bottom_left = int(12 * scale_factor_y)
	app_icon_style.corner_radius_bottom_right = int(12 * scale_factor_y)
	app_icon_bg.add_theme_stylebox_override("panel", app_icon_style)
	app_icon_bg.add_child(app_icon)
	app_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	info_hbox.add_child(app_icon_bg)

	var text_vbox := VBoxContainer.new()
	text_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	text_vbox.add_theme_constant_override("separation", int(4 * scale_factor_y))
	info_hbox.add_child(text_vbox)

	var title_lbl := Label.new()
	title_lbl.text = "Flood-It!"
	title_lbl.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	title_lbl.add_theme_font_size_override("font_size", max(1, int(round(18 * scale_factor_y))))
	text_vbox.add_child(title_lbl)

	var rating_hbox := HBoxContainer.new()
	rating_hbox.add_theme_constant_override("separation", int(4 * scale_factor_x))
	text_vbox.add_child(rating_hbox)

	var rating_val := Label.new()
	rating_val.text = "4.2"
	rating_val.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3))
	rating_val.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	rating_hbox.add_child(rating_val)

	var star_hbox := HBoxContainer.new()
	star_hbox.add_theme_constant_override("separation", int(1 * scale_factor_x))
	rating_hbox.add_child(star_hbox)

	for i in range(5):
		var star := Label.new()
		star.text = "★"
		star.add_theme_color_override("font_color", Color(0.95, 0.7, 0.1) if i < 4 else Color(0.8, 0.8, 0.8))
		star.add_theme_font_size_override("font_size", max(1, int(round(10 * scale_factor_y))))
		star.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		star_hbox.add_child(star)

	var play_icon_control := Control.new()
	play_icon_control.custom_minimum_size = Vector2(8 * scale_factor_x, 8 * scale_factor_y)
	play_icon_control.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	rating_hbox.add_child(play_icon_control)

	var play_tri := Polygon2D.new()
	play_tri.polygon = [
		Vector2(0, 0),
		Vector2(8 * scale_factor_x, 4 * scale_factor_y),
		Vector2(0, 8 * scale_factor_y)
	]
	play_tri.color = Color(0.0, 0.65, 0.35)
	play_icon_control.add_child(play_tri)

	var is_ios := OS.get_name() == "iOS"
	if is_ios:
		play_tri.polygon = [
			Vector2(2 * scale_factor_x, 2 * scale_factor_y),
			Vector2(6 * scale_factor_x, 2 * scale_factor_y),
			Vector2(6 * scale_factor_x, 6 * scale_factor_y),
			Vector2(2 * scale_factor_x, 6 * scale_factor_y)
		]
		play_tri.color = Color(0.2, 0.2, 0.2)

	var desc_lbl := Label.new()
	desc_lbl.text = "Puzzle game with colors"
	desc_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	desc_lbl.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	text_vbox.add_child(desc_lbl)

	var install_btn := Button.new()
	install_btn.text = "Install"
	install_btn.custom_minimum_size = Vector2(1, 48 * scale_factor_y)
	install_btn.add_theme_color_override("font_color", Color.WHITE)
	install_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	install_btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	install_btn.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))

	var btn_normal := StyleBoxFlat.new()
	btn_normal.bg_color = Color(0.08, 0.38, 0.85)
	btn_normal.corner_radius_top_left = int(24 * scale_factor_y)
	btn_normal.corner_radius_top_right = int(24 * scale_factor_y)
	btn_normal.corner_radius_bottom_left = int(24 * scale_factor_y)
	btn_normal.corner_radius_bottom_right = int(24 * scale_factor_y)

	var btn_hover := btn_normal.duplicate() as StyleBoxFlat
	btn_hover.bg_color = Color(0.08, 0.38, 0.85).lightened(0.15)

	var btn_pressed := btn_normal.duplicate() as StyleBoxFlat
	btn_pressed.bg_color = Color(0.08, 0.38, 0.85).darkened(0.15)

	install_btn.add_theme_stylebox_override("normal", btn_normal)
	install_btn.add_theme_stylebox_override("hover", btn_hover)
	install_btn.add_theme_stylebox_override("pressed", btn_pressed)
	install_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	bottom_vbox.add_child(install_btn)

	install_btn.pressed.connect(func() -> void:
		on_app_open_ad_clicked.emit(uid)
	)


func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_update_ui(uid)
		_ads[uid]["ui"].show()
		on_app_open_ad_showed_full_screen_content.emit(uid)
		on_app_open_ad_impression.emit(uid)


func destroy(uid: int) -> void:
	if _ads.has(uid):
		if is_instance_valid(_ads[uid]["ui"]):
			_ads[uid]["ui"].get_parent().queue_free()
		_ads.erase(uid)


func get_response_info(_uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": {},
		"loaded_adapter_response_info": {},
		"response_extras": {}
	}
