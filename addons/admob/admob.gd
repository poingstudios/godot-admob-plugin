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

const MENU_NAME := "AdMob Manager"
const AdMobEditorMenu := preload("res://addons/admob/internal/editor/editor_menu.gd")

var _main_exporter := preload("res://addons/admob/internal/exporters/main_export_plugin.gd").new()
var _android_exporter := preload("res://addons/admob/internal/exporters/android/export_plugin.gd").new()

func _enter_tree() -> void:
	add_export_plugin(_main_exporter)
	add_export_plugin(_android_exporter)
	add_tool_submenu_item(MENU_NAME, AdMobEditorMenu.new(self))

func _exit_tree() -> void:
	remove_export_plugin(_main_exporter)
	remove_export_plugin(_android_exporter)
	remove_tool_menu_item(MENU_NAME)
