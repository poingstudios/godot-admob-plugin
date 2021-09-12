const BEGINNING_SETTINGS_SCRIPT = "extends Node\n\nvar config : Dictionary = "
const FILE_PATH = "res://addons/admob/src/utils/Settings.gd"

static func save_config(config : Dictionary) -> void:
#	if !(OS.get_name() == "Android" or OS.get_name() == "iOS"):
#		var file = File.new()
#		file.open(FILE_PATH, File.WRITE)
#		file.store_string(BEGINNING_SETTINGS_SCRIPT + JSON.print(config, "\t"))
#		file.close()
	var config_file = ConfigFile.new()
	config_file.set_value("section_test", "key_test", config)
	config_file.save("res://export_presets.cfg")
	
static func load_config() -> void:
#	var config_file := File.new()
#	if config_file.file_exists(FILE_PATH):
#		config_file.open(FILE_PATH, File.READ)
#		var new_config : Dictionary = parse_json(config_file.get_as_text().replace(BEGINNING_SETTINGS_SCRIPT, ""))
#		config_file.close()
	ResourceSaver.save("res://test.tres", load(FILE_PATH))
	var TEST_SETTINGS = load("res://test.tres").new()
	print(TEST_SETTINGS.get_script().new().config)
