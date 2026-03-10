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

class_name AdapterResponseInfo

var adapter_class_name : String
var ad_source_id : String
var ad_source_name : String
var ad_source_instance_id : String
var ad_source_instance_name : String
var ad_unit_mapping : Dictionary
var ad_error : AdError
var latency_millis : int


func _init(adapter_class_name : String,
			ad_source_id : String,
			ad_source_name : String,
			ad_source_instance_id : String,
			ad_source_instance_name : String,
			ad_unit_mapping : Dictionary,
			ad_error : AdError,
			latency_millis : int):
	
	self.adapter_class_name = adapter_class_name
	self.ad_source_id = ad_source_id
	self.ad_source_name = ad_source_name
	self.ad_source_instance_id = ad_source_instance_id
	self.ad_source_instance_name = ad_source_instance_name
	self.ad_unit_mapping = ad_unit_mapping
	self.ad_error = ad_error
	self.latency_millis = latency_millis

static func create(adapter_response_info_dictionary : Dictionary) -> AdapterResponseInfo:
	if not adapter_response_info_dictionary.is_empty():
		var adapter_class_name : String = adapter_response_info_dictionary["adapter_class_name"]
		var ad_source_id : String = adapter_response_info_dictionary["ad_source_id"]
		var ad_source_name : String = adapter_response_info_dictionary["ad_source_name"]
		var ad_source_instance_id : String = adapter_response_info_dictionary["ad_source_instance_id"]
		var ad_source_instance_name : String = adapter_response_info_dictionary["ad_source_instance_name"]
		var ad_unit_mapping : Dictionary = adapter_response_info_dictionary["ad_unit_mapping"]
		var ad_error := AdError.create(adapter_response_info_dictionary["ad_error"])
		var latency_millis : int = adapter_response_info_dictionary["latency_millis"]
		
		return AdapterResponseInfo.new(adapter_class_name, 
			ad_source_id, 
			ad_source_name,
			ad_source_instance_id, 
			ad_source_instance_name, 
			ad_unit_mapping, 
			ad_error, 
			latency_millis
		)
	return null

static func create_adapter_responses(adapter_responses_dictionary : Dictionary) -> Array[AdapterResponseInfo]:
	var array : Array[AdapterResponseInfo]
	
	for key in adapter_responses_dictionary:
		var adapter_response_info_dictionary = adapter_responses_dictionary[key] as Dictionary
		array.append(AdapterResponseInfo.create(adapter_response_info_dictionary))
		
	return array
