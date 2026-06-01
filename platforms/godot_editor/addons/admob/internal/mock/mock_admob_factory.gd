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

extends RefCounted

static var _mocks: Dictionary = {}

static func get_mock_plugin(plugin_name: String) -> Object:
	if _mocks.has(plugin_name):
		return _mocks[plugin_name]

	var mock_instance: Object = null

	match plugin_name:
		"PoingGodotAdMob":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_mobile_ads_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobAdView":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_ad_view_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobNativeOverlayAd":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_native_overlay_ad_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobAdSize":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_ad_size_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobInterstitialAd":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_interstitial_ad_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobRewardedAd":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_rewarded_ad_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobRewardedInterstitialAd":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_rewarded_interstitial_ad_plugin.gd")
			mock_instance = PluginScript.new()
		"PoingGodotAdMobAppOpenAd":
			var PluginScript = preload("res://addons/admob/internal/mock/mock_app_open_ad_plugin.gd")
			mock_instance = PluginScript.new()

	if mock_instance:
		_mocks[plugin_name] = mock_instance
		if mock_instance is Node:
			var main_loop := Engine.get_main_loop()
			if main_loop and main_loop is SceneTree:
				(main_loop as SceneTree).root.add_child.call_deferred(mock_instance)

	return mock_instance
