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

class_name RewardedInterstitialAd
extends MobileSingletonPlugin

static var _plugin = _get_plugin("PoingGodotAdMobRewardedInterstitialAd")
var full_screen_content_callback := FullScreenContentCallback.new()

var _uid : int

func _init(uid : int):
	self._uid = uid
	register_callbacks()

func show(on_user_earned_reward_listener := OnUserEarnedRewardListener.new()) -> void:
	if _plugin:
		_plugin.show(_uid)
		_plugin.connect("on_rewarded_interstitial_ad_user_earned_reward", func(uid : int, rewarded_item_dictionary : Dictionary):
			if uid == _uid:
				on_user_earned_reward_listener.on_user_earned_reward.call_deferred(RewardedItem.create(rewarded_item_dictionary))
			)

func destroy() -> void:
	if _plugin:
		_plugin.destroy(_uid)

func set_server_side_verification_options(server_side_verification_options : ServerSideVerificationOptions):
	if _plugin:
		_plugin.set_server_side_verification_options(_uid, server_side_verification_options.convert_to_dictionary())

func register_callbacks() -> void:
	if _plugin:
		_plugin.connect("on_rewarded_interstitial_ad_clicked", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_clicked.call_deferred()
			)
		_plugin.connect("on_rewarded_interstitial_ad_dismissed_full_screen_content", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_dismissed_full_screen_content.call_deferred()
			)
		_plugin.connect("on_rewarded_interstitial_ad_failed_to_show_full_screen_content", func(uid : int, ad_error_dictionary : Dictionary):
			if uid == _uid:
				full_screen_content_callback.on_ad_failed_to_show_full_screen_content.call_deferred(AdError.create(ad_error_dictionary))
			)
		_plugin.connect("on_rewarded_interstitial_ad_impression", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_impression.call_deferred()
			)
		_plugin.connect("on_rewarded_interstitial_ad_showed_full_screen_content", func(uid : int):
			if uid == _uid:
				full_screen_content_callback.on_ad_showed_full_screen_content.call_deferred()
			)
