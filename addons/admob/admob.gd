# MIT License

# Copyright (c) 2023 Poing Studios

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

var MainScreen : Control

func _enter_tree():
	MainScreen = load("res://addons/admob/src/editor/scenes/MainScreen.tscn").instantiate()
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
