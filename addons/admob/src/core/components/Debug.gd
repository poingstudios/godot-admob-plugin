tool
extends VBoxContainer

onready var AdMobEditor : Control = find_parent("AdMobEditor")
onready var DebugOnRelease : Control = $TabContainer/Release/DebugOnRelease
onready var IsReal : Control = $TabContainer/Release/IsReal
onready var TestEuropeUserConsent : Control = $TabContainer/General/TestEuropeUserConsent

func _ready():
	DebugOnRelease.pressed = AdMobEditor.AdMobSettings.config.debug.is_debug_on_release
	IsReal.pressed = AdMobEditor.AdMobSettings.config.debug.is_real
	TestEuropeUserConsent.pressed = AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent

	IsReal.disabled = not DebugOnRelease.pressed


func _on_DebugOnRelease_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_debug_on_release = DebugOnRelease.pressed
	if DebugOnRelease.pressed:
		IsReal.disabled = false
	else:
		IsReal.disabled = true

func _on_IsReal_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_real = IsReal.pressed

func _on_TestEuropeUserConsent_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent = TestEuropeUserConsent.pressed

