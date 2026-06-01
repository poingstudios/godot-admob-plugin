# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends Node

signal on_ad_clicked(uid: int)
signal on_ad_closed(uid: int)
signal on_ad_failed_to_load(uid: int, error_dictionary: Dictionary)
signal on_ad_impression(uid: int)
signal on_ad_loaded(uid: int)
signal on_ad_opened(uid: int)
signal on_ad_view_paid(uid: int, ad_value_dictionary: Dictionary)

var _uid_counter := 0
var _ads := {}

func _ready() -> void:
	Engine.get_main_loop().root.size_changed.connect(_on_window_size_changed)

func _on_window_size_changed() -> void:
	for uid in _ads.keys():
		_update_size(uid)

func create(ad_view_dictionary: Dictionary) -> int:
	_uid_counter += 1
	var uid := _uid_counter

	var ui := ColorRect.new()
	ui.color = Color.DARK_GRAY
	ui.hide()

	var bg_color := ColorRect.new()
	bg_color.color = Color.WHITE
	bg_color.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(bg_color)

	var ad_size: Dictionary = ad_view_dictionary.get("ad_size", {"width": 320, "height": 50})
	var width: int = ad_size.get("width", 320)
	var height: int = ad_size.get("height", 50)
	var is_adaptive := (width <= 0)

	if is_adaptive:
		var window_size := DisplayServer.window_get_size()
		var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
		width = int(window_size.x / screen_scale)
	if height <= 0: height = 50

	ui.custom_minimum_size = Vector2(width, height)
	ui.size = ui.custom_minimum_size

	var position: int = ad_view_dictionary.get("ad_position", 0)
	var custom_position: Dictionary = ad_view_dictionary.get("custom_position", {"x": 0, "y": 0})

	var toggle_btn := Button.new()
	toggle_btn.text = "^"
	toggle_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	toggle_btn.anchor_bottom = 0.0
	toggle_btn.anchor_left = 1.0
	toggle_btn.offset_left = -30
	toggle_btn.offset_bottom = 30
	toggle_btn.hide()
	ui.add_child(toggle_btn)

	toggle_btn.pressed.connect(func():
		if _ads.has(uid):
			_ads[uid]["is_collapsed"] = true
			_ads[uid]["toggle_btn"].hide()
			_update_size(uid)
			on_ad_closed.emit(uid)
	)

	_ads[uid] = {
		"ui": ui,
		"position": position,
		"custom_position": custom_position,
		"width": width,
		"height": height,
		"current_width": width,
		"current_height": height,
		"toggle_btn": toggle_btn,
		"is_collapsible": false,
		"is_collapsed": false,
		"is_adaptive": is_adaptive
	}

	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.add_child(ui)
	add_child(canvas)

	return uid

func load_ad(uid: int, _ad_request_dictionary: Dictionary, _keywords: Array) -> void:
	if not _ads.has(uid): return

	var extras: Dictionary = _ad_request_dictionary.get("extras", {})
	if extras.has("collapsible"):
		_ads[uid]["is_collapsible"] = true
		_ads[uid]["is_collapsed"] = false
		if is_instance_valid(_ads[uid]["toggle_btn"]):
			_ads[uid]["toggle_btn"].show()

	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		on_ad_loaded.emit(uid)
		var ad: Dictionary = _ads[uid]
		if not ad.get("is_hidden", false) and is_instance_valid(ad["ui"]):
			_update_size(uid)
			ad["ui"].show()
			on_ad_impression.emit(uid)
	)

func destroy(uid: int) -> void:
	if _ads.has(uid):
		if is_instance_valid(_ads[uid]["ui"]):
			_ads[uid]["ui"].get_parent().queue_free()
		_ads.erase(uid)

func get_response_info(uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": [], "loaded_adapter_response_info": {}, "response_extras": {}
	}

