tool
extends Control

onready var Enabled := $MiddleContainer/VBoxContainer/Enabled
onready var TestEuropeUserConsent := $MiddleContainer/VBoxContainer/TestEuropeUserConsent
onready var BannerShowInstantly := $MiddleContainer/VBoxContainer/BannerShowInstantly
onready var BannerSize := $MiddleContainer/VBoxContainer/BannerSizeHBoxContainer/BannerSize
onready var BannerOnTop := $MiddleContainer/VBoxContainer/BannerOnTop
onready var ChildDirectedTreatment := $MiddleContainer/VBoxContainer/ChildDirectedTreatment
onready var MaxAdContentRating := $MiddleContainer/VBoxContainer/MaxAdContentRating/Value

onready var Android = {
	"Banner" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/Android/BannerValue,
	"Interstitial" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/Android/InterstitialValue,
	"Rewarded" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/Android/RewardedValue,
	"RewardedInterstitial" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/Android/RewardedInterstitialValue
}
onready var iOS = {
	"Banner" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/iOS/BannerValue,
	"Interstitial" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/iOS/InterstitialValue,
	"Rewarded" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/iOS/RewardedValue,
	"RewardedInterstitial" : $MiddleContainer/VBoxContainer/UnitIds/TabContainer/iOS/RewardedInterstitialValue
}

onready var CurrentVersion := $BottomPanel/CurrentVersion

const BANNER_SIZE : Array = ["BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "ADAPTIVE", "SMART_BANNER"] 
const MAX_AD_RATING : Array = ["G", "PG", "T", "MA"]

const Settings = preload("res://addons/admob/src/utils/Settings.gd")
onready var SettingsConfig := Settings.new().config setget set_settings

var SaveLoad = preload("res://addons/admob/src/utils/SaveLoad.gd").new()

func set_settings(value):
	SettingsConfig = value
	SaveLoad.save_config(SettingsConfig)
	
func _ready():
	SaveLoad.load_config()
	var plugin_config_file := ConfigFile.new()
	#plugin_config_file.load("res://addons/admob/plugin.cfg")
	#CurrentVersion.text = "Version: " + plugin_config_file.get_value("plugin", "version")

	BannerSize.clear()
	MaxAdContentRating.clear()
	for banner_size in BANNER_SIZE:
		BannerSize.add_item(banner_size)
	for content_rating in MAX_AD_RATING:
		MaxAdContentRating.add_item(content_rating)

	Enabled.pressed = SettingsConfig.is_enabled
	TestEuropeUserConsent.pressed = SettingsConfig.is_test_europe_user_consent
	BannerShowInstantly.pressed = SettingsConfig.banner.show_instantly
	BannerSize.selected = BANNER_SIZE.find(SettingsConfig.banner.size)
	BannerOnTop.pressed = SettingsConfig.banner.position
	ChildDirectedTreatment.pressed = SettingsConfig.is_for_child_directed_treatment
	MaxAdContentRating.selected = MAX_AD_RATING.find(SettingsConfig.max_ad_content_rating)
	

	Android.Banner.text = SettingsConfig.unit_ids.banner.Android
	Android.Interstitial.text = SettingsConfig.unit_ids.interstitial.Android
	Android.Rewarded.text = SettingsConfig.unit_ids.rewarded.Android
	Android.RewardedInterstitial.text = SettingsConfig.unit_ids.rewarded_interstitial.Android

	iOS.Banner.text = SettingsConfig.unit_ids.banner.iOS
	iOS.Interstitial.text = SettingsConfig.unit_ids.interstitial.iOS
	iOS.Rewarded.text = SettingsConfig.unit_ids.rewarded.iOS
	iOS.RewardedInterstitial.text = SettingsConfig.unit_ids.rewarded_interstitial.iOS

func _on_Enabled_pressed():
	self.SettingsConfig.is_enabled = Enabled.pressed

func _on_TestEuropeUserConsent_pressed():
	self.SettingsConfig.is_test_europe_user_consent = TestEuropeUserConsent.pressed

func _on_BannerSize_item_selected(index):
	self.SettingsConfig.banner.size = BANNER_SIZE[index]

func _on_BannerOnTop_pressed():
	self.SettingsConfig.banner.position = int(BannerOnTop.pressed)

func _on_ChildDirectedTreatment_pressed():
	self.SettingsConfig.is_for_child_directed_treatment = ChildDirectedTreatment.pressed

func _on_MaxAdContentRating_item_selected(index):
	self.SettingsConfig.max_ad_content_rating = MAX_AD_RATING[index]

func _on_AndroidBanner_text_changed(new_text):
	self.SettingsConfig.unit_ids.banner.Android = new_text

func _on_AndroidInterstitial_text_changed(new_text):
	self.SettingsConfig.unit_ids.interstitial.Android = new_text

func _on_AndroidRewarded_text_changed(new_text):
	self.SettingsConfig.unit_ids.rewarded.Android = new_text

func _on_iOSBanner_text_changed(new_text):
	self.SettingsConfig.unit_ids.banner.iOS = new_text

func _on_iOSInterstitial_text_changed(new_text):
	self.SettingsConfig.unit_ids.interstitial.iOS = new_text

func _on_iOSRewarded_text_changed(new_text):
	self.SettingsConfig.unit_ids.rewarded.iOS = new_text

func _on_iOSRewardedInterstitial_text_changed(new_text):
	self.SettingsConfig.unit_ids.rewarded_interstitial.iOS = new_text

func _on_AndroidRewardedInterstitial_text_changed(new_text):
	self.SettingsConfig.unit_ids.rewarded_interstitial.Android = new_text

func _on_BannerShowInstantly_pressed():
	self.SettingsConfig.banner.show_instantly = BannerShowInstantly.pressed

func _on_InstallationTutorial_pressed():
	OS.shell_open("https://github.com/Poing-Studios/Godot-AdMob-Android-iOS#installation") 

