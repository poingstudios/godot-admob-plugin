extends "util/Signals.gd"

func _ready():
	load_config()
	if config.is_enabled:
		if (Engine.has_singleton("AdMob")):
			_admob_singleton = Engine.get_singleton("AdMob")
			_initialize()
			# warning-ignore:return_value_discarded
			get_tree().connect("screen_resized", self, "_on_get_tree_resized")

func _initialize():
	if _admob_singleton and !is_initialized:
		_admob_singleton.initialize(config.is_for_child_directed_treatment, MAX_AD_RATING[config.max_ad_content_rating], config.is_real, config.is_test_europe_user_consent, get_instance_id())

func load_banner():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_banner(config.unit_ids.banner[OS.get_name()], config.banner.position, BANNER_SIZE[config.banner.size])

func load_interstitial():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_interstitial(config.unit_ids.interstitial[OS.get_name()])

func load_rewarded():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_rewarded(config.unit_ids.rewarded[OS.get_name()])

func load_native(control_node_to_be_replaced : Control):
	if _admob_singleton and is_initialized:
		_control_node_to_be_replaced = control_node_to_be_replaced
		var params := {
			"size" : {
				"w" : control_node_to_be_replaced.rect_size.x * _native_scale.x,
				"h" : control_node_to_be_replaced.rect_size.y * _native_scale.y
			},
			"position" : {
				"x" : control_node_to_be_replaced.rect_position.x * _native_scale.x,
				"y" : control_node_to_be_replaced.rect_position.y * _native_scale.y
			}
		}
		_admob_singleton.load_native(config.unit_ids.native[OS.get_name()], [params.size.w, params.size.h], [params.position.x, params.position.y])

func destroy_banner():
	if _admob_singleton and is_initialized:
		_admob_singleton.destroy_banner()

func destroy_native():
	if _admob_singleton and is_initialized:
		_admob_singleton.destroy_native()

func show_interstitial():
	if _admob_singleton and is_initialized:
		_admob_singleton.show_interstitial()

func show_rewarded():
	if _admob_singleton and is_initialized:
		_admob_singleton.show_rewarded()

func _on_get_tree_resized():
	if _admob_singleton and is_initialized:
		config.unit_ids.native.scale = {
			"x" : OS.get_screen_size().x / get_viewport_rect().size.x,
			"y" : OS.get_screen_size().y / get_viewport_rect().size.y
		}
		if native_enabled:
			load_native(_control_node_to_be_replaced)
		if banner_enabled and config.banner.size == "SMART_BANNER":
			load_banner()
		if interstitial_loaded: #verify if interstitial and rewarded is loaded because the only reason to load again now is to resize
			load_interstitial()
		if rewarded_loaded:
			load_rewarded()
