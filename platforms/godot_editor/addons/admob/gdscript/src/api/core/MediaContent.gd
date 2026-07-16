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


class_name MediaContent
extends RefCounted

var _uid: int
var _plugin: Object
var _video_controller: AdVideoController

func _init(uid: int, plugin: Object) -> void:
	_uid = uid
	_plugin = plugin
	_video_controller = AdVideoController.new(uid, plugin)


func has_video_content() -> bool:
	if _plugin:
		return _plugin.has_video_content(_uid)
	return false


func get_video_controller() -> AdVideoController:
	return _video_controller


func get_duration() -> float:
	if _plugin:
		return float(_plugin.get_video_duration(_uid))
	return 0.0


func get_aspect_ratio() -> float:
	if _plugin:
		return float(_plugin.get_video_aspect_ratio(_uid))
	return 0.0
