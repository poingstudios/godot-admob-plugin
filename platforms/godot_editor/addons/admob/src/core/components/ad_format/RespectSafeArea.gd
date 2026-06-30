tool
extends CheckBox

signal value_changed(value)


func _on_ConfirmationDialog_confirmed():
	pressed = false
	emit_signal("value_changed", pressed)


func _on_RespectSafeArea_pressed():
	if not pressed:
		pressed = true
		$ConfirmationDialog.show()
	else:
		emit_signal("value_changed", pressed)
