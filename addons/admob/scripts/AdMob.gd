tool
extends EditorPlugin

var AdMobScene : Control

func _enter_tree():
	add_autoload_singleton("GodotAdMob", "res://addons/admob/scripts/GodotAdMob.gd")
	AdMobScene = load("res://addons/admob/scripts/AdMob.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(AdMobScene)
	

func _exit_tree():
	remove_autoload_singleton("GodotAdMob")
	get_editor_interface().get_editor_viewport().remove_child(AdMobScene)
	AdMobScene.queue_free()
	
func has_main_screen():
	return true

func make_visible(visible):
	AdMobScene.visible = visible

func get_plugin_name():
	return "AdMob"

