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

class_name InitializationStatus

var adapter_status_map : Dictionary

func _set_adapter_status_value(key : String, value : AdapterStatus):
	adapter_status_map[key] = value

static func create(initialization_status_dictionary : Dictionary) -> InitializationStatus:
	var initialization_status := InitializationStatus.new()
	for adapter_status_key in initialization_status_dictionary:
		var latency : int = initialization_status_dictionary[adapter_status_key]["latency"]
		var initialization_state : AdapterStatus.State = initialization_status_dictionary[adapter_status_key]["initializationState"]
		var description : String = initialization_status_dictionary[adapter_status_key]["description"]
		
		var adapterStatus = AdapterStatus.new(latency, initialization_state, description)
		initialization_status._set_adapter_status_value(adapter_status_key, adapterStatus)
	
	return initialization_status
