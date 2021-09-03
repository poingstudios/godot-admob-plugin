extends "../../config/Settings.gd"

enum INITIALIZATION_STATUS {NOT_READY, READY}

#private attributes
var _control_node_to_be_replaced : Control
enum _position_options {BOTTOM, TOP}

const BANNER_SIZE : Array = ["BANNER", "MEDIUM_RECTANGLE", "FULL_BANNER", "LEADERBOARD", "ADAPTIVE", "SMART_BANNER"] 
const MAX_AD_RATING : Array = ["G", "PG", "T", "MA"]

const BEGINNING_SETTINGS_SCRIPT = "extends Node\n\nvar config : Dictionary = "
const FILE_PATH = "res://addons/admob/config/Settings.gd"


func _ready() -> void:
	load_config()

func save_config() -> void:
	if !(OS.get_name() == "Android" or OS.get_name() == "iOS"):
		var file = File.new()
		file.open(FILE_PATH, File.WRITE)
		file.store_string(BEGINNING_SETTINGS_SCRIPT + JSON.print(config, "\t"))
		file.close()

func load_config() -> void:
	var config_file := File.new()
	if config_file.file_exists(FILE_PATH):
		config_file.open(FILE_PATH, File.READ)
		var new_config : Dictionary = parse_json(config_file.get_as_text().replace(BEGINNING_SETTINGS_SCRIPT, ""))
		config_file.close()
		config = new_config
