tool
extends "util/Variables.gd"

onready var CurrentVersion := $PanelContainer/VBoxContainer/TopPanel/CurrentVersion
onready var BannerSize := $PanelContainer/VBoxContainer/BannerSizeHBoxContainer/BannerSize
onready var MaxAdContentRating := $PanelContainer/VBoxContainer/MaxAdContentRating/Value
onready var Enabled := $PanelContainer/VBoxContainer/Enabled
onready var Real := $PanelContainer/VBoxContainer/Real
onready var TestEuropeUserConsent := $PanelContainer/VBoxContainer/TestEuropeUserConsent
onready var BannerShowInstantly := $PanelContainer/VBoxContainer/BannerShowInstantly
onready var BannerOnTop := $PanelContainer/VBoxContainer/BannerOnTop
onready var ChildDirectedTreatment := $PanelContainer/VBoxContainer/ChildDirectedTreatment
onready var Android = {
	"Banner" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/Android/Banner,
	"Interstitial" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/Android/Interstitial,
	"Rewarded" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/Android/Rewarded,
	"RewardedInterstitial" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/Android/RewardedInterstitial
}
onready var iOS = {
	"Banner" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/iOS/Banner,
	"Interstitial" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/iOS/Interstitial,
	"Rewarded" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/iOS/Rewarded,
	"RewardedInterstitial" : $PanelContainer/VBoxContainer/UnitIds/TabContainer/iOS/RewardedInterstitial
}

func _ready():
	var plugin_config_file := ConfigFile.new()
	plugin_config_file.load("res://addons/admob/plugin.cfg")
	CurrentVersion.text = "Version: " + plugin_config_file.get_value("plugin", "version")

	load_config()
	BannerSize.clear()
	MaxAdContentRating.clear()
	for banner_size in BANNER_SIZE:
		BannerSize.add_item(banner_size)
	for content_rating in MAX_AD_RATING:
		MaxAdContentRating.add_item(content_rating)
	
	Enabled.pressed = config.is_enabled
	Real.pressed = config.is_real
	TestEuropeUserConsent.pressed = config.is_test_europe_user_consent
	BannerShowInstantly.pressed = config.banner.show_instantly
	BannerSize.selected = config.banner.size
	BannerOnTop.pressed = config.banner.position
	ChildDirectedTreatment.pressed = config.is_for_child_directed_treatment
	MaxAdContentRating.selected = config.max_ad_content_rating
	Android.Banner.text = config.unit_ids.banner.Android
	Android.Interstitial.text = config.unit_ids.interstitial.Android
	Android.Rewarded.text = config.unit_ids.rewarded.Android
	Android.RewardedInterstitial.text = config.unit_ids.rewarded_interstitial.Android

	iOS.Banner.text = config.unit_ids.banner.iOS
	iOS.Interstitial.text = config.unit_ids.interstitial.iOS
	iOS.Rewarded.text = config.unit_ids.rewarded.iOS
	iOS.RewardedInterstitial.text = config.unit_ids.rewarded_interstitial.iOS

func _on_Enabled_pressed():
	config.is_enabled = Enabled.pressed
	save_config()


func _on_Real_pressed():
	config.is_real = Real.pressed
	save_config()


func _on_TestEuropeUserConsent_pressed():
	config.is_test_europe_user_consent = TestEuropeUserConsent.pressed
	save_config()


func _on_BannerSize_item_selected(index):
	config.banner.size = index
	save_config()

func _on_BannerOnTop_pressed():
	config.banner.position = int(BannerOnTop.pressed)
	save_config()


func _on_ChildDirectedTreatment_pressed():
	config.is_for_child_directed_treatment = ChildDirectedTreatment.pressed
	save_config()


func _on_MaxAdContentRating_item_selected(index):
	config.max_ad_content_rating = index
	save_config()


func _on_AndroidBanner_text_changed(new_text):
	config.unit_ids.banner.Android = new_text
	save_config()


func _on_AndroidInterstitial_text_changed(new_text):
	config.unit_ids.interstitial.Android = new_text
	save_config()


func _on_AndroidRewarded_text_changed(new_text):
	config.unit_ids.rewarded.Android = new_text
	save_config()


func _on_iOSBanner_text_changed(new_text):
	config.unit_ids.banner.iOS = new_text
	save_config()


func _on_iOSInterstitial_text_changed(new_text):
	config.unit_ids.interstitial.iOS = new_text
	save_config()


func _on_iOSRewarded_text_changed(new_text):
	config.unit_ids.rewarded.iOS = new_text
	save_config()

func _on_iOSRewardedInterstitial_text_changed(new_text):
	config.unit_ids.rewarded_interstitial.iOS = new_text
	save_config()


func _on_AndroidRewardedInterstitial_text_changed(new_text):
	config.unit_ids.rewarded_interstitial.Android = new_text
	save_config()

func _on_InstallationTutorial_pressed():
	OS.shell_open("https://github.com/Poing-Studios/Godot-AdMob-Android-iOS#installation") 



func _on_BannerShowInstantly_pressed():
	config.banner.show_instantly = BannerShowInstantly.pressed
	save_config()
