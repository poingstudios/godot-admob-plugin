# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends VBoxContainer

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

func _ready() -> void:
	_update_consent_info()

func _update_consent_info() -> void:
	var request := ConsentRequestParameters.new()
	var debug_settings := ConsentDebugSettings.new()
	
	debug_settings.debug_geography = DebugGeography.Values.EEA
	# Add test device IDs here if needed
	request.consent_debug_settings = debug_settings
	
	UserMessagingPlatform.consent_information.update(
		request,
		_on_consent_update_success,
		_on_consent_update_failure
	)

func _on_consent_update_success() -> void:
	_log("Consent info updated successfully")
	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
		_log("Consent form available, loading...")
		_load_consent_form()
	else:
		_log("Consent form not available at this time")

func _on_consent_update_failure(error: FormError) -> void:
	_log("Update failure: [%d] %s" % [error.error_code, error.message])

func _load_consent_form() -> void:
	UserMessagingPlatform.load_consent_form(_on_form_load_success, _on_form_load_failure)

func _on_form_load_success(form: ConsentForm) -> void:
	_log("Form loaded successfully")
	var status := UserMessagingPlatform.consent_information.get_consent_status()
	if status == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
		_log("Consent REQUIRED, showing form...")
		form.show(_on_form_dismissed)
	else:
		_log("Consent not required (Status: %d)" % status)

func _on_form_load_failure(error: FormError) -> void:
	_log("Form load failure: [%d] %s" % [error.error_code, error.message])

func _on_form_dismissed(error: FormError) -> void:
	if error:
		_log("Form dismissal error: " + error.message)
	
	var status := UserMessagingPlatform.consent_information.get_consent_status()
	if status == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
		_log("Consent OBTAINED. You can now request ads.")

func _on_reset_consent_information_pressed() -> void:
	_log("Resetting consent information...")
	UserMessagingPlatform.consent_information.reset()
	_update_consent_info()

func _on_get_consent_status_pressed() -> void:
	_log("Current Consent Status: " + ConsentInformation.ConsentStatus.keys()[UserMessagingPlatform.consent_information.get_consent_status()])

func _log(message: String) -> void:
	if Registry.logger:
		Registry.logger.log_message("[UMP] " + message)
	else:
		print("[UMP] " + message)
