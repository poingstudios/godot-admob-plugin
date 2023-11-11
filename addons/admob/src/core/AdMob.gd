# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

@tool
extends EditorPlugin

var AdMobEditor : Control

class PoingAdMobEditorExportPlugin extends EditorExportPlugin:
	const CFG_FILE_PATH := "res://addons/admob/plugin.cfg"
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		var file = FileAccess.open(CFG_FILE_PATH, FileAccess.READ)
		if file:
			print("Exporting Poing AdMob '.cfg' file")
			add_file(CFG_FILE_PATH, file.get_buffer(file.get_length()), false)
		file.close()

	func _get_name() -> String:
		return "PoingAdMob"
		
var _exporter := PoingAdMobEditorExportPlugin.new()

func _enter_tree():
	add_export_plugin(_exporter)

	add_autoload_singleton("MobileAds", "res://addons/admob/src/singletons/MobileAds.gd")
	AdMobEditor = load("res://addons/admob/src/core/AdMobEditor.tscn").instantiate()
	get_editor_interface().get_editor_main_screen().add_child(AdMobEditor)
	AdMobEditor.hide()

func _exit_tree():
	remove_export_plugin(_exporter)

	remove_autoload_singleton("MobileAds")
	get_editor_interface().get_editor_main_screen().remove_child(AdMobEditor)
	AdMobEditor.queue_free()
	
func _has_main_screen():
	return true

func _make_visible(visible):
	AdMobEditor.visible = visible

func _get_plugin_name():
	return "AdMob"

func _get_plugin_icon():
	return load("res://addons/admob/assets/icon-15.png")
