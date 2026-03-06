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

class_name UserMessagingPlatform
extends MobileSingletonPlugin

static var _plugin := _get_plugin("PoingGodotAdMobUserMessagingPlatform")

static var consent_information := ConsentInformation.new()

static var _on_consent_form_load_success_listener_callback
static var _on_consent_form_load_failure_listener_callback

static func load_consent_form(
		on_consent_form_load_success_listener := func(consent_form: ConsentForm): pass ,
		on_consent_form_load_failure_listener := func(form_error: FormError): pass ) -> void:
	if _plugin:
		_on_consent_form_load_success_listener_callback = on_consent_form_load_success_listener
		_on_consent_form_load_failure_listener_callback = on_consent_form_load_failure_listener
		_plugin.load_consent_form()
		safe_connect(_plugin, "on_consent_form_load_success_listener", _on_consent_form_load_success_listener, CONNECT_ONE_SHOT)
		safe_connect(_plugin, "on_consent_form_load_failure_listener", _on_consent_form_load_failure_listener, CONNECT_ONE_SHOT)

static func _on_consent_form_load_success_listener(UID: int) -> void:
	_on_consent_form_load_success_listener_callback.call_deferred(ConsentForm.new(UID))

static func _on_consent_form_load_failure_listener(form_error_dictionary: Dictionary) -> void:
	_on_consent_form_load_failure_listener_callback.call_deferred(FormError.create(form_error_dictionary))
