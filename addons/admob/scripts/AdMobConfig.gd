tool
extends Control

onready var config_file := File.new()

func _ready():
	$VBoxContainer/BannerSize.add_item("BANNER")
	$VBoxContainer/BannerSize.add_item("MEDIUM_RECTANGLE")
	$VBoxContainer/BannerSize.add_item("FULL_BANNER")
	$VBoxContainer/BannerSize.add_item("LEADERBOARD")
	$VBoxContainer/BannerSize.add_item("SMART_BANNER")
	$VBoxContainer/MaxAdContentRating.add_item("G")
	$VBoxContainer/MaxAdContentRating.add_item("PG")
	$VBoxContainer/MaxAdContentRating.add_item("T")
	$VBoxContainer/MaxAdContentRating.add_item("MA")

	var content_file = load_config()
	$VBoxContainer/Enabled.pressed = content_file["Enabled"]
	$VBoxContainer/Real.pressed = content_file["Real"]
	$VBoxContainer/TestEuropeUserConsent.pressed = content_file["TestEuropeUserConsent"]
	$VBoxContainer/BannerSize.selected = content_file["BannerSize"]

	$VBoxContainer/BannerOnTop.pressed = content_file["BannerOnTop"]
	$VBoxContainer/ChildDirectedTreatment.pressed = content_file["ChildDirectedTreatment"]
	$VBoxContainer/MaxAdContentRating.selected = content_file["MaxAdContentRating"]
	$VBoxContainer/UnitIds/Android/VBoxContainer/Banner/Value.text = content_file["AndroidBanner"]
	$VBoxContainer/UnitIds/Android/VBoxContainer/Interstitial/Value.text = content_file["AndroidInterstitial"]
	$VBoxContainer/UnitIds/Android/VBoxContainer/Rewarded/Value.text = content_file["AndroidRewarded"]
	$VBoxContainer/UnitIds/iOS/VBoxContainer/Banner/Value.text = content_file["iOSBanner"]
	$VBoxContainer/UnitIds/iOS/VBoxContainer/Interstitial/Value.text = content_file["iOSInterstitial"]
	$VBoxContainer/UnitIds/iOS/VBoxContainer/Rewarded/Value.text = content_file["iOSRewarded"]

func save_config(content : Dictionary):
	config_file.open("res://addons/admob/config/settings.json", File.WRITE)
	config_file.store_string(to_json(content))
	config_file.close()

func load_config() -> Dictionary:
	config_file.open("res://addons/admob/config/settings.json", File.READ)
	return parse_json(config_file.get_as_text())
	

func _on_Enabled_pressed():
	var content = load_config()
	content["Enabled"] = $VBoxContainer/Enabled.pressed
	save_config(content)


func _on_Real_pressed():
	var content = load_config()
	content["Real"] = $VBoxContainer/Real.pressed
	save_config(content)


func _on_TestEuropeUserConsent_pressed():
	var content = load_config()
	content["TestEuropeUserConsent"] = $VBoxContainer/TestEuropeUserConsent.pressed
	save_config(content)


func _on_BannerSize_item_selected(index):
	var content = load_config()
	content["BannerSize"] = index
	save_config(content)

func _on_BannerOnTop_pressed():
	var content = load_config()
	content["BannerOnTop"] = $VBoxContainer/BannerOnTop.pressed
	save_config(content)


func _on_ChildDirectedTreatment_pressed():
	var content = load_config()
	content["ChildDirectedTreatment"] = $VBoxContainer/ChildDirectedTreatment.pressed
	save_config(content)


func _on_MaxAdContentRating_item_selected(index):
	var content = load_config()
	content["MaxAdContentRating"] = index
	save_config(content)


func _on_AndroidBanner_text_changed(new_text):
	var content = load_config()
	content["AndroidBanner"] = new_text
	save_config(content)


func _on_AndroidInterstitial_text_changed(new_text):
	var content = load_config()
	content["AndroidInterstitial"] = new_text
	save_config(content)


func _on_AndroidRewarded_text_changed(new_text):
	var content = load_config()
	content["AndroidRewarded"] = new_text
	save_config(content)


func _on_iOSBanner_text_changed(new_text):
	var content = load_config()
	content["iOSBanner"] = new_text
	save_config(content)


func _on_iOSInterstitial_text_changed(new_text):
	var content = load_config()
	content["iOSInterstitial"] = new_text
	save_config(content)


func _on_iOSRewarded_text_changed(new_text):
	var content = load_config()
	content["iOSRewarded"] = new_text
	save_config(content)
