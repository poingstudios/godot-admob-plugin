extends Control

onready var EnableBanner : Button = $Background/CenterContainer/VBoxContainer/Banner/EnableBanner
onready var DisableBanner : Button = $Background/CenterContainer/VBoxContainer/Banner/DisableBanner
onready var Interstitial : Button = $Background/CenterContainer/VBoxContainer/Interstitial
onready var Rewarded : Button = $Background/CenterContainer/VBoxContainer/Rewarded
onready var EnableNative : Button = $Background/CenterContainer/VBoxContainer/UnifiedNative/EnableUnifiedNative
onready var DisableNative : Button = $Background/CenterContainer/VBoxContainer/UnifiedNative/DisableUnifiedNative
onready var UnifiedNativePanel : Panel = $Background/UnifiedNative
onready var UnifiedNativeHBox : HBoxContainer = $Background/CenterContainer/VBoxContainer/UnifiedNative
onready var Advice : RichTextLabel = $Background/Advice
onready var Music : AudioStreamPlayer = $Music

func _add_text_Advice_Node(text_value : String):
	Advice.bbcode_text += text_value + "\n"

func _ready():
	OS.center_window()
	Music.play()
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		for banner_size in MobileAds.BANNER_SIZE:
			Music.add_item(banner_size)
		
		# warning-ignore:return_value_discarded
		MobileAds.connect("consent_info_update_failure", self, "_on_AdMobAPI_consent_info_update_failure")
		# warning-ignore:return_value_discarded
		MobileAds.connect("consent_status_changed", self, "_on_AdMobAPI_consent_status_changed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("banner_loaded", self, "_on_AdMobAPI_banner_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("banner_destroyed", self, "_on_AdMobAPI_banner_destroyed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("interstitial_loaded", self, "_on_AdMobAPI_interstitial_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("interstitial_closed", self, "_on_AdMobAPI_interstitial_closed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_ad_loaded", self, "_on_AdMobAPI_rewarded_ad_loaded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_ad_closed", self, "_on_AdMobAPI_rewarded_ad_closed")
		# warning-ignore:return_value_discarded
		MobileAds.connect("rewarded_user_earned_rewarded", self, "_on_AdMobAPI_rewarded_user_earned_rewarded")
		# warning-ignore:return_value_discarded
		MobileAds.connect("initialization_complete", self, "_on_AdMobAPI_initialization_complete")
		if OS.get_name() == "Android":
			# warning-ignore:return_value_discarded
			MobileAds.connect("native_loaded", self, "_on_AdMobAPI_native_loaded")
			# warning-ignore:return_value_discarded
			MobileAds.connect("native_destroyed", self, "_on_AdMobAPI_native_destroyed")
		else:
			UnifiedNativePanel.hide()
			UnifiedNativeHBox.hide()
	else:
		_add_text_Advice_Node("AdMob only works on Android or iOS devices!")

func _on_AdMobAPI_initialization_complete(status, _adapter_name):
	if status == MobileAds.INITIALIZATION_STATUS.READY:
		MobileAds.load_interstitial()
		MobileAds.load_rewarded()
		_add_text_Advice_Node("AdMob initialized! With parameters:")
		_add_text_Advice_Node("is_real: " + str(MobileAds.config.is_real))
		_add_text_Advice_Node("is_for_child_directed_treatment: " + str(MobileAds.config.is_for_child_directed_treatment))
		_add_text_Advice_Node("max_ad_content_rating: " + str(MobileAds.config.max_ad_content_rating))
		_add_text_Advice_Node("instance_id: " + str(get_instance_id()))
		EnableBanner.disabled = false
		EnableNative.disabled = false
	else:
		_add_text_Advice_Node("AdMob not initialized, check your configuration")
	_add_text_Advice_Node("---------------------------------------------------")
func _on_AdMobAPI_interstitial_loaded():
	Interstitial.disabled = false
	_add_text_Advice_Node("Interstitial loaded")

func _on_AdMobAPI_interstitial_closed():
	MobileAds.load_interstitial()
	_add_text_Advice_Node("Interstitial closed")

func _on_Interstitial_pressed():
	MobileAds.show_interstitial()
	Interstitial.disabled = true
	
func reset_banner_and_native_buttons():
	DisableBanner.disabled = true
	DisableNative.disabled = true
	EnableBanner.disabled = false
	EnableNative.disabled = false

func _on_AdMobAPI_banner_destroyed():
	reset_banner_and_native_buttons()
	_add_text_Advice_Node("Banner destroyed")

func _on_AdMobAPI_native_destroyed():
	reset_banner_and_native_buttons()
	_add_text_Advice_Node("Unified Natived destroyed")

func _on_AdMobAPI_banner_loaded():
	DisableNative.disabled = true
	DisableBanner.disabled = false
	EnableBanner.disabled = true
	EnableNative.disabled = true
	_add_text_Advice_Node("Banner loaded")

func _on_EnableBanner_pressed():
	EnableBanner.disabled = true
	EnableNative.disabled = true
	MobileAds.load_banner()

func _on_DisableBanner_pressed():
	DisableBanner.disabled = true
	EnableBanner.disabled = false
	EnableNative.disabled = false
	MobileAds.destroy_banner()

func _on_Rewarded_pressed():
	MobileAds.show_rewarded()
	Rewarded.disabled = true
	
func _on_AdMobAPI_rewarded_ad_loaded():
	Rewarded.disabled = false
	_add_text_Advice_Node("Rewarded ad loaded")
	
func _on_AdMobAPI_rewarded_ad_closed():
	MobileAds.load_rewarded()
	_add_text_Advice_Node("Rewarded ad closed")
	
func _on_AdMobAPI_rewarded_user_earned_rewarded(currency : String, amount : int):
	Advice.bbcode_text += "EARNED " + currency + " with amount: " + str(amount) + "\n"

func _on_AdMobAPI_consent_info_update_failure(_error_code : int, error_message : String):
	_add_text_Advice_Node(error_message)

func _on_AdMobAPI_consent_status_changed(status_message : String):
	_add_text_Advice_Node(status_message)


func _on_AdMobAPI_native_loaded():
	DisableNative.disabled = false
	DisableBanner.disabled = true
	EnableBanner.disabled = true
	EnableNative.disabled = true
	_add_text_Advice_Node("Unified Native loaded")

func _on_EnableUnifiedNative_pressed():
	EnableNative.disabled = true
	EnableBanner.disabled = true
	MobileAds.load_native($Background/UnifiedNative)

func _on_DisableUnifiedNative_pressed():
	DisableNative.disabled = true
	EnableNative.disabled = false
	EnableBanner.disabled = false
	MobileAds.destroy_native()


func _on_BannerSizes_item_selected(index):
	if MobileAds.is_initialized:
		var item_text : String = $Background/BannerSizes.get_item_text(index)
		MobileAds.config.banner.size = index
		_add_text_Advice_Node("Banner Size changed:" + item_text)
		if MobileAds.banner_enabled:
			MobileAds.load_banner()
