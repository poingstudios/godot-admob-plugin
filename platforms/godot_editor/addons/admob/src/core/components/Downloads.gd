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

tool
extends VBoxContainer

signal files_extracted

const GITHUB_RELEASES_URL = (
	"https://github.com/poingstudios/godot-admob-plugin/releases"
)
const GITHUB_ISSUES_URL = (
	"https://github.com/poingstudios/godot-admob-plugin/issues"
)
const DISCORD_URL = "https://discord.gg/CKkYqCzK"

var actual_downloading_file : String = ""
var downloaded_plugin_version : String = ""
var version_support : Dictionary

var android_dictionary : Dictionary = {
		"download_directory" : "res://addons/admob/downloads/android"
	} setget set_android_dictionary

var ios_dictionary : Dictionary = {
		"download_directory" : "res://addons/admob/downloads/ios"
	} setget set_ios_dictionary

var current_dir_download_label = (
	"Current Download Directory: %s"
)
var download_complete_message = (
	"Download of %s completed! \n%s"
)
var download_failed_message = (
	"Download failed with response code: %d\n\n"
	+ "Possible causes:\n"
	+ "- No internet connection\n"
	+ "- GitHub rate limit exceeded\n"
	+ "- Version not available for your Godot version\n\n"
	+ "The releases page will open in your browser.\n"
	+ "Check the available versions and try again.\n\n"
	+ "Need more help? Open an issue on GitHub or join our Discord."
)

onready var ad_mob_editor : Control = find_parent("AdMobEditor")

onready var godot_version : String = (
	"v" + String(Engine.get_version_info().major)
	+ "." + String(Engine.get_version_info().minor)
	+ "." + String(Engine.get_version_info().patch)
)

func set_android_dictionary(value):
	android_dictionary = value
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text = (
		current_dir_download_label
		% android_dictionary.download_directory
	)

func set_ios_dictionary(value):
	ios_dictionary = value
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text = (
		current_dir_download_label
		% ios_dictionary.download_directory
	)

func _ready():
	$DontHaveConnectionPanelContainer/Label.text %= $VerifyNetworkGithub.server_to_test

	if godot_version[godot_version.length()-1] == "0":
		godot_version = godot_version.substr(
			0, godot_version.length()-2
		)

	set_process(false)
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text = (
		current_dir_download_label
		% android_dictionary.download_directory
	)
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text = (
		current_dir_download_label
		% ios_dictionary.download_directory
	)

func _process(_delta):
	var body_size = $TabContainer/HTTPRequest.get_body_size()
	var downloaded_bytes = $TabContainer/HTTPRequest.get_downloaded_bytes()
	var percent = int(downloaded_bytes * 100 / body_size)
	$ProgressBar.value = percent

func set_buttons_disabled(disabled: bool):
	$TabContainer/Android/DownloadAndroidTemplate.disabled = disabled
	$TabContainer/iOS/DownloadiOSTemplate.disabled = disabled



func _on_HTTPRequest_request_completed(
	_result, response_code, _headers, _body
):
	if response_code != 200:
		$AdviceAcceptDialog.dialog_text = download_failed_message % response_code
		$ProgressBar.value = 0
		set_process(false)
		set_buttons_disabled(false)
		$AdviceAcceptDialog.popup_centered()
		yield($AdviceAcceptDialog, "confirmed")
		OS.shell_open(GITHUB_ISSUES_URL)
	else:
		var filepath = $TabContainer/HTTPRequest.download_file
		var success := false
		if actual_downloading_file.begins_with("android-template"):
			success = _extract_android_zip(filepath)
		elif actual_downloading_file.begins_with("ios-template"):
			success = _extract_ios_zip(filepath)

		$AdviceAcceptDialog.dialog_text = download_complete_message % [
			actual_downloading_file,
			downloaded_plugin_version
		]
		set_process(false)
		set_buttons_disabled(false)
		$AdviceAcceptDialog.popup_centered()
		if success:
			emit_signal("files_extracted")
			_check_and_auto_download()
		else:
			if actual_downloading_file.begins_with("android-template"):
				var ios_file = "res://ios/plugins/admob.gdip"
				var dir = Directory.new()
				if not dir.file_exists(ios_file):
					_on_DownloadiOSTemplate_pressed()

