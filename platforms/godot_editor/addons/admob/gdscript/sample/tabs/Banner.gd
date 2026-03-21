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
var _ad_position := AdPosition.Values.TOP

@onready var _load_button: Button = $BannerActions/LoadBanner
@onready var _destroy_button: Button = $BannerActions/DestroyBanner
@onready var _show_button: Button = $BannerActions/ShowBanner
@onready var _hide_button: Button = $BannerActions/HideBanner
@onready var _get_size_button: Button = $BannerActions/GetSize

func _ready() -> void:
	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
	_ad_listener.on_ad_clicked = _on_ad_clicked
	_ad_listener.on_ad_closed = _on_ad_closed
	_ad_listener.on_ad_impression = _on_ad_impression
	_ad_listener.on_ad_loaded = _on_ad_loaded
	_ad_listener.on_ad_opened = _on_ad_opened
	_update_ui_state(false)

func _update_ui_state(is_loaded: bool) -> void:
	_load_button.disabled = is_loaded
	_destroy_button.disabled = !is_loaded
	_show_button.disabled = !is_loaded
	_hide_button.disabled = !is_loaded
	_get_size_button.disabled = !is_loaded

func _on_load_banner_pressed() -> void:
	if _ad_view:
		_ad_view.destroy()
	
	_update_ui_state(false)
	_log("Loading adaptive banner...")
	
	var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	_ad_view = AdView.new("ca-app-pub-3940256099942544/2934735716", ad_size, _ad_position)
	_ad_view.ad_listener = _ad_listener
	_ad_view.load_ad(AdRequest.new())

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
		_ad_view.show()
		_log("Banner shown")
		if Registry.safe_area:
			Registry.safe_area.update_ad_overlap(_ad_view)

func _on_hide_banner_pressed() -> void:
	if _ad_view:
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
	if Registry.safe_area:
		Registry.safe_area.update_ad_overlap(_ad_view)

func _on_ad_opened() -> void:
	_log("Ad opened")
#endregion

func _update_position(new_position: int) -> void:
	_ad_position = new_position
	if _ad_view:
		_on_load_banner_pressed()

#region Position Signals
func _on_top_pressed() -> void: _update_position(AdPosition.Values.TOP)
func _on_bottom_pressed() -> void: _update_position(AdPosition.Values.BOTTOM)
func _on_left_pressed() -> void: _update_position(AdPosition.Values.LEFT)
func _on_right_pressed() -> void: _update_position(AdPosition.Values.RIGHT)
func _on_top_left_pressed() -> void: _update_position(AdPosition.Values.TOP_LEFT)
func _on_top_right_pressed() -> void: _update_position(AdPosition.Values.TOP_RIGHT)
func _on_bottom_left_pressed() -> void: _update_position(AdPosition.Values.BOTTOM_LEFT)
func _on_bottom_right_pressed() -> void: _update_position(AdPosition.Values.BOTTOM_RIGHT)
func _on_center_pressed() -> void: _update_position(AdPosition.Values.CENTER)
#endregion

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[Banner] " + message)
	else:
		print("[Banner] " + message)
