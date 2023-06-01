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

func _ready() -> void:
	var request_configuration := RequestConfiguration.new()
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G

	Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
	MobileAds.initialize(OnInitializationCompleteListener.new(_on_initialization_complete))
	adView1 = AdView.new("ca-app-pub-3940256099942544/6300978111", AdPosition.BOTTOM, AdSize.BANNER)

	_on_load_banner_pressed()
	
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
	print(adRequest1.convert_to_dictionary())
	adView1.load_ad(adRequest1)

func _on_destroy_banner_pressed():
	adView1.destroy()

func _on_show_banner_pressed():
	adView1.show()

func _on_hide_banner_pressed():
	adView1.hide()

func _on_get_width_pressed():
	if adView1:
		print(adView1.get_width(), adView1.get_height(), adView1.get_width_in_pixels(), adView1.get_height_in_pixels())
