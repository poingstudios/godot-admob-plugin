tool
extends VBoxContainer

onready var AdMobEditor : Control = find_parent("AdMobEditor")
onready var config_dictionary : Dictionary = AdMobEditor.AdMobSettings.config.general


func _ready():
	$Enabled.pressed = config_dictionary.is_enabled
	$TestEuropeUserConsent.pressed = config_dictionary.is_test_europe_user_consent
	$ChildDirectedTreatment.pressed = config_dictionary.is_for_child_directed_treatment
	$MaxAdContentRating/Value.selected = AdMobEditor.AdMobSettings.MAX_AD_RATING.find(config_dictionary.max_ad_content_rating)

func _on_Enabled_pressed():
	config_dictionary.is_enabled = $Enabled.pressed

func _on_TestEuropeUserConsent_pressed():
	config_dictionary.is_test_europe_user_consent = $TestEuropeUserConsent.pressed

func _on_ChildDirectedTreatment_pressed():
	config_dictionary.is_for_child_directed_treatment = $ChildDirectedTreatment.pressed

func _on_MaxAdContentRating_item_selected(index):
	config_dictionary.max_ad_content_rating = AdMobEditor.AdMobSettings.MAX_AD_RATING[index]
