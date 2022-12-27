var AdMobLoad = preload("res://addons/admob/src/utils/AdMobLoad.gd")
var AdMobSave = preload("res://addons/admob/src/utils/AdMobSave.gd")

enum INITIALIZATION_STATUS {NOT_READY, READY}
const PATH_ADMOB_PROJECT_SETTINGS = "admob/config"

const BANNER_SIZE : Array = ["BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "ADAPTIVE", "SMART_BANNER"] 
const MAX_AD_RATING : Array = ["G", "PG", "T", "MA"]
enum POSITION {BOTTOM, TOP}


var config : Dictionary = {
	"general" : {
		"is_enabled": true,
		"is_for_child_directed_treatment": false,
		"max_ad_content_rating": "PG"
	},
	"debug" : {
		"is_debug_on_release": false,
		"is_real": true,
		"is_test_europe_user_consent": false
	},
	"banner": {
		"position": POSITION.TOP,
		"respect_safe_area" : true,
		"show_instantly": true,
		"size": BANNER_SIZE[0],
		"unit_ids" : {
			"Android": {
				"standard" : "ca-app-pub-3940256099942544/6300978111",
			},
			"iOS":  {
				"standard" : "ca-app-pub-3940256099942544/2934735716"
			}
		}
	},
	"interstitial": {
		"unit_ids" : {
			"Android": {
				"standard" : "ca-app-pub-3940256099942544/1033173712"
			},
			"iOS": {
				"standard" : "ca-app-pub-3940256099942544/4411468910"
			}
		}
	},
	"rewarded": {
		"unit_ids" : {
			"Android": {
				"standard" : "ca-app-pub-3940256099942544/5224354917"
			},
			"iOS": {
				"standard" : "ca-app-pub-3940256099942544/1712485313"
			}
		}
	},
	"rewarded_interstitial": {
		"unit_ids" : {
			"Android": {
				"standard" : "ca-app-pub-3940256099942544/5354046379"
			},
			"iOS": {
				"standard" : "ca-app-pub-3940256099942544/6978759866"
			}
		}
	}
} : 
	set(value):
		config = value
		save_config()
		
func _init():
	var config_project_settings : Dictionary = AdMobLoad.load_config(PATH_ADMOB_PROJECT_SETTINGS)
	merge_dir(config, config_project_settings)
	if Engine.is_editor_hint():
		save_config()

func save_config():
	AdMobSave.save_config(PATH_ADMOB_PROJECT_SETTINGS, self.config)


func merge_dir(target : Dictionary, patch : Dictionary):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge_dir(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]


static func pascal2snake(string : String) -> String:
	string = string.replacen("adformat", "")
	var result = PackedStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return ''.join(result)
