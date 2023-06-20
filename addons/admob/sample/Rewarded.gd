# MIT License

# Copyright (c) 2023 Poing Studios

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

var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
var full_screen_content_callback := FullScreenContentCallback.new()

@onready var ShowButton := $Show
@onready var LoadButton := $Load

func _ready():
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

	full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		rewarded_ad = null #need to load again
		ShowButton.disabled = true
		LoadButton.disabled = false
		
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")

func _on_load_pressed():
	RewardedAdLoader.new().load("ca-app-pub-3940256099942544/5224354917", AdRequest.new(), rewarded_ad_load_callback)

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("rewarded ad loaded" + str(rewarded_ad._uid))
	rewarded_ad.full_screen_content_callback = full_screen_content_callback
	self.rewarded_ad = rewarded_ad
	ShowButton.disabled = false
	LoadButton.disabled = true

func _on_show_pressed():
	if rewarded_ad:
		rewarded_ad.show()
