# MIT License

# Copyright (c) 2026-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the_conditions:

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
const ZipService := preload("res://addons/admob/internal/services/archive/zip_service.gd")
const AndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const IOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")
const InstallerService := preload("res://addons/admob/internal/services/installer_service.gd")


static func install_missing_binaries_sync() -> void:
	if DisplayServer.get_name() != "headless":
		return

	if not PluginVersion.is_android_installed:
		_install_android_sync()

	if not PluginVersion.is_ios_installed:
		_install_ios_sync()


static func _install_android_sync() -> void:
	var zip_file_name := AndroidHandler.get_zip_file_name()
	var url := AndroidHandler.BASE_URL % [PluginVersion.current, zip_file_name]
	var destination := AndroidHandler.DOWNLOAD_DIR.path_join(zip_file_name)

	print(
		"AdMob: Headless mode detected and Android binaries are missing. Downloading dynamically..."
	)
	var success := _download_file_sync(url, destination)
	if not success:
		return

	var extract_success := ZipService.extract_zip(
		destination, AndroidHandler.EXTRACT_PATH, true, ZipService.StripMode.NONE
	)
	if extract_success:
		InstallerService.create_package_file(AndroidHandler.PACKAGE_PATH)
		print("AdMob: Android binaries successfully downloaded and installed!")


static func _install_ios_sync() -> void:
	var zip_file_name := IOSHandler.get_zip_file_name()
	var url := IOSHandler.BASE_URL % [PluginVersion.current, zip_file_name]
	var destination := IOSHandler.DOWNLOAD_DIR.path_join(zip_file_name)

	print("AdMob: Headless mode detected and iOS binaries are missing. Downloading dynamically...")
	var success := _download_file_sync(url, destination)
	if not success:
		return

	var extract_success := ZipService.extract_zip(
		destination, IOSHandler.EXTRACT_PATH, false, ZipService.StripMode.NONE
	)
	if extract_success:
		InstallerService.create_package_file(IOSHandler.PACKAGE_PATH)
		print("AdMob: iOS binaries successfully downloaded and installed!")



static func _download_file_sync(url: String, destination_path: String) -> bool:
	DirAccess.make_dir_recursive_absolute(destination_path.get_base_dir())
	var global_dest := ProjectSettings.globalize_path(destination_path)

	var args := PackedStringArray()
	var executable := ""

	if OS.get_name() == "Windows":
		executable = "powershell"
		args = PackedStringArray(
			[
				"-Command",
				(
					"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%s' -OutFile '%s'"
					% [url, global_dest]
				)
			]
		)
	else:
		var output := []
		var exit_code := OS.execute("which", PackedStringArray(["curl"]), output)
		if exit_code == 0:
			executable = "curl"
			args = PackedStringArray(["-L", "-o", global_dest, url])
		else:
			exit_code = OS.execute("which", PackedStringArray(["wget"]), output)
			if exit_code == 0:
				executable = "wget"
				args = PackedStringArray(["-O", global_dest, url])
			else:
				printerr(
					"AdMob Error: Neither curl nor wget is available for synchronous download."
				)
				return false

	print("AdMob: Downloading synchronously from " + url)
	var output := []
	var exit_code := OS.execute(executable, args, output, true)
	if exit_code != 0:
		printerr(
			(
				"AdMob Error: Synchronous download failed with exit code %d. Output: %s"
				% [exit_code, str(output)]
			)
		)
		return false

	return true
