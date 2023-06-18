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

extends Control

var adView1: AdView
var consent_information := UserMessagingPlatform.consent_information
var fullScreenContentCallback := FullScreenContentCallback.new()

func _ready() -> void:
	var request_configuration := RequestConfiguration.new()
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G

	Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
	MobileAds.initialize(on_initialization_complete_listener)
	
	var ad_listener := AdListener.new()
	ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
	ad_listener.on_ad_clicked = _on_ad_clicked
	ad_listener.on_ad_closed = _on_ad_closed
	ad_listener.on_ad_impression = _on_ad_impression
	ad_listener.on_ad_loaded = _on_ad_loaded
	ad_listener.on_ad_opened = _on_ad_opened
	
	var adSize := AdSize.get_landscape_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	
	adView1 = AdView.new("ca-app-pub-3940256099942544/6300978111", adSize, AdPosition.Values.TOP)
	adView1.ad_listener = ad_listener
	var request := ConsentRequestParameters.new()
	var consent_debug_settings := ConsentDebugSettings.new()
	consent_debug_settings.debug_geography = DebugGeography.Values.NOT_EEA
	request.consent_debug_settings = consent_debug_settings
	
	consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
	_on_get_consent_status_pressed()

	var rewardedAdLoadCallback := RewardedAdLoadCallback.new()
	rewardedAdLoadCallback.on_ad_loaded = on_rewarded_ad_loaded
	rewardedAdLoadCallback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load

	RewardedAdLoader.new().load("ca-app-pub-3940256099942544/5224354917", create_ad_request(), rewardedAdLoadCallback)


#	var interstitialAdLoadCallback := InterstitialAdLoadCallback.new()
#	interstitialAdLoadCallback.on_ad_loaded = on_interstitial_ad_loaded
#	interstitialAdLoadCallback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
#
#	InterstitialAdLoader.new().load("ca-app-pub-3940256099942544/1033173712", create_ad_request(), interstitialAdLoadCallback)


func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	print("rewarded ad loaded" + str(rewarded_ad._uid))
	fullScreenContentCallback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	fullScreenContentCallback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
	fullScreenContentCallback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	fullScreenContentCallback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	fullScreenContentCallback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
	rewarded_ad.full_screen_content_callback = fullScreenContentCallback
	var onUserEarnedRewardListener := OnUserEarnedRewardListener.new()
	onUserEarnedRewardListener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("Type: " + str(rewarded_item.type), "Amount: " + str(rewarded_item.amount))
	rewarded_ad.show(onUserEarnedRewardListener)


#	var interstitialAdLoadCallback1 := InterstitialAdLoadCallback.new()
#	interstitialAdLoadCallback1.on_ad_loaded = on_interstitial_ad_loaded1
#	interstitialAdLoadCallback1.on_ad_failed_to_load = on_interstitial_ad_failed_to_load1
#	InterstitialAdLoader.new().load("ca-app-pub-3940256099942544/1033173712", create_ad_request(), interstitialAdLoadCallback1)
#
#func on_interstitial_ad_failed_to_load1(adError : LoadAdError) -> void:
#	print(adError.message)
#
#func on_interstitial_ad_loaded1(interstitial_ad : InterstitialAd) -> void:
#	print("interstitial ad loaded" + str(interstitial_ad._uid))
#	interstitial_ad.show()
	
func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	print("interstitial ad loaded" + str(interstitial_ad._uid))
	fullScreenContentCallback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	fullScreenContentCallback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
	fullScreenContentCallback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	fullScreenContentCallback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	fullScreenContentCallback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
	interstitial_ad.full_screen_content_callback = fullScreenContentCallback
	interstitial_ad.show()

func _on_consent_info_updated_success():
	if consent_information.get_is_consent_form_available():
		load_form()

func load_form():
	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
	

func _on_consent_form_load_success(consent_form : ConsentForm):
	if consent_information.get_consent_status() == consent_information.ConsentStatus.REQUIRED:
		consent_form.show(_on_consent_form_dismissed)

func _on_consent_form_dismissed(form_error : FormError):
	if consent_information.get_consent_status() == consent_information.ConsentStatus.OBTAINED:
		_on_load_banner_pressed()
	
func _on_consent_form_load_failure(form_error : FormError):
	print("_on_consent_form_load_failure, form_error: error_code=" + str(form_error.error_code) + " message=" + form_error.message)

func _on_consent_info_updated_failure(form_error : FormError):
	print("_on_consent_info_updated_failure, form_error: error_code=" + str(form_error.error_code) + " message=" + form_error.message)

func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
	print("_on_ad_failed_to_load: " + load_ad_error.message)
	
func _on_ad_clicked() -> void:
	print("_on_ad_clicked")
	
func _on_ad_closed() -> void:
	print("_on_ad_closed")
	
func _on_ad_impression() -> void:
	print("_on_ad_impression")
	
func _on_ad_loaded() -> void:
	print("_on_ad_loaded")
	
func _on_ad_opened() -> void:
	print("_on_ad_opened")

func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
	print_all_values(initialization_status)

func _on_get_initialization_status_pressed() -> void:
	var initialization_status := MobileAds.get_initialization_status()
	print_all_values(initialization_status)

func print_all_values(initialization_status : InitializationStatus) -> void:
	for key in initialization_status.adapter_status_map:
		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
		prints(key, adapterStatus.latency, adapterStatus.initialization_status, adapterStatus.description)

func _on_load_banner_pressed():
	adView1.load_ad(create_ad_request())

func create_ad_request() -> AdRequest:
	var adRequest1 := AdRequest.new()
	var adColonyMediationExtras := AdColonyMediationExtras.new()
	var vungleInterstitialMediationExtras := VungleInterstitialMediationExtras.new()
	var vungleRewardedMediationExtras := VungleRewardedMediationExtras.new()
	vungleInterstitialMediationExtras.all_placements = ["placement_1", "placement_2"]
	vungleInterstitialMediationExtras.user_id = "poing-studios"
	
	adColonyMediationExtras.show_post_popup = true
	adRequest1.mediation_extras.append_array([
		adColonyMediationExtras, 
		vungleInterstitialMediationExtras, 
		vungleRewardedMediationExtras])
		
	adRequest1.keywords.append_array(["tip", "bonus"])
	adRequest1.extras["rdp"] = 1
	adRequest1.extras["IABUSPrivacy_String"] = "IAB_STRING"
	
	return adRequest1

func _on_destroy_banner_pressed():
	adView1.destroy()

func _on_show_banner_pressed():
	adView1.show()

func _on_hide_banner_pressed():
	adView1.hide()

func _on_get_width_pressed():
	if adView1:
		print(adView1.get_width(), adView1.get_height(), adView1.get_width_in_pixels(), adView1.get_height_in_pixels())

func _on_reset_consent_information_pressed():
	consent_information.reset()

func _on_get_consent_status_pressed():
	print("ConsentStatus: " + ConsentInformation.ConsentStatus.keys()[consent_information.get_consent_status()])
