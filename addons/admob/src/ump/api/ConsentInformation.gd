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

class_name ConsentInformation
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobConsentInformation")

enum ConsentStatus {
	UNKNOWN,
	NOT_REQUIRED,
	REQUIRED,
	OBTAINED
}

func get_consent_status() -> ConsentStatus:
	if _plugin:
		return _plugin.get_consent_status()
	return ConsentStatus.UNKNOWN

func get_is_consent_form_available() -> bool:
	if _plugin:
		return _plugin.get_is_consent_form_available()
	return false

func update(consent_request : ConsentRequestParameters, 
			on_consent_info_updated_success := func() : pass,
			on_consent_info_updated_failure := func(form_error : FormError) : pass,
			) -> void:
	if _plugin:
		_plugin.update(consent_request.convert_to_dictionary())
		
		_plugin.connect("on_consent_info_updated_success", func(): 
			on_consent_info_updated_success.call_deferred()
		, CONNECT_ONE_SHOT)
		_plugin.connect("on_consent_info_updated_failure", func(form_error_dictionary : Dictionary): 
			on_consent_info_updated_failure.call_deferred(FormError.create(form_error_dictionary))
		, CONNECT_ONE_SHOT)

func reset():
	if _plugin:
		_plugin.reset()
