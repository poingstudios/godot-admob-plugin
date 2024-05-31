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
@tool
class_name AdMobEditorPlugin
extends EditorPlugin

var http_request_downloader := HTTPRequest.new()
var timer := Timer.new()

var android_download_path := "res://addons/admob/downloads/android/"
var ios_download_path := "res://addons/admob/downloads/ios/"
var default_download_path := "res://addons/admob/downloads/"
var current_download_path := default_download_path
var godot_version := "v" + str(Engine.get_version_info().major) + "." + str(Engine.get_version_info().minor) + "." + str(Engine.get_version_info().patch)
var plugin_version := PoingAdMobVersionHelper.get_plugin_version()

var version_support := {
	"android": "v3.0.2",
	"ios": "v3.0.3"
}

enum Items {
	LatestVersion,
	Folder,
	GitHub
}

class PoingAdMobEditorExportPlugin extends EditorExportPlugin:
	const CFG_FILE_PATH := "res://addons/admob/plugin.cfg"
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		var file = FileAccess.open(CFG_FILE_PATH, FileAccess.READ)
		if file:
			print("Exporting Poing AdMob '.cfg' file")
			add_file(CFG_FILE_PATH, file.get_buffer(file.get_length()), false)
		file.close()
		
	func _get_name() -> String:
		return "PoingAdMob"
		
var _exporter := PoingAdMobEditorExportPlugin.new()
func _enter_tree():
	godot_version = _format_version(godot_version)
	add_export_plugin(_exporter)
	
	setup_timer()
	create_download_directories()
	_request_version_support()
	_setup_download_request_listener()
	
	var popup := PopupMenu.new()

	var android_popup := PopupMenu.new()
	android_popup.name = "Android"
	popup.add_child(android_popup)

	var ios_popup := PopupMenu.new()
	ios_popup.name = "iOS"
	popup.add_child(ios_popup)
	
	android_popup.connect("id_pressed", _on_android_popupmenu_id_pressed)
	android_popup.add_item(str(Items.keys()[Items.LatestVersion]), Items.LatestVersion)
	android_popup.add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	android_popup.add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)

	ios_popup.connect("id_pressed", _on_ios_popupmenu_id_pressed)
	ios_popup.add_item(str(Items.keys()[Items.LatestVersion]), Items.LatestVersion)
	ios_popup.add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	ios_popup.add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)
	
	popup.connect("id_pressed", _on_popupmenu_id_pressed)
	
	popup.add_submenu_item(android_popup.name, android_popup.name)
	popup.add_submenu_item(ios_popup.name, ios_popup.name)
	popup.add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	popup.add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)

	add_tool_submenu_item("AdMob Download Manager", popup)

func _exit_tree():
	remove_export_plugin(_exporter)
	remove_tool_menu_item("AdMob Download Manager")

func _format_version(version: String) -> String:
	var pattern = RegEx.new()
	pattern.compile("^(v\\d+\\.\\d+)(\\.0)$")
	var match_result = pattern.search(version)
	return match_result.get_string(1) if match_result else version

func _request_version_support():
	var url = "https://raw.githubusercontent.com/poingstudios/godot-admob-versions/" + plugin_version + "/versions.json"
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(_on_version_support_request_completed)
	add_child(http_request)
	http_request.request(url)

func _on_version_support_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			version_support = json.get_data() as Dictionary
			return
	printerr("ERR_001: Couldn't get version supported dynamic for AdMob, the latest supported version listed may be outdated. \n" \
	+ "Read more about on: res://addons/admob/docs/errors/ERR_001.md")

func _on_download_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Download completed, you can check the downloaded file at: " + current_download_path)
	else:
		printerr("ERR_002: It is not possible to download the Android/iOS plugin. \n" \
			+ "Read more about on: res://addons/admob/docs/errors/ERR_002.md")
	
	timer.stop()

func _setup_download_request_listener():
	http_request_downloader.request_completed.connect(_on_download_request_completed)
	add_child(http_request_downloader)

func setup_timer():
	timer.wait_time = 3
	timer.timeout.connect(show_download_percent)
	add_child(timer)

func create_download_directories():
	DirAccess.make_dir_recursive_absolute(android_download_path)
	DirAccess.make_dir_recursive_absolute(ios_download_path)

func start_download(platform: String, download_path: String, file_prefix: String):
	if http_request_downloader.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		printerr("http_request_downloader is processing a request, wait for completion")
		return

	var file_name = file_prefix + godot_version + ".zip"
	var url_download = "https://github.com/poingstudios/godot-admob-" + platform + "/releases/download/" + version_support[platform] + "/" + file_name

	http_request_downloader.request_ready()
	http_request_downloader.download_file = download_path + file_name
	http_request_downloader.request(url_download)
	show_download_percent(url_download)
	timer.start()

func _on_android_popupmenu_id_pressed(id: int):
	match id:
		Items.LatestVersion:
			start_download("android", android_download_path, "poing-godot-admob-android-")
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(android_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-android/tree/" + version_support.android)

func _on_ios_popupmenu_id_pressed(id: int):
	match id:
		Items.LatestVersion:
			start_download("ios", ios_download_path, "poing-godot-admob-ios-")
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(ios_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-ios/tree/" + version_support.ios)

func _on_popupmenu_id_pressed(id : int):
	match id:
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(default_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-plugin/tree/" + plugin_version)

func show_download_percent(url_download: String = ""):
	if not url_download.is_empty():
		print("Downloading " + url_download)
	
	var bodySize = http_request_downloader.get_body_size()
	var downloadedBytes = http_request_downloader.get_downloaded_bytes()
	
	var percent = int(downloadedBytes * 100 / bodySize)
	print("Download percent: " + str(percent) + "%")
