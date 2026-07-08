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

extends EditorExportPlugin

func get_plugin_name() -> String:
	return "AdMob Mediation Chartboost"


func get_binary_path() -> String:
	return "libs/poing-godot-admob-chartboost.xcframework"


func get_initialization_method() -> String:
	return "register_poing_godot_admob_chartboost_types"


func get_deinitialization_method() -> String:
	return "unregister_poing_godot_admob_chartboost_types"


func get_system_dependencies() -> PackedStringArray:
	return PackedStringArray([])


func get_files_to_copy() -> PackedStringArray:
	return PackedStringArray([])


func get_linker_flags() -> PackedStringArray:
	return PackedStringArray([])


func get_spm_packages() -> Array[Dictionary]:
	return [
		{
			"url": "https://github.com/googleads/googleads-mobile-ios-mediation-chartboost.git",
			"version": "9.12.0",
			"products": ["ChartboostAdapterTarget"]
		}
	]
