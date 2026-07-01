tool
extends VBoxContainer

onready var ad_mob_editor : Control = find_parent("AdMobEditor")
onready var debug_on_release : Control = $TabContainer/Release/DebugOnRelease
onready var is_real : Control = $TabContainer/Release/IsReal
onready var test_europe_user_consent : Control = $TabContainer/General/TestEuropeUserConsent

func _ready():
	var debug_config = ad_mob_editor.ad_mob_settings.config.debug
	debug_on_release.pressed = debug_config.is_debug_on_release
	is_real.pressed = debug_config.is_real
	test_europe_user_consent.pressed = (
		debug_config.is_test_europe_user_consent
	)

	is_real.disabled = not debug_on_release.pressed


func _on_DebugOnRelease_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_debug_on_release = debug_on_release.pressed
	if debug_on_release.pressed:
		is_real.disabled = false
	else:
		is_real.disabled = true

func _on_IsReal_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_real = is_real.pressed

func _on_TestEuropeUserConsent_pressed():
	ad_mob_editor.ad_mob_settings.config.debug.is_test_europe_user_consent = (
		test_europe_user_consent.pressed
	)
