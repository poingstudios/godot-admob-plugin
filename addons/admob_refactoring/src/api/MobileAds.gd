extends Node

var _plugin : Object
const PLATFORM_PLUGIN_NAME := "PoingGodotAdMob"
var request_configuration : Dictionary


func _ready() -> void:
	if (Engine.has_singleton(PLATFORM_PLUGIN_NAME)):
		_plugin = Engine.get_singleton(PLATFORM_PLUGIN_NAME)
	else:
		print_debug("Doesn't has plugin:", PLATFORM_PLUGIN_NAME)

func initialize(on_initialization_complete_listener : OnInitializationCompleteListener) -> void:
	if _plugin:
		_plugin.initialize()
		
		_plugin.connect("initialization_complete", func(admob_initialization_status : Dictionary):
			var initialization_status := InitializationStatus.create(admob_initialization_status)
			on_initialization_complete_listener.on_initialization_complete.call(initialization_status)
		)


func set_request_configuration(request_configuration : RequestConfiguration):
	if _plugin:
		#test_device_ids needs to be passed separarely because Dictionary can't serialize Arrays 
		_plugin.set_request_configuration(request_configuration.convert_to_dictionary(), request_configuration.test_device_ids)

func get_initialization_status() -> InitializationStatus:
	if _plugin:
		var initialization_status_dictionary : Dictionary = _plugin.get_initialization_status()
		return InitializationStatus.create(initialization_status_dictionary)
	return null
