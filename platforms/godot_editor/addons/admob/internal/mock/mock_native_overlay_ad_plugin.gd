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

signal on_native_overlay_ad_loaded(uid: int)
signal on_native_overlay_ad_failed_to_load(uid: int, error: Dictionary)
signal on_native_overlay_ad_clicked(uid: int)
signal on_native_overlay_ad_closed(uid: int)
signal on_native_overlay_ad_impression(uid: int)
signal on_native_overlay_ad_opened(uid: int)
signal on_native_overlay_ad_paid(uid: int, ad_value: Dictionary)

var _uid_counter := 0
var _ads: Dictionary = {}

func _ready() -> void:
	Engine.get_main_loop().root.size_changed.connect(_on_window_size_changed)

func _on_window_size_changed() -> void:
	for uid in _ads.keys():
		_update_ui_position(uid)

func create() -> int:
	_uid_counter += 1
	var uid := _uid_counter

	var ui := ColorRect.new()
	ui.color = Color(0.2, 0.4, 0.2, 0.9)
	ui.hide()

	var label := Label.new()
	label.text = "Native Ad Mock"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(label)

	_ads[uid] = {
		"ui": ui,
		"position": 0,
		"custom_position": null,
		"ad_size": null,
		"is_hidden": false
	}

	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.add_child(ui)
	add_child(canvas)

	return uid

func load(ad_unit_id: String, _ad_request_dictionary: Dictionary, _keywords: Array, _options: Dictionary, uid: int) -> void:
	if not _ads.has(uid): return
	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		emit_signal("on_native_overlay_ad_loaded", uid)
		var ad: Dictionary = _ads[uid]
		if not ad.get("is_hidden", false) and is_instance_valid(ad["ui"]):
			_update_ui_position(uid)
			ad["ui"].show()
			emit_signal("on_native_overlay_ad_impression", uid)
	)

func render_template(uid: int, _style: Dictionary, position: int, ad_size: Dictionary) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = position
		_ads[uid]["custom_position"] = null
		_ads[uid]["ad_size"] = ad_size
		_update_ui_position(uid)

func render_template_custom_position(uid: int, _style: Dictionary, x: float, y: float, ad_size: Dictionary) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = 2
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_ads[uid]["ad_size"] = ad_size
		_update_ui_position(uid)

func update_position(uid: int, position: int) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = position
		_ads[uid]["custom_position"] = null
		_update_ui_position(uid)

func update_custom_position(uid: int, x: float, y: float) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = 2
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_update_ui_position(uid)

func _update_ui_position(uid: int) -> void:
	if not _ads.has(uid): return
	var ad: Dictionary = _ads[uid]
	var ui: ColorRect = ad["ui"]
	if not is_instance_valid(ui): return

	var viewport := get_viewport()
	if not viewport: return
	var viewport_size := viewport.get_visible_rect().size

	var window_size := DisplayServer.window_get_size()
	var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())

	var scale_x := window_size.x / float(viewport_size.x)
	var scale_y := window_size.y / float(viewport_size.y)

	var scale_factor_x := screen_scale / scale_x if scale_x > 0 else 1.0
	var scale_factor_y := screen_scale / scale_y if scale_y > 0 else 1.0

	var width := 320
	var height := 50

	if ad["ad_size"] != null:
		var size_dict: Dictionary = ad["ad_size"]
		if size_dict.has("width"): width = size_dict["width"]
		if size_dict.has("height"): height = size_dict["height"]

	if width <= 0: width = 320
	if height <= 0: height = 50

	ui.custom_minimum_size = Vector2(width * scale_factor_x, height * scale_factor_y)
	ui.size = ui.custom_minimum_size

	var label: Label = ui.get_child(0) as Label
	if label:
		label.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))

	if ad["position"] == 2: # CUSTOM
		var x: float = ad["custom_position"].get("x", 0.0) * scale_factor_x if ad["custom_position"] != null else 0.0
		var y: float = ad["custom_position"].get("y", 0.0) * scale_factor_y if ad["custom_position"] != null else 0.0
		ui.position = Vector2(x, y)
	elif ad["position"] == 1: # BOTTOM
		ui.position = Vector2((viewport_size.x - ui.size.x) / 2.0, viewport_size.y - ui.size.y)
	else: # TOP
		ui.position = Vector2((viewport_size.x - ui.size.x) / 2.0, 0)

func hide(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_ads[uid]["is_hidden"] = true
		_ads[uid]["ui"].hide()

func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_ads[uid]["is_hidden"] = false
		_update_ui_position(uid)
		_ads[uid]["ui"].show()
		emit_signal("on_native_overlay_ad_impression", uid)

func destroy(uid: int) -> void:
	if _ads.has(uid):
		if is_instance_valid(_ads[uid]["ui"]):
			_ads[uid]["ui"].get_parent().queue_free()
		_ads.erase(uid)

func get_width_in_pixels(uid: int) -> float:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
		var width := 320
		if _ads[uid]["ad_size"] != null:
			var size_dict: Dictionary = _ads[uid]["ad_size"]
			if size_dict.has("width"): width = size_dict["width"]
		if width <= 0: width = 320
		return float(width * screen_scale)
	return 0.0

func get_height_in_pixels(uid: int) -> float:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		var screen_scale := DisplayServer.screen_get_scale(DisplayServer.window_get_current_screen())
		var height := 50
		if _ads[uid]["ad_size"] != null:
			var size_dict: Dictionary = _ads[uid]["ad_size"]
			if size_dict.has("height"): height = size_dict["height"]
		if height <= 0: height = 50
		return float(height * screen_scale)
	return 0.0

func get_response_info(_uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": [], "loaded_adapter_response_info": {}, "response_extras": {}
	}
