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

class_name AdView
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobAdView")

var ad_listener := AdListener.new()
var on_ad_paid: Callable = func(_ad_value: AdValue): pass
var _uid: int

var ad_unit_id: String
var ad_size: AdSize
var ad_position: AdPosition

func _init(ad_unit_id: String, ad_size: AdSize, ad_position: AdPosition) -> void:
	self.ad_unit_id = ad_unit_id
	self.ad_size = ad_size
	self.ad_position = ad_position

	if _plugin:
		var ad_view_dictionary := {
			"ad_unit_id": ad_unit_id,
			"ad_position": ad_position.value,
			"custom_position": {
				"x": ad_position.offset.x,
				"y": ad_position.offset.y
			},
			"ad_size": {
				"width": ad_size.width,
				"height": ad_size.height
			}
		}

		_uid = _plugin.create(ad_view_dictionary)
		safe_connect(_plugin, "on_ad_clicked", _on_ad_clicked)
		safe_connect(_plugin, "on_ad_closed", _on_ad_closed)
		safe_connect(_plugin, "on_ad_failed_to_load", _on_ad_failed_to_load)
		safe_connect(_plugin, "on_ad_impression", _on_ad_impression)
		safe_connect(_plugin, "on_ad_loaded", _on_ad_loaded)
		safe_connect(_plugin, "on_ad_opened", _on_ad_opened)
		safe_connect(_plugin, "on_ad_view_paid", _on_ad_view_paid)

func load_ad(ad_request: AdRequest) -> void:
	if _plugin:
		_plugin.load_ad(_uid, ad_request.convert_to_dictionary(), ad_request.keywords)

func destroy() -> void:
	if _plugin:
		_plugin.destroy(_uid)

func get_response_info() -> ResponseInfo:
	if _plugin:
		var response_info_dictionary : Dictionary = _plugin.get_response_info(_uid)
		return ResponseInfo.create(response_info_dictionary)
	return null

func hide() -> void:
	if _plugin:
		_plugin.hide(_uid)

func show() -> void:
	if _plugin:
		_plugin.show(_uid)

func set_position(ad_position: AdPosition) -> void:
	self.ad_position = ad_position
	if _plugin:
		if ad_position.value == AdPosition.Values.CUSTOM:
			_plugin.update_custom_position(_uid, ad_position.offset.x, ad_position.offset.y)
		else:
			_plugin.update_position(_uid, ad_position.value)

func get_width() -> int:
	if _plugin:
		return _plugin.get_width(_uid)
	return -1
	
func get_height() -> int:
	if _plugin:
		return _plugin.get_height(_uid)
	return -1
	
func get_width_in_pixels() -> int:
	if _plugin:
		return _plugin.get_width_in_pixels(_uid)
	return -1
	
func get_height_in_pixels() -> int:
	if _plugin:
		return _plugin.get_height_in_pixels(_uid)
	return -1

func is_collapsible() -> bool:
	if _plugin:
		return _plugin.is_collapsible(_uid)
	return false

func _on_ad_clicked(uid: int) -> void:
	if uid == _uid:
		ad_listener.on_ad_clicked.call_deferred()

func _on_ad_closed(uid: int) -> void:
	if uid == _uid:
		ad_listener.on_ad_closed.call_deferred()

func _on_ad_failed_to_load(uid: int, load_ad_error_dictionary: Dictionary) -> void:
	if uid == _uid:
		ad_listener.on_ad_failed_to_load.call_deferred(LoadAdError.create(load_ad_error_dictionary))

func _on_ad_impression(uid: int) -> void:
	if uid == _uid:
		ad_listener.on_ad_impression.call_deferred()

func _on_ad_loaded(uid: int) -> void:
	if uid == _uid:
		ad_listener.on_ad_loaded.call_deferred()

func _on_ad_opened(uid: int) -> void:
	if uid == _uid:
		ad_listener.on_ad_opened.call_deferred()

func _on_ad_view_paid(uid: int, ad_value_dictionary: Dictionary) -> void:
	if uid == _uid:
		on_ad_paid.call_deferred(AdValue.create(ad_value_dictionary))
