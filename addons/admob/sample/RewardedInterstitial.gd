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

extends VBoxContainer

var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var rewarded_interstitial_ad : RewardedInterstitialAd
var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()

@onready var LoadButton := $Load
@onready var ShowButton := $Show
@onready var DestroyButton := $Destroy

func _ready():
	on_user_earned_reward_listener.on_user_earned_reward = on_user_earned_reward
	
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = on_rewarded_interstitial_ad_failed_to_load
	rewarded_interstitial_ad_load_callback.on_ad_loaded = on_rewarded_interstitial_ad_loaded

	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		destroy()
		
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")

func _on_load_pressed():
	RewardedInterstitialAdLoader.new().load("ca-app-pub-3940256099942544/5354046379", AdRequest.new(), rewarded_interstitial_ad_load_callback)

func on_rewarded_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_interstitial_ad_loaded(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
	print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
	rewarded_interstitial_ad.full_screen_content_callback = full_screen_content_callback

	var server_side_verification_options := ServerSideVerificationOptions.new()
	server_side_verification_options.custom_data = "TEST PURPOSE"
	rewarded_interstitial_ad.set_server_side_verification_options(server_side_verification_options)

	self.rewarded_interstitial_ad = rewarded_interstitial_ad
	DestroyButton.disabled = false
	ShowButton.disabled = false
	LoadButton.disabled = true

func _on_show_pressed():
	if rewarded_interstitial_ad:
		rewarded_interstitial_ad.show(on_user_earned_reward_listener)
		
func on_user_earned_reward(rewarded_item : RewardedItem):
	print("on_user_earned_reward, rewarded_item interstitial:", rewarded_item.amount, rewarded_item.type)

func _on_destroy_pressed():
	destroy()

func destroy():
	if rewarded_interstitial_ad:
		rewarded_interstitial_ad.destroy()
		rewarded_interstitial_ad = null #need to load again
		
		DestroyButton.disabled = true
		ShowButton.disabled = true
		LoadButton.disabled = false
