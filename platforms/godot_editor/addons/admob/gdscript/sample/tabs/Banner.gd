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

extends VBoxContainer

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

var _ad_view: AdView
var _ad_listener := AdListener.new()
var _ad_position := AdPosition.TOP
var _is_hidden := false

@onready var _load_button: Button = $ActionsCard/VBox/BannerActions/LoadBanner
@onready var _load_background_button: Button = $ActionsCard/VBox/BannerActions/LoadBannerBackground
@onready var _destroy_button: Button = $ActionsCard/VBox/BannerActions/DestroyBanner
@onready var _show_button: Button = $ActionsCard/VBox/BannerActions/ShowBanner
@onready var _hide_button: Button = $ActionsCard/VBox/BannerActions/HideBanner
@onready var _get_size_button: Button = $ActionsCard/VBox/BannerActions/GetSize
@onready var _x_value: LineEdit = %XValue
@onready var _y_value: LineEdit = %YValue

func _ready() -> void:
	_ad_listener.on_ad_clicked = _on_ad_clicked
	_ad_listener.on_ad_closed = _on_ad_closed
	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
	_ad_listener.on_ad_impression = _on_ad_impression
	_ad_listener.on_ad_loaded = _on_ad_loaded
	_ad_listener.on_ad_opened = _on_ad_opened
	
	_update_ui_state(false)

func _update_ui_state(is_loaded: bool) -> void:
	_load_button.disabled = is_loaded
	_load_background_button.disabled = is_loaded
	_show_button.disabled = !is_loaded
	_hide_button.disabled = !is_loaded
	_destroy_button.disabled = !is_loaded
	_get_size_button.disabled = !is_loaded

func _get_ad_unit_id() -> String:
	return "ca-app-pub-3940256099942544/2934735716" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/2934735716"

func _load_banner(hide_immediately: bool = false) -> void:
	if _ad_view:
		_ad_view.destroy()
	
	_update_ui_state(false)
	_log("Loading adaptive banner%s..." % (" in background" if hide_immediately else ""))
	
	var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	_ad_view = AdView.new(_get_ad_unit_id(), ad_size, _ad_position)
	_ad_view.ad_listener = _ad_listener
	
	_is_hidden = hide_immediately
	if _is_hidden:
		_ad_view.hide()
		
	_ad_view.load_ad(AdRequest.new())

func _on_load_banner_pressed() -> void:
	_load_banner(false)

func _on_load_banner_background_pressed() -> void:
	_load_banner(true)

func _on_destroy_banner_pressed() -> void:
	if _ad_view:
		_ad_view.destroy()
		_ad_view = null
		_log("Banner destroyed")
		_update_ui_state(false)
		if Registry.safe_area:
			Registry.safe_area.reset_ad_overlap()

func _on_show_banner_pressed() -> void:
	if _ad_view:
		_is_hidden = false
		_ad_view.show()
		_log("Banner shown")
		if Registry.safe_area:
			Registry.safe_area.update_ad_overlap(_ad_view)

func _on_hide_banner_pressed() -> void:
	if _ad_view:
		_is_hidden = true
		_ad_view.hide()
		_log("Banner hidden")
		if Registry.safe_area:
			Registry.safe_area.reset_ad_overlap()

func _on_get_size_pressed() -> void:
	if _ad_view:
		var info := "W: %d, H: %d | Pixels: %dx%d" % [
			_ad_view.get_width(),
			_ad_view.get_height(),
			_ad_view.get_width_in_pixels(),
			_ad_view.get_height_in_pixels()
		]
		_log(info)

func _on_apply_custom_pressed() -> void:
	var x := int(_x_value.text)
	var y := int(_y_value.text)
	_log("Applying custom position: (%d, %d)" % [x, y])
	_update_position(AdPosition.custom(x, y))

	DisplayServer.virtual_keyboard_hide()
#region Callbacks
func _on_ad_failed_to_load(error: LoadAdError) -> void:
	_log("Failed to load: " + error.message)
	_update_ui_state(false)
	if Registry.safe_area:
		Registry.safe_area.reset_ad_overlap()

func _on_ad_clicked() -> void:
	_log("Ad clicked")

func _on_ad_closed() -> void:
	_log("Ad closed")

func _on_ad_impression() -> void:
	_log("Ad impression recorded")

func _on_ad_loaded() -> void:
	_log("Ad loaded successfully")
	_update_ui_state(true)
	if Registry.safe_area and not _is_hidden:
		Registry.safe_area.update_ad_overlap(_ad_view)

func _on_ad_opened() -> void:
	_log("Ad opened")
#endregion

func _update_position(new_position: AdPosition) -> void:
	_ad_position = new_position
	if _ad_view:
		_ad_view.set_position(_ad_position)
		_log("Position updated")
		if Registry.safe_area and not _is_hidden:
			Registry.safe_area.update_ad_overlap(_ad_view)

#region Position Signals
func _on_top_pressed() -> void: _update_position(AdPosition.TOP)
func _on_bottom_pressed() -> void: _update_position(AdPosition.BOTTOM)
func _on_left_pressed() -> void: _update_position(AdPosition.LEFT)
func _on_right_pressed() -> void: _update_position(AdPosition.RIGHT)
func _on_top_left_pressed() -> void: _update_position(AdPosition.TOP_LEFT)
func _on_top_right_pressed() -> void: _update_position(AdPosition.TOP_RIGHT)
func _on_bottom_left_pressed() -> void: _update_position(AdPosition.BOTTOM_LEFT)
func _on_bottom_right_pressed() -> void: _update_position(AdPosition.BOTTOM_RIGHT)
func _on_center_pressed() -> void: _update_position(AdPosition.CENTER)
#endregion

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[Banner] " + message)
	else:
		print("[Banner] " + message)