func hide(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_ads[uid]["is_hidden"] = true
		_ads[uid]["ui"].hide()

func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_ads[uid]["is_hidden"] = false
		_update_size(uid)
		_ads[uid]["ui"].show()
		on_ad_impression.emit(uid)

func update_custom_position(uid: int, x: float, y: float) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = -1
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_update_size(uid)

func update_position(uid: int, position: int) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = position
		_update_size(uid)

func get_width(uid: int) -> int:
	if _ads.has(uid):
		return 0 if _ads[uid].get("is_hidden", false) else _ads[uid]["current_width"]
	return 0

func get_height(uid: int) -> int:
	if _ads.has(uid):
		return 0 if _ads[uid].get("is_hidden", false) else _ads[uid]["current_height"]
	return 0

func get_width_in_pixels(uid: int) -> int:
	if not _ads.has(uid): return 0
	var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
	return int(get_width(uid) * screen_scale)

func get_height_in_pixels(uid: int) -> int:
	if not _ads.has(uid): return 0
	var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
	return int(get_height(uid) * screen_scale)

func is_collapsible(uid: int) -> bool:
	return _ads[uid].get("is_collapsible", false) if _ads.has(uid) else false

func _update_size(uid: int) -> void:
	if not _ads.has(uid) or not is_instance_valid(_ads[uid]["ui"]): return
	var ad: Dictionary = _ads[uid]
	var ui: Control = ad["ui"]

	var viewport_size := get_viewport().get_visible_rect().size
	var window_size := DisplayServer.window_get_size()
	var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())

	var scale_x := window_size.x / float(viewport_size.x)
	var scale_y := window_size.y / float(viewport_size.y)

	var scale_factor_x := screen_scale / scale_x if scale_x > 0 else 1.0
	var scale_factor_y := screen_scale / scale_y if scale_y > 0 else 1.0

	if ad.get("is_adaptive", false):
		ad["width"] = int(window_size.x / screen_scale)

	var is_expanded: bool = ad.get("is_collapsible", false) and not ad.get("is_collapsed", false)

	if is_expanded:
		ad["current_height"] = 250
	else:
		ad["current_height"] = ad["height"]
	ad["current_width"] = ad["width"]

	ad["ui"].custom_minimum_size = Vector2(ad["current_width"] * scale_factor_x, ad["current_height"] * scale_factor_y)
	ad["ui"].size = ad["ui"].custom_minimum_size

	if is_instance_valid(ad.get("toggle_btn")):
		var btn: Button = ad["toggle_btn"]
		if is_expanded:
			btn.text = "^"
			btn.show()
		else:
			btn.hide()

		var btn_width := 28.0 * scale_factor_x
		var btn_height := 28.0 * scale_factor_y

		btn.anchor_left = 0.0
		btn.anchor_right = 0.0
		btn.anchor_top = 0.0
		btn.anchor_bottom = 0.0

		var local_visible_rect := Rect2(Vector2.ZERO, ui.size).intersection(Rect2(-ui.position, viewport_size))
		if local_visible_rect.size.x > 0 and local_visible_rect.size.y > 0:
			var target_left := local_visible_rect.position.x + local_visible_rect.size.x - btn_width - 10 * scale_factor_x
			var target_top := local_visible_rect.position.y + 10 * scale_factor_y

			target_left = clamp(target_left, local_visible_rect.position.x, local_visible_rect.position.x + local_visible_rect.size.x - btn_width)
			target_top = clamp(target_top, local_visible_rect.position.y, local_visible_rect.position.y + local_visible_rect.size.y - btn_height)

			btn.offset_left = target_left
			btn.offset_top = target_top
			btn.offset_right = target_left + btn_width
			btn.offset_bottom = target_top + btn_height
		else:
			btn.offset_left = ui.size.x - 38 * scale_factor_x
			btn.offset_top = 10 * scale_factor_y
			btn.offset_right = ui.size.x - 10 * scale_factor_x
			btn.offset_bottom = (10 + 28) * scale_factor_y

		var style_normal := StyleBoxFlat.new()
		style_normal.bg_color = Color.WHITE
		style_normal.corner_radius_top_left = 999
		style_normal.corner_radius_top_right = 999
		style_normal.corner_radius_bottom_left = 999
		style_normal.corner_radius_bottom_right = 999
		style_normal.shadow_color = Color(0, 0, 0, 0.15)
		style_normal.shadow_size = int(round(2 * scale_factor_y))
		style_normal.shadow_offset = Vector2(0, int(round(1 * scale_factor_y)))
		style_normal.content_margin_top = int(round(4 * scale_factor_y))
		style_normal.content_margin_bottom = 0

		var style_hover := style_normal.duplicate() as StyleBoxFlat
		style_hover.bg_color = Color(0.95, 0.95, 0.95)

		var style_pressed := style_normal.duplicate() as StyleBoxFlat
		style_pressed.bg_color = Color(0.9, 0.9, 0.9)

		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_hover)
		btn.add_theme_stylebox_override("pressed", style_pressed)
		btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

		btn.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
		btn.add_theme_color_override("font_hover_color", Color(0.1, 0.1, 0.1))
		btn.add_theme_color_override("font_pressed_color", Color(0.0, 0.0, 0.0))
		btn.add_theme_font_size_override("font_size", max(1, int(round(14 * scale_factor_y))))

	for child in ad["ui"].get_children():
		if child is ColorRect or child == ad.get("toggle_btn"): continue
		child.queue_free()


	var test_ad_label := Label.new()
	test_ad_label.text = "Mock Ad"
	test_ad_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	test_ad_label.add_theme_color_override("font_color", Color.WHITE)
	test_ad_label.add_theme_font_size_override("font_size", max(1, int(round(10 * scale_factor_y))))

	var test_ad_bg := ColorRect.new()
	test_ad_bg.color = Color(0.2, 0.2, 0.2, 0.8)
	test_ad_bg.custom_minimum_size = Vector2(45 * scale_factor_x, 14 * scale_factor_y)
	test_ad_bg.set_anchors_preset(Control.PRESET_CENTER_TOP)
	test_ad_bg.grow_horizontal = Control.GROW_DIRECTION_BOTH
	test_ad_bg.add_child(test_ad_label)
	test_ad_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(test_ad_bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", max(0, int(round(5 * scale_factor_y))))
	ui.add_child(vbox)

	var flood_it_tex := load("res://addons/admob/assets/flood_it_icon.svg") as Texture2D
	var play_tex := load("res://addons/admob/assets/google_play_icon.svg") as Texture2D

	var use_tall_layout: bool = is_expanded or ui.custom_minimum_size.y >= 100 * scale_factor_y

	if use_tall_layout:
		var spacer_top := Control.new()
		spacer_top.custom_minimum_size = Vector2(0, 20 * scale_factor_y)
		vbox.add_child(spacer_top)

		var icon := TextureRect.new()
		icon.texture = flood_it_tex
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(64 * scale_factor_x, 64 * scale_factor_y)
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		vbox.add_child(icon)

		var title := Label.new()
		title.text = "Flood-It!"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_color_override("font_color", Color.BLACK)
		title.add_theme_font_size_override("font_size", max(1, int(round(24 * scale_factor_y))))
		vbox.add_child(title)

		var subtitle := Label.new()
		subtitle.text = "Can you flood it?"
		subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		subtitle.add_theme_color_override("font_color", Color.DARK_GRAY)
		subtitle.add_theme_font_size_override("font_size", max(1, int(round(14 * scale_factor_y))))
		vbox.add_child(subtitle)

		var play_hbox := HBoxContainer.new()
		play_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		var play_icon := TextureRect.new()
		play_icon.texture = play_tex
		play_icon.custom_minimum_size = Vector2(24 * scale_factor_x, 24 * scale_factor_y)
		play_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		play_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		var play_label := Label.new()
		play_label.text = "Google Play"
		play_label.add_theme_color_override("font_color", Color.DARK_GRAY)
		play_label.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
		play_hbox.add_child(play_icon)
		play_hbox.add_child(play_label)
		vbox.add_child(play_hbox)

		var btn_margin := MarginContainer.new()
		btn_margin.add_theme_constant_override("margin_left", max(0, int(round(20 * scale_factor_x))))
		btn_margin.add_theme_constant_override("margin_right", max(0, int(round(20 * scale_factor_x))))
		btn_margin.add_theme_constant_override("margin_top", max(0, int(round(10 * scale_factor_y))))

		var install_btn := Button.new()
		install_btn.text = "Install"
		install_btn.custom_minimum_size = Vector2(0, 40 * scale_factor_y)
		install_btn.add_theme_font_size_override("font_size", max(1, int(round(14 * scale_factor_y))))
		btn_margin.add_child(install_btn)
		vbox.add_child(btn_margin)
	else:
		var hbox := HBoxContainer.new()
		hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(hbox)

		var left_margin := MarginContainer.new()
		left_margin.add_theme_constant_override("margin_left", max(0, int(round(15 * scale_factor_x))))
		var nice_job := Label.new()
		nice_job.text = "Nice job!"
		nice_job.add_theme_color_override("font_color", Color(0.26, 0.52, 0.96))
		nice_job.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
		nice_job.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		left_margin.add_child(nice_job)
		hbox.add_child(left_margin)

		var spacer1 := Control.new()
		spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer1)

		var center_label := Label.new()
		center_label.text = "This is a %dx%d mock ad." % [ad["width"], ad["height"]]
		center_label.add_theme_color_override("font_color", Color.BLACK)
		center_label.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
		center_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hbox.add_child(center_label)

		var spacer2 := Control.new()
		spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(spacer2)

		var admob_logo := TextureRect.new()
		admob_logo.texture = load("res://addons/admob/assets/icon-120.png") as Texture2D
		admob_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		admob_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		admob_logo.custom_minimum_size = Vector2(30 * scale_factor_x, 30 * scale_factor_y)
		admob_logo.size_flags_vertical = Control.SIZE_SHRINK_CENTER

		var right_margin := MarginContainer.new()
		right_margin.add_theme_constant_override("margin_right", max(0, int(round(15 * scale_factor_x))))
		right_margin.add_child(admob_logo)
		hbox.add_child(right_margin)

	if is_instance_valid(ad.get("toggle_btn")):
		ad["toggle_btn"].move_to_front()

	_update_ui_position(uid)

