extends "Variables.gd"

signal banner_loaded()
signal banner_destroyed()
signal banner_failed_to_load(error_code)
signal banner_opened()
signal banner_clicked()
signal banner_closed()
signal banner_recorded_impression()

signal interstitial_loaded()
signal interstitial_failed_to_load(error_code)
signal interstitial_opened()
signal interstitial_clicked()
signal interstitial_left_application()
signal interstitial_closed()

signal rewarded_ad_loaded()
signal rewarded_ad_failed_to_load()
signal rewarded_ad_opened()
signal rewarded_ad_closed()
signal rewarded_ad_failed_to_show(error_code)

signal user_earned_rewarded(currency, amount) #for Rewarded and Rewarded Interstitial

signal rewarded_interstitial_ad_loaded()
signal rewarded_interstitial_ad_failed_to_load()
signal rewarded_interstitial_ad_opened()
signal rewarded_interstitial_ad_closed()
signal rewarded_interstitial_ad_failed_to_show(error_code)

signal consent_form_dismissed()
signal consent_status_changed(consent_status_message)
signal consent_form_load_failure(error_code, error_message)
signal consent_info_update_success(consent_status_message)
signal consent_info_update_failure(error_code, error_message)

signal initialization_complete(status, adapter_name)

#SIGNALS
func _on_AdMob_banner_loaded():
	emit_signal("banner_loaded")
	
func _on_AdMob_banner_destroyed():
	emit_signal("banner_destroyed")

func _on_AdMob_banner_failed_to_load(error_code : int):
	emit_signal("banner_failed_to_load", error_code)
	
func _on_AdMob_banner_opened():
	emit_signal("banner_opened")
	
func _on_AdMob_banner_clicked():
	emit_signal("banner_clicked")
	
func _on_AdMob_banner_closed():
	emit_signal("banner_closed")

func _on_AdMob_banner_recorded_impression():
	emit_signal("banner_recorded_impression")


func _on_AdMob_interstitial_loaded():
	emit_signal("interstitial_loaded")

func _on_AdMob_interstitial_failed_to_load(error_code : int):
	emit_signal("interstitial_failed_to_load", error_code)
	
func _on_AdMob_interstitial_clicked():
	emit_signal("interstitial_clicked")
	
func _on_AdMob_interstitial_left_application():
	emit_signal("interstitial_left_application")

func _on_AdMob_interstitial_opened():
	emit_signal("interstitial_opened")

func _on_AdMob_interstitial_closed():
	emit_signal("interstitial_closed")


func _on_AdMob_rewarded_ad_loaded():
	emit_signal("rewarded_ad_loaded")

func _on_AdMob_rewarded_ad_opened():
	emit_signal("rewarded_ad_opened")

func _on_AdMob_rewarded_ad_closed():
	emit_signal("rewarded_ad_closed")

func _on_AdMob_rewarded_ad_failed_to_load(error_code : int):
	emit_signal("rewarded_ad_failed_to_load")
	
func _on_AdMob_user_earned_rewarded(currency : String, amount : int):
	emit_signal("user_earned_rewarded", currency, amount)

func _on_AdMob_rewarded_ad_failed_to_show(error_code : int):
	emit_signal("rewarded_ad_failed_to_show", error_code)


func _on_AdMob_rewarded_interstitial_ad_loaded():
	emit_signal("rewarded_interstitial_ad_loaded")

func _on_AdMob_rewarded_interstitial_ad_opened():
	emit_signal("rewarded_interstitial_ad_opened")

func _on_AdMob_rewarded_interstitial_ad_closed():
	emit_signal("rewarded_interstitial_ad_closed")

func _on_AdMob_rewarded_interstitial_ad_failed_to_load(error_code : int):
	emit_signal("rewarded_interstitial_ad_failed_to_load")
	
func _on_AdMob_rewarded_interstitial_ad_failed_to_show(error_code : int):
	emit_signal("rewarded_interstitial_ad_failed_to_show", error_code)


func _on_AdMob_consent_form_dismissed():
	emit_signal("consent_form_dismissed")

func _on_AdMob_consent_status_changed(consent_status_message : String):
	emit_signal("consent_status_changed", consent_status_message)

func _on_AdMob_consent_form_load_failure(error_code : int, error_message : String):
	emit_signal("consent_form_load_failure", error_code, error_message)

func _on_AdMob_consent_info_update_success(consent_status_message : String):
	emit_signal("consent_info_update_success", consent_status_message)

func _on_AdMob_consent_info_update_failure(error_code : int, error_message : String):
	emit_signal("consent_info_update_failure", error_code, error_message)


func _on_AdMob_initialization_complete(status : int, adapter_name : String):
	emit_signal("initialization_complete", status, adapter_name)
