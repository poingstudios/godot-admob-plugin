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

class_name NativeOverlayAd
extends MobileSingletonPlugin

static var _plugin = _get_plugin("PoingGodotAdMobNativeOverlayAd")

var ad_listener := AdListener.new()
var on_ad_paid: Callable = func(_ad_value: AdValue): pass
var _uid: int
var _ad_load_callback: Callable

func _init(uid: int) -> void:
	self._uid = uid
	if _plugin:
		safe_connect(_plugin, "on_native_overlay_ad_clicked", _on_ad_clicked)
		safe_connect(_plugin, "on_native_overlay_ad_closed", _on_ad_closed)
		safe_connect(_plugin, "on_native_overlay_ad_impression", _on_ad_impression)
		safe_connect(_plugin, "on_native_overlay_ad_opened", _on_ad_opened)
		safe_connect(_plugin, "on_native_overlay_ad_paid", _on_ad_paid)

## Loads a native overlay ad.
## [param ad_unit_id]: An ad unit ID created in the AdMob UI.
## [param ad_request]: An ad request object containing targeting information.
## [param options]: Native Ad Options for configuring rendering settings.
## [param ad_load_callback]: Callback function with signature (ad: NativeOverlayAd, error: LoadAdError).
static func load(ad_unit_id: String, ad_request: AdRequest, options: NativeAdOptions, ad_load_callback: Callable) -> void:
	if _plugin:
		var uid = _plugin.create()
		var ad = NativeOverlayAd.new(uid)
		ad._ad_load_callback = ad_load_callback
		ad.reference() # Keep alive until loaded or failed
		
		safe_connect(_plugin, "on_native_overlay_ad_loaded", ad._on_ad_loaded, CONNECT_DEFERRED)
		safe_connect(_plugin, "on_native_overlay_ad_failed_to_load", ad._on_ad_failed_to_load, CONNECT_DEFERRED)
		
		_plugin.load(ad_unit_id, ad_request.convert_to_dictionary(), ad_request.keywords, options.convert_to_dictionary(), uid)

## Renders the native overlay ad at provided AdPosition.
func render_template(style: NativeTemplateStyle, ad_position: AdPosition, ad_size: AdSize = null) -> void:
	if _plugin:
		var ad_size_dict := {} # Initialize as empty dictionary to avoid Nil conversion error in JNI
		if ad_size:
			ad_size_dict = {"width": ad_size.width, "height": ad_size.height}
			
		if ad_position.value == AdPosition.Values.CUSTOM:
			_plugin.render_template_custom_position(_uid, style.convert_to_dictionary(), ad_position.offset.x, ad_position.offset.y, ad_size_dict)
		else:
			_plugin.render_template(_uid, style.convert_to_dictionary(), ad_position.value, ad_size_dict)

## Sets the position of the native overlay ad.
func set_template_position(ad_position: AdPosition) -> void:
	if _plugin:
		if ad_position.value == AdPosition.Values.CUSTOM:
			_plugin.update_custom_position(_uid, ad_position.offset.x, ad_position.offset.y)
		else:
			_plugin.update_position(_uid, ad_position.value)

## Destroys the native overlay ad.
func destroy() -> void:
	if _plugin:
		_plugin.destroy(_uid)

func get_response_info() -> ResponseInfo:
	if _plugin:
		var response_info_dictionary : Dictionary = _plugin.get_response_info(_uid)
		return ResponseInfo.create(response_info_dictionary)
	return null

## Hides the ad from being shown.
func hide() -> void:
	if _plugin:
		_plugin.hide(_uid)

## Shows the previously hidden ad.
func show() -> void:
	if _plugin:
		_plugin.show(_uid)

func get_template_width_in_pixels() -> float:
	if _plugin:
		return float(_plugin.get_width_in_pixels(_uid))
	return 0.0
	
func get_template_height_in_pixels() -> float:
	if _plugin:
		return float(_plugin.get_height_in_pixels(_uid))
	return 0.0

#region Internal Callbacks
func _on_ad_loaded(uid: int) -> void:
	if uid == _uid:
		safe_disconnect(_plugin, "on_native_overlay_ad_loaded", _on_ad_loaded)
		safe_disconnect(_plugin, "on_native_overlay_ad_failed_to_load", _on_ad_failed_to_load)
		if _ad_load_callback.is_valid():
			_ad_load_callback.call(self, null)
		unreference.call_deferred()

func _on_ad_failed_to_load(uid: int, load_ad_error_dictionary: Dictionary) -> void:
	if uid == _uid:
		safe_disconnect(_plugin, "on_native_overlay_ad_loaded", _on_ad_loaded)
		safe_disconnect(_plugin, "on_native_overlay_ad_failed_to_load", _on_ad_failed_to_load)
		if _ad_load_callback.is_valid():
			_ad_load_callback.call(null, LoadAdError.create(load_ad_error_dictionary))
		unreference.call_deferred()

func _on_ad_clicked(uid: int) -> void:
	if uid == self._uid and ad_listener.on_ad_clicked.is_valid():
		ad_listener.on_ad_clicked.call_deferred()

func _on_ad_closed(uid: int) -> void:
	if uid == self._uid and ad_listener.on_ad_closed.is_valid():
		ad_listener.on_ad_closed.call_deferred()

func _on_ad_impression(uid: int) -> void:
	if uid == self._uid and ad_listener.on_ad_impression.is_valid():
		ad_listener.on_ad_impression.call_deferred()

func _on_ad_opened(uid: int) -> void:
	if uid == self._uid and ad_listener.on_ad_opened.is_valid():
		ad_listener.on_ad_opened.call_deferred()

func _on_ad_paid(uid: int, ad_value_dictionary: Dictionary) -> void:
	if uid == self._uid and on_ad_paid.is_valid():
		on_ad_paid.call_deferred(AdValue.create(ad_value_dictionary))
#endregion
