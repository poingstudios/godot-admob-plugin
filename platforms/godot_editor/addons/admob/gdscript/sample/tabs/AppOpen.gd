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

var _app_open_ad: AppOpenAd
var _load_callback := AppOpenAdLoadCallback.new()
var _content_callback := FullScreenContentCallback.new()
var _load_time: int = 0

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
	_log("Loading app open ad...")
	var unit_id := "ca-app-pub-3940256099942544/9257395921" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/5575463023"
	AppOpenAdLoader.new().load(unit_id, AdRequest.new(), _load_callback)

func _on_show_pressed() -> void:
	if _app_open_ad:
		if _is_ad_expired():
			_log("Ad expired (more than 4 hours). Destroying and please load again.")
			_destroy_ad()
		else:
			_log("Showing app open ad...")
			_app_open_ad.show()

func _is_ad_expired() -> bool:
	var now := Time.get_unix_time_from_system()
	var elapsed_seconds := now - _load_time
	var four_hours_in_seconds := 4 * 60 * 60
	return elapsed_seconds >= four_hours_in_seconds

func _on_destroy_pressed() -> void:
	_destroy_ad()

func _destroy_ad() -> void:
	if _app_open_ad:
		_app_open_ad.destroy()
		_app_open_ad = null
		_load_time = 0
		_log("Ad destroyed")
		_update_ui_state(false)


func _on_ad_failed_to_load(error: LoadAdError) -> void:
	_log("Failed to load: " + error.message)
	_update_ui_state(false)
	
func _on_ad_loaded(ad: AppOpenAd) -> void:
	_log("Ad loaded successfully")
	_log(" - Ad Unit ID: " + ad.get_ad_unit_id())
	
	var response_info := ad.get_response_info()
	if response_info:
		_log(" - Response ID: " + response_info.response_id)
		_log(" - Adapter: " + response_info.mediation_adapter_class_name)
	
	ad.full_screen_content_callback = _content_callback
	ad.on_ad_paid = func(ad_value: AdValue) -> void:
		var ad_source_name := "N/A"
		var paid_response_info := ad.get_response_info()
		if paid_response_info:
			if paid_response_info.loaded_adapter_response_info:
				ad_source_name = paid_response_info.loaded_adapter_response_info.ad_source_name
			else:
				ad_source_name = "None"
		_log("Ad paid: %f %s (precision: %d, source: %s)" % [ad_value.value_micros / 1000000.0, ad_value.currency_code, ad_value.precision, ad_source_name])
	
	_app_open_ad = ad
	_load_time = Time.get_unix_time_from_system()
	_update_ui_state(true)

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[App Open] " + message)
	else:
		print("[App Open] " + message)
