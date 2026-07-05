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

const _ICON_120 := preload("res://addons/admob/assets/icon-120.png")
const _GOOGLE_PLAY_ICON := preload("res://addons/admob/assets/google_play_icon.svg")
const _FORMAT_REWARDED_INTERSTITIAL := preload("res://addons/admob/assets/format-rewarded-interstitial.svg")

signal on_rewarded_ad_clicked(uid: int)
signal on_rewarded_ad_dismissed_full_screen_content(uid: int)
signal on_rewarded_ad_failed_to_show_full_screen_content(uid: int, error: Dictionary)
signal on_rewarded_ad_impression(uid: int)
signal on_rewarded_ad_showed_full_screen_content(uid: int)
signal on_rewarded_ad_loaded(uid: int)
signal on_rewarded_ad_failed_to_load(uid: int, error: Dictionary)
signal on_rewarded_ad_paid(uid: int, ad_value: Dictionary)
signal on_rewarded_ad_user_earned_reward(uid: int, reward: Dictionary)

var _uid_counter := 0
var _ads: Dictionary = {}
var _active_uid := -1
var _time_elapsed := 0.0
var _timer_active := false
var _reward_earned := false
var _popup_visible := false

var _countdown_lbl: Label
var _close_btn_node: Button
var _popup_node: Control
var _video_screen_node: Control
var _end_screen_node: Control


func _ready() -> void:
	Engine.get_main_loop().root.size_changed.connect(_on_window_size_changed)
	set_process(false)


func _on_window_size_changed() -> void:
	if _active_uid != -1:
		_update_ui(_active_uid)


func _process(delta: float) -> void:
	if not _timer_active or _popup_visible or _reward_earned:
		return

	_time_elapsed += delta
	if _time_elapsed >= 8.0:
		_time_elapsed = 8.0
		_reward_earned = true
		_timer_active = false
		_on_reward_earned()

	_update_countdown_ui()


func _on_reward_earned() -> void:
	_update_countdown_ui()
	if _video_screen_node:
		_video_screen_node.hide()
	if _end_screen_node:
		_end_screen_node.show()


func _update_countdown_ui() -> void:
	if not _countdown_lbl:
		return
	if _reward_earned:
		_countdown_lbl.text = "Reward granted"
		_close_btn_node.show()
	else:
		var remaining := int(ceil(8.0 - _time_elapsed))
		_countdown_lbl.text = "Reward in %d seconds" % remaining
		if _time_elapsed >= 5.0:
			_close_btn_node.show()
		else:
			_close_btn_node.hide()


func _on_close_pressed() -> void:
	if _reward_earned:
		var reward := {
			"amount": 10,
			"type": "coins"
		}
		on_rewarded_ad_user_earned_reward.emit(_active_uid, reward)
		_ads[_active_uid]["ui"].hide()
		on_rewarded_ad_dismissed_full_screen_content.emit(_active_uid)
		set_process(false)
	else:
		_popup_visible = true
		if _popup_node:
			_popup_node.show()


func _on_close_video_confirmed() -> void:
	if _popup_node:
		_popup_node.hide()
	_ads[_active_uid]["ui"].hide()
	on_rewarded_ad_dismissed_full_screen_content.emit(_active_uid)
	set_process(false)


