# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name ResponseInfo

var loaded_adapter_response_info : AdapterResponseInfo
var adapter_responses : Array[AdapterResponseInfo]
var response_extras : Dictionary
var mediation_adapter_class_name : String
var response_id : String

func _init(loaded_adapter_response_info : AdapterResponseInfo, 
			adapter_responses : Array[AdapterResponseInfo], 
			response_extras : Dictionary, 
			mediation_adapter_class_name : String, 
			response_id : String):
	self.loaded_adapter_response_info = loaded_adapter_response_info
	self.adapter_responses = adapter_responses
	self.response_extras = response_extras
	self.mediation_adapter_class_name = mediation_adapter_class_name
	self.response_id = response_id
	
static func create(response_info_dictionary : Dictionary) -> ResponseInfo:
	if not response_info_dictionary.is_empty():
		var loaded_adapter_response_info := AdapterResponseInfo.create(response_info_dictionary["loaded_adapter_response_info"])
		var adapter_responses := AdapterResponseInfo.create_adapter_responses(response_info_dictionary["adapter_responses"])
		var response_extras : Dictionary = response_info_dictionary["response_extras"]
		var mediation_adapter_class_name : String = response_info_dictionary["mediation_adapter_class_name"]
		var response_id : String = response_info_dictionary["response_id"]
		
		return ResponseInfo.new(loaded_adapter_response_info, adapter_responses, response_extras, mediation_adapter_class_name, response_id)
	return null
