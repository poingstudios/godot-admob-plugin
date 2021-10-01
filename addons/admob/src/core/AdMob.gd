tool
extends EditorPlugin

var AdMobEditor : Control

func _enter_tree():
	add_autoload_singleton("MobileAds", "res://addons/admob/src/singletons/MobileAds.gd")
	AdMobEditor = load("res://addons/admob/src/core/AdMobEditor.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(AdMobEditor)
	AdMobEditor.hide()

func _exit_tree():
	remove_autoload_singleton("MobileAds")
	get_editor_interface().get_editor_viewport().remove_child(AdMobEditor)
	AdMobEditor.queue_free()
	
func has_main_screen():
	return true

func make_visible(visible):
	AdMobEditor.visible = visible

func get_plugin_name():
	return "AdMob"

func get_plugin_icon():
	return load("res://addons/admob/assets/icon-15.png")