func _copy_virtual_file(
	src_path: String, dest_path: String
) -> bool:
	var dir = Directory.new()
	var dest_dir = dest_path.get_base_dir()
	if not dir.dir_exists(dest_dir):
		dir.make_dir_recursive(dest_dir)

	var f_src = File.new()
	if f_src.open(src_path, File.READ) != OK:
		print(
			"AdMob Error: Failed to open "
			+ "virtual src file: " + src_path
		)
		return false

	var f_dest = File.new()
	if f_dest.open(dest_path, File.WRITE) != OK:
		print(
			"AdMob Error: Failed to open "
			+ "physical dest file: " + dest_path
		)
		f_src.close()
		return false

	f_dest.store_buffer(f_src.get_buffer(f_src.get_len()))
	f_src.close()
	f_dest.close()
	return true

func _extract_zip(zip_path: String, mappings: Dictionary) -> bool:
	if ProjectSettings.load_resource_pack(zip_path):
		var success = true
		for virtual_path in mappings.keys():
			var physical_path = mappings[virtual_path]
			success = success and _copy_virtual_file(virtual_path, physical_path)
		var dir = Directory.new()
		dir.remove(zip_path)
		return success

	return _extract_zip_manual(zip_path, mappings)

func _extract_zip_manual(zip_path: String, mappings: Dictionary) -> bool:
	var file = File.new()
	if file.open(zip_path, File.READ) != OK:
		return false

	var needed := {}
	for virtual_path in mappings.keys():
		needed[virtual_path.replace("res://", "")] = mappings[virtual_path]

	var found := 0
	var success := true

	while file.get_position() < file.get_len() - 4:
		var sig = file.get_32()
		if sig != 0x04034b50:
			break

		file.get_16()
		file.get_16()
		var method = file.get_16()
		file.get_16()
		file.get_16()
		var crc = file.get_32()
		var comp_size = file.get_32()
		var uncomp_size = file.get_32()
		var name_len = file.get_16()
		var extra_len = file.get_16()

		var entry_name = file.get_buffer(name_len).get_string_from_utf8()
		if extra_len > 0:
			file.get_buffer(extra_len)

		if entry_name.ends_with("/"):
			continue

		if entry_name in needed:
			var raw = file.get_buffer(comp_size)
			var output = PoolByteArray()

			if method == 0:
				output = raw
			elif method == 8:
				output = _inflate_raw(raw, uncomp_size, crc)

			if output.size() == uncomp_size:
				success = success and _write_extracted_file(
					needed[entry_name], output
				)
				found += 1
			else:
				success = false

			if found >= needed.size():
				break
		else:
			if comp_size > 0:
				file.seek(file.get_position() + comp_size)

	file.close()
	var dir = Directory.new()
	dir.remove(zip_path)
	return success and found == needed.size()

func _inflate_raw(
	data: PoolByteArray, uncomp_size: int, crc32: int
) -> PoolByteArray:
	var gzip = PoolByteArray()
	gzip.append(0x1F)
	gzip.append(0x8B)
	gzip.append(0x08)
	gzip.append(0x00)
	gzip.append_array(PoolByteArray([0, 0, 0, 0]))
	gzip.append(0x00)
	gzip.append(0xFF)
	gzip.append_array(data)
	gzip.append(crc32 & 0xFF)
	gzip.append((crc32 >> 8) & 0xFF)
	gzip.append((crc32 >> 16) & 0xFF)
	gzip.append((crc32 >> 24) & 0xFF)
	gzip.append(uncomp_size & 0xFF)
	gzip.append((uncomp_size >> 8) & 0xFF)
	gzip.append((uncomp_size >> 16) & 0xFF)
	gzip.append((uncomp_size >> 24) & 0xFF)
	return gzip.decompress(uncomp_size, File.COMPRESSION_GZIP)

func _write_extracted_file(
	res_path: String, data: PoolByteArray
) -> bool:
	var dir = Directory.new()
	var dir_path = res_path.get_base_dir()
	if not dir.dir_exists(dir_path):
		dir.make_dir_recursive(dir_path)
	var f = File.new()
	if f.open(res_path, File.WRITE) != OK:
		return false
	f.store_buffer(data)
	f.close()
	return true

func _extract_android_zip(zip_path: String) -> bool:
	var mappings = {
		"res://AdMob.gdap": "res://android/plugins/AdMob.gdap",
		"res://build/outputs/aar/admob-release.aar": "res://android/plugins/admob-release.aar",
		"res://build/outputs/aar/admob-debug.aar": "res://android/plugins/admob-debug.aar"
	}
	var success = _extract_zip(zip_path, mappings)
	if success:
		print("AdMob: Android templates extracted successfully!")
	else:
		print("AdMob Error: Failed to extract Android templates from " + zip_path)
	return success

