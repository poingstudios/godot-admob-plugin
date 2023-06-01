class_name AdRequest

var keywords : Array[String]
var mediation_extras : Array[MediationExtras]

func convert_to_dictionary() -> Dictionary:
	return {
		"mediation_extras" : _transform_mediation_extras_to_dictionary()
	}

func _transform_mediation_extras_to_dictionary() -> Dictionary:
	var mediation_extras_dictionary : Dictionary
	for i in mediation_extras.size():
		var extra = mediation_extras[i] as MediationExtras
		mediation_extras_dictionary[i] = {
			"class_name" : extra.get_class_name(),
			"extras" : extra.extras
		}
	return mediation_extras_dictionary
