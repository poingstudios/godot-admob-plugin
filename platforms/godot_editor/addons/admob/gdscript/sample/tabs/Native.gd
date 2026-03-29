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

extends "res://addons/admob/gdscript/sample/tabs/BaseTab.gd"

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

var _native_overlay_ad: NativeOverlayAd
var _ad_position := AdPosition.TOP
var _is_hidden := false

@onready var _load_button: Button = %LoadNative
@onready var _load_background_button: Button = %LoadNativeBackground
@onready var _destroy_button: Button = %DestroyNative
@onready var _show_button: Button = %ShowNative
@onready var _hide_button: Button = %HideNative
@onready var _get_size_button: Button = %GetSize
@onready var _x_value: LineEdit = %XValue
@onready var _y_value: LineEdit = %YValue

@onready var _template_type: OptionButton = %TemplateType
@onready var _main_bg_button: Button = %MainBGButton
@onready var _cta_bg_button: Button = %CTABGButton
@onready var _cta_text_button: Button = %CTATextButton

var _main_bg_color := Color(1, 1, 1, 1)
var _cta_bg_color := Color(0.258824, 0.521569, 0.956863, 1)
var _cta_text_color := Color(1, 1, 1, 1)

func _ready() -> void:
	super()
	_main_bg_button.pressed.connect(_on_main_bg_button_pressed)
	_cta_bg_button.pressed.connect(_on_cta_bg_button_pressed)
	_cta_text_button.pressed.connect(_on_cta_text_button_pressed)
	_update_ui_state(false)

func _update_button_color(button: Button, color: Color) -> void:
	for state: String in ["normal", "hover", "pressed"]:
		var style: StyleBoxFlat = button.get_theme_stylebox(state).duplicate()
		style.bg_color = color
		button.add_theme_stylebox_override(state, style)

func _show_color_popup(current_color: Color, callback: Callable) -> void:
	var popup := PopupPanel.new()
	var picker := ColorPicker.new()
	picker.color = current_color
	picker.edit_alpha = false
	picker.custom_minimum_size = Vector2(300, 400)
	popup.add_child(picker)
	add_child(popup)
	popup.popup_centered()
	picker.color_changed.connect(callback)
	popup.popup_hide.connect(popup.queue_free)

func _on_main_bg_button_pressed() -> void:
	_show_color_popup(_main_bg_color, func(color: Color) -> void:
		_main_bg_color = color
		_update_button_color(_main_bg_button, color)
	)

func _on_cta_bg_button_pressed() -> void:
	_show_color_popup(_cta_bg_color, func(color: Color) -> void:
		_cta_bg_color = color
		_update_button_color(_cta_bg_button, color)
	)

func _on_cta_text_button_pressed() -> void:
	_show_color_popup(_cta_text_color, func(color: Color) -> void:
		_cta_text_color = color
		_update_button_color(_cta_text_button, color)
	)

func _update_ui_state(is_loaded: bool) -> void:
	_load_button.disabled = is_loaded
	_load_background_button.disabled = is_loaded
	_show_button.disabled = !is_loaded
	_hide_button.disabled = !is_loaded
	_destroy_button.disabled = !is_loaded
	_get_size_button.disabled = !is_loaded

func _get_ad_unit_id() -> String:
	return "ca-app-pub-3940256099942544/2247696110" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/3986624511"

func _load_native(hide_immediately: bool = false) -> void:
	if _native_overlay_ad:
		_native_overlay_ad.destroy()
		_native_overlay_ad = null
	
	_update_ui_state(false)
	_log("Loading native ad%s..." % (" in background" if hide_immediately else ""))
	
	_is_hidden = hide_immediately
	
	var options := NativeAdOptions.new()
	options.ad_choices_placement = AdChoicesPlacement.Values.TOP_RIGHT
	options.media_aspect_ratio = NativeMediaAspectRatio.Values.ANY
	
	NativeOverlayAd.load(
		_get_ad_unit_id(), 
		AdRequest.new(), 
		options, 
		_on_ad_load_finished
	)

