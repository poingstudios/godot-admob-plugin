@tool
extends CheckBox

signal value_changed(value)


func _on_ConfirmationDialog_confirmed():
	button_pressed = false
	emit_signal("value_changed", button_pressed)


func _on_RespectSafeArea_pressed():
	if not button_pressed:
		button_pressed = true
		$ConfirmationDialog.show()
	else:
		emit_signal("value_changed", button_pressed)
