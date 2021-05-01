tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("MobileAds", "res://addons/admob/scripts/MobileAds.gd")

func _exit_tree():
	remove_autoload_singleton("MobileAds")
