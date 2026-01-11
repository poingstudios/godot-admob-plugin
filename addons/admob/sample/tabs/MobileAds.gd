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

@onready var _ios_pause_check: CheckButton = $iOSAppPause
@onready var _mute_music_check: CheckButton = $MuteMusic
@onready var _music_player: AudioStreamPlayer = $MusicPlayer

func _on_set_ios_app_pause_on_background_button_pressed() -> void:
	var is_enabled := _ios_pause_check.button_pressed
	_log("Setting iOS App Pause on Background: " + str(is_enabled))
	MobileAds.set_ios_app_pause_on_background(is_enabled)

func _on_mute_music_pressed() -> void:
	var is_muted := _mute_music_check.button_pressed
	_log("Muting music: " + str(is_muted))
	_music_player.stream_paused = is_muted

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[MobileAds] " + message)
	else:
		print("[MobileAds] " + message)
