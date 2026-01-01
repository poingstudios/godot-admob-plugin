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
const AdMobVersionService := preload("res://addons/admob/internal/services/network/version_service.gd")
const AdMobAndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const AdMobIOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")
const AdMobPluginVersion := preload("res://addons/admob/internal/version/admob_plugin_version.gd")
const AdMobEditorMenu := preload("res://addons/admob/internal/ui/editor_menu.gd")

var _main_exporter := preload("res://addons/admob/internal/exporters/main_export_plugin.gd").new()
var _android_exporter := preload("res://addons/admob/internal/exporters/android_export_plugin.gd").new()

func _enter_tree():
	add_export_plugin(_main_exporter)
	add_export_plugin(_android_exporter)
	
	var version_http_request := HTTPRequest.new()
	add_child(version_http_request)
	var version_service := AdMobVersionService.new(version_http_request)
	version_service.check_for_updates()
	

	var download_http_request := HTTPRequest.new()
	add_child(download_http_request)
	
	var progress_timer := Timer.new()
	progress_timer.wait_time = 3.0
	add_child(progress_timer)
	
	var download_service := AdMobDownloadService.new(download_http_request, progress_timer)
	var android_handler := AdMobAndroidHandler.new(download_service)
	var ios_handler := AdMobIOSHandler.new(download_service)
	
	var popup := AdMobEditorMenu.new(android_handler, ios_handler)
	add_tool_submenu_item("AdMob Download Manager", popup)

func _exit_tree():
	remove_export_plugin(_main_exporter)
	remove_export_plugin(_android_exporter)
	remove_tool_menu_item("AdMob Download Manager")
