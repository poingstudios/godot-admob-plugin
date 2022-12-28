@tool
extends VBoxContainer

@onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready():
	for item in AdMobEditor.AdMobSettings.MAX_AD_RATING:
		$MaxAdContentRating/Value.add_item(item)

	$ChildDirectedTreatment.button_pressed = AdMobEditor.AdMobSettings.config.general.is_for_child_directed_treatment
	$MaxAdContentRating/Value.selected = AdMobEditor.AdMobSettings.MAX_AD_RATING.find(AdMobEditor.AdMobSettings.config.general.max_ad_content_rating)


func _on_ChildDirectedTreatment_pressed():
	AdMobEditor.AdMobSettings.config.general.is_for_child_directed_treatment = $ChildDirectedTreatment.button_pressed

func _on_MaxAdContentRating_item_selected(index):
	AdMobEditor.AdMobSettings.config.general.max_ad_content_rating = AdMobEditor.AdMobSettings.MAX_AD_RATING[index]
