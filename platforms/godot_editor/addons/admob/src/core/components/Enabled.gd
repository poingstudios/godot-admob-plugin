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
extends CheckBox

onready var ad_mob_editor : Control = find_parent("AdMobEditor")

func _ready() -> void:
	pressed = ad_mob_editor.ad_mob_settings.config.general.is_enabled


func _on_Enabled_pressed():
	if not pressed:
		pressed = true
		$ConfirmationDialog.show()
	else:
		ad_mob_editor.ad_mob_settings.config.general.is_enabled = pressed


func _on_ConfirmationDialog_confirmed() -> void:
	pressed = false
	ad_mob_editor.ad_mob_settings.config.general.is_enabled = pressed
