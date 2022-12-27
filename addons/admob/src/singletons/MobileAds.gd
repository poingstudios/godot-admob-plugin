extends "res://addons/admob/src/singletons/AdMobSingleton.gd" 

func _ready() -> void:
	# warning-ignore:return_value_discarded
	super._ready()
	get_viewport().size_changed.connect(Callable(self, "_on_get_tree_resized"))

func load_banner(ad_unit_name : String = "standard") -> void:
	if _plugin:
		_plugin.load_banner(config.banner.unit_ids[OS.get_name()][ad_unit_name], config.banner.position, config.banner.size, config.banner.show_instantly, config.banner.respect_safe_area)

func load_interstitial(ad_unit_name : String = "standard") -> void:
	if _plugin:
		_plugin.load_interstitial(config.interstitial.unit_ids[OS.get_name()][ad_unit_name])

func load_rewarded(ad_unit_name : String = "standard") -> void:
	if _plugin:
		_plugin.load_rewarded(config.rewarded.unit_ids[OS.get_name()][ad_unit_name])

func load_rewarded_interstitial(ad_unit_name : String = "standard") -> void:
	if _plugin:
		_plugin.load_rewarded_interstitial(config.rewarded_interstitial.unit_ids[OS.get_name()][ad_unit_name])

func destroy_banner() -> void:
	if _plugin:
		_plugin.destroy_banner()

func show_banner() -> void:
	if _plugin:
		_plugin.show_banner()
		
func hide_banner() -> void:
	if _plugin:
		_plugin.hide_banner()

func show_interstitial() -> void:
	if _plugin:
		_plugin.show_interstitial()

func show_rewarded() -> void:
	if _plugin:
		_plugin.show_rewarded()

func show_rewarded_interstitial() -> void:
	if _plugin:
		_plugin.show_rewarded_interstitial()

func request_user_consent() -> void:
	if _plugin:
		_plugin.request_user_consent()

func reset_consent_state(will_request_user_consent := false) -> void:
	if _plugin:
		_plugin.reset_consent_state()

func get_banner_width() -> int:
	if _plugin:
		return _plugin.get_banner_width()
	return 0

func get_banner_width_in_pixels() -> int:
	if _plugin:
		return _plugin.get_banner_width_in_pixels()
	return 0
	
func get_banner_height() -> int:
	if _plugin:
		return _plugin.get_banner_height()
	return 0
	
func get_banner_height_in_pixels() -> int:
	if _plugin:
		return _plugin.get_banner_height_in_pixels()
	return 0
	
func get_is_banner_loaded() -> bool:
	if _plugin:
		return _plugin.get_is_banner_loaded()
	return false

func get_is_interstitial_loaded() -> bool:
	if _plugin:
		return _plugin.get_is_interstitial_loaded()
	return false

func get_is_rewarded_loaded() -> bool:
	if _plugin:
		return _plugin.get_is_rewarded_loaded()
	return false

func get_is_rewarded_interstitial_loaded() -> bool:
	if _plugin:
		return _plugin.get_is_rewarded_interstitial_loaded()
	return false
	
func _on_get_tree_resized() -> void:
	if _plugin:
		if get_is_banner_loaded() and config.banner.size == "SMART_BANNER":
			load_banner()
		if get_is_interstitial_loaded(): #verify if interstitial and rewarded is loaded because the only reason to load again now is to resize
			load_interstitial()
		if get_is_rewarded_loaded():
			load_rewarded()
		if get_is_rewarded_interstitial_loaded():
			load_rewarded_interstitial()

