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

tool
extends VBoxContainer

onready var ad_mob_editor : Control = find_parent("AdMobEditor")
onready var debug_on_release : Control = $TabContainer/Release/DebugOnRelease
onready var is_real : Control = $TabContainer/Release/IsReal
onready var test_europe_user_consent : Control = $TabContainer/General/TestEuropeUserConsent

func _ready():
	var debug_config = ad_mob_editor.ad_mob_settings.config.debug
	debug_on_release.pressed = debug_config.is_debug_on_release
	is_real.pressed = debug_config.is_real
	test_europe_user_consent.pressed = (
		debug_config.is_test_europe_user_consent
	)

	is_real.disabled = not debug_on_release.pressed


func _on_DebugOnRelease_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_debug_on_release = debug_on_release.pressed
	if debug_on_release.pressed:
		is_real.disabled = false
	else:
		is_real.disabled = true

func _on_IsReal_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_real = is_real.pressed

func _on_TestEuropeUserConsent_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_test_europe_user_consent = (
		test_europe_user_consent.pressed
	)
