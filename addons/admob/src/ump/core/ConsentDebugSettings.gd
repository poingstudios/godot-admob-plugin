class_name ConsentDebugSettings

var debug_geography := DebugGeography.Values.DISABLED
var test_device_hashed_ids : Array[String]

func convert_to_dictionary() -> Dictionary:
	return {
		"debug_geography" : debug_geography,
		"test_device_hashed_ids" : _transform_test_device_hashed_ids_to_dictionary()
	}


func _transform_test_device_hashed_ids_to_dictionary() -> Dictionary:
	var test_device_hashed_ids_dictionary : Dictionary
	for i in test_device_hashed_ids.size():
		var id = test_device_hashed_ids[i] as String
		test_device_hashed_ids_dictionary[i] = {
			"_" : id
		}
	return test_device_hashed_ids_dictionary
