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

extends VBoxContainer

func _ready():
	var request := ConsentRequestParameters.new()
	var consent_debug_settings := ConsentDebugSettings.new()
	consent_debug_settings.debug_geography = DebugGeography.Values.EEA
	consent_debug_settings.test_device_hashed_ids.append("test_device_hashed_id")
	request.consent_debug_settings = consent_debug_settings
	
	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)


func _on_consent_info_updated_failure(form_error : FormError):
	print("_on_consent_info_updated_failure, form_error: error_code=" + str(form_error.error_code) + " message=" + form_error.message)

func _on_consent_info_updated_success():
	print("_on_consent_info_updated_success")
	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
		print("form is available")
		load_form()

func load_form():
	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)

func _on_consent_form_load_failure(form_error : FormError):
	print("_on_consent_form_load_failure, form_error: error_code=" + str(form_error.error_code) + " message=" + form_error.message)

func _on_consent_form_load_success(consent_form : ConsentForm):
	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
		consent_form.show(_on_consent_form_dismissed)

func _on_consent_form_dismissed(form_error : FormError):
	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
		print("The consent was OBTAINED, you can start request ads")


func _on_reset_consent_information_pressed():
	UserMessagingPlatform.consent_information.reset()

func _on_get_consent_status_pressed():
	print("ConsentStatus: " + ConsentInformation.ConsentStatus.keys()[UserMessagingPlatform.consent_information.get_consent_status()])
