extends Control

var _banner_path = "Background/TabContainer/AdFormats/VBoxContainer/Banner/"
var _banner2_path = "Background/TabContainer/AdFormats/VBoxContainer/Banner2/"
var _ad_formats_path = "Background/TabContainer/AdFormats/VBoxContainer/"
var _ump_path = "Background/TabContainer/UMP/VBoxContainer/"
var _banner_cfg_path = "Background/TabContainer/Banner/VBoxContainer/"

onready var enable_banner : Button = get_node(_banner_path + "EnableBanner")
onready var disable_banner : Button = get_node(_banner_path + "DisableBanner")
onready var show_banner_btn : Button = get_node(_banner2_path + "ShowBanner")
onready var hide_banner_btn : Button = get_node(_banner2_path + "HideBanner")

onready var interstitial_btn : Button = get_node(_ad_formats_path + "Interstitial")
onready var rewarded_btn : Button = get_node(_ad_formats_path + "Rewarded")
onready var rewarded_interstitial_btn : Button = get_node(_ad_formats_path + "RewardedInterstitial")

onready var request_user_consent_btn : Button = get_node(_ump_path + "RequestUserConsent")
onready var reset_consent_state_btn : Button = get_node(_ump_path + "ResetConsentState")

onready var advice_label : RichTextLabel = $Background/Advice

onready var banner_position_check : CheckBox = get_node(_banner_cfg_path + "Position")
onready var respect_safe_area_check : CheckBox = get_node(_banner_cfg_path + "RespectSafeArea")
onready var banner_sizes : ItemList = get_node(_banner_cfg_path + "BannerSizes")

func _add_text_advice_node(text_value : String) -> void:
	advice_label.bbcode_text += text_value + "\n"

func _ready() -> void:
	banner_position_check.pressed = MobileAds.ad_mob_settings.config.banner.position
	respect_safe_area_check.pressed = MobileAds.ad_mob_settings.config.banner.respect_safe_area

	OS.center_window()
	for banner_size in MobileAds.ad_mob_settings.BANNER_SIZE:
		banner_sizes.add_item(banner_size)
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"consent_form_dismissed", self,
			"_on_MobileAds_consent_form_dismissed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"consent_form_load_failure", self,
			"_on_MobileAds_consent_form_load_failure"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"consent_info_update_failure", self,
			"_on_MobileAds_consent_info_update_failure"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"consent_info_update_success", self,
			"_on_MobileAds_consent_info_update_success"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"consent_status_changed", self,
			"_on_MobileAds_consent_status_changed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_loaded", self,
			"_on_MobileAds_banner_loaded"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_destroyed", self,
			"_on_MobileAds_banner_destroyed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_clicked", self,
			"_on_MobileAds_banner_clicked"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_closed", self,
			"_on_MobileAds_banner_closed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_failed_to_load", self,
			"_on_MobileAds_banner_failed_to_load"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"banner_recorded_impression", self,
			"_on_MobileAds_banner_recorded_impression"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_loaded", self,
			"_on_MobileAds_interstitial_loaded"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_closed", self,
			"_on_MobileAds_interstitial_closed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_clicked", self,
			"_on_MobileAds_interstitial_clicked"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_failed_to_load", self,
			"_on_MobileAds_interstitial_failed_to_load"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_failed_to_show", self,
			"_on_MobileAds_interstitial_failed_to_show"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_opened", self,
			"_on_MobileAds_interstitial_opened"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"interstitial_recorded_impression", self,
			"_on_MobileAds_interstitial_recorded_impression"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_loaded", self,
			"_on_MobileAds_rewarded_ad_loaded"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_closed", self,
			"_on_MobileAds_rewarded_ad_closed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_clicked", self,
			"_on_MobileAds_rewarded_ad_clicked"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_failed_to_load", self,
			"_on_MobileAds_rewarded_ad_failed_to_load"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_failed_to_show", self,
			"_on_MobileAds_rewarded_ad_failed_to_show"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_opened", self,
			"_on_MobileAds_rewarded_ad_opened"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_ad_recorded_impression", self,
			"_on_MobileAds_rewarded_ad_recorded_impression"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_loaded", self,
			"_on_MobileAds_rewarded_interstitial_ad_loaded"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_closed", self,
			"_on_MobileAds_rewarded_interstitial_ad_closed"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_clicked", self,
			"_on_MobileAds_rewarded_interstitial_ad_clicked"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_failed_to_load", self,
			"_on_MobileAds_rewarded_interstitial_ad_failed_to_load"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_failed_to_show", self,
			"_on_MobileAds_rewarded_interstitial_ad_failed_to_show"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_opened", self,
			"_on_MobileAds_rewarded_interstitial_ad_opened"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"rewarded_interstitial_ad_recorded_impression", self,
			"_on_MobileAds_rewarded_interstitial_ad_recorded_impression"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"user_earned_rewarded", self,
			"_on_MobileAds_user_earned_rewarded"
		)
		# warning-ignore:return_value_discarded
		MobileAds.connect(
			"initialization_complete", self,
			"_on_MobileAds_initialization_complete"
		)
	else:
		_add_text_advice_node(
			"AdMob only works on Android or iOS devices!"
		)

