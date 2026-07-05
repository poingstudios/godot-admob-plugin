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

const _FORMAT_INTERSTITIAL := preload("res://addons/admob/assets/format-interstitial.svg")

signal on_interstitial_ad_clicked(uid: int)
signal on_interstitial_ad_dismissed_full_screen_content(uid: int)
signal on_interstitial_ad_failed_to_show_full_screen_content(uid: int, error: Dictionary)
signal on_interstitial_ad_impression(uid: int)
signal on_interstitial_ad_showed_full_screen_content(uid: int)
signal on_interstitial_ad_loaded(uid: int)
signal on_interstitial_ad_failed_to_load(uid: int, error: Dictionary)
signal on_interstitial_ad_paid(uid: int, ad_value: Dictionary)

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
	ui.color = Color.BLACK
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
		on_interstitial_ad_loaded.emit(uid)
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

	ui.color = Color.BLACK

	var main_vbox := VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 0)
	ui.add_child(main_vbox)

	# 1. Top Bar (sits on the black background)
	var top_margin := MarginContainer.new()
	top_margin.add_theme_constant_override("margin_left", int(16 * scale_factor_x))
	top_margin.add_theme_constant_override("margin_right", int(16 * scale_factor_x))
	top_margin.add_theme_constant_override("margin_top", int(16 * scale_factor_y))
	top_margin.add_theme_constant_override("margin_bottom", int(8 * scale_factor_y))
	main_vbox.add_child(top_margin)

	var top_control := Control.new()
	top_control.custom_minimum_size = Vector2(1, 40 * scale_factor_y)
	top_margin.add_child(top_control)

	var test_ad_pill := Panel.new()
	test_ad_pill.custom_minimum_size = Vector2(65 * scale_factor_x, 22 * scale_factor_y)
	test_ad_pill.set_anchors_preset(Control.PRESET_CENTER)
	test_ad_pill.grow_horizontal = Control.GROW_DIRECTION_BOTH
	test_ad_pill.grow_vertical = Control.GROW_DIRECTION_BOTH
	var test_ad_pill_style := StyleBoxFlat.new()
	test_ad_pill_style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	test_ad_pill_style.corner_radius_top_left = int(4 * scale_factor_y)
	test_ad_pill_style.corner_radius_top_right = int(4 * scale_factor_y)
	test_ad_pill_style.corner_radius_bottom_left = int(4 * scale_factor_y)
	test_ad_pill_style.corner_radius_bottom_right = int(4 * scale_factor_y)
	test_ad_pill.add_theme_stylebox_override("panel", test_ad_pill_style)
	top_control.add_child(test_ad_pill)

	var test_ad_lbl := Label.new()
	test_ad_lbl.text = "Mock Ad"
	test_ad_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	test_ad_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	test_ad_lbl.add_theme_color_override("font_color", Color.WHITE)
	test_ad_lbl.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	test_ad_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	test_ad_pill.add_child(test_ad_lbl)

	var close_btn := Button.new()
	close_btn.custom_minimum_size = Vector2(32 * scale_factor_y, 32 * scale_factor_y)
	close_btn.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	close_btn.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	close_btn.grow_vertical = Control.GROW_DIRECTION_BOTH

	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color(0.9, 0.9, 0.9, 0.95)
	close_style.corner_radius_top_left = int(16 * scale_factor_y)
	close_style.corner_radius_top_right = int(16 * scale_factor_y)
	close_style.corner_radius_bottom_left = int(16 * scale_factor_y)
	close_style.corner_radius_bottom_right = int(16 * scale_factor_y)

	close_btn.add_theme_stylebox_override("normal", close_style)
	close_btn.add_theme_stylebox_override("hover", close_style)
	close_btn.add_theme_stylebox_override("pressed", close_style)
	close_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	top_control.add_child(close_btn)

	var close_icon := Label.new()
	close_icon.text = "X"
	close_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	close_icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	close_icon.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	close_icon.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
	close_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	close_btn.add_child(close_icon)

	close_btn.pressed.connect(func() -> void:
		ui.hide()
		on_interstitial_ad_dismissed_full_screen_content.emit(uid)
	)

	# Spacer above the card to center it vertically
	var spacer_top := Control.new()
	spacer_top.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(spacer_top)

	# 2. Central White Card (full width, flat white, centered vertically)
	var card_rect := ColorRect.new()
	card_rect.color = Color.WHITE
	card_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var card_height := min(420 * scale_factor_y, viewport_size.y - (140 * scale_factor_y))
	card_rect.custom_minimum_size = Vector2(1, card_height)
	main_vbox.add_child(card_rect)

	var card_margin := MarginContainer.new()
	card_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_margin.add_theme_constant_override("margin_left", int(24 * scale_factor_x))
	card_margin.add_theme_constant_override("margin_right", int(24 * scale_factor_x))
	card_margin.add_theme_constant_override("margin_top", int(24 * scale_factor_y))
	card_margin.add_theme_constant_override("margin_bottom", int(24 * scale_factor_y))
	card_rect.add_child(card_margin)

	var content_vbox := VBoxContainer.new()
	content_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	content_vbox.add_theme_constant_override("separation", int(24 * scale_factor_y))
	card_margin.add_child(content_vbox)

	var ad_image := TextureRect.new()
	ad_image.texture = _FORMAT_INTERSTITIAL
	ad_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ad_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ad_image.custom_minimum_size = Vector2(1, 160 * scale_factor_y)
	ad_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_vbox.add_child(ad_image)

	var title_lbl := Label.new()
	title_lbl.text = "This is an\ninterstitial mock ad."
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_color_override("font_color", Color(0.12, 0.12, 0.12))
	title_lbl.add_theme_font_size_override("font_size", max(1, int(round(22 * scale_factor_y))))
	content_vbox.add_child(title_lbl)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, 16 * scale_factor_y)
	content_vbox.add_child(spacer)

	var logo_hbox := HBoxContainer.new()
	logo_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	logo_hbox.add_theme_constant_override("separation", int(8 * scale_factor_x))
	content_vbox.add_child(logo_hbox)

	var admob_logo := TextureRect.new()
	admob_logo.texture = load("res://addons/admob/assets/icon-120.png") as Texture2D
	admob_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	admob_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	admob_logo.custom_minimum_size = Vector2(24 * scale_factor_y, 24 * scale_factor_y)
	admob_logo.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	logo_hbox.add_child(admob_logo)

	var admob_lbl := Label.new()
	admob_lbl.text = "Google AdMob"
	admob_lbl.add_theme_color_override("font_color", Color(0.35, 0.35, 0.35))
	admob_lbl.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
	logo_hbox.add_child(admob_lbl)

	# Spacer below the card to center it vertically
	var spacer_bottom := Control.new()
	spacer_bottom.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(spacer_bottom)


func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_update_ui(uid)
		_ads[uid]["ui"].show()
		on_interstitial_ad_showed_full_screen_content.emit(uid)
		on_interstitial_ad_impression.emit(uid)


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

