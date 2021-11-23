tool
extends VBoxContainer

onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready():
	$TestEuropeUserConsent.pressed = AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent

func _on_TestEuropeUserConsent_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent = $TestEuropeUserConsent.pressed
