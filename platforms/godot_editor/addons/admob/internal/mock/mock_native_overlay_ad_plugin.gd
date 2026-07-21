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

const _FLOOD_IT_ICON := preload("res://addons/admob/assets/flood_it_icon.svg")

signal on_native_overlay_ad_loaded(uid: int)
signal on_native_overlay_ad_failed_to_load(uid: int, error: Dictionary)
signal on_native_overlay_ad_clicked(uid: int)
signal on_native_overlay_ad_closed(uid: int)
signal on_native_overlay_ad_impression(uid: int)
signal on_native_overlay_ad_opened(uid: int)
signal on_native_overlay_ad_paid(uid: int, ad_value: Dictionary)
signal on_native_overlay_ad_video_start(uid: int)
signal on_native_overlay_ad_video_play(uid: int)
signal on_native_overlay_ad_video_pause(uid: int)
signal on_native_overlay_ad_video_end(uid: int)
signal on_native_overlay_ad_video_mute(uid: int, is_muted: bool)
signal on_native_overlay_ad_rendered(uid: int)

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
	var is_video := ad_unit_id.ends_with("1044960115") or ad_unit_id.ends_with("2521693316")
	_ads[uid]["has_video_content"] = is_video
	_ads[uid]["is_video_muted"] = false
	_ads[uid]["is_video_playing"] = false
	_ads[uid]["video_duration"] = 15.0
	_ads[uid]["video_aspect_ratio"] = 1.777

	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		emit_signal("on_native_overlay_ad_loaded", uid)
		var ad: Dictionary = _ads[uid]
		if not ad.get("is_hidden", false) and is_instance_valid(ad["ui"]):
			_update_ui_position(uid)
			ad["ui"].show()
			emit_signal("on_native_overlay_ad_impression", uid)
	)

func render_template(uid: int, style: Dictionary, position: int, ad_size: Dictionary) -> void:
	if _ads.has(uid):
		_ads[uid]["style"] = style
		_ads[uid]["position"] = position
		_ads[uid]["custom_position"] = null
		_ads[uid]["ad_size"] = ad_size
		_update_ui_position(uid)
		on_native_overlay_ad_rendered.emit(uid)


func render_template_custom_position(uid: int, style: Dictionary, x: float, y: float, ad_size: Dictionary) -> void:
	if _ads.has(uid):
		_ads[uid]["style"] = style
		_ads[uid]["position"] = -1 # CUSTOM
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_ads[uid]["ad_size"] = ad_size
		_update_ui_position(uid)
		on_native_overlay_ad_rendered.emit(uid)


func update_position(uid: int, position: int) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = position
		_ads[uid]["custom_position"] = null
		_update_ui_position(uid)


func update_custom_position(uid: int, x: float, y: float) -> void:
	if _ads.has(uid):
		_ads[uid]["position"] = -1 # CUSTOM
		_ads[uid]["custom_position"] = {"x": x, "y": y}
		_update_ui_position(uid)


func _get_dict(parent: Dictionary, key: String) -> Dictionary:
	if parent.has(key) and parent[key] is Dictionary:
		return parent[key]
	return {}


func _parse_color(hex: String, default_color: Color) -> Color:
	if hex == "":
		return default_color
	if not hex.begins_with("#"):
		hex = "#" + hex
	return Color.from_string(hex, default_color)


func _apply_text_style(label: Label, style_dict: Dictionary, default_text_color: Color, default_font_size: float, scale_factor_y: float) -> void:
	var txt_color := _parse_color(style_dict.get("text_color", ""), default_text_color)
	label.add_theme_color_override("font_color", txt_color)

	var font_size: float = style_dict.get("font_size", 0.0)
	if font_size <= 0.0:
		font_size = default_font_size
	label.add_theme_font_size_override("font_size", max(1, int(round(font_size * scale_factor_y))))

	var bg_hex := style_dict.get("background_color", "") as String
	if bg_hex != "":
		var bg_color := _parse_color(bg_hex, Color.TRANSPARENT)
		if bg_color.a > 0.0:
			var sb := StyleBoxFlat.new()
			sb.bg_color = bg_color
			sb.content_margin_left = int(4 * scale_factor_y)
			sb.content_margin_right = int(4 * scale_factor_y)
			sb.content_margin_top = int(2 * scale_factor_y)
			sb.content_margin_bottom = int(2 * scale_factor_y)
			label.add_theme_stylebox_override("normal", sb)


