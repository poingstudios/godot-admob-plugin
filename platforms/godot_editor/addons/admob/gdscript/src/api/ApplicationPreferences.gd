# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name ApplicationPreferences
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMob")


static func set_int(key: String, value: int) -> void:
	if _plugin:
		_plugin.set_app_preference_int(key, value)


static func get_int(key: String, default_value := 0) -> int:
	if _plugin:
		return _plugin.get_app_preference_int(key, default_value)
	return default_value


static func set_string(key: String, value: String) -> void:
	if _plugin:
		_plugin.set_app_preference_string(key, value)


static func get_string(key: String, default_value := "") -> String:
	if _plugin:
		return _plugin.get_app_preference_string(key, default_value)
	return default_value


static func set_boolean(key: String, value: bool) -> void:
	if _plugin:
		_plugin.set_app_preference_boolean(key, value)


static func get_boolean(key: String, default_value := false) -> bool:
	if _plugin:
		return _plugin.get_app_preference_boolean(key, default_value)
	return default_value
