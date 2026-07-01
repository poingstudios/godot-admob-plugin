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