func _update_ui_position(uid: int) -> void:
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

	var style: Dictionary = ad.get("style", {})
	var template_id: String = style.get("template_id", "small")

	var width_dp := 0
	var height_dp := 0

	if ad["ad_size"] != null:
		var size_dict: Dictionary = ad["ad_size"]
		if size_dict.has("width"): width_dp = size_dict["width"]
		if size_dict.has("height"): height_dp = size_dict["height"]

	if template_id == "medium" and height_dp > 0 and height_dp < 120:
		template_id = "small"

	if template_id == "small":
		height_dp = 90 if height_dp <= 0 else min(height_dp, 90)
	else:
		height_dp = 250 if height_dp <= 0 else min(height_dp, 250)

	var width_in_viewport: float
	if width_dp <= 0:
		width_in_viewport = viewport_size.x
		width_dp = int(round(viewport_size.x / scale_factor_x))
	else:
		width_in_viewport = width_dp * scale_factor_x

	var height_in_viewport := height_dp * scale_factor_y

	ad["current_width"] = width_dp
	ad["current_height"] = height_dp

	ui.clip_contents = true
	ui.custom_minimum_size = Vector2(width_in_viewport, height_in_viewport)
	ui.size = ui.custom_minimum_size

	for child in ui.get_children():
		child.queue_free()

	var bg_color := Color.WHITE
	if style.get("main_background_color", "") != "":
		bg_color = _parse_color(style["main_background_color"], Color.WHITE)

	ui.color = bg_color

	var primary_style := _get_dict(style, "primary_text")
	var secondary_style := _get_dict(style, "secondary_text")
	var tertiary_style := _get_dict(style, "tertiary_text")
	var cta_style_dict := _get_dict(style, "call_to_action_text")

	var cta_bg := Color(0.18, 0.45, 0.96)
	if cta_style_dict.get("background_color", "") != "":
		cta_bg = _parse_color(cta_style_dict["background_color"], cta_bg)

	var cta_text := Color.WHITE
	if cta_style_dict.get("text_color", "") != "":
		cta_text = _parse_color(cta_style_dict["text_color"], cta_text)

	if template_id == "small":
		var margin := MarginContainer.new()
		margin.set_anchors_preset(Control.PRESET_FULL_RECT)
		var margin_l_r := clamp(height_dp * 0.1, 4, 12)
		var margin_t_b := clamp(height_dp * 0.06, 2, 8)
		margin.add_theme_constant_override("margin_left", int(margin_l_r * scale_factor_x))
		margin.add_theme_constant_override("margin_right", int(margin_l_r * scale_factor_x))
		margin.add_theme_constant_override("margin_top", int(margin_t_b * scale_factor_y))
		margin.add_theme_constant_override("margin_bottom", int(margin_t_b * scale_factor_y))
		ui.add_child(margin)

		var vbox_main := VBoxContainer.new()
		vbox_main.add_theme_constant_override("separation", int(clamp(height_dp * 0.05, 2, 6) * scale_factor_y))
		margin.add_child(vbox_main)

		var hbox_top := HBoxContainer.new()
		hbox_top.add_theme_constant_override("separation", int(8 * scale_factor_x))
		hbox_top.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox_main.add_child(hbox_top)

		var icon := TextureRect.new()
		icon.texture = _FLOOD_IT_ICON
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var icon_size_dp := clamp(height_dp - 28, 10, 40)
		icon.custom_minimum_size = Vector2(icon_size_dp * scale_factor_y, icon_size_dp * scale_factor_y)
		icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER

		var icon_bg := Panel.new()
		icon_bg.custom_minimum_size = icon.custom_minimum_size
		icon_bg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var icon_style := StyleBoxFlat.new()
		icon_style.bg_color = Color.TRANSPARENT
		icon_style.border_color = Color(0.85, 0.85, 0.85)
		icon_style.border_width_left = 1
		icon_style.border_width_right = 1
		icon_style.border_width_top = 1
		icon_style.border_width_bottom = 1
		icon_style.corner_radius_top_left = int(4 * scale_factor_y)
		icon_style.corner_radius_top_right = int(4 * scale_factor_y)
		icon_style.corner_radius_bottom_left = int(4 * scale_factor_y)
		icon_style.corner_radius_bottom_right = int(4 * scale_factor_y)
		icon_bg.add_theme_stylebox_override("panel", icon_style)
		icon_bg.add_child(icon)
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		hbox_top.add_child(icon_bg)

		var vbox_text := VBoxContainer.new()
		vbox_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_text.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		vbox_text.add_theme_constant_override("separation", 0)
		hbox_top.add_child(vbox_text)

		var title := Label.new()
		title.text = "Mock Ad : Flood-It!"
		var title_font_size := clamp(height_dp * 0.18, 8, 14)
		_apply_text_style(title, primary_style, Color(0.1, 0.1, 0.1), title_font_size, scale_factor_y)
		vbox_text.add_child(title)

		var sub_hbox := HBoxContainer.new()
		sub_hbox.add_theme_constant_override("separation", int(4 * scale_factor_x))
		vbox_text.add_child(sub_hbox)

		var ad_badge := Panel.new()
		var badge_height: float = clamp(height_dp * 0.2, 8, 14)
		var badge_width: float = badge_height * 1.6
		ad_badge.custom_minimum_size = Vector2(badge_width * scale_factor_x, badge_height * scale_factor_y)
		ad_badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var badge_bg := Color(0.0, 0.53, 0.28)
		if secondary_style.get("background_color", "") != "":
			badge_bg = _parse_color(secondary_style["background_color"], badge_bg)
		var ad_badge_style := StyleBoxFlat.new()
		ad_badge_style.bg_color = badge_bg
		ad_badge_style.corner_radius_top_left = 2
		ad_badge_style.corner_radius_top_right = 2
		ad_badge_style.corner_radius_bottom_left = 2
		ad_badge_style.corner_radius_bottom_right = 2
		ad_badge.add_theme_stylebox_override("panel", ad_badge_style)

		var ad_badge_lbl := Label.new()
		ad_badge_lbl.text = "Ad"
		ad_badge_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ad_badge_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var badge_font_size := clamp(height_dp * 0.14, 6, 9)
		_apply_text_style(ad_badge_lbl, secondary_style, Color.WHITE, badge_font_size, scale_factor_y)
		ad_badge.add_child(ad_badge_lbl)
		ad_badge_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		sub_hbox.add_child(ad_badge)

		var stars := Label.new()
		stars.text = "★ ★ ★ ★ ☆"
		stars.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var stars_font_size := clamp(height_dp * 0.16, 7, 12)
		_apply_text_style(stars, secondary_style, Color(1.0, 0.76, 0.03), stars_font_size, scale_factor_y)
		sub_hbox.add_child(stars)

		var cta_btn := Button.new()
		cta_btn.text = "INSTALL"
		var btn_height_dp := clamp(height_dp - 32, 14, 28)
		cta_btn.custom_minimum_size = Vector2(1, btn_height_dp * scale_factor_y)
		cta_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cta_btn.add_theme_color_override("font_color", cta_text)
		cta_btn.add_theme_color_override("font_hover_color", cta_text)
		cta_btn.add_theme_color_override("font_pressed_color", cta_text)
		var cta_font_size := clamp(height_dp * 0.18, 8, 13)
		if cta_style_dict.get("font_size", 0.0) > 0.0:
			cta_font_size = cta_style_dict["font_size"]
		cta_btn.add_theme_font_size_override("font_size", max(1, int(round(cta_font_size * scale_factor_y))))

		var cta_btn_normal := StyleBoxFlat.new()
		cta_btn_normal.bg_color = cta_bg
		cta_btn_normal.corner_radius_top_left = int(2 * scale_factor_y)
		cta_btn_normal.corner_radius_top_right = int(2 * scale_factor_y)
		cta_btn_normal.corner_radius_bottom_left = int(2 * scale_factor_y)
		cta_btn_normal.corner_radius_bottom_right = int(2 * scale_factor_y)

		var cta_btn_hover := cta_btn_normal.duplicate() as StyleBoxFlat
		cta_btn_hover.bg_color = cta_bg.lightened(0.15)

		var cta_btn_pressed := cta_btn_normal.duplicate() as StyleBoxFlat
		cta_btn_pressed.bg_color = cta_bg.darkened(0.15)

		cta_btn.add_theme_stylebox_override("normal", cta_btn_normal)
		cta_btn.add_theme_stylebox_override("hover", cta_btn_hover)
		cta_btn.add_theme_stylebox_override("pressed", cta_btn_pressed)
		cta_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		vbox_main.add_child(cta_btn)

	else:
		var margin := MarginContainer.new()
		margin.set_anchors_preset(Control.PRESET_FULL_RECT)
		margin.add_theme_constant_override("margin_left", int(12 * scale_factor_x))
		margin.add_theme_constant_override("margin_right", int(12 * scale_factor_x))
		margin.add_theme_constant_override("margin_top", int(10 * scale_factor_y))
		margin.add_theme_constant_override("margin_bottom", int(10 * scale_factor_y))
		ui.add_child(margin)

		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", int(10 * scale_factor_y))
		margin.add_child(vbox)

		# 1. Media content panel (Top)
		var media_panel := ColorRect.new()
		var media_bg := Color.BLACK
		if tertiary_style.get("background_color", "") != "":
			media_bg = _parse_color(tertiary_style["background_color"], media_bg)
		media_panel.color = media_bg
		media_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox.add_child(media_panel)

		var media_vbox := VBoxContainer.new()
		media_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
		media_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		media_vbox.add_theme_constant_override("separation", int(8 * scale_factor_y))
		media_panel.add_child(media_vbox)

		if has_video_content(uid):
			var video_status := Label.new()
			video_status.text = "Video Ad (Paused)"
			video_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			video_status.add_theme_color_override("font_color", Color.YELLOW)
			video_status.add_theme_font_size_override("font_size", max(1, int(round(16 * scale_factor_y))))
			media_vbox.add_child(video_status)

			var controls_hbox := HBoxContainer.new()
			controls_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
			controls_hbox.add_theme_constant_override("separation", int(10 * scale_factor_x))
			media_vbox.add_child(controls_hbox)

			var play_btn := Button.new()
			play_btn.text = "Play"
			play_btn.custom_minimum_size = Vector2(60 * scale_factor_x, 30 * scale_factor_y)
			controls_hbox.add_child(play_btn)

			var mute_btn := Button.new()
			mute_btn.text = "Mute"
			mute_btn.custom_minimum_size = Vector2(60 * scale_factor_x, 30 * scale_factor_y)
			controls_hbox.add_child(mute_btn)

			var has_started := false
			play_btn.pressed.connect(func():
				var playing: bool = _ads[uid].get("is_video_playing", false)
				if playing:
					_ads[uid]["is_video_playing"] = false
					play_btn.text = "Play"
					video_status.text = "Video Ad (Paused)"
					video_status.add_theme_color_override("font_color", Color.YELLOW)
					on_native_overlay_ad_video_pause.emit(uid)
				else:
					_ads[uid]["is_video_playing"] = true
					play_btn.text = "Pause"
					video_status.text = "Video Ad (Playing...)"
					video_status.add_theme_color_override("font_color", Color.GREEN)
					if not has_started:
						has_started = true
						on_native_overlay_ad_video_start.emit(uid)
					on_native_overlay_ad_video_play.emit(uid)
			)

			mute_btn.pressed.connect(func():
				var muted: bool = _ads[uid].get("is_video_muted", false)
				_ads[uid]["is_video_muted"] = not muted
				mute_btn.text = "Unmute" if not muted else "Mute"
				on_native_overlay_ad_video_mute.emit(uid, not muted)
			)
		else:
			var media_title := Label.new()
			media_title.text = "Flood-It!"
			media_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			media_title.add_theme_color_override("font_color", Color.WHITE)
			media_title.add_theme_font_size_override("font_size", max(1, int(round(20 * scale_factor_y))))
			media_vbox.add_child(media_title)

			var grid := GridContainer.new()
			grid.columns = 6
			grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			grid.add_theme_constant_override("h_separation", int(4 * scale_factor_x))
			grid.add_theme_constant_override("v_separation", int(4 * scale_factor_y))
			media_vbox.add_child(grid)
			var colors := [
				Color.AQUA, Color.GREEN, Color.YELLOW, Color.DEEP_PINK, Color.BLUE, Color.RED,
				Color.YELLOW, Color.DEEP_PINK, Color.BLUE, Color.RED, Color.AQUA, Color.GREEN
			]
			for c in colors:
				var sq := ColorRect.new()
				sq.color = c
				sq.custom_minimum_size = Vector2(8 * scale_factor_x, 8 * scale_factor_y)
				grid.add_child(sq)

		# 2. Metadata row (Middle)
		var meta_hbox := HBoxContainer.new()
		meta_hbox.add_theme_constant_override("separation", int(10 * scale_factor_x))
		vbox.add_child(meta_hbox)

		var icon := TextureRect.new()
		icon.texture = _FLOOD_IT_ICON
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var icon_size := 40
		icon.custom_minimum_size = Vector2(icon_size * scale_factor_y, icon_size * scale_factor_y)
		icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER

		var icon_bg := Panel.new()
		icon_bg.custom_minimum_size = icon.custom_minimum_size
		icon_bg.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var icon_style := StyleBoxFlat.new()
		icon_style.bg_color = Color.TRANSPARENT
		icon_style.border_color = Color(0.85, 0.85, 0.85)
		icon_style.border_width_left = 1
		icon_style.border_width_right = 1
		icon_style.border_width_top = 1
		icon_style.border_width_bottom = 1
		icon_style.corner_radius_top_left = int(6 * scale_factor_y)
		icon_style.corner_radius_top_right = int(6 * scale_factor_y)
		icon_style.corner_radius_bottom_left = int(6 * scale_factor_y)
		icon_style.corner_radius_bottom_right = int(6 * scale_factor_y)
		icon_bg.add_theme_stylebox_override("panel", icon_style)
		icon_bg.add_child(icon)
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		meta_hbox.add_child(icon_bg)

		var meta_vbox := VBoxContainer.new()
		meta_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		meta_vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		meta_vbox.add_theme_constant_override("separation", int(2 * scale_factor_y))
		meta_hbox.add_child(meta_vbox)

		var title := Label.new()
		title.text = "Mock Ad : Flood-It!"
		_apply_text_style(title, primary_style, Color(0.1, 0.1, 0.1), 14.0, scale_factor_y)
		meta_vbox.add_child(title)

		var sub_hbox := HBoxContainer.new()
		sub_hbox.add_theme_constant_override("separation", int(6 * scale_factor_x))
		meta_vbox.add_child(sub_hbox)

		var ad_badge := Panel.new()
		ad_badge.custom_minimum_size = Vector2(24 * scale_factor_x, 15 * scale_factor_y)
		ad_badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var badge_bg := Color(0.0, 0.53, 0.28)
		if secondary_style.get("background_color", "") != "":
			badge_bg = _parse_color(secondary_style["background_color"], badge_bg)
		var ad_badge_style := StyleBoxFlat.new()
		ad_badge_style.bg_color = badge_bg
		ad_badge_style.corner_radius_top_left = 3
		ad_badge_style.corner_radius_top_right = 3
		ad_badge_style.corner_radius_bottom_left = 3
		ad_badge_style.corner_radius_bottom_right = 3
		ad_badge.add_theme_stylebox_override("panel", ad_badge_style)

		var ad_badge_lbl := Label.new()
		ad_badge_lbl.text = "Ad"
		ad_badge_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		ad_badge_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_apply_text_style(ad_badge_lbl, secondary_style, Color.WHITE, 9.0, scale_factor_y)
		ad_badge.add_child(ad_badge_lbl)
		ad_badge_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		sub_hbox.add_child(ad_badge)

		var stars := Label.new()
		stars.text = "★ ★ ★ ★ ☆"
		stars.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		_apply_text_style(stars, secondary_style, Color(1.0, 0.76, 0.03), 12.0, scale_factor_y)
		sub_hbox.add_child(stars)

		# 3. Description Label
		var desc := Label.new()
		desc.text = "Install Flood-It App for free! Free Popular Casual Game"
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		desc.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		_apply_text_style(desc, tertiary_style, Color.DARK_GRAY, 10.0, scale_factor_y)
		vbox.add_child(desc)

		# 4. CTA Button (INSTALL) - Full Width
		var cta_btn := Button.new()
		cta_btn.text = "INSTALL"
		cta_btn.custom_minimum_size = Vector2(1, 36 * scale_factor_y)
		cta_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cta_btn.add_theme_color_override("font_color", cta_text)
		cta_btn.add_theme_color_override("font_hover_color", cta_text)
		cta_btn.add_theme_color_override("font_pressed_color", cta_text)
		var cta_font_size := 13.0
		if cta_style_dict.get("font_size", 0.0) > 0.0:
			cta_font_size = cta_style_dict["font_size"]
		cta_btn.add_theme_font_size_override("font_size", max(1, int(round(cta_font_size * scale_factor_y))))

		var cta_btn_normal := StyleBoxFlat.new()
		cta_btn_normal.bg_color = cta_bg
		cta_btn_normal.corner_radius_top_left = int(4 * scale_factor_y)
		cta_btn_normal.corner_radius_top_right = int(4 * scale_factor_y)
		cta_btn_normal.corner_radius_bottom_left = int(4 * scale_factor_y)
		cta_btn_normal.corner_radius_bottom_right = int(4 * scale_factor_y)

		var cta_btn_hover := cta_btn_normal.duplicate() as StyleBoxFlat
		cta_btn_hover.bg_color = cta_bg.lightened(0.15)

		var cta_btn_pressed := cta_btn_normal.duplicate() as StyleBoxFlat
		cta_btn_pressed.bg_color = cta_bg.darkened(0.15)

		cta_btn.add_theme_stylebox_override("normal", cta_btn_normal)
		cta_btn.add_theme_stylebox_override("hover", cta_btn_hover)
		cta_btn.add_theme_stylebox_override("pressed", cta_btn_pressed)
		cta_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		vbox.add_child(cta_btn)

	var close_btn := Button.new()
	close_btn.text = "×"
	close_btn.anchor_left = 1.0
	close_btn.anchor_right = 1.0
	close_btn.anchor_top = 0.0
	close_btn.anchor_bottom = 0.0
	close_btn.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	close_btn.custom_minimum_size = Vector2(20 * scale_factor_x, 20 * scale_factor_y)
	close_btn.position = Vector2(ui.size.x - 25 * scale_factor_x, 5 * scale_factor_y)
	ui.add_child(close_btn)

	var close_style := StyleBoxFlat.new()
	close_style.bg_color = Color.WHITE
	close_style.corner_radius_top_left = 999
	close_style.corner_radius_top_right = 999
	close_style.corner_radius_bottom_left = 999
	close_style.corner_radius_bottom_right = 999
	close_style.shadow_color = Color(0, 0, 0, 0.15)
	close_style.shadow_size = int(round(2 * scale_factor_y))
	close_style.shadow_offset = Vector2(0, int(round(1 * scale_factor_y)))
	close_style.content_margin_top = 0
	close_style.content_margin_bottom = 0

	close_btn.add_theme_stylebox_override("normal", close_style)
	close_btn.add_theme_stylebox_override("hover", close_style)
	close_btn.add_theme_stylebox_override("pressed", close_style)
	close_btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	close_btn.add_theme_color_override("font_color", Color(0.85, 0.15, 0.15))
	close_btn.add_theme_font_size_override("font_size", max(1, int(round(14 * scale_factor_y))))

	close_btn.pressed.connect(func() -> void:
		ad["is_hidden"] = true
		ui.hide()
		on_native_overlay_ad_closed.emit(uid)
	)

	var scaled_size := ui.size
	match ad["position"]:
		-1: # CUSTOM
			var x: float = ad["custom_position"].get("x", 0.0) * scale_factor_x if ad["custom_position"] != null else 0.0
			var y: float = ad["custom_position"].get("y", 0.0) * scale_factor_y if ad["custom_position"] != null else 0.0
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
	if _ads.has(uid) and not _ads[uid].get("is_hidden", false):
		var viewport_size := get_viewport().get_visible_rect().size
		var window_size := DisplayServer.window_get_size()
		var gui_scale_factor := 1.0
		if window_size.x > 0:
			gui_scale_factor = viewport_size.x / float(window_size.x)

		var width_dp: int = _ads[uid].get("current_width", 320)
		var scale_factor: float = min(viewport_size.x / 360.0, viewport_size.y / 640.0)
		if scale_factor <= 0.0:
			scale_factor = 1.0
		var width_in_viewport = width_dp * scale_factor
		return float(width_in_viewport / gui_scale_factor)
	return 0.0


