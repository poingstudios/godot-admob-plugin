@tool
extends EditorPlugin

var MainScreen : Control

func _enter_tree():
	MainScreen = load("res://addons/admob_refactoring/src/editor/scenes/MainScreen.tscn").instantiate()
	get_editor_interface().get_editor_main_screen().add_child(MainScreen)
	MainScreen.hide()

func _exit_tree():
	get_editor_interface().get_editor_main_screen().remove_child(MainScreen)
	MainScreen.queue_free()
	
func _has_main_screen():
	return true

func _make_visible(visible):
	MainScreen.visible = visible

func _get_plugin_name():
	return "AdMob"

func _get_plugin_icon():
	return load("res://addons/admob/assets/icon-15.png")
