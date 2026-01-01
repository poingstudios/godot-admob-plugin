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

const AdMobDownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")
const AdMobZipService := preload("res://addons/admob/internal/services/archive/zip_service.gd")
const AdMobFolderService := preload("res://addons/admob/internal/services/file_system/folder_service.gd")
const AdMobAndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const AdMobIOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")
const AdMobPluginVersion := preload("res://addons/admob/internal/version/admob_plugin_version.gd")
const AdMobEditorMenu := preload("res://addons/admob/internal/ui/editor_menu.gd")

var _main_exporter := preload("res://addons/admob/internal/exporters/main_export_plugin.gd").new()
var _android_exporter := preload("res://addons/admob/internal/exporters/android_export_plugin.gd").new()

func _enter_tree():
	add_export_plugin(_main_exporter)
	add_export_plugin(_android_exporter)

	_request_version_support()
	
	var http_request := HTTPRequest.new()
	add_child(http_request)
	
	var progress_timer := Timer.new()
	progress_timer.wait_time = 3.0
	add_child(progress_timer)
	
	var download_service := AdMobDownloadService.new(http_request, progress_timer)
	var android_handler := AdMobAndroidHandler.new(download_service)
	var ios_handler := AdMobIOSHandler.new(download_service)
	
	var popup := AdMobEditorMenu.new(android_handler, ios_handler)
	add_tool_submenu_item("AdMob Download Manager", popup)

func _exit_tree():
	remove_export_plugin(_main_exporter)
	remove_export_plugin(_android_exporter)
	remove_tool_menu_item("AdMob Download Manager")

func _request_version_support():
	var url = "https://raw.githubusercontent.com/poingstudios/godot-admob-versions/" + AdMobPluginVersion.current + "/versions.json"
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(_on_version_support_request_completed)
	add_child(http_request)
	http_request.request(url)

func _on_version_support_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			AdMobPluginVersion.support = json.get_data() as Dictionary
			return
	printerr("ERR_001: Couldn't get version supported dynamic for AdMob, the latest supported version listed may be outdated. \n" \
	+"Read more about on: res://addons/admob/docs/errors/ERR_001.md")
