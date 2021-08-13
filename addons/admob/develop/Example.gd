extends Control

onready var EnableBanner : Button = $Background/TabContainer/AdFormats/VBoxContainer/Banner/EnableBanner
onready var DisableBanner : Button = $Background/TabContainer/AdFormats/VBoxContainer/Banner/DisableBanner
onready var ShowBanner : Button = $Background/TabContainer/AdFormats/VBoxContainer/Banner2/ShowBanner
onready var HideBanner : Button = $Background/TabContainer/AdFormats/VBoxContainer/Banner2/HideBanner

onready var Interstitial : Button = $Background/TabContainer/AdFormats/VBoxContainer/Interstitial
onready var Rewarded : Button = $Background/TabContainer/AdFormats/VBoxContainer/Rewarded
onready var RewardedInterstitial : Button = $Background/TabContainer/AdFormats/VBoxContainer/RewardedInterstitial

onready var RequestUserConsent : Button = $Background/TabContainer/UMP/VBoxContainer/RequestUserConsent
onready var ResetConsentState : Button = $Background/TabContainer/UMP/VBoxContainer/ResetConsentState

onready var Advice : RichTextLabel = $Background/Advice
onready var Music : AudioStreamPlayer = $Music

onready var BannerPosition : CheckBox = $Background/TabContainer/Banner/VBoxContainer/Position
onready var BannerSizes : ItemList = $Background/TabContainer/Banner/VBoxContainer/BannerSizes

func _add_text_Advice_Node(text_value : String):
	Advice.bbcode_text += text_value + "\n"