func get_height_in_pixels(uid: int) -> float:
	if _ads.has(uid) and not _ads[uid].get("is_hidden", false):
		var viewport_size := get_viewport().get_visible_rect().size
		var window_size := DisplayServer.window_get_size()
		var gui_scale_factor := 1.0
		if window_size.y > 0:
			gui_scale_factor = viewport_size.y / float(window_size.y)

		var height_dp: int = _ads[uid].get("current_height", 90)
		var scale_factor: float = min(viewport_size.x / 360.0, viewport_size.y / 640.0)
		if scale_factor <= 0.0:
			scale_factor = 1.0
		var height_in_viewport = height_dp * scale_factor
		return float(height_in_viewport / gui_scale_factor)
	return 0.0


func get_response_info(_uid: int) -> Dictionary:
	return {
		"response_id": "mock_response_id",
		"mediation_adapter_class_name": "MockAdapter",
		"adapter_responses": {}, "loaded_adapter_response_info": {}, "response_extras": {}
	}


func has_video_content(uid: int) -> bool:
	if _ads.has(uid):
		return _ads[uid].get("has_video_content", false)
	return false


func get_video_duration(uid: int) -> float:
	if _ads.has(uid):
		return _ads[uid].get("video_duration", 0.0)
	return 0.0


func get_video_aspect_ratio(uid: int) -> float:
	if _ads.has(uid):
		return _ads[uid].get("video_aspect_ratio", 0.0)
	return 0.0


func is_video_muted(uid: int) -> bool:
	if _ads.has(uid):
		return _ads[uid].get("is_video_muted", false)
	return false


func is_video_custom_controls_enabled(_uid: int) -> bool:
	return false
