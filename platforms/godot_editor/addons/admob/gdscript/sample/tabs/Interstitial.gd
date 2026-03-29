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

var _interstitial_ad: InterstitialAd
var _load_callback := InterstitialAdLoadCallback.new()
var _content_callback := FullScreenContentCallback.new()

@onready var _load_button: Button = $Load
@onready var _show_button: Button = $Show
@onready var _destroy_button: Button = $Destroy

func _ready() -> void:
	super()
	_load_callback.on_ad_failed_to_load = _on_ad_failed_to_load
	_load_callback.on_ad_loaded = _on_ad_loaded

	_content_callback.on_ad_clicked = func() -> void: _log("Ad clicked")
	_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		_log("Ad dismissed")
		_destroy_ad()
		
	_content_callback.on_ad_failed_to_show_full_screen_content = func(err: AdError) -> void:
		_log("Failed to show: " + err.message)
	_content_callback.on_ad_impression = func() -> void: _log("Impression recorded")
	_content_callback.on_ad_showed_full_screen_content = func() -> void: _log("Ad showed")
	
	_update_ui_state(false)

func _update_ui_state(is_loaded: bool) -> void:
	_load_button.disabled = is_loaded
	_show_button.disabled = !is_loaded
	_destroy_button.disabled = !is_loaded

func _on_load_pressed() -> void:
	_log("Loading interstitial...")
	var unit_id := "ca-app-pub-3940256099942544/1033173712" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/4411468910"
	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), _load_callback)

func _on_show_pressed() -> void:
	if _interstitial_ad:
		_log("Showing interstitial ad...")
		_interstitial_ad.show()

func _on_destroy_pressed() -> void:
	_destroy_ad()

func _destroy_ad() -> void:
	if _interstitial_ad:
		_interstitial_ad.destroy()
		_interstitial_ad = null
		_log("Ad destroyed")
		_update_ui_state(false)

#region Callbacks
func _on_ad_failed_to_load(error: LoadAdError) -> void:
	_log("Failed to load: " + error.message)
	_update_ui_state(false)
	
func _on_ad_loaded(ad: InterstitialAd) -> void:
	_log("Ad loaded successfully (UID: %s)" % str(ad._uid))
	ad.full_screen_content_callback = _content_callback
	ad.on_ad_paid = func(ad_value: AdValue) -> void:
		var ad_source_name := "N/A"
		var response_info := ad.get_response_info()
		if response_info:
			if response_info.loaded_adapter_response_info:
				ad_source_name = response_info.loaded_adapter_response_info.ad_source_name
			else:
				ad_source_name = "None"
		_log("Ad paid: %f %s (precision: %d, source: %s)" % [ad_value.value_micros / 1000000.0, ad_value.currency_code, ad_value.precision, ad_source_name])
	_interstitial_ad = ad
	_update_ui_state(true)
#endregion

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[Interstitial] " + message)
	else:
		print("[Interstitial] " + message)
