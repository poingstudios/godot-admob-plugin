extends Node

signal initialization_complete(status, adapter_name)

signal consent_form_dismissed()
signal consent_status_changed(consent_status_message)
signal consent_form_load_failure(error_code, error_message)
signal consent_info_update_success(consent_status_message)
signal consent_info_update_failure(error_code, error_message)

signal banner_loaded()
signal banner_failed_to_load(error_code)
signal banner_opened()
signal banner_clicked()
signal banner_closed()
signal banner_recorded_impression()
signal banner_destroyed()

signal interstitial_failed_to_load(error_code)
signal interstitial_loaded()
signal interstitial_failed_to_show(error_code)
signal interstitial_opened()
signal interstitial_clicked()
signal interstitial_closed()
signal interstitial_recorded_impression()

signal rewarded_ad_failed_to_load(error_code)
signal rewarded_ad_loaded()
signal rewarded_ad_failed_to_show(error_code)
signal rewarded_ad_opened()
signal rewarded_ad_clicked()
signal rewarded_ad_closed()
signal rewarded_ad_recorded_impression()

signal rewarded_interstitial_ad_failed_to_load(error_code)
signal rewarded_interstitial_ad_loaded()
signal rewarded_interstitial_ad_failed_to_show(error_code)
signal rewarded_interstitial_ad_opened()
signal rewarded_interstitial_ad_clicked()
signal rewarded_interstitial_ad_closed()
signal rewarded_interstitial_ad_recorded_impression()

signal user_earned_rewarded(currency, amount)

var AdMobSettings = preload("res://addons/admob/src/utils/AdMobSettings.gd").new()
@onready var config = AdMobSettings.config
var _plugin : Object

func _ready() -> void:
	if config.general.is_enabled:
		if (Engine.has_singleton("AdMob")):
			_plugin = Engine.get_singleton("AdMob")
			initialize()
			_connect_signals()

func get_is_initialized() -> bool:
	if _plugin:
		return _plugin.get_is_initialized()
	return false

func initialize() -> void:
	if _plugin:
		var is_release : bool = OS.has_feature("release")
		
		var is_debug_on_release : bool = config.debug.is_debug_on_release

		var is_real : bool = false
		var is_test_europe_user_consent : bool = config.debug.is_test_europe_user_consent

		if is_release:
			is_real = true
			is_test_europe_user_consent = false

			if is_debug_on_release:
				is_real = config.debug.is_real 
				is_test_europe_user_consent = config.debug.is_test_europe_user_consent
		
		_plugin.initialize(config.general.is_for_child_directed_treatment, config.general.max_ad_content_rating, is_real, is_test_europe_user_consent)




func _connect_signals() -> void:
	_plugin.connect("initialization_complete",Callable(self,"_on_AdMob_initialization_complete"))

	_plugin.connect("consent_form_dismissed",Callable(self,"_on_AdMob_consent_form_dismissed"))
	_plugin.connect("consent_status_changed",Callable(self,"_on_AdMob_consent_status_changed"))
	_plugin.connect("consent_form_load_failure",Callable(self,"_on_AdMob_consent_form_load_failure"))
	_plugin.connect("consent_info_update_success",Callable(self,"_on_AdMob_consent_info_update_success"))
	_plugin.connect("consent_info_update_failure",Callable(self,"_on_AdMob_consent_info_update_failure"))

	_plugin.connect("banner_loaded",Callable(self,"_on_AdMob_banner_loaded"))
	_plugin.connect("banner_failed_to_load",Callable(self,"_on_AdMob_banner_failed_to_load"))
	_plugin.connect("banner_opened",Callable(self,"_on_AdMob_banner_opened"))
	_plugin.connect("banner_clicked",Callable(self,"_on_AdMob_banner_clicked"))
	_plugin.connect("banner_closed",Callable(self,"_on_AdMob_banner_closed"))
	_plugin.connect("banner_recorded_impression",Callable(self,"_on_AdMob_banner_recorded_impression"))
	_plugin.connect("banner_destroyed",Callable(self,"_on_AdMob_banner_destroyed"))

	_plugin.connect("interstitial_failed_to_load",Callable(self,"_on_AdMob_interstitial_failed_to_load"))
	_plugin.connect("interstitial_loaded",Callable(self,"_on_AdMob_interstitial_loaded"))
	_plugin.connect("interstitial_failed_to_show",Callable(self,"_on_AdMob_interstitial_failed_to_show"))
	_plugin.connect("interstitial_opened",Callable(self,"_on_AdMob_interstitial_opened"))
	_plugin.connect("interstitial_clicked",Callable(self,"_on_AdMob_interstitial_clicked"))
	_plugin.connect("interstitial_closed",Callable(self,"_on_AdMob_interstitial_closed"))
	_plugin.connect("interstitial_recorded_impression",Callable(self,"_on_AdMob_interstitial_recorded_impression"))

	_plugin.connect("rewarded_ad_failed_to_load",Callable(self,"_on_AdMob_rewarded_ad_failed_to_load"))
	_plugin.connect("rewarded_ad_loaded",Callable(self,"_on_AdMob_rewarded_ad_loaded"))
	_plugin.connect("rewarded_ad_failed_to_show",Callable(self,"_on_AdMob_rewarded_ad_failed_to_show"))
	_plugin.connect("rewarded_ad_opened",Callable(self,"_on_AdMob_rewarded_ad_opened"))
	_plugin.connect("rewarded_ad_clicked",Callable(self,"_on_AdMob_rewarded_ad_clicked"))
	_plugin.connect("rewarded_ad_closed",Callable(self,"_on_AdMob_rewarded_ad_closed"))
	_plugin.connect("rewarded_ad_recorded_impression",Callable(self,"_on_AdMob_rewarded_ad_recorded_impression"))

	_plugin.connect("rewarded_interstitial_ad_failed_to_load",Callable(self,"_on_AdMob_rewarded_interstitial_ad_failed_to_load"))
	_plugin.connect("rewarded_interstitial_ad_loaded",Callable(self,"_on_AdMob_rewarded_interstitial_ad_loaded"))
	_plugin.connect("rewarded_interstitial_ad_failed_to_show",Callable(self,"_on_AdMob_rewarded_interstitial_ad_failed_to_show"))
	_plugin.connect("rewarded_interstitial_ad_opened",Callable(self,"_on_AdMob_rewarded_interstitial_ad_opened"))
	_plugin.connect("rewarded_interstitial_ad_clicked",Callable(self,"_on_AdMob_rewarded_interstitial_ad_clicked"))
	_plugin.connect("rewarded_interstitial_ad_closed",Callable(self,"_on_AdMob_rewarded_interstitial_ad_closed"))
	_plugin.connect("rewarded_interstitial_ad_recorded_impression",Callable(self,"_on_AdMob_rewarded_interstitial_ad_recorded_impression"))

	_plugin.connect("user_earned_rewarded",Callable(self,"_on_AdMob_user_earned_rewarded"))


