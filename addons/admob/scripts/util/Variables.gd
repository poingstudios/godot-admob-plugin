extends Node

const FILE_PATH = "user://admob_settings.json"
enum INITIALIZATION_STATUS {NOT_READY, READY}

#public attributes
var is_initialized : bool = false 
var banner_enabled : bool = false
var interstitial_loaded : bool = false
var rewarded_loaded : bool = false


#private attributes
var _admob_singleton : Object
var _control_node_to_be_replaced : Control
enum _position_options {BOTTOM, TOP}
const BANNER_SIZE = ["BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "SMART_BANNER"] 
const MAX_AD_RATING = ["G", "PG", "T", "MA"]


var config : Dictionary = {
	"banner" : {
		"size" : 0,
		"position" : _position_options.BOTTOM,
	},
	"max_ad_content_rating": 0,
	"is_enabled" : true,
	"is_real" : false,
	"is_test_europe_user_consent" : true,
	"is_for_child_directed_treatment" : true,
	"unit_ids" : {
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
		}
	}
}


func save_config():
	var file = File.new()
	file.open(FILE_PATH, File.WRITE)
	file.store_string(to_json(config))
	file.close()

func load_config():
	var config_file := File.new()
	if config_file.file_exists(FILE_PATH):
		config_file.open(FILE_PATH, File.READ)
		config = parse_json(config_file.get_as_text())
		config_file.close()
	else:
		save_config()
