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

signal on_rewarded_interstitial_ad_clicked(uid: int)
signal on_rewarded_interstitial_ad_dismissed_full_screen_content(uid: int)
signal on_rewarded_interstitial_ad_failed_to_show_full_screen_content(uid: int, error: Dictionary)
signal on_rewarded_interstitial_ad_impression(uid: int)
signal on_rewarded_interstitial_ad_showed_full_screen_content(uid: int)
signal on_rewarded_interstitial_ad_loaded(uid: int)
signal on_rewarded_interstitial_ad_failed_to_load(uid: int, error: Dictionary)
signal on_rewarded_interstitial_ad_paid(uid: int, ad_value: Dictionary)
signal on_rewarded_interstitial_ad_user_earned_reward(uid: int, reward: Dictionary)

var _uid_counter := 0
var _ads: Dictionary = {}


func create() -> int:
	_uid_counter += 1
	var uid := _uid_counter

	var ui := ColorRect.new()
	ui.color = Color(0.1, 0.1, 0.1, 0.9)
	ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.hide()

	var label := Label.new()
	label.text = "AdMob Mock\nRewarded Interstitial"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(label)

	var close_btn := Button.new()
	close_btn.text = "Close Ad"
	close_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	close_btn.position = Vector2(-100, 20)
	ui.add_child(close_btn)

	var reward_btn := Button.new()
	reward_btn.text = "Earn Reward"
	reward_btn.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	reward_btn.position = Vector2(-50, -60)
	ui.add_child(reward_btn)

	reward_btn.pressed.connect(func() -> void:
		var reward := {
			"amount": 10,
			"type": "coins"
		}
		on_rewarded_interstitial_ad_user_earned_reward.emit(uid, reward)
		reward_btn.disabled = true
		reward_btn.text = "Reward Earned"
	)

	close_btn.pressed.connect(func() -> void:
		ui.hide()
		on_rewarded_interstitial_ad_dismissed_full_screen_content.emit(uid)
	)

	_ads[uid] = {
		"ui": ui,
		"reward_btn": reward_btn
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
		on_rewarded_interstitial_ad_loaded.emit(uid)
	)


func get_ad_unit_id(uid: int) -> String:
	if _ads.has(uid):
		return _ads[uid].get("ad_unit_id", "")
	return ""


func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		if _ads[uid]["reward_btn"] and is_instance_valid(_ads[uid]["reward_btn"]):
			_ads[uid]["reward_btn"].disabled = false
			_ads[uid]["reward_btn"].text = "Earn Reward"
		_ads[uid]["ui"].show()
		on_rewarded_interstitial_ad_showed_full_screen_content.emit(uid)
		on_rewarded_interstitial_ad_impression.emit(uid)


func set_server_side_verification_options(_uid: int, _options: Dictionary) -> void:
	pass


func destroy(uid: int) -> void:
	if _ads.has(uid):
		if is_instance_valid(_ads[uid]["ui"]):
			_ads[uid]["ui"].get_parent().queue_free()
		_ads.erase(uid)


func get_response_info(_uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": [],
		"loaded_adapter_response_info": {},
		"response_extras": {}
	}
