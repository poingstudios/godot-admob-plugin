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
const DownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")
const ZipService := preload("res://addons/admob/internal/services/archive/zip_service.gd")
const InstallerService := preload("res://addons/admob/internal/services/installer_service.gd")

const PACKAGE_PATH := "res://addons/admob/android/bin/package.gd"
const DOWNLOAD_DIR := "res://addons/admob/downloads/android/"
const EXTRACT_PATH := "res://addons/admob/android/bin/"
const BASE_URL := "https://github.com/poingstudios/godot-admob-plugin/releases/download/%s/%s"

const DialogService := preload("res://addons/admob/internal/services/ui/dialog_service.gd")

var _download_service: DownloadService
var _dialog_service: DialogService


func _init(download_service: DownloadService, dialog_service: DialogService) -> void:
	_download_service = download_service
	_dialog_service = dialog_service
	_download_service.download_completed.connect(_on_download_completed)


func check_dependencies() -> void:
	if not PluginVersion.is_android_installed:
		print_rich("[color=YELLOW]AdMob Android plugin not found. Installing...[/color]")
		install()


func install() -> void:
	var file_name := get_zip_file_name()
	var url := BASE_URL % [PluginVersion.current, file_name]
	var destination := DOWNLOAD_DIR.path_join(file_name)

	_download_service.download_file(url, destination, "Android")


func _on_download_completed(success: bool) -> void:
	if not success:
		return

	var file_name := get_zip_file_name()
	var zip_path := DOWNLOAD_DIR.path_join(file_name)

	var extract_success := ZipService.extract_zip(zip_path, EXTRACT_PATH, true)
	if extract_success:
		InstallerService.create_package_file(PACKAGE_PATH)
		(
			_dialog_service
			. show_message(
				"Android plugin installed successfully!\n\nPlease configure AdMob for Android in the Project Settings (Project -> Project Settings -> General -> Admob)."
			)
		)



static func get_zip_file_name() -> String:
	return "android-template-" + PluginVersion.godot + ".zip"
