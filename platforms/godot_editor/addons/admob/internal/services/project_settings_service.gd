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

extends RefCounted

const MEDIATION_PREFIX := "admob/mediation/"

const ANDROID_DEFAULT_APP_ID := "ca-app-pub-3940256099942544~3347511713"
const IOS_DEFAULT_APP_ID := "ca-app-pub-3940256099942544~1458002511"

const MEDIATION_LIBS: Array[String] = [
	"applovin",
	"bidmachine",
	"chartboost",
	"dtexchange",
	"imobile",
	"inmobi",
	"ironsource",
	"line",
	"maio",
	"meta",
	"mintegral",
	"moloco",
	"mytarget",
	"pangle",
	"pubmatic",
	"unity_ads",
	"vungle"
]


class SettingDefinition:
	var name := ""
	var type := TYPE_NIL
	var default_value

	func _init(p_name: String, p_type: int, p_default) -> void:
		name = p_name
		type = p_type
		default_value = p_default


static func get_android_setting_path(setting_name: String) -> String:
	return "admob/general/android/%s" % setting_name


static func get_ios_setting_path(setting_name: String) -> String:
	return "admob/general/ios/%s" % setting_name


static func _get_android_settings() -> Array[SettingDefinition]:
	return [
		SettingDefinition.new(get_android_setting_path("enabled"), TYPE_BOOL, true),
		SettingDefinition.new(get_android_setting_path("app_id"), TYPE_STRING, ANDROID_DEFAULT_APP_ID),
		SettingDefinition.new(get_android_setting_path("disable_initialization_optimization"), TYPE_BOOL, false),
		SettingDefinition.new(get_android_setting_path("disable_ad_loading_optimization"), TYPE_BOOL, false),
	]


static func _get_ios_settings() -> Array[SettingDefinition]:
	return [
		SettingDefinition.new(get_ios_setting_path("enabled"), TYPE_BOOL, true),
		SettingDefinition.new(get_ios_setting_path("app_id"), TYPE_STRING, IOS_DEFAULT_APP_ID),
	]


static func register_settings() -> void:
	var settings: Array[SettingDefinition] = []
	settings.append_array(_get_android_settings())
	settings.append_array(_get_ios_settings())

	for lib_name in MEDIATION_LIBS:
		settings.append(SettingDefinition.new(MEDIATION_PREFIX + lib_name, TYPE_BOOL, false))

	var active_names: Array[String] = []
	var modified := false
	var order := 0

	for s in settings:
		active_names.append(s.name)
		if _add_setting(s.name, s.type, s.default_value, order):
			modified = true
		order += 1

	if _cleanup_obsolete_settings(active_names):
		modified = true

	if _register_translations():
		modified = true

	if modified:
		var err := ProjectSettings.save()
		if err != OK:
			push_error("AdMob: Failed to save project settings")


static func _register_translations() -> bool:
	var csv_path := "res://addons/admob/gdscript/sample/translations/admob_sample.csv"
	if not FileAccess.file_exists(csv_path):
		return false

	var translations : Array[String] = [
		"res://addons/admob/gdscript/sample/translations/admob_sample.en.translation",
		"res://addons/admob/gdscript/sample/translations/admob_sample.pt_BR.translation",
		"res://addons/admob/gdscript/sample/translations/admob_sample.es.translation",
		"res://addons/admob/gdscript/sample/translations/admob_sample.zh_CN.translation",
		"res://addons/admob/gdscript/sample/translations/admob_sample.ja.translation"
	]

	var current_translations := PackedStringArray()
	if ProjectSettings.has_setting("internationalization/locale/translations"):
		current_translations = ProjectSettings.get_setting("internationalization/locale/translations")

	var modified := false
	for t in translations:
		if not t in current_translations:
			current_translations.append(t)
			modified = true

	if modified:
		ProjectSettings.set_setting("internationalization/locale/translations", current_translations)
	return modified


static func _cleanup_obsolete_settings(active_names: Array[String]) -> bool:
	var modified := false
	for prop in ProjectSettings.get_property_list():
		var prop_name: String = prop.name
		if prop_name.begins_with("admob/") and not prop_name in active_names:
			ProjectSettings.set_setting(prop_name, null)
			modified = true
	return modified


static func _add_setting(setting_name: String, type: int, default_value, order: int) -> bool:
	var is_new := false
	if not ProjectSettings.has_setting(setting_name):
		ProjectSettings.set_setting(setting_name, default_value)
		is_new = true

	ProjectSettings.set_initial_value(setting_name, default_value)
	var info := {
		"name": setting_name,
		"type": type,
	}
	ProjectSettings.add_property_info(info)
	ProjectSettings.set_as_basic(setting_name, true)
	ProjectSettings.set_order(setting_name, order)
	return is_new
