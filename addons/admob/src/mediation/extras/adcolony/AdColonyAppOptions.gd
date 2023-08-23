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

class_name AdColonyAppOptions
extends MobileSingletonPlugin

const CCPA := "CCPA"
const GDPR := "GDPR"

const PLUGIN_NAME := "PoingGodotAdMobAdColonyAppOptions"
var _plugin : Object

func _init() -> void:
	_plugin = _get_plugin(PLUGIN_NAME)

func set_privacy_framework_required(type : String, required : bool) -> void:
	if _plugin:
		_plugin.set_privacy_framework_required(type, required)

func get_privacy_framework_required(type : String) -> bool:
	if _plugin:
		return _plugin.get_privacy_framework_required(type)
	return false

func set_privacy_consent_string(type : String, consent_string : String) -> void :
	if _plugin:
		_plugin.set_privacy_consent_string(type, consent_string)

func get_privacy_consent_string(type : String) -> String:
	if _plugin:
		return _plugin.get_privacy_consent_string(type)
	return ""

func set_user_id(user_id : String) -> void:
	if _plugin:
		_plugin.set_user_id(user_id)

func get_user_id() -> String:
	if _plugin:
		return _plugin.get_user_id()
	return ""

func set_test_mode(enabled : bool) -> void:
	if _plugin:
		_plugin.set_test_mode(enabled)

func get_test_mode() -> bool:
	if _plugin:
		return _plugin.get_test_mode()
	return false
