tool
extends "res://addons/admob/scripts/GodotAdMobBase.gd"

const FILE_PATH = "res://addons/admob/config/settings.json"

var config : Dictionary = {
	"banner" : {
		"size" : 0,
		"position" : 0,
	},
	"max_ad_content_rating": 0,
	"is_enabled" : true,
	"is_real" : false,
	"is_test_europe_user_consent" : true,
	"is_for_child_directed_treatment" : true,
	"unit_ids" : {
		"banner": {
			"iOS" : "ca-app-pub-3940256099942544/2934735716",
			"Android" : "ca-app-pub-3940256099942544/6300978111",
		},
		"interstitial" : {
			"iOS" : "ca-app-pub-3940256099942544/4411468910",
			"Android" : "ca-app-pub-3940256099942544/1033173712",
		},
		"rewarded" : {
			"iOS" : "ca-app-pub-3940256099942544/1712485313",
			"Android" : "ca-app-pub-3940256099942544/5224354917",
		},
		"native" : {
			"iOS" : "",
			"Android" : "ca-app-pub-3940256099942544/2247696110",
		}
	}
}

onready var BannerSize := $VBoxContainer/BannerSize
onready var MaxAdContentRating := $VBoxContainer/MaxAdContentRating
onready var Enabled := $VBoxContainer/Enabled
onready var Real := $VBoxContainer/Real
onready var TestEuropeUserConsent := $VBoxContainer/TestEuropeUserConsent
onready var BannerOnTop := $VBoxContainer/BannerOnTop
onready var ChildDirectedTreatment := $VBoxContainer/ChildDirectedTreatment
onready var Android = {
	"Banner" : $VBoxContainer/UnitIds/Android/VBoxContainer/Banner/Value,
	"Interstitial" : $VBoxContainer/UnitIds/Android/VBoxContainer/Interstitial/Value,
	"Rewarded" : $VBoxContainer/UnitIds/Android/VBoxContainer/Rewarded/Value
}
onready var iOS = {
	"Banner" : $VBoxContainer/UnitIds/iOS/VBoxContainer/Banner/Value,
	"Interstitial" : $VBoxContainer/UnitIds/iOS/VBoxContainer/Interstitial/Value,
	"Rewarded" : $VBoxContainer/UnitIds/iOS/VBoxContainer/Rewarded/Value
}

func _ready():
	BannerSize.clear()
	MaxAdContentRating.clear()
	for banner_size in BANNER_SIZE:
		BannerSize.add_item(banner_size)
	for content_rating in MAX_AD_RATING:
		MaxAdContentRating.add_item(content_rating)

	var content_file = load_config()
	
	Enabled.pressed = content_file.is_enabled if content_file.is_enabled != null else config.is_enabled
	Real.pressed = content_file.is_real
	TestEuropeUserConsent.pressed = content_file.is_test_europe_user_consent
	BannerSize.selected = content_file.banner.size
	BannerOnTop.pressed = content_file.banner.position
	ChildDirectedTreatment.pressed = content_file.is_for_child_directed_treatment
	MaxAdContentRating.selected = content_file.max_ad_content_rating

	Android.Banner.text = content_file.unit_ids.banner.Android
	Android.Interstitial.text = content_file.unit_ids.interstitial.Android
	Android.Rewarded.text = content_file.unit_ids.rewarded.Android

	iOS.Banner.text = content_file.unit_ids.banner.iOS
	iOS.Interstitial.text = content_file.unit_ids.interstitial.iOS
	iOS.Rewarded.text = content_file.unit_ids.rewarded.iOS

func save_config(content):
	var file = File.new()
	file.open(FILE_PATH, File.WRITE)
	file.store_string(to_json(content))
	file.close()

func load_config() -> Dictionary:
	var config_file := File.new()
	if config_file.file_exists(FILE_PATH):
		config_file.open(FILE_PATH, File.READ)
		return parse_json(config_file.get_as_text())
	else:
		save_config(config)
		return config


func _on_Enabled_pressed():
	var content = load_config()
	content.is_enabled = Enabled.pressed
	save_config(content)


func _on_Real_pressed():
	var content = load_config()
	content.is_real = Real.pressed
	save_config(content)


func _on_TestEuropeUserConsent_pressed():
	var content = load_config()
	content.is_test_europe_user_consent = TestEuropeUserConsent.pressed
	save_config(content)


func _on_BannerSize_item_selected(index):
	var content = load_config()
	content.banner.size = index
	save_config(content)

func _on_BannerOnTop_pressed():
	var content = load_config()
	content.banner.position = int(BannerOnTop.pressed)
	save_config(content)


func _on_ChildDirectedTreatment_pressed():
	var content = load_config()
	content.is_for_child_directed_treatment = ChildDirectedTreatment.pressed
	save_config(content)


func _on_MaxAdContentRating_item_selected(index):
	var content = load_config()
	content.max_ad_content_rating = index
	save_config(content)


func _on_AndroidBanner_text_changed(new_text):
	var content = load_config()
	content.unit_ids.banner.Android = new_text
	save_config(content)


func _on_AndroidInterstitial_text_changed(new_text):
	var content = load_config()
	content.unit_ids.interstitial.Android = new_text
	save_config(content)


func _on_AndroidRewarded_text_changed(new_text):
	var content = load_config()
	content.unit_ids.rewarded.Android = new_text
	save_config(content)


func _on_iOSBanner_text_changed(new_text):
	var content = load_config()
	content.unit_ids.banner.iOS = new_text
	save_config(content)


func _on_iOSInterstitial_text_changed(new_text):
	var content = load_config()
	content.unit_ids.interstitial.iOS = new_text
	save_config(content)


func _on_iOSRewarded_text_changed(new_text):
	var content = load_config()
	content.unit_ids.rewarded.iOS = new_text
	print(content)
	save_config(content)
