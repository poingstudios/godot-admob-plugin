# MIT License

# Copyright (c) 2026-present Poing Studios

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

extends "res://addons/admob/internal/editor/popup_menu.gd"

const DialogService := preload("res://addons/admob/internal/services/ui/dialog_service.gd")

var _dialog_service: DialogService


func _init(dialog_service: DialogService) -> void:
	super._init()
	name = "AI Copilot"
	_dialog_service = dialog_service

	add_menu_item("Install AI Skills to Project", _on_install_ai_skills)


func _on_install_ai_skills() -> void:
	var src_dir := "res://addons/admob/skills"
	var dest_dir := "res://.skills"

	if not DirAccess.dir_exists_absolute(src_dir):
		_dialog_service.show_message("Source skills folder not found at: " + src_dir)
		return

	var err := _copy_directory_recursive(src_dir, dest_dir)
	if err == OK:
		_dialog_service.show_message("AdMob AI Copilot skills installed successfully in project root (.skills/)!\nYou can now use them in Cursor, Antigravity, Claude, etc.")
	else:
		_dialog_service.show_message("Failed to copy AI skills. Error code: " + str(err))


func _copy_directory_recursive(from_dir: String, to_dir: String) -> Error:
	var dir := DirAccess.open(from_dir)
	if not dir:
		return DirAccess.get_open_error()

	var err := DirAccess.make_dir_recursive_absolute(to_dir)
	if err != OK:
		return err

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			var from_path := from_dir.path_join(file_name)
			var to_path := to_dir.path_join(file_name)
			if dir.current_is_dir():
				var res := _copy_directory_recursive(from_path, to_path)
				if res != OK:
					return res
			else:
				var res := DirAccess.copy_absolute(from_path, to_path)
				if res != OK:
					return res
		file_name = dir.get_next()
	return OK