func _ready():
	OS.center_window()
	Music.play()
	for banner_size in MobileAds.BANNER_SIZE:
		BannerSizes.add_item(banner_size)
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		BannerPosition.pressed = MobileAds.config.banner.position
		MobileAds.request_user_consent()
		# warning-ignore:return_value_discarded
		MobileAds.connect("consent_info_update_failure", self, "_on_MobileAds_consent_info_update_failure")
		# warning-ignore:return_value_discarded
		MobileAds.connect("consent_status_changed", self, "_on_MobileAds_consent_status_changed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("banner_loaded", self, "_on_MobileAds_banner_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("banner_destroyed", self, "_on_MobileAds_banner_destroyed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("interstitial_loaded", self, "_on_MobileAds_interstitial_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("interstitial_closed", self, "_on_MobileAds_interstitial_closed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_ad_loaded", self, "_on_MobileAds_rewarded_ad_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_ad_closed", self, "_on_MobileAds_rewarded_ad_closed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_interstitial_ad_loaded", self, "_on_MobileAds_rewarded_interstitial_ad_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_interstitial_ad_closed", self, "_on_MobileAds_rewarded_interstitial_ad_closed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("user_earned_rewarded", self, "_on_MobileAds_user_earned_rewarded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("initialization_complete", self, "_on_MobileAds_initialization_complete")
	else:
		_add_text_Advice_Node("AdMob only works on Android or iOS devices!")

func _on_MobileAds_initialization_complete(status, _adapter_name):
	if status == MobileAds.INITIALIZATION_STATUS.READY:
		MobileAds.load_interstitial()
		MobileAds.load_rewarded()
		MobileAds.load_rewarded_interstitial()
		_add_text_Advice_Node("AdMob initialized on GDScript! With parameters:")
		_add_text_Advice_Node("is_real: " + str(MobileAds.config.is_real))
		_add_text_Advice_Node("is_for_child_directed_treatment: " + str(MobileAds.config.is_for_child_directed_treatment))
		_add_text_Advice_Node("max_ad_content_rating: " + str(MobileAds.config.max_ad_content_rating))
		_add_text_Advice_Node("instance_id: " + str(get_instance_id()))
		EnableBanner.disabled = false
		BannerPosition.disabled = false
		RequestUserConsent.disabled = false
		ResetConsentState.disabled = false
	else:
		_add_text_Advice_Node("AdMob not initialized, check your configuration")
	_add_text_Advice_Node("---------------------------------------------------")
func _on_MobileAds_interstitial_loaded():
	Interstitial.disabled = false
	_add_text_Advice_Node("Interstitial loaded")

func _on_MobileAds_interstitial_closed():
	MobileAds.load_interstitial()
	_add_text_Advice_Node("Interstitial closed")

func _on_Interstitial_pressed():
	MobileAds.show_interstitial()
	MobileAds.load_interstitial()
	Interstitial.disabled = true

func reset_banner_buttons():
	DisableBanner.disabled = true
	EnableBanner.disabled = false
	ShowBanner.disabled = true
	HideBanner.disabled = true

func _on_MobileAds_banner_destroyed():
	reset_banner_buttons()
	_add_text_Advice_Node("Banner destroyed")

func _on_MobileAds_banner_loaded():
	DisableBanner.disabled = false
	EnableBanner.disabled = true
	ShowBanner.disabled = false
	HideBanner.disabled = false
	_add_text_Advice_Node("Banner loaded")
	_add_text_Advice_Node("Banner width: " + str(MobileAds.get_banner_width()))
	_add_text_Advice_Node("Banner height: " + str(MobileAds.get_banner_height()))
	_add_text_Advice_Node("Banner width in pixels: " + str(MobileAds.get_banner_width_in_pixels()))
	_add_text_Advice_Node("Banner height in pixels: " + str(MobileAds.get_banner_height_in_pixels()))

func _on_EnableBanner_pressed():
	EnableBanner.disabled = true
	MobileAds.load_banner()

func _on_DisableBanner_pressed():
	DisableBanner.disabled = true
	EnableBanner.disabled = false
	MobileAds.destroy_banner()

func _on_Rewarded_pressed():
	MobileAds.show_rewarded()
	MobileAds.load_rewarded()
	Rewarded.disabled = true

func _on_RewardedInterstitial_pressed():
	MobileAds.show_rewarded_interstitial()
	MobileAds.load_rewarded_interstitial()
	RewardedInterstitial.disabled = true

func _on_MobileAds_rewarded_ad_loaded():
	Rewarded.disabled = false
	_add_text_Advice_Node("Rewarded ad loaded")
	
func _on_MobileAds_rewarded_ad_closed():
	MobileAds.load_rewarded()
	_add_text_Advice_Node("Rewarded ad closed")

func _on_MobileAds_rewarded_interstitial_ad_loaded():
	RewardedInterstitial.disabled = false
	_add_text_Advice_Node("Rewarded Interstitial ad loaded")
	
func _on_MobileAds_rewarded_interstitial_ad_closed():
	MobileAds.load_rewarded_interstitial()
	_add_text_Advice_Node("Rewarded Interstitial ad closed")
	
func _on_MobileAds_user_earned_rewarded(currency : String, amount : int):
	Advice.bbcode_text += "EARNED " + currency + " with amount: " + str(amount) + "\n"

func _on_MobileAds_consent_info_update_failure(_error_code : int, error_message : String):
	_add_text_Advice_Node(error_message)

func _on_MobileAds_consent_status_changed(status_message : String):
	_add_text_Advice_Node(status_message)


func _on_BannerSizes_item_selected(index):
	if MobileAds.get_is_initialized():
		var item_text : String = BannerSizes.get_item_text(index)
		MobileAds.config.banner.size = index
		_add_text_Advice_Node("Banner Size changed:" + item_text)
		if MobileAds.get_is_banner_loaded():
			MobileAds.load_banner()

func _on_ResetConsentState_pressed():
	MobileAds.reset_consent_state(true)

func _on_RequestUserConsent_pressed():
	MobileAds.request_user_consent()


func _on_Position_pressed():
	MobileAds.config.banner.position = BannerPosition.pressed
	if MobileAds.get_is_banner_loaded():
		MobileAds.load_banner()


func _on_IsInitialized_pressed():
	_add_text_Advice_Node("Is initialized: " + str(MobileAds.get_is_initialized()))


func _on_IsBannerLoaded_pressed():
	_add_text_Advice_Node("Is Banner loaded: " + str(MobileAds.get_is_banner_loaded()))


func _on_IsInterstitialLoaded_pressed():
	_add_text_Advice_Node("Is Interstitial loaded: " + str(MobileAds.get_is_interstitial_loaded()))


func _on_IsRewardedLoaded_pressed():
	_add_text_Advice_Node("Is Rewarded loaded: " + str(MobileAds.get_is_rewarded_loaded()))


func _on_IsRewardedInterstitialLoaded_pressed():
	_add_text_Advice_Node("Is RewardedInterstitial loaded: " + str(MobileAds.get_is_rewarded_interstitial_loaded()))


func _on_ShowBanner_pressed():
	MobileAds.show_banner()

func _on_HideBanner_pressed():
	MobileAds.hide_banner()
