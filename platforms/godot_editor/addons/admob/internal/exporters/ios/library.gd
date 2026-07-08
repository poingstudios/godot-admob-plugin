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

const ROOT_BIN_PATH := "res://addons/admob/ios/bin"

var path: String
var is_enabled: bool


func _init(p_path: String, p_is_enabled: bool = true) -> void:
	path = p_path
	is_enabled = p_is_enabled


func get_config_script_path() -> String:
	return ROOT_BIN_PATH + "/" + path + "/poing_godot_admob_" + path + ".gd"


func get_config() -> EditorExportPlugin:
	var script_path := get_config_script_path()
	if not FileAccess.file_exists(script_path):
		push_error("AdMob: iOS library configuration not found at " + script_path)
		return null
	return load(script_path).new()
