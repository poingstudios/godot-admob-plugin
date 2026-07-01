tool
extends CheckBox

onready var ad_mob_editor : Control = find_parent("AdMobEditor")

func _ready() -> void:
	pressed = ad_mob_editor.ad_mob_settings.config.general.is_enabled


func _on_Enabled_pressed():
	if not pressed:
		pressed = true
		$ConfirmationDialog.show()
	else:
		ad_mob_editor.ad_mob_settings.config.general.is_enabled = pressed


func _on_ConfirmationDialog_confirmed() -> void:
	pressed = false
	ad_mob_editor.ad_mob_settings.config.general.is_enabled = pressed