func _on_resume_video_pressed() -> void:
	_popup_visible = false
	if _popup_node:
		_popup_node.hide()


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
		on_rewarded_ad_loaded.emit(uid)
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

	ui.color = Color(0.12, 0.12, 0.12)

	var main_vbox := VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.add_theme_constant_override("separation", 0)
	ui.add_child(main_vbox)

	# 1. Top Bar
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

	var status_hbox := HBoxContainer.new()
	status_hbox.alignment = BoxContainer.ALIGNMENT_END
	status_hbox.add_theme_constant_override("separation", int(8 * scale_factor_x))
	status_hbox.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	status_hbox.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	status_hbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	top_control.add_child(status_hbox)

	var countdown_panel := PanelContainer.new()
	var countdown_style := StyleBoxFlat.new()
	countdown_style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	countdown_style.corner_radius_top_left = int(12 * scale_factor_y)
	countdown_style.corner_radius_top_right = int(12 * scale_factor_y)
	countdown_style.corner_radius_bottom_left = int(12 * scale_factor_y)
	countdown_style.corner_radius_bottom_right = int(12 * scale_factor_y)
	countdown_panel.add_theme_stylebox_override("panel", countdown_style)
	status_hbox.add_child(countdown_panel)

	var countdown_margin := MarginContainer.new()
	countdown_margin.add_theme_constant_override("margin_left", int(12 * scale_factor_x))
	countdown_margin.add_theme_constant_override("margin_right", int(12 * scale_factor_x))
	countdown_margin.add_theme_constant_override("margin_top", int(4 * scale_factor_y))
	countdown_margin.add_theme_constant_override("margin_bottom", int(4 * scale_factor_y))
	countdown_panel.add_child(countdown_margin)

	_countdown_lbl = Label.new()
	_countdown_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_countdown_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_countdown_lbl.add_theme_color_override("font_color", Color.WHITE)
	_countdown_lbl.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	countdown_margin.add_child(_countdown_lbl)

	_close_btn_node = Button.new()
	_close_btn_node.custom_minimum_size = Vector2(24 * scale_factor_y, 24 * scale_factor_y)
	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	close_style.corner_radius_top_left = int(12 * scale_factor_y)
	close_style.corner_radius_top_right = int(12 * scale_factor_y)
	close_style.corner_radius_bottom_left = int(12 * scale_factor_y)
	close_style.corner_radius_bottom_right = int(12 * scale_factor_y)
	_close_btn_node.add_theme_stylebox_override("normal", close_style)
	_close_btn_node.add_theme_stylebox_override("hover", close_style)
	_close_btn_node.add_theme_stylebox_override("pressed", close_style)
	_close_btn_node.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	_close_btn_node.hide()
	status_hbox.add_child(_close_btn_node)

	var close_icon := Label.new()
	close_icon.text = "X"
	close_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	close_icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	close_icon.add_theme_color_override("font_color", Color.WHITE)
	close_icon.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	close_icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	_close_btn_node.add_child(close_icon)

	_close_btn_node.pressed.connect(_on_close_pressed)

	# Main Area
	var content_margin := MarginContainer.new()
	content_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_margin.add_theme_constant_override("margin_left", int(16 * scale_factor_x))
	content_margin.add_theme_constant_override("margin_right", int(16 * scale_factor_x))
	content_margin.add_theme_constant_override("margin_top", int(8 * scale_factor_y))
	content_margin.add_theme_constant_override("margin_bottom", int(24 * scale_factor_y))
	main_vbox.add_child(content_margin)

	var content_control := Control.new()
	content_margin.add_child(content_control)

	# 2a. Video Screen
	_video_screen_node = VBoxContainer.new()
	_video_screen_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	_video_screen_node.add_theme_constant_override("separation", int(16 * scale_factor_y))
	content_control.add_child(_video_screen_node)

	var profile_panel := PanelContainer.new()
	var profile_style := StyleBoxEmpty.new()
	profile_panel.add_theme_stylebox_override("panel", profile_style)
	_video_screen_node.add_child(profile_panel)

	var profile_hbox := HBoxContainer.new()
	profile_hbox.add_theme_constant_override("separation", int(12 * scale_factor_x))
	profile_panel.add_child(profile_hbox)

	var app_icon := TextureRect.new()
	app_icon.texture = _ICON_120
	app_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	app_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	app_icon.custom_minimum_size = Vector2(56 * scale_factor_y, 56 * scale_factor_y)
	profile_hbox.add_child(app_icon)

	var profile_details := VBoxContainer.new()
	profile_details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	profile_details.add_theme_constant_override("separation", int(2 * scale_factor_y))
	profile_hbox.add_child(profile_details)

	var app_title := Label.new()
	app_title.text = "Google Ads"
	app_title.add_theme_color_override("font_color", Color.WHITE)
	app_title.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
	profile_details.add_child(app_title)

	var app_subtitle := Label.new()
	app_subtitle.text = "Congratulations!"
	app_subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	app_subtitle.add_theme_font_size_override("font_size", max(1, int(round(12 * scale_factor_y))))
	profile_details.add_child(app_subtitle)

	var play_badge := HBoxContainer.new()
	play_badge.add_theme_constant_override("separation", int(4 * scale_factor_x))
	profile_details.add_child(play_badge)

	var play_icon := TextureRect.new()
	play_icon.texture = _GOOGLE_PLAY_ICON
	play_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	play_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	play_icon.custom_minimum_size = Vector2(10 * scale_factor_y, 10 * scale_factor_y)
	play_badge.add_child(play_icon)

	var play_lbl := Label.new()
	play_lbl.text = "Google Play"
	play_lbl.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5))
	play_lbl.add_theme_font_size_override("font_size", max(1, int(round(10 * scale_factor_y))))
	play_badge.add_child(play_lbl)

	var stats_hbox := HBoxContainer.new()
	stats_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	stats_hbox.add_theme_constant_override("separation", int(24 * scale_factor_x))
	_video_screen_node.add_child(stats_hbox)

	var ratings_vbox := VBoxContainer.new()
	ratings_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	var rat_title := Label.new()
	rat_title.text = "RATINGS"
	rat_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rat_title.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	rat_title.add_theme_font_size_override("font_size", max(1, int(round(9 * scale_factor_y))))
	ratings_vbox.add_child(rat_title)
	var rat_val := Label.new()
	rat_val.text = "4.4 ★★★★★"
	rat_val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rat_val.add_theme_color_override("font_color", Color.WHITE)
	rat_val.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	ratings_vbox.add_child(rat_val)
	stats_hbox.add_child(ratings_vbox)

	var cat_vbox := VBoxContainer.new()
	cat_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	var cat_title := Label.new()
	cat_title.text = "CATEGORY"
	cat_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cat_title.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	cat_title.add_theme_font_size_override("font_size", max(1, int(round(9 * scale_factor_y))))
	cat_vbox.add_child(cat_title)
	var cat_val := Label.new()
	cat_val.text = "Business"
	cat_val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cat_val.add_theme_color_override("font_color", Color.WHITE)
	cat_val.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	cat_vbox.add_child(cat_val)
	stats_hbox.add_child(cat_vbox)

	var dev_vbox := VBoxContainer.new()
	dev_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	var dev_title := Label.new()
	dev_title.text = "DEVELOPER"
	dev_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dev_title.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	dev_title.add_theme_font_size_override("font_size", max(1, int(round(9 * scale_factor_y))))
	dev_vbox.add_child(dev_title)
	var dev_val := Label.new()
	dev_val.text = "Google LLC"
	dev_val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dev_val.add_theme_color_override("font_color", Color.WHITE)
	dev_val.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	dev_vbox.add_child(dev_val)
	stats_hbox.add_child(dev_vbox)

	var video_panel := Panel.new()
	video_panel.custom_minimum_size = Vector2(1, 180 * scale_factor_y)
	video_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var video_style := StyleBoxFlat.new()
	video_style.bg_color = Color(0.1, 0.1, 0.1)
	video_panel.add_theme_stylebox_override("panel", video_style)
	_video_screen_node.add_child(video_panel)

	var bars_hbox := HBoxContainer.new()
	bars_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	bars_hbox.add_theme_constant_override("separation", 0)
	video_panel.add_child(bars_hbox)

	var colors := [Color.YELLOW, Color.CYAN, Color.GREEN, Color.MAGENTA, Color.RED, Color.BLUE, Color.DARK_BLUE]
	for col in colors:
		var bar := ColorRect.new()
		bar.color = col
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bars_hbox.add_child(bar)

	var man_rect := TextureRect.new()
	man_rect.texture = _FORMAT_REWARDED_INTERSTITIAL
	man_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	man_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	man_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	video_panel.add_child(man_rect)

	var speaker_icon := Label.new()
	speaker_icon.text = "🔊"
	speaker_icon.add_theme_font_size_override("font_size", max(1, int(round(18 * scale_factor_y))))
	speaker_icon.position = Vector2(16 * scale_factor_x, 16 * scale_factor_y)
	video_panel.add_child(speaker_icon)

	var pause_icon := Label.new()
	pause_icon.text = "⏸"
	pause_icon.add_theme_font_size_override("font_size", max(1, int(round(18 * scale_factor_y))))
	pause_icon.position = Vector2(48 * scale_factor_x, 16 * scale_factor_y)
	video_panel.add_child(pause_icon)

	var desc_lbl := Label.new()
	desc_lbl.text = "The Google Ads mobile app helps you stay connected to your campaigns while on the go with your smartphone."
	desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_lbl.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	desc_lbl.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	_video_screen_node.add_child(desc_lbl)

	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.5, 0.7, 0.9)
	btn_style.corner_radius_top_left = int(18 * scale_factor_y)
	btn_style.corner_radius_top_right = int(18 * scale_factor_y)
	btn_style.corner_radius_bottom_left = int(18 * scale_factor_y)
	btn_style.corner_radius_bottom_right = int(18 * scale_factor_y)

	var install_btn := Button.new()
	install_btn.custom_minimum_size = Vector2(1, 36 * scale_factor_y)
	install_btn.add_theme_stylebox_override("normal", btn_style)
	install_btn.add_theme_stylebox_override("hover", btn_style)
	install_btn.add_theme_stylebox_override("pressed", btn_style)
	install_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	_video_screen_node.add_child(install_btn)

	var btn_lbl := Label.new()
	btn_lbl.text = "Install"
	btn_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	btn_lbl.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	btn_lbl.add_theme_font_size_override("font_size", max(1, int(round(13 * scale_factor_y))))
	btn_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	install_btn.add_child(btn_lbl)

	# 2b. End Screen
	_end_screen_node = VBoxContainer.new()
	_end_screen_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	_end_screen_node.alignment = BoxContainer.ALIGNMENT_CENTER
	_end_screen_node.add_theme_constant_override("separation", int(32 * scale_factor_y))
	content_control.add_child(_end_screen_node)

	var end_icon := TextureRect.new()
	end_icon.texture = _ICON_120
	end_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	end_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	end_icon.custom_minimum_size = Vector2(80 * scale_factor_y, 80 * scale_factor_y)
	end_icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_end_screen_node.add_child(end_icon)

	var end_title := Label.new()
	end_title.text = "Google Ads"
	end_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_title.add_theme_color_override("font_color", Color.WHITE)
	end_title.add_theme_font_size_override("font_size", max(1, int(round(22 * scale_factor_y))))
	_end_screen_node.add_child(end_title)

	var end_install := Button.new()
	end_install.custom_minimum_size = Vector2(160 * scale_factor_x, 36 * scale_factor_y)
	end_install.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	end_install.add_theme_stylebox_override("normal", btn_style)
	end_install.add_theme_stylebox_override("hover", btn_style)
	end_install.add_theme_stylebox_override("pressed", btn_style)
	end_install.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	_end_screen_node.add_child(end_install)

	var end_btn_lbl := Label.new()
	end_btn_lbl.text = "Install"
	end_btn_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_btn_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	end_btn_lbl.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	end_btn_lbl.add_theme_font_size_override("font_size", max(1, int(round(13 * scale_factor_y))))
	end_btn_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	end_install.add_child(end_btn_lbl)

	# 3. Popup Overlay
	_popup_node = ColorRect.new()
	_popup_node.color = Color(0, 0, 0, 0.6)
	_popup_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui.add_child(_popup_node)

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color.WHITE
	card_style.corner_radius_top_left = int(12 * scale_factor_y)
	card_style.corner_radius_top_right = int(12 * scale_factor_y)
	card_style.corner_radius_bottom_left = int(12 * scale_factor_y)
	card_style.corner_radius_bottom_right = int(12 * scale_factor_y)

	var popup_card := Panel.new()
	popup_card.custom_minimum_size = Vector2(250 * scale_factor_x, 150 * scale_factor_y)
	popup_card.set_anchors_preset(Control.PRESET_CENTER)
	popup_card.grow_horizontal = Control.GROW_DIRECTION_BOTH
	popup_card.grow_vertical = Control.GROW_DIRECTION_BOTH
	popup_card.add_theme_stylebox_override("panel", card_style)
	_popup_node.add_child(popup_card)

	var card_margin := MarginContainer.new()
	card_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_margin.add_theme_constant_override("margin_left", int(16 * scale_factor_x))
	card_margin.add_theme_constant_override("margin_right", int(16 * scale_factor_x))
	card_margin.add_theme_constant_override("margin_top", int(16 * scale_factor_y))
	card_margin.add_theme_constant_override("margin_bottom", int(16 * scale_factor_y))
	popup_card.add_child(card_margin)

	var card_vbox := VBoxContainer.new()
	card_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	card_vbox.add_theme_constant_override("separation", int(12 * scale_factor_y))
	card_margin.add_child(card_vbox)

	var gift_icon := Label.new()
	gift_icon.text = "🎁"
	gift_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gift_icon.add_theme_font_size_override("font_size", max(1, int(round(24 * scale_factor_y))))
	card_vbox.add_child(gift_icon)

	var popup_title := Label.new()
	popup_title.text = "Close Video?"
	popup_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup_title.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	popup_title.add_theme_font_size_override("font_size", max(1, int(round(15 * scale_factor_y))))
	card_vbox.add_child(popup_title)

	var popup_sub := Label.new()
	popup_sub.text = "You will lose your reward"
	popup_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	popup_sub.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
	popup_sub.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	card_vbox.add_child(popup_sub)

	var popup_buttons := HBoxContainer.new()
	popup_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	popup_buttons.add_theme_constant_override("separation", int(16 * scale_factor_x))
	card_vbox.add_child(popup_buttons)

	var close_video_btn := Button.new()
	close_video_btn.text = "CLOSE VIDEO"
	close_video_btn.flat = true
	close_video_btn.add_theme_color_override("font_color", Color(0.3, 0.5, 0.8))
	close_video_btn.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	close_video_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	popup_buttons.add_child(close_video_btn)
	close_video_btn.pressed.connect(_on_close_video_confirmed)

	var resume_video_btn := Button.new()
	resume_video_btn.text = "RESUME VIDEO"
	var res_style := StyleBoxFlat.new()
	res_style.bg_color = Color(0.3, 0.5, 0.8)
	res_style.corner_radius_top_left = int(4 * scale_factor_y)
	res_style.corner_radius_top_right = int(4 * scale_factor_y)
	res_style.corner_radius_bottom_left = int(4 * scale_factor_y)
	res_style.corner_radius_bottom_right = int(4 * scale_factor_y)
	resume_video_btn.add_theme_stylebox_override("normal", res_style)
	resume_video_btn.add_theme_stylebox_override("hover", res_style)
	resume_video_btn.add_theme_stylebox_override("pressed", res_style)
	resume_video_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	resume_video_btn.add_theme_color_override("font_color", Color.WHITE)
	resume_video_btn.add_theme_font_size_override("font_size", max(1, int(round(11 * scale_factor_y))))
	popup_buttons.add_child(resume_video_btn)
	resume_video_btn.pressed.connect(_on_resume_video_pressed)

	if _reward_earned:
		_video_screen_node.hide()
		_end_screen_node.show()
	else:
		_video_screen_node.show()
		_end_screen_node.hide()

	if _popup_visible:
		_popup_node.show()
	else:
		_popup_node.hide()

	_update_countdown_ui()


func show(uid: int) -> void:
	if _ads.has(uid) and is_instance_valid(_ads[uid]["ui"]):
		_active_uid = uid
		_time_elapsed = 0.0
		_timer_active = true
		_reward_earned = false
		_popup_visible = false
		_update_ui(uid)
		_ads[uid]["ui"].show()
		on_rewarded_ad_showed_full_screen_content.emit(uid)
		on_rewarded_ad_impression.emit(uid)
		set_process(true)


func destroy(uid: int) -> void:
	if _ads.has(uid):
		if is_instance_valid(_ads[uid]["ui"]):
			_ads[uid]["ui"].get_parent().queue_free()
		_ads.erase(uid)
		if _active_uid == uid:
			_active_uid = -1
			set_process(false)


func set_server_side_verification_options(_uid: int, _options: Dictionary) -> void:
	pass


func get_response_info(_uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": {},
		"loaded_adapter_response_info": {},
		"response_extras": {}
	}
