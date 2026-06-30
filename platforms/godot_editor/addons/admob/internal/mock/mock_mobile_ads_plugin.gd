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

signal on_initialization_complete(initialization_status_dictionary: Dictionary)
signal on_ad_inspector_closed(error_dictionary: Dictionary)

var _is_initialized := false
var _volume := 1.0
var _muted := false
var _publisher_first_party_id_enabled := true
var _request_configuration := {}
var _gad_has_consent_for_cookies := true

func initialize() -> void:
	if _is_initialized:
		return
	_is_initialized = true
	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		on_initialization_complete.emit({
			"MockAdapter": {
				"latency": 42,
				"initializationState": 1,
				"description": "Mock Adapter Ready"
			}
		})
	)

func get_initialization_status() -> Dictionary:
	return {
		"com.google.android.gms.ads.MobileAds": {
			"initializationState": 1, # READY
			"description": "Mock Ads Ready",
			"latency": 500
		}
	}

func set_request_configuration(request_configuration_dictionary: Dictionary, _test_device_ids: Array) -> void:
	_request_configuration = request_configuration_dictionary

func set_ios_app_pause_on_background(_pause: bool) -> void:
	pass

func set_app_volume(volume: float) -> void:
	_volume = volume

func set_app_muted(muted: bool) -> void:
	_muted = muted

func set_publisher_first_party_id_enabled(enabled: bool) -> void:
	_publisher_first_party_id_enabled = enabled

func set_gad_has_consent_for_cookies(enabled: bool) -> void:
	_gad_has_consent_for_cookies = enabled

func get_gad_has_consent_for_cookies() -> bool:
	return _gad_has_consent_for_cookies

func disable_sdk_crash_reporting() -> void:
	pass

func get_version() -> String:
	return "1.0.0-mock"

func get_platform_version() -> String:
	return "1.0.0-mock"

func open_ad_inspector() -> void:
	var timer := (Engine.get_main_loop() as SceneTree).create_timer(0.5)
	timer.timeout.connect(func():
		on_ad_inspector_closed.emit({})
	)
