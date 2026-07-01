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

func _ready():
	$RespectSafeArea.connect(
		"value_changed", self,
		"_on_RespectSafeArea_value_changed"
	)

	$BannerSizeHBoxContainer/BannerSize.selected = (
		ad_mob_editor.ad_mob_settings.BANNER_SIZE.find(
			ad_mob_editor.ad_mob_settings.config.banner.size
		)
	)
	$RespectSafeArea.pressed = ad_mob_editor.ad_mob_settings.config.banner.respect_safe_area
	$BannerShowInstantly.pressed = ad_mob_editor.ad_mob_settings.config.banner.show_instantly
	$BannerOnTop.pressed = ad_mob_editor.ad_mob_settings.config.banner.position

func _on_BannerSize_item_selected(index):
	ad_mob_editor.ad_mob_settings.config.banner.size = (
		ad_mob_editor.ad_mob_settings.BANNER_SIZE[index]
	)

func _on_BannerShowInstantly_pressed():
	ad_mob_editor.ad_mob_settings.config.banner.show_instantly = $BannerShowInstantly.pressed

func _on_BannerOnTop_pressed():
	ad_mob_editor.ad_mob_settings.config.banner.position = int($BannerOnTop.pressed)

func _on_RespectSafeArea_value_changed(value : bool):
	ad_mob_editor.ad_mob_settings.config.banner.respect_safe_area = value
