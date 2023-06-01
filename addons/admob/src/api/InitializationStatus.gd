class_name InitializationStatus

var adapter_status_map : Dictionary

func set_adapter_status_value(key : String, value : AdapterStatus):
	adapter_status_map[key] = value

static func create(initialization_status_dictionary : Dictionary) -> InitializationStatus:
	var initialization_status := InitializationStatus.new()
	for adapter_status_key in initialization_status_dictionary:
		var latency : int = initialization_status_dictionary[adapter_status_key]["latency"]
		var initialization_state : AdapterStatus.State = initialization_status_dictionary[adapter_status_key]["initializationState"]
		var description : String = initialization_status_dictionary[adapter_status_key]["description"]
		
		var adapterStatus = AdapterStatus.new(latency, initialization_state, description)
		initialization_status.set_adapter_status_value(adapter_status_key, adapterStatus)
	
	return initialization_status