func _update_ui_position(uid: int) -> void:
	if not _ads.has(uid) or not is_instance_valid(_ads[uid]["ui"]): return
	var ad: Dictionary = _ads[uid]
	var ui: ColorRect = ad["ui"]
	var viewport_size := get_viewport().get_visible_rect().size

	var window_size := DisplayServer.window_get_size()
	var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())

	var scale_x := window_size.x / float(viewport_size.x)
	var scale_y := window_size.y / float(viewport_size.y)

	ui.scale = Vector2.ONE
	var scaled_size := ui.size

	match ad["position"]:
		-1: # CUSTOM
			var scale_factor_x := screen_scale / scale_x if scale_x > 0 else 1.0
			var scale_factor_y := screen_scale / scale_y if scale_y > 0 else 1.0
			var x: float = ad["custom_position"]["x"] * scale_factor_x
			var y: float = ad["custom_position"]["y"] * scale_factor_y
			ui.position = Vector2(x, y)
		0: # TOP
			ui.position = Vector2((viewport_size.x - scaled_size.x) / 2.0, 0)
		1: # BOTTOM
			ui.position = Vector2((viewport_size.x - scaled_size.x) / 2.0, viewport_size.y - scaled_size.y)
		2: # LEFT
			ui.position = Vector2(0, (viewport_size.y - scaled_size.y) / 2.0)
		3: # RIGHT
			ui.position = Vector2(viewport_size.x - scaled_size.x, (viewport_size.y - scaled_size.y) / 2.0)
		4: # TOP_LEFT
			ui.position = Vector2(0, 0)
		5: # TOP_RIGHT
			ui.position = Vector2(viewport_size.x - scaled_size.x, 0)
		6: # BOTTOM_LEFT
			ui.position = Vector2(0, viewport_size.y - scaled_size.y)
		7: # BOTTOM_RIGHT
			ui.position = Vector2(viewport_size.x - scaled_size.x, viewport_size.y - scaled_size.y)
		8: # CENTER
			ui.position = Vector2((viewport_size.x - scaled_size.x) / 2.0, (viewport_size.y - scaled_size.y) / 2.0)
		_:
			ui.position = Vector2((viewport_size.x - scaled_size.x) / 2.0, 0)

