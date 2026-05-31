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

func create(ad_view_dictionary: Dictionary) -> int:
	_uid_counter += 1
	var uid := _uid_counter

	var ui := ColorRect.new()
	ui.color = Color.DARK_GRAY
	ui.hide()

	var label := Label.new()
	label.text = "AdMob Banner Mock"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(label)

	var ad_size: Dictionary = ad_view_dictionary.get("ad_size", {"width": 320, "height": 50})
	var width: int = ad_size.get("width", 320)
	var height: int = ad_size.get("height", 50)
	if width <= 0: width = 320
	if height <= 0: height = 50

	ui.custom_minimum_size = Vector2(width, height)
	ui.size = ui.custom_minimum_size

	var position: int = ad_view_dictionary.get("ad_position", 0)
	var custom_position: Dictionary = ad_view_dictionary.get("custom_position", {"x": 0, "y": 0})

	_ads[uid] = {
		"ui": ui,
		"position": position,
		"custom_position": custom_position,
		"width": width,
		"height": height
	}

	var canvas := CanvasLayer.new()
	canvas.layer = 100
	canvas.add_child(ui)
	add_child(canvas)

	return uid

func load_ad(uid: int, _ad_request_dictionary: Dictionary, _keywords: Array) -> void:
	if not _ads.has(uid): return
	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		on_ad_loaded.emit(uid)
		var ad: Dictionary = _ads[uid]
		if not ad.get("is_hidden", false) and is_instance_valid(ad["ui"]):
			_update_ui_position(uid)
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
		_update_ui_position(uid)
		_ads[uid]["ui"].show()
		on_ad_impression.emit(uid)

func update_custom_position(uid: int, x: float, y: float) -> void:
	if _ads.has(uid):
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_update_ui_position(uid)

func update_position(uid: int, position: int) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = position
		_update_ui_position(uid)

func get_width(uid: int) -> int:
	return _ads[uid]["width"] if _ads.has(uid) else 0

func get_height(uid: int) -> int:
	return _ads[uid]["height"] if _ads.has(uid) else 0

func get_width_in_pixels(uid: int) -> int:
	return get_width(uid)

func get_height_in_pixels(uid: int) -> int:
	return get_height(uid)

func is_collapsible(_uid: int) -> bool:
	return false

func _update_ui_position(uid: int) -> void:
	if not _ads.has(uid) or not is_instance_valid(_ads[uid]["ui"]): return
	var ad: Dictionary = _ads[uid]
	var ui: ColorRect = ad["ui"]
	var viewport_size := get_viewport().get_visible_rect().size

	if ad["position"] == 2: # CUSTOM
		ui.position = Vector2(ad["custom_position"]["x"], ad["custom_position"]["y"])
	elif ad["position"] == 1: # BOTTOM
		ui.position = Vector2((viewport_size.x - ui.size.x) / 2.0, viewport_size.y - ui.size.y)
	else: # TOP
		ui.position = Vector2((viewport_size.x - ui.size.x) / 2.0, 0)