func _on_AdMob_initialization_complete(status : int, adapter_name : String) -> void:
	emit_signal("initialization_complete", status, adapter_name)

func _on_AdMob_consent_form_dismissed() -> void:
	emit_signal("consent_form_dismissed")
func _on_AdMob_consent_status_changed(consent_status_message : String) -> void:
	emit_signal("consent_status_changed", consent_status_message)
func _on_AdMob_consent_form_load_failure(error_code : int, error_message: String) -> void:
	emit_signal("consent_form_load_failure", error_code, error_message)
func _on_AdMob_consent_info_update_success(consent_status_message : String) -> void:
	emit_signal("consent_info_update_success", consent_status_message)
func _on_AdMob_consent_info_update_failure(error_code : int, error_message : String) -> void:
	emit_signal("consent_info_update_failure", error_code, error_message)

func _on_AdMob_banner_loaded() -> void:
	emit_signal("banner_loaded")
func _on_AdMob_banner_failed_to_load(error_code : int) -> void:
	emit_signal("banner_failed_to_load", error_code)
func _on_AdMob_banner_opened() -> void:
	emit_signal("banner_loaded")
func _on_AdMob_banner_clicked() -> void:
	emit_signal("banner_clicked")
func _on_AdMob_banner_closed() -> void:
	emit_signal("banner_closed")
func _on_AdMob_banner_recorded_impression() -> void:
	emit_signal("banner_recorded_impression")
func _on_AdMob_banner_destroyed() -> void:
	emit_signal("banner_destroyed")

func _on_AdMob_interstitial_failed_to_load(error_code : int) -> void:
	emit_signal("interstitial_failed_to_load", error_code)
func _on_AdMob_interstitial_loaded() -> void:
	emit_signal("interstitial_loaded")
func _on_AdMob_interstitial_failed_to_show(error_code : int) -> void:
	emit_signal("interstitial_failed_to_show", error_code)
func _on_AdMob_interstitial_opened() -> void:
	emit_signal("interstitial_opened")
func _on_AdMob_interstitial_clicked() -> void:
	emit_signal("interstitial_clicked")
func _on_AdMob_interstitial_closed() -> void:
	emit_signal("interstitial_closed")
func _on_AdMob_interstitial_recorded_impression() -> void:
	emit_signal("interstitial_recorded_impression")

func _on_AdMob_rewarded_ad_failed_to_load(error_code : int) -> void:
	emit_signal("rewarded_ad_failed_to_load", error_code)
func _on_AdMob_rewarded_ad_loaded() -> void:
	emit_signal("rewarded_ad_loaded")
func _on_AdMob_rewarded_ad_failed_to_show(error_code : int) -> void:
	emit_signal("rewarded_ad_failed_to_show", error_code)
func _on_AdMob_rewarded_ad_opened() -> void:
	emit_signal("rewarded_ad_opened")
func _on_AdMob_rewarded_ad_clicked() -> void:
	emit_signal("rewarded_ad_clicked")
func _on_AdMob_rewarded_ad_closed() -> void:
	emit_signal("rewarded_ad_closed")
func _on_AdMob_rewarded_ad_recorded_impression() -> void:
	emit_signal("rewarded_ad_recorded_impression")

func _on_AdMob_rewarded_interstitial_ad_failed_to_load(error_code : int) -> void:
	emit_signal("rewarded_interstitial_ad_failed_to_load", error_code)
func _on_AdMob_rewarded_interstitial_ad_loaded() -> void:
	emit_signal("rewarded_interstitial_ad_loaded")
func _on_AdMob_rewarded_interstitial_ad_failed_to_show(error_code : int) -> void:
	emit_signal("rewarded_interstitial_ad_failed_to_show", error_code)
func _on_AdMob_rewarded_interstitial_ad_opened() -> void:
	emit_signal("rewarded_interstitial_ad_opened")
func _on_AdMob_rewarded_interstitial_ad_clicked() -> void:
	emit_signal("rewarded_interstitial_ad_clicked")
func _on_AdMob_rewarded_interstitial_ad_closed() -> void:
	emit_signal("rewarded_interstitial_ad_closed")
func _on_AdMob_rewarded_interstitial_ad_recorded_impression() -> void:
	emit_signal("rewarded_interstitial_ad_recorded_impression")

func _on_AdMob_user_earned_rewarded(currency : String, amount : int) -> void:
	emit_signal("user_earned_rewarded", currency, amount)
