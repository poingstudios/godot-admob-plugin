@tool
extends CheckBox

@onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready() -> void:
	button_pressed = AdMobEditor.AdMobSettings.config.general.is_enabled


func _on_Enabled_pressed():
	if not button_pressed:
		button_pressed = true
		$ConfirmationDialog.show()
	else:
		AdMobEditor.AdMobSettings.config.general.is_enabled = button_pressed


func _on_ConfirmationDialog_confirmed() -> void:
	button_pressed = false
	AdMobEditor.AdMobSettings.config.general.is_enabled = button_pressed
