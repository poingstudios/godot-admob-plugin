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

extends RefCounted

const TRANSLATIONS_DIR := "res://addons/admob/internal/translations"

var _editor_translations: Array[Translation] = []


static func get_translation_paths(dir_path: String = TRANSLATIONS_DIR) -> Array[String]:
	var paths: Array[String] = []
	for file in DirAccess.get_files_at(dir_path):
		if file.get_extension() == "translation":
			paths.append(dir_path.path_join(file))
	paths.sort()
	return paths


static func load_sample_translations(dir_path: String = TRANSLATIONS_DIR) -> Array[Translation]:
	var loaded: Array[Translation] = []
	for path in get_translation_paths(dir_path):
		if ResourceLoader.exists(path):
			var translation := load(path) as Translation
			if translation != null:
				TranslationServer.add_translation(translation)
				loaded.append(translation)
	return loaded


func setup() -> void:
	if not ProjectSettings.settings_changed.is_connected(_on_project_settings_changed):
		ProjectSettings.settings_changed.connect(_on_project_settings_changed)
	_load_translations()


func cleanup() -> void:
	if ProjectSettings.settings_changed.is_connected(_on_project_settings_changed):
		ProjectSettings.settings_changed.disconnect(_on_project_settings_changed)
	_unload_translations()


func _on_project_settings_changed() -> void:
	_load_translations()


func _load_translations() -> void:
	_unload_translations()
	_editor_translations = load_sample_translations()


func _unload_translations() -> void:
	for translation in _editor_translations:
		TranslationServer.remove_translation(translation)
	_editor_translations.clear()
