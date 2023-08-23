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

class_name MobileAds
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMob")

static func initialize(on_initialization_complete_listener : OnInitializationCompleteListener = null) -> void:
	if _plugin:
		_plugin.initialize()
		
		if on_initialization_complete_listener:
			_plugin.connect("on_initialization_complete", func(admob_initialization_status : Dictionary):
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
