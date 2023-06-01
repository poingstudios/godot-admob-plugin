class_name MobileAds
extends MobileSingletonPlugin

static var _plugin : Object
const PLUGIN_NAME := "PoingGodotAdMob"


static func _static_init() -> void:
	_plugin = _get_plugin(PLUGIN_NAME)

static func initialize(on_initialization_complete_listener : OnInitializationCompleteListener) -> void:
	if _plugin:
		_plugin.initialize()
		
		_plugin.connect("initialization_complete", func(admob_initialization_status : Dictionary):
			var initialization_status := InitializationStatus.create(admob_initialization_status)
			on_initialization_complete_listener.on_initialization_complete.call(initialization_status)
		)


static func set_request_configuration(request_configuration : RequestConfiguration):
	if _plugin:
		#test_device_ids needs to be passed separarely because Dictionary can't serialize Arrays 
		_plugin.set_request_configuration(request_configuration.convert_to_dictionary(), request_configuration.test_device_ids)

static func get_initialization_status() -> InitializationStatus:
	if _plugin:
		var initialization_status_dictionary : Dictionary = _plugin.get_initialization_status()
		return InitializationStatus.create(initialization_status_dictionary)
	return null
