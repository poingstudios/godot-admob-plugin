tool
extends EditorPlugin

var AdMobEditor : Control

class PoingAdMobEditorExportPlugin extends EditorExportPlugin:
	const CFG_FILE_PATH := "res://addons/admob/plugin.cfg"

	func _export_begin(features: PoolStringArray, is_debug: bool, path: String, flags: int) -> void:
		var file := File.new()

		if file.open(CFG_FILE_PATH, File.READ) == OK:
			print("Exporting Poing AdMob '.cfg' file")
			add_file(CFG_FILE_PATH, file.get_buffer(file.get_len()), false)
		file.close()

	func _get_name() -> String:
		return "PoingAdMob"

var _exporter := PoingAdMobEditorExportPlugin.new()

func _enter_tree():
	add_export_plugin(_exporter)
	
	add_autoload_singleton("MobileAds", "res://addons/admob/src/singletons/MobileAds.gd")
	AdMobEditor = load("res://addons/admob/src/core/AdMobEditor.tscn").instance()
	get_editor_interface().get_editor_viewport().add_child(AdMobEditor)
	AdMobEditor.hide()

func _exit_tree():
	remove_export_plugin(_exporter)
	
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
