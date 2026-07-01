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
	var general = ad_mob_editor.ad_mob_settings.config.general
	$ChildDirectedTreatment.pressed = (
		general.is_for_child_directed_treatment
	)
	$MaxAdContentRating/Value.selected = (
		ad_mob_editor.ad_mob_settings.MAX_AD_RATING.find(
			general.max_ad_content_rating
		)
	)


func _on_ChildDirectedTreatment_pressed():
	ad_mob_editor.ad_mob_settings.config.general.is_for_child_directed_treatment = (
		$ChildDirectedTreatment.pressed
	)

func _on_MaxAdContentRating_item_selected(index):
	ad_mob_editor.ad_mob_settings.config.general.max_ad_content_rating = (
		ad_mob_editor.ad_mob_settings.MAX_AD_RATING[index]
	)
