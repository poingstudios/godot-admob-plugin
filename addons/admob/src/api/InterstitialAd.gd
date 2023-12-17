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

class_name InterstitialAd
extends MobileSingletonPlugin

static var _plugin = _get_plugin("PoingGodotAdMobInterstitialAd")
var full_screen_content_callback := FullScreenContentCallback.new()

var _uid : int

func _init(uid : int):
	self._uid = uid
	register_callbacks()

func show() -> void:
	if _plugin:
		_plugin.show(_uid)

func destroy() -> void:
	if _plugin:
		_plugin.destroy(_uid)

func register_callbacks() -> void:
	if _plugin:
		_plugin.connect("on_interstitial_ad_clicked", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_clicked.call_deferred()
			)
		_plugin.connect("on_interstitial_ad_dismissed_full_screen_content", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_dismissed_full_screen_content.call_deferred()
			)
		_plugin.connect("on_interstitial_ad_failed_to_show_full_screen_content", func(uid : int, ad_error_dictionary : Dictionary):
			if uid == _uid:
				full_screen_content_callback.on_ad_failed_to_show_full_screen_content.call_deferred(AdError.create(ad_error_dictionary))
			)
		_plugin.connect("on_interstitial_ad_impression", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_impression.call_deferred()
			)
		_plugin.connect("on_interstitial_ad_showed_full_screen_content", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_showed_full_screen_content.call_deferred()
			)
