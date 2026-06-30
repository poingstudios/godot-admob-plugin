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

@onready var _ios_pause_check: CheckButton = $iOSAppPause
@onready var _mute_music_check: CheckButton = $MuteMusic
@onready var _music_player: AudioStreamPlayer = $MusicPlayer
@onready var _ad_volume_slider: HSlider = $AdVolumeCard/AdVolumeContainer/AdVolumeSlider
@onready var _consent_cookies_check: CheckButton = $ConsentCookies
@onready var _ad_muted_check: CheckButton = $AdMuted
@onready var _language_button: OptionButton = %LanguageButton



func _ready() -> void:
	_consent_cookies_check.set_pressed_no_signal(MobileAds.get_gad_has_consent_for_cookies())

	_language_button.add_item("English", 0)
	_language_button.set_item_metadata(0, "en")
	_language_button.add_item("Português (Brasil)", 1)
	_language_button.set_item_metadata(1, "pt_BR")
	_language_button.add_item("Español", 2)
	_language_button.set_item_metadata(2, "es")
	_language_button.add_item("简体中文", 3)
	_language_button.set_item_metadata(3, "zh_CN")
	_language_button.add_item("日本語", 4)
	_language_button.set_item_metadata(4, "ja")

	var current_locale := TranslationServer.get_locale()
	var config := ConfigFile.new()
	if config.load(Registry.SETTINGS_PATH) == OK:
		current_locale = config.get_value(Registry.LOCALIZATION_SECTION, Registry.LOCALE_KEY, current_locale) as String

	if current_locale.begins_with("pt"):
		_language_button.selected = 1
	elif current_locale.begins_with("es"):
		_language_button.selected = 2
	elif current_locale.begins_with("zh"):
		_language_button.selected = 3
	elif current_locale.begins_with("ja"):
		_language_button.selected = 4
	else:
		_language_button.selected = 0
	_language_button.item_selected.connect(_on_language_selected)


func _on_language_selected(index: int) -> void:
	var locale := _language_button.get_item_metadata(index) as String
	_log("Changing language to: " + locale)
	TranslationServer.set_locale(locale)

	var config := ConfigFile.new()
	config.load(Registry.SETTINGS_PATH)
	config.set_value(Registry.LOCALIZATION_SECTION, Registry.LOCALE_KEY, locale)
	config.save(Registry.SETTINGS_PATH)


func _on_get_initialization_status_pressed() -> void:
	var status := MobileAds.get_initialization_status()
	if status:
		_log_adapter_status(status)


func _log_adapter_status(status: InitializationStatus) -> void:
	for adapter_name in status.adapter_status_map:
		var adapter_status: AdapterStatus = status.adapter_status_map[adapter_name]
		var info := (
			"[%s] State: %d | Latency: %dms | Desc: %s"
			% [
				adapter_name,
				adapter_status.initialization_state,
				adapter_status.latency,
				adapter_status.description
			]
		)
		_log(info)


func _on_set_ios_app_pause_on_background_button_pressed(is_enabled: bool) -> void:
	_log("Setting iOS App Pause on Background: " + str(is_enabled))
	MobileAds.set_ios_app_pause_on_background(is_enabled)


func _on_mute_music_pressed(is_muted: bool) -> void:
	_log("Muting music: " + str(is_muted))
	_music_player.stream_paused = is_muted


func _on_ad_volume_changed(value: float) -> void:
	_log("Setting ad volume: " + str(value))
	MobileAds.set_app_volume(value)


func _on_consent_cookies_toggled(button_pressed: bool) -> void:
	_log("Setting consent for cookies: " + str(button_pressed))
	MobileAds.set_gad_has_consent_for_cookies(button_pressed)


func _on_ad_muted_pressed(is_muted: bool) -> void:
	_log("Muting ads: " + str(is_muted))
	MobileAds.set_app_muted(is_muted)


func _on_open_ad_inspector_pressed() -> void:
	_log("Opening Ad Inspector...")
	var listener := AdInspectorClosedListener.new()
	listener.on_ad_inspector_closed = func(error: Dictionary):
		if error.is_empty():
			_log("Ad Inspector closed. Result: OK")
		else:
			_log("Ad Inspector closed. Error code: %d | message: %s | domain: %s" % [
				error.get("code", -1),
				error.get("message", ""),
				error.get("domain", "")
			])
	MobileAds.open_ad_inspector(listener)


func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[MobileAds] " + message)
	else:
		print("[MobileAds] " + message)
