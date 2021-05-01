extends MobileAdsBase

export var admob_enabled := true
export var is_real := false
export var is_test_europe_user_consent := true
export(String, "BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "SMART_BANNER") var banner_size : String = "BANNER"
export(_position_options) var banner_position = _position_options.BOTTOM
export var is_for_child_directed_treatment := false
export(String, "G", "PG", "T", "MA") var max_ad_content_rating = "G"
export (Dictionary) var unit_ids : Dictionary = {
	"banner": {
		"iOS" : "ca-app-pub-3940256099942544/2934735716",
		"Android" : "ca-app-pub-3940256099942544/6300978111",
	},
	"interstitial" : {
		"iOS" : "ca-app-pub-3940256099942544/4411468910",
		"Android" : "ca-app-pub-3940256099942544/1033173712",
	},
	"rewarded" : {
		"iOS" : "ca-app-pub-3940256099942544/1712485313",
		"Android" : "ca-app-pub-3940256099942544/5224354917",
	},
	"native" : {
		"iOS" : "",
		"Android" : "ca-app-pub-3940256099942544/2247696110",
	}
}

func _ready():
	if admob_enabled:
		if (Engine.has_singleton("AdMob")):
			_admob_singleton = Engine.get_singleton("AdMob")
			_initialize()
			# warning-ignore:return_value_discarded
			get_tree().connect("screen_resized", self, "_on_get_tree_resized")

func _initialize():
	if _admob_singleton and !is_initialized:
		_admob_singleton.initialize(is_for_child_directed_treatment, max_ad_content_rating, is_real, is_test_europe_user_consent, get_instance_id())

func load_banner():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_banner(unit_ids.banner[OS.get_name()], banner_position, banner_size)

func load_interstitial():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_interstitial(unit_ids.interstitial[OS.get_name()])

func load_rewarded():
	if _admob_singleton and is_initialized:
		_admob_singleton.load_rewarded(unit_ids.rewarded[OS.get_name()])

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
		_admob_singleton.load_native(unit_ids.native[OS.get_name()], [params.size.w, params.size.h], [params.position.x, params.position.y])

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
		unit_ids.native.scale = {
			"x" : OS.get_screen_size().x / get_viewport_rect().size.x,
			"y" : OS.get_screen_size().y / get_viewport_rect().size.y
		}
		if native_enabled:
			load_native(_control_node_to_be_replaced)
		if banner_enabled and banner_size == "SMART_BANNER":
			load_banner()
		if interstitial_loaded: #verify if interstitial and rewarded is loaded because the only reason to load again now is to resize
			load_interstitial()
		if rewarded_loaded:
			load_rewarded()
