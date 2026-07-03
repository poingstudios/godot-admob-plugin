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
const UIScaler = preload("res://addons/admob/gdscript/sample/UIScaler.gd")

@onready
var _console_output: RichTextLabel = $Background/SafeArea/LayoutContainer/ConsolePanel/ConsoleOutput
@onready
var _main_tabs: TabContainer = $Background/SafeArea/LayoutContainer/TabContent/MainTabs

@onready
var _app_title: Label = $Background/SafeArea/LayoutContainer/HeaderContainer/VBox/LogoContainer/TitleContainer/AppTitle
@onready
var _support_label: Label = $Background/SafeArea/LayoutContainer/HeaderContainer/VBox/SupportCard/VBox/SupportLabel
@onready
var _support_card: Control = $Background/SafeArea/LayoutContainer/HeaderContainer/VBox/SupportCard


@onready
var _app_subtitle: Label = $Background/SafeArea/LayoutContainer/HeaderContainer/VBox/LogoContainer/TitleContainer/AppSubtitle
@onready
var _resize_timer: Timer = $ResizeTimer


func _ready() -> void:
	var current_year: int = Time.get_datetime_dict_from_system().year
	_app_subtitle.text = "© %d Poing Studios" % current_year

	_resize_timer.timeout.connect(_apply_resize)
	resized.connect(_on_resized)
	_apply_resize()

	var config := ConfigFile.new()
	if config.load(Registry.SETTINGS_PATH) == OK:
		var saved_locale := config.get_value(Registry.LOCALIZATION_SECTION, Registry.LOCALE_KEY, "") as String
		if saved_locale != "":
			TranslationServer.set_locale(saved_locale)

	Registry.logger = self
	_app_title.autowrap_mode = TextServer.AUTOWRAP_OFF
	_support_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_console_output.text = tr("GAD_LogsStart")
	log_message("Main initialized")
	log_message("Plugin Version: " + MobileAds.get_version())
	log_message("Platform SDK Version: " + MobileAds.get_platform_version())

	$Background/SafeArea/LayoutContainer/HeaderContainer/VBox/SupportCard/VBox/SupportLabel.text = tr("GAD_SupportProject")

	_initialize_mobile_ads()
	_setup_tab_titles()


func _setup_tab_titles() -> void:
	_main_tabs.set_tab_title(0, "Banner")
	_main_tabs.set_tab_title(1, "Native")
	_main_tabs.set_tab_title(2, "App Open")
	_main_tabs.set_tab_title(3, "Interstitial")
	_main_tabs.set_tab_title(4, "Rewarded")
	_main_tabs.set_tab_title(5, "Rewarded Interstitial")
	_main_tabs.set_tab_title(6, "UMP")
	_main_tabs.set_tab_title(7, "Mobile Ads")


func log_message(message: String) -> void:
	print(message)
	if _console_output:
		_console_output.text += "\n" + message


func _on_resized() -> void:
	if _resize_timer:
		_resize_timer.start()


func _apply_resize() -> void:
	var vp := get_viewport_rect().size
	var win_size := get_window().size
	if vp.x <= 0 or vp.y <= 0 or win_size.x <= 0 or win_size.y <= 0:
		return

	var scale_factor := vp.y / float(win_size.y)
	var window_factor: float = (float(win_size.x) + float(win_size.y)) / 1140.0
	var total_factor: float = window_factor * scale_factor

	# Use the centralized UI scaling utility to recursively scale all controls
	UIScaler.scale_ui(self, total_factor, scale_factor)

	# Correctly hide the support card in landscape modes based on physical window height
	_support_card.visible = win_size.y >= 500


func _initialize_mobile_ads() -> void:
	var on_init_listener := OnInitializationCompleteListener.new()
	on_init_listener.on_initialization_complete = _on_initialization_complete

	var request_config := RequestConfiguration.new()
	request_config.tag_for_child_directed_treatment = (
		RequestConfiguration.TagForChildDirectedTreatment.TRUE
	)
	request_config.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.TRUE
	request_config.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
	request_config.test_device_ids = []  # Production ready

	MobileAds.set_request_configuration(request_config)
	MobileAds.initialize(on_init_listener)


func _on_initialization_complete(status: InitializationStatus) -> void:
	log_message("MobileAds initialization complete")
	_log_adapter_status(status)

	_setup_mediation_adapters()

	if OS.get_name() == "iOS":
		FBAdSettings.set_advertiser_tracking_enabled(true)


func _setup_mediation_adapters() -> void:
	# Vungle setup example
	Vungle.update_ccpa_status(Vungle.Consent.OPTED_OUT)
	Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "consent_message")

	# IronSource setup example
	IronSource.set_consent(true)
	IronSource.set_metadata("do_not_sell", "false")
	IronSource.set_user_id("unique_user_id_123")

	# AppLovin setup example
	AppLovin.set_has_user_consent(true)
	AppLovin.set_do_not_sell(false)
	AppLovin.set_muted(true)

	# BidMachine setup example
	BidMachine.set_subject_to_gdpr(true)
	BidMachine.set_consent_status(true)
	BidMachine.set_us_privacy_string("1YNN")

	# Unity Ads setup example
	UnityAds.set_consent(true)
	UnityAds.set_privacy_consent("user_privacy_data", true)

	# Chartboost setup example
	Chartboost.set_consent(true)

	# DT Exchange setup example
	DTExchange.set_gdpr_consent(true)
	DTExchange.set_gdpr_consent_string("consent_string_example")
	DTExchange.set_ccpa_string("1YNN")


func _on_get_initialization_status_pressed() -> void:
	var status := MobileAds.get_initialization_status()
	if status:
		_log_adapter_status(status)


func _log_adapter_status(status: InitializationStatus) -> void:
	for adapter_name in status.adapter_status_map:
		var adapter_status: AdapterStatus = status.adapter_status_map[adapter_name]
		var info := "[{0}] State: {1} | Latency: {2}ms | Desc: {3}".format([
				adapter_name,
				adapter_status.initialization_state,
				adapter_status.latency,
				adapter_status.description
			])
		log_message(info)
