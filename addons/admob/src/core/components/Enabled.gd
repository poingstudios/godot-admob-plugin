tool
extends CheckBox

onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready() -> void:
	pressed = AdMobEditor.AdMobSettings.config.general.is_enabled


func _on_Enabled_pressed():
	if not pressed:
		pressed = true
		$ConfirmationDialog.show()
	else:
		AdMobEditor.AdMobSettings.config.general.is_enabled = pressed


func _on_ConfirmationDialog_confirmed() -> void:
	pressed = false
	AdMobEditor.AdMobSettings.config.general.is_enabled = pressed
