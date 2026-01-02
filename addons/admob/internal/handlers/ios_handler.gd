# MIT License

# Copyright (c) 2026-present Poing Studios

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

const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")
const AdMobDownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")
const DOWNLOAD_DIR := "res://addons/admob/downloads/ios/"
var _download_service: AdMobDownloadService

func _init(download_service: AdMobDownloadService) -> void:
	_download_service = download_service

func download() -> void:
	var file_name = _get_zip_file_name()
	var url = "https://github.com/poingstudios/godot-admob-ios/releases/download/" + PluginVersion.support.ios + "/" + file_name
	var destination = DOWNLOAD_DIR.path_join(file_name)
	
	_download_service.download_file(url, destination)

func _get_zip_file_name() -> String:
	return "poing-godot-admob-ios-" + PluginVersion.godot + ".zip"