func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
	if error:
		_log("Failed to load: " + error.message)
		_update_ui_state(false)
		return
	
	_log("Ad loaded successfully")
	_native_overlay_ad = ad
	
	_native_overlay_ad.ad_listener.on_ad_clicked = _on_ad_clicked
	_native_overlay_ad.ad_listener.on_ad_closed = _on_ad_closed
	_native_overlay_ad.ad_listener.on_ad_impression = _on_ad_impression
	_native_overlay_ad.ad_listener.on_ad_opened = _on_ad_opened
	_native_overlay_ad.on_ad_paid = func(ad_value: AdValue) -> void:
		var ad_source_name := "N/A"
		var response_info := _native_overlay_ad.get_response_info() if _native_overlay_ad else null
		if response_info:
			if response_info.loaded_adapter_response_info:
				ad_source_name = response_info.loaded_adapter_response_info.ad_source_name
		_log("Ad paid: %f %s (precision: %d, source: %s)" % [ad_value.value_micros / 1000000.0, ad_value.currency_code, ad_value.precision, ad_source_name])
	
	var style := NativeTemplateStyle.new()
	style.template_id = NativeTemplateStyle.SMALL if _template_type.selected == 0 else NativeTemplateStyle.MEDIUM
	style.main_background_color = _main_bg_color
	
	var cta_style := NativeTemplateTextStyle.new()
	cta_style.background_color = _cta_bg_color
	cta_style.text_color = _cta_text_color
	cta_style.font_size = 15 # Default
	cta_style.style = NativeTemplateFontStyle.Values.BOLD
	
	style.call_to_action_text = cta_style
	
	_native_overlay_ad.render_template(style, _ad_position)
	
	if _is_hidden:
		_native_overlay_ad.hide()
		
	_update_ui_state(true)

func _on_load_native_pressed() -> void:
	_load_native(false)

func _on_load_native_background_pressed() -> void:
	_load_native(true)

func _on_destroy_native_pressed() -> void:
	if _native_overlay_ad:
		_native_overlay_ad.destroy()
		_native_overlay_ad = null
		_log("Native destroyed")
		_update_ui_state(false)

func _on_show_native_pressed() -> void:
	if _native_overlay_ad:
		_is_hidden = false
		_native_overlay_ad.show()
		_log("Native shown")

func _on_hide_native_pressed() -> void:
	if _native_overlay_ad:
		_is_hidden = true
		_native_overlay_ad.hide()
		_log("Native hidden")

func _on_get_size_pressed() -> void:
	if _native_overlay_ad:
		var info := "W: %.1f, H: %.1f" % [
			_native_overlay_ad.get_template_width_in_pixels(),
			_native_overlay_ad.get_template_height_in_pixels()
		]
		_log(info)

func _update_position(pos: AdPosition) -> void:
	_ad_position = pos
	if _native_overlay_ad:
		_native_overlay_ad.set_template_position(pos)

func _on_position_selected(pos: AdPosition) -> void:
	_log("Updating position to: " + AdPosition.Values.keys()[pos.value])
	_update_position(pos)

func _on_apply_custom_pressed() -> void:
	var x := int(_x_value.text)
	var y := int(_y_value.text)
	_log("Applying custom position: (%d, %d)" % [x, y])
	_update_position(AdPosition.custom(x, y))

	DisplayServer.virtual_keyboard_hide()
#region Callbacks
func _on_ad_clicked() -> void:
	_log("Ad clicked")

func _on_ad_closed() -> void:
	_log("Ad closed")

func _on_ad_impression() -> void:
	_log("Ad impression recorded")

func _on_ad_opened() -> void:
	_log("Ad opened")
#endregion

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[Native] " + message)
	else:
		print("[Native] " + message)

func _on_top_pressed() -> void: _on_position_selected(AdPosition.TOP)
func _on_bottom_pressed() -> void: _on_position_selected(AdPosition.BOTTOM)
func _on_left_pressed() -> void: _on_position_selected(AdPosition.LEFT)
func _on_right_pressed() -> void: _on_position_selected(AdPosition.RIGHT)
func _on_top_left_pressed() -> void: _on_position_selected(AdPosition.TOP_LEFT)
func _on_top_right_pressed() -> void: _on_position_selected(AdPosition.TOP_RIGHT)
func _on_bottom_left_pressed() -> void: _on_position_selected(AdPosition.BOTTOM_LEFT)
func _on_bottom_right_pressed() -> void: _on_position_selected(AdPosition.BOTTOM_RIGHT)
func _on_center_pressed() -> void: _on_position_selected(AdPosition.CENTER)
