@tool
extends VBoxContainer

@onready var AdMobEditor : Control = find_parent("AdMobEditor")
@onready var DebugOnRelease : Control = $TabContainer/Release/DebugOnRelease
@onready var IsReal : Control = $TabContainer/Release/IsReal
@onready var TestEuropeUserConsent : Control = $TabContainer/General/TestEuropeUserConsent

func _ready():
	DebugOnRelease.button_pressed = AdMobEditor.AdMobSettings.config.debug.is_debug_on_release
	IsReal.button_pressed = AdMobEditor.AdMobSettings.config.debug.is_real
	TestEuropeUserConsent.button_pressed = AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent

	IsReal.disabled = not DebugOnRelease.button_pressed


func _on_DebugOnRelease_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_debug_on_release = DebugOnRelease.button_pressed
	if DebugOnRelease.button_pressed:
		IsReal.disabled = false
	else:
		IsReal.disabled = true

func _on_IsReal_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_real = IsReal.button_pressed

func _on_TestEuropeUserConsent_pressed():
	AdMobEditor.AdMobSettings.config.debug.is_test_europe_user_consent = TestEuropeUserConsent.button_pressed

