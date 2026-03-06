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

extends VBoxContainer

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

var _rewarded_interstitial_ad: RewardedInterstitialAd
var _reward_listener := OnUserEarnedRewardListener.new()
var _load_callback := RewardedInterstitialAdLoadCallback.new()
var _content_callback := FullScreenContentCallback.new()

@onready var _load_button: Button = $Load
@onready var _show_button: Button = $Show
@onready var _destroy_button: Button = $Destroy

func _ready() -> void:
	_reward_listener.on_user_earned_reward = _on_user_earned_reward
	
	_load_callback.on_ad_failed_to_load = _on_ad_failed_to_load
	_load_callback.on_ad_loaded = _on_ad_loaded

	_content_callback.on_ad_clicked = func() -> void: _log("Ad clicked")
	_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		_log("Ad dismissed")
		_destroy_ad()
		
	_content_callback.on_ad_failed_to_show_full_screen_content = func(err: AdError) -> void:
		_log("Failed to show: " + err.message)
	_content_callback.on_ad_impression = func() -> void: _log("Impression recorded")
	_content_callback.on_ad_showed_full_screen_content = func() -> void: _log("Ad showed")
	
	_update_ui_state(false)

func _update_ui_state(is_loaded: bool) -> void:
	_load_button.disabled = is_loaded
	_show_button.disabled = !is_loaded
	_destroy_button.disabled = !is_loaded

func _on_load_pressed() -> void:
	_log("Loading rewarded interstitial...")
	RewardedInterstitialAdLoader.new().load("ca-app-pub-3940256099942544/5354046379", AdRequest.new(), _load_callback)

func _on_show_pressed() -> void:
	if _rewarded_interstitial_ad:
		_log("Showing rewarded interstitial ad...")
		_rewarded_interstitial_ad.show(_reward_listener)

func _on_destroy_pressed() -> void:
	_destroy_ad()

func _destroy_ad() -> void:
	if _rewarded_interstitial_ad:
		_rewarded_interstitial_ad.destroy()
		_rewarded_interstitial_ad = null
		_log("Ad destroyed")
		_update_ui_state(false)

#region Callbacks
func _on_user_earned_reward(item: RewardedItem) -> void:
	_log("Reward earned: %d %s" % [item.amount, item.type])

func _on_ad_failed_to_load(error: LoadAdError) -> void:
	_log("Failed to load: " + error.message)
	_update_ui_state(false)
	
func _on_ad_loaded(ad: RewardedInterstitialAd) -> void:
	_log("Ad loaded successfully (UID: %s)" % str(ad._uid))
	ad.full_screen_content_callback = _content_callback
	
	var ssv_options := ServerSideVerificationOptions.new()
	ssv_options.custom_data = "TEST_DATA"
	ad.set_server_side_verification_options(ssv_options)
	
	_rewarded_interstitial_ad = ad
	_update_ui_state(true)
#endregion

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[RewardedInterstitial] " + message)
	else:
		print("[RewardedInterstitial] " + message)
