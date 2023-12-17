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

extends Control

func _ready() -> void:
	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
	var request_configuration := RequestConfiguration.new()
	request_configuration.tag_for_child_directed_treatment = 1
	request_configuration.tag_for_under_age_of_consent = 1
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
	request_configuration.test_device_ids = ["asdasda"]
	request_configuration.convert_to_dictionary()
	MobileAds.set_request_configuration(request_configuration)
	MobileAds.initialize(on_initialization_complete_listener)

	
func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
	print("MobileAds initialization complete")
	print_all_values(initialization_status)
	var ad_colony_app_options := AdColonyAppOptions.new()
	print("set values ad_colony")
	ad_colony_app_options.set_privacy_consent_string(AdColonyAppOptions.CCPA, "STRIaNG CCPA")
	ad_colony_app_options.set_privacy_framework_required(AdColonyAppOptions.CCPA, false)
	ad_colony_app_options.set_user_id("asdaaaad")
	ad_colony_app_options.set_test_mode(false)
	
	print(ad_colony_app_options.get_privacy_consent_string(AdColonyAppOptions.CCPA))
	print(ad_colony_app_options.get_privacy_framework_required(AdColonyAppOptions.CCPA))
	print(ad_colony_app_options.get_user_id())
	print(ad_colony_app_options.get_test_mode())
	
	if OS.get_name() == "iOS":
		#FBAdSettings is available only for iOS, Google didn't put this method on Android SDK
		FBAdSettings.set_advertiser_tracking_enabled(true)
		
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_OUT)
	Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "message1")
	Vungle.update_consent_status(Vungle.Consent.OPTED_OUT, "message2")

func _on_get_initialization_status_pressed() -> void:
	var initialization_status := MobileAds.get_initialization_status()
	if initialization_status:
		print_all_values(initialization_status)

func print_all_values(initialization_status : InitializationStatus) -> void:
	for key in initialization_status.adapter_status_map:
		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
		prints("Key:", key, "Latency:", adapterStatus.latency, "Initialization Status:", adapterStatus.initialization_status, "Description:", adapterStatus.description)

