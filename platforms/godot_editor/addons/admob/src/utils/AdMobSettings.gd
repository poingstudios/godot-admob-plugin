# MIT License
# 
# Copyright (c) 2023-present Poing Studios
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

enum InitializationStatus {NOT_READY, READY}
enum Position {BOTTOM, TOP}

const PATH_ADMOB_PROJECT_SETTINGS = "admob/config"
const BANNER_SIZE : Array = [
	"BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER",
	"LEADERBOARD", "ADAPTIVE", "SMART_BANNER"
]
const MAX_AD_RATING : Array = ["G", "PG", "T", "MA"]

var ad_mob_load = preload(
	"res://addons/admob/src/utils/AdMobLoad.gd"
)
var ad_mob_save = preload(
	"res://addons/admob/src/utils/AdMobSave.gd"
)


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
		"position": Position.TOP,
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
} setget set_config

func _init():
	var config_project_settings : Dictionary = (
		ad_mob_load.load_config(PATH_ADMOB_PROJECT_SETTINGS)
	)
	merge_dir(config, config_project_settings)
	if Engine.editor_hint:
		save_config()

func save_config():
	ad_mob_save.save_config(PATH_ADMOB_PROJECT_SETTINGS, self.config)

func set_config(value : Dictionary):
	config = value
	save_config()

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
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_' + ch.to_lower())
	result[0] = result[0][1]
	return result.join('')
