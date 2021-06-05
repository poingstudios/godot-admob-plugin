tool
extends EditorPlugin

var AdMobConfigScene : Control

func _enter_tree():
	add_autoload_singleton("MobileAds", "res://addons/admob/scripts/MobileAds.gd")
	AdMobConfigScene = load("res://addons/admob/scenes/AdMobConfig.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(AdMobConfigScene)
	AdMobConfigScene.hide()

func _exit_tree():
	remove_autoload_singleton("MobileAds")
	get_editor_interface().get_editor_viewport().remove_child(AdMobConfigScene)
	AdMobConfigScene.queue_free()
	
func has_main_screen():
	return true

func make_visible(visible):
	AdMobConfigScene.visible = visible

func get_plugin_name():
	return "AdMob"

func get_plugin_icon():
	return load("res://addons/admob/assets/icon-15.png")
