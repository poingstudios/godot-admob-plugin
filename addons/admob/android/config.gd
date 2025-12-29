# MIT License

# Copyright (c) 2025-present Poing Studios

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

extends Object

const APPLICATION_ID := "ca-app-pub-3940256099942544~3347511713" # Change to your own AdMob App ID when releasing your game.

var libraries: Array[AndroidAdMobLibrary] = [
	AndroidAdMobLibrary.new("ads", true), # Disable if you don't want to use AdMob.
	
	# Mediations
	AndroidAdMobLibrary.new("adcolony", true),
	AndroidAdMobLibrary.new("meta", true),
	AndroidAdMobLibrary.new("vungle", true)
]

####################################################################

func is_ads_enabled() -> bool:
	for lib in libraries:
		if lib.path == "ads":
			return lib.is_enabled
	return false

class AndroidAdMobLibrary:
	const ROOT_BIN_PATH := "res://addons/admob/android/bin"
	
	var path: String
	var is_enabled: bool

	func _init(path: String, is_enabled: bool = true) -> void:
		self.path = path
		self.is_enabled = is_enabled

	func get_full_path() -> String:
		return ROOT_BIN_PATH + "/" + "poing_godot_admob_" + path + ".gd"

	func get_plugin() -> EditorExportPlugin:
		return load(get_full_path()).new()
