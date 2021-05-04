extends "res://addons/admob/scripts/GodotAdMobBase.gd"

var admob_enabled := true
var is_real := false
var is_test_europe_user_consent := true
var banner_size : String = "BANNER"
var banner_position = _position_options.BOTTOM
var is_for_child_directed_treatment := false
var max_ad_content_rating = "G"
var unit_ids : Dictionary 

func load_config() -> Dictionary:
	var config_file := File.new()
	config_file.open("res://addons/admob/config/settings.json", File.READ)
	return parse_json(config_file.get_as_text())
	

func _ready():
	var content_file = load_config()
	
	admob_enabled =  content_file["Enabled"]
	is_real = content_file["Real"]
	is_test_europe_user_consent = content_file["TestEuropeUserConsent"]
	banner_size = BANNER_SIZE[content_file["BannerSize"]]	
	banner_position = MAX_AD_RATING[int(content_file["BannerOnTop"])]
	is_for_child_directed_treatment = content_file["ChildDirectedTreatment"]
	max_ad_content_rating = content_file["MaxAdContentRating"]
	unit_ids = {
		"banner": {
			"iOS" : content_file["iOSBanner"],
			"Android" : content_file["AndroidBanner"],
		},
		"interstitial" : {
			"iOS" : content_file["iOSInterstitial"],
			"Android" : content_file["AndroidInterstitial"],
		},
		"rewarded" : {
			"iOS" : content_file["iOSRewarded"],
			"Android" : content_file["AndroidRewarded"],
		},
		"native" : {
			"iOS" : "",
			"Android" : "ca-app-pub-3940256099942544/2247696110",
		}
	}

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
		print("loading_interstitial")
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
		print("showing interstitial")
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


func _on_Button_pressed():
	admob_enabled = false
	print(admob_enabled)


func _on_OptionButton_item_selected(index):
	print(index)



