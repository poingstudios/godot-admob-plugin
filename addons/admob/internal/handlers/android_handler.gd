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
const AdMobZipService := preload("res://addons/admob/internal/services/archive/zip_service.gd")

const PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const DOWNLOAD_DIR := "res://addons/admob/downloads/android/"
const EXTRACT_PATH := "res://addons/admob/android/bin/"
const BASE_URL := "https://github.com/poingstudios/godot-admob-android/releases/download/%s/%s"

var _download_service: AdMobDownloadService

func _init(download_service: AdMobDownloadService) -> void:
	_download_service = download_service
	_download_service.download_completed.connect(_on_download_completed)

func check_dependencies() -> void:
	var remote_version: String = PluginVersion.support.get("android")
	var local_version := _get_local_version()
	
	if local_version == remote_version:
		return

	if local_version.is_empty():
		print_rich("[color=YELLOW]AdMob Android plugin not found. Downloading version %s automatically...[/color]" % remote_version)
	else:
		print_rich("[color=YELLOW]AdMob Android plugin is outdated. Local: %s, Remote: %s. Downloading automatically...[/color]" % [local_version, remote_version])
	
	install(remote_version)

func install(version: String) -> void:
	var file_name := _get_zip_file_name()
	var url := BASE_URL % [version, file_name]
	var destination := DOWNLOAD_DIR.path_join(file_name)
	
	_download_service.download_file(url, destination)

func _on_download_completed(success: bool, _path: String) -> void:
	if not success:
		return
	
	var file_name := _get_zip_file_name()
	var zip_path := DOWNLOAD_DIR.path_join(file_name)
	
	var extract_success := AdMobZipService.extract_zip(zip_path, EXTRACT_PATH, true)

func _get_local_version() -> String:
	if not FileAccess.file_exists(PACKAGE_PATH):
		return ""
	
	var script := load(PACKAGE_PATH)
	if script and "VERSION" in script:
		return str(script.get("VERSION"))
	
	return ""

func _get_zip_file_name() -> String:
	return "poing-godot-admob-android-" + PluginVersion.godot + ".zip"