func _extract_ios_zip(zip_path: String) -> bool:
	var mappings = {
		"res://admob.gdip": "res://ios/plugins/admob.gdip",
		"res://admob/bin/admob.release.a": "res://ios/plugins/admob/bin/admob.release.a",
		"res://admob/bin/admob.debug.a": "res://ios/plugins/admob/bin/admob.debug.a"
	}
	var success = _extract_zip(zip_path, mappings)
	if success:
		print("AdMob: iOS templates extracted successfully!")
	else:
		print("AdMob Error: Failed to extract iOS templates from " + zip_path)
	return success

func _check_and_auto_download():
	if is_processing() or version_support.empty():
		return

	var android_file = "res://android/plugins/admob-release.aar"
	var ios_file = "res://ios/plugins/admob.gdip"

	var dir = Directory.new()
	if not dir.file_exists(android_file):
		_on_DownloadAndroidTemplate_pressed()
	elif not dir.file_exists(ios_file):
		_on_DownloadiOSTemplate_pressed()

func _on_DownloadiOSTemplate_pressed():
	var file_name = "ios-template-" + godot_version + ".zip"
	var plugin_version = version_support.ios
	$TabContainer/HTTPRequest.download_file = (
		ios_dictionary.download_directory
		+ "/" + file_name
	)
	$TabContainer/HTTPRequest.request(
		"https://github.com/poingstudios/"
		+ "godot-admob-plugin/releases/download/"
		+ plugin_version + "/" + file_name
	)
	actual_downloading_file = file_name
	downloaded_plugin_version = (
		"iOS Plugin Version: " + plugin_version
	)

	set_process(true)
	set_buttons_disabled(true)

func _on_DownloadAndroidTemplate_pressed():
	var file_name = (
		"android-template-" + godot_version + ".zip"
	)
	var plugin_version = version_support.android
	$TabContainer/HTTPRequest.download_file = (
		android_dictionary.download_directory
		+ "/" + file_name
	)
	$TabContainer/HTTPRequest.request(
		"https://github.com/poingstudios/"
		+ "godot-admob-plugin/releases/download/"
		+ plugin_version + "/" + file_name
	)
	actual_downloading_file = file_name

	downloaded_plugin_version = (
		"Android Plugin Version: " + plugin_version
	)

	set_process(true)
	set_buttons_disabled(true)

func _on_AndroidChangeDirectoryFileDialog_dir_selected(dir):
	self.android_dictionary.download_directory = dir

func _on_AndroidChangeDirectoryButton_pressed():
	var node = $TabContainer/Android/ChangeDirectoryHBoxContainer
	node.AndroidChangeDirectoryFileDialog.popup_centered()

func _on_ios_change_directory_file_dialog_dir_selected(dir):
	self.ios_dictionary.download_directory = dir

func _on_ios_change_directory_button_pressed():
	var node = $TabContainer/iOS/ChangeDirectoryHBoxContainer
	node.iOSChangeDirectoryFileDialog.popup_centered()

func _on_AndroidOpenDirectoryButton_pressed():
	var path_directory = ProjectSettings.globalize_path(
		android_dictionary.download_directory
	)
	OS.shell_open(str("file://", path_directory))

func _on_ios_open_directory_button_pressed():
	var path_directory = ProjectSettings.globalize_path(
		ios_dictionary.download_directory
	)
	OS.shell_open(str("file://", path_directory))

func _on_VerifyNetworkGithub_network_status_changed(
	value : int
):
	if value == $VerifyNetworkGithub.CONNECTED:
		$TabContainer.visible = true
		$DontHaveConnectionPanelContainer.visible = false
	else:
		$TabContainer.visible = false
		$DontHaveConnectionPanelContainer.visible = true

func _on_VersionSupportedHTTPRequest_supported_version_changed(
	value_dictionary : Dictionary
):
	version_support = value_dictionary
	_check_and_auto_download()

func get_versions_platform_supported(body):
	var json = JSON.parse(body.get_string_from_utf8())

	var regex = RegEx.new()
	regex.compile(
		"[v](([0-9])+(\\.{0,1}([0-9]))*)+"
	)

	var versions_supported : Array

	for asset in json.result["assets"]:
		var godot_version = asset["name"]

		var regex_result = regex.search(godot_version)
		if regex_result:
			if not versions_supported.has(
				regex_result.get_string()
			):
				versions_supported.append(
					regex_result.get_string()
				)

	return versions_supported
