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

extends Control

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

@onready var _console_output: RichTextLabel = $Background/SafeArea/LayoutContainer/ConsolePanel/ConsoleOutput

func _ready() -> void:
	Registry.logger = self
	log_message("Main initialized")
	
	_initialize_mobile_ads()

func log_message(message: String) -> void:
	print(message)
	if _console_output:
		_console_output.text += "\n" + message

func _initialize_mobile_ads() -> void:
	var on_init_listener := OnInitializationCompleteListener.new()
	on_init_listener.on_initialization_complete = _on_initialization_complete
	
	var request_config := RequestConfiguration.new()
	request_config.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
	request_config.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.TRUE
	request_config.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
	request_config.test_device_ids = [] # Production ready
	
	MobileAds.set_request_configuration(request_config)
	MobileAds.initialize(on_init_listener)

func _on_initialization_complete(status: InitializationStatus) -> void:
	log_message("MobileAds initialization complete")
	_log_adapter_status(status)
	
	_setup_mediation_adapters()
	
	if OS.get_name() == "iOS":
		FBAdSettings.set_advertiser_tracking_enabled(true)

func _setup_mediation_adapters() -> void:
	# AdColony setup example
	var ad_colony_options := AdColonyAppOptions.new()
	ad_colony_options.set_privacy_consent_string(AdColonyAppOptions.CCPA, "OPTED_OUT")
	ad_colony_options.set_privacy_framework_required(AdColonyAppOptions.CCPA, false)
	ad_colony_options.set_test_mode(false)
	
	# Vungle setup example
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_OUT)
	Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "consent_message")

func _on_get_initialization_status_pressed() -> void:
	var status := MobileAds.get_initialization_status()
	if status:
		_log_adapter_status(status)

func _log_adapter_status(status: InitializationStatus) -> void:
	for adapter_name in status.adapter_status_map:
		var adapter_status: AdapterStatus = status.adapter_status_map[adapter_name]
		var info := "[%s] State: %d | Latency: %dms | Desc: %s" % [
			adapter_name,
			adapter_status.initialization_state,
			adapter_status.latency,
			adapter_status.description
		]
		log_message(info)
