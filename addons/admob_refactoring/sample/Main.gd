extends Control

func _ready() -> void:
	var request_configuration := RequestConfiguration.new()
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G

	MobileAds.initialize(OnInitializationCompleteListener.new(_on_initialization_complete))

func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
	print_all_values(initialization_status)

func _on_get_initialization_status_pressed() -> void:
	var initialization_status := MobileAds.get_initialization_status()
	print_all_values(initialization_status)

func print_all_values(initialization_status : InitializationStatus) -> void:
	for key in initialization_status.adapter_status_map:
		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
		prints(key, adapterStatus.latency, adapterStatus.initialization_status, adapterStatus.description)
