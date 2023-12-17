extends VBoxContainer

@onready var set_ios_app_pause_on_background_button := $SetiOSAppPauseOnBackgroundButton
@onready var set_mute_music := $SetMuteMusic
@onready var music := $Music

func _on_set_ios_app_pause_on_background_button_pressed() -> void:
	var enabled : bool = set_ios_app_pause_on_background_button.button_pressed
	MobileAds.set_ios_app_pause_on_background(enabled)

func _on_mute_music_pressed() -> void:
	music.playing = not set_mute_music.button_pressed