func _on_MobileAds_rewarded_interstitial_ad_clicked():
	_add_text_advice_node("Rewarded Interstitial clicked")

func _on_MobileAds_rewarded_interstitial_ad_failed_to_load(
	_error_code
):
	_add_text_advice_node(
		"Rewarded Interstitial failed to load, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_rewarded_interstitial_ad_failed_to_show(
	_error_code
):
	_add_text_advice_node(
		"Rewarded Interstitial failed to show, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_rewarded_interstitial_ad_opened():
	_add_text_advice_node("Rewarded Interstitial opened")

func _on_MobileAds_rewarded_interstitial_ad_recorded_impression():
	_add_text_advice_node(
		"Rewarded Interstitial recorded impression"
	)

func _on_MobileAds_rewarded_ad_clicked():
	_add_text_advice_node("Rewarded clicked")

func _on_MobileAds_rewarded_ad_failed_to_load(_error_code):
	_add_text_advice_node(
		"Rewarded failed to load, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_rewarded_ad_failed_to_show(_error_code):
	_add_text_advice_node(
		"Rewarded failed to show, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_rewarded_ad_opened():
	_add_text_advice_node("Rewarded opened")

func _on_MobileAds_rewarded_ad_recorded_impression():
	_add_text_advice_node("Rewarded recorded impression")


func _on_MobileAds_interstitial_clicked():
	_add_text_advice_node("Interstitial clicked")

func _on_MobileAds_interstitial_failed_to_load(_error_code):
	_add_text_advice_node(
		"Interstitial failed to load, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_interstitial_failed_to_show(_error_code):
	_add_text_advice_node(
		"Interstitial failed to show, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_interstitial_opened():
	_add_text_advice_node("Interstitial opened")

func _on_MobileAds_interstitial_recorded_impression():
	_add_text_advice_node("Interstitial recorded impression")

func _on_MobileAds_banner_clicked():
	_add_text_advice_node("Banner clicked")

func _on_MobileAds_banner_closed():
	_add_text_advice_node("Banner closed")

func _on_MobileAds_banner_failed_to_load(_error_code):
	_add_text_advice_node(
		"Banner failed to load, "
		+ "error_code = " + str(_error_code)
	)

func _on_MobileAds_banner_recorded_impression():
	_add_text_advice_node("Banner recorded impression")

func _on_MobileAds_initialization_complete(
	status : int, _adapter_name : String
) -> void:
	if status == MobileAds.ad_mob_settings.InitializationStatus.READY:
		MobileAds.load_interstitial()
		MobileAds.load_rewarded()
		MobileAds.load_rewarded_interstitial()
		_add_text_advice_node(
			"AdMob initialized on GDScript! With parameters:"
		)
		_add_text_advice_node(
			JSON.print(MobileAds.config, "\t")
		)
		_add_text_advice_node(
			"instance_id: " + str(get_instance_id())
		)
		enable_banner.disabled = false
		banner_position_check.disabled = false
		request_user_consent_btn.disabled = false
		reset_consent_state_btn.disabled = false
	else:
		_add_text_advice_node(
			"AdMob not initialized, check your configuration"
		)
	_add_text_advice_node(
		"---------------------------------------------------"
	)

func _on_MobileAds_interstitial_loaded() -> void:
	interstitial_btn.disabled = false
	_add_text_advice_node("Interstitial loaded")

func _on_MobileAds_interstitial_closed() -> void:
	MobileAds.load_interstitial()
	_add_text_advice_node("Interstitial closed")

func _on_Interstitial_pressed() -> void:
	MobileAds.show_interstitial()
	interstitial_btn.disabled = true

func reset_banner_buttons() -> void:
	disable_banner.disabled = true
	enable_banner.disabled = false
	show_banner_btn.disabled = true
	hide_banner_btn.disabled = true

func _on_MobileAds_banner_destroyed() -> void:
	reset_banner_buttons()
	_add_text_advice_node("Banner destroyed")

func _on_MobileAds_banner_loaded() -> void:
	disable_banner.disabled = false
	enable_banner.disabled = true
	show_banner_btn.disabled = false
	hide_banner_btn.disabled = false
	_add_text_advice_node("Banner loaded")
	_add_text_advice_node(
		"Banner width: "
		+ str(MobileAds.get_banner_width())
	)
	_add_text_advice_node(
		"Banner height: "
		+ str(MobileAds.get_banner_height())
	)
	_add_text_advice_node(
		"Banner width in pixels: "
		+ str(MobileAds.get_banner_width_in_pixels())
	)
	_add_text_advice_node(
		"Banner height in pixels: "
		+ str(MobileAds.get_banner_height_in_pixels())
	)

func _on_EnableBanner_pressed() -> void:
	enable_banner.disabled = true
	MobileAds.load_banner()

func _on_DisableBanner_pressed() -> void:
	disable_banner.disabled = true
	enable_banner.disabled = false
	MobileAds.destroy_banner()

func _on_Rewarded_pressed() -> void:
	MobileAds.show_rewarded()
	rewarded_btn.disabled = true

func _on_RewardedInterstitial_pressed() -> void:
	MobileAds.show_rewarded_interstitial()
	rewarded_interstitial_btn.disabled = true

func _on_MobileAds_rewarded_ad_loaded() -> void:
	rewarded_btn.disabled = false
	_add_text_advice_node("Rewarded ad loaded")

func _on_MobileAds_rewarded_ad_closed() -> void:
	MobileAds.load_rewarded()
	_add_text_advice_node("Rewarded ad closed")

func _on_MobileAds_rewarded_interstitial_ad_loaded() -> void:
	rewarded_interstitial_btn.disabled = false
	_add_text_advice_node("Rewarded Interstitial ad loaded")

func _on_MobileAds_rewarded_interstitial_ad_closed() -> void:
	MobileAds.load_rewarded_interstitial()
	_add_text_advice_node("Rewarded Interstitial ad closed")

func _on_MobileAds_user_earned_rewarded(
	currency : String, amount : int
) -> void:
	advice_label.bbcode_text += (
		"EARNED " + currency
		+ " with amount: " + str(amount) + "\n"
	)

func _on_MobileAds_consent_form_dismissed() -> void:
	_add_text_advice_node(
		"Request Consent from European Users Form dismissed"
	)

func _on_MobileAds_consent_form_load_failure(
	_error_code, _error_message
) -> void:
	_add_text_advice_node(
		"Request Consent from European Users load_failure: "
		+ _error_message
	)
	_add_text_advice_node(
		"---------------------------------------------------"
	)

func _on_MobileAds_consent_info_update_failure(
	_error_code : int, error_message : String
) -> void:
	_add_text_advice_node(
		"Request Consent from European Users update failure: "
		+ error_message
	)
	_add_text_advice_node(
		"---------------------------------------------------"
	)

func _on_MobileAds_consent_info_update_success(
	status_message : String
) -> void:
	_add_text_advice_node(
		"Consent info update success: " + status_message
	)

func _on_MobileAds_consent_status_changed(
	status_message : String
) -> void:
	_add_text_advice_node(
		"Consent status changed: " + status_message
	)

func _on_BannerSizes_item_selected(index : int) -> void:
	if MobileAds.get_is_initialized():
		var item_text : String = banner_sizes.get_item_text(index)
		MobileAds.config.banner.size = item_text
		_add_text_advice_node(
			"Banner Size changed:" + item_text
		)
		if MobileAds.get_is_banner_loaded():
			MobileAds.load_banner()

func _on_ResetConsentState_pressed() -> void:
	MobileAds.reset_consent_state(true)

func _on_RequestUserConsent_pressed() -> void:
	MobileAds.request_user_consent()


func _on_Position_pressed() -> void:
	MobileAds.config.banner.position = banner_position_check.pressed
	if MobileAds.get_is_banner_loaded():
		MobileAds.load_banner()

func _on_RespectSafeArea_pressed():
	MobileAds.config.banner.respect_safe_area = (
		respect_safe_area_check.pressed
	)
	if MobileAds.get_is_banner_loaded():
		MobileAds.load_banner()

func _on_IsInitialized_pressed() -> void:
	_add_text_advice_node(
		"Is initialized: "
		+ str(MobileAds.get_is_initialized())
	)


func _on_IsBannerLoaded_pressed() -> void:
	_add_text_advice_node(
		"Is Banner loaded: "
		+ str(MobileAds.get_is_banner_loaded())
	)


func _on_IsInterstitialLoaded_pressed() -> void:
	_add_text_advice_node(
		"Is Interstitial loaded: "
		+ str(MobileAds.get_is_interstitial_loaded())
	)


func _on_IsRewardedLoaded_pressed() -> void:
	_add_text_advice_node(
		"Is Rewarded loaded: "
		+ str(MobileAds.get_is_rewarded_loaded())
	)


func _on_IsRewardedInterstitialLoaded_pressed() -> void:
	_add_text_advice_node(
		"Is RewardedInterstitial loaded: "
		+ str(MobileAds.get_is_rewarded_interstitial_loaded())
	)


func _on_ShowBanner_pressed() -> void:
	MobileAds.show_banner()

func _on_HideBanner_pressed() -> void:
	MobileAds.hide_banner()
