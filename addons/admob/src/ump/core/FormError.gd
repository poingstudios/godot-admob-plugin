class_name FormError

var error_code : int
var message : String

func _init(error_code : int, message : String):
	self.error_code = error_code
	self.message = message

static func create(form_error_dictionary : Dictionary) -> FormError:
	var error_code = form_error_dictionary["error_code"]
	var message = form_error_dictionary["message"]
	return FormError.new(error_code, message)
