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

extends PopupMenu

const AdMobVersionService := preload("res://addons/admob/internal/services/network/version_service.gd")
const AdMobDownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")
const AdMobAndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const AdMobIOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")
const AdMobPluginVersion := preload("res://addons/admob/internal/version/admob_plugin_version.gd")

var _android_download_path := "res://addons/admob/downloads/android/"
var _ios_download_path := "res://addons/admob/downloads/ios/"
var _default_download_path := "res://addons/admob/downloads/"

enum Items {
	LatestVersion,
	Folder,
	GitHub
}

enum DocumentsItems {
	Official,
	Google,
}

enum HelpItems {
	Discord,
	SDK_Developers,
}

enum SupportItems {
	Patreon,
	KoFi,
	PayPal
}

var _version_service: Object
var _download_service: Object
var _android_handler: Object
var _ios_handler: Object

func _init(host: Node) -> void:
	# Initialize Services
	_version_service = AdMobVersionService.new(host)
	_version_service.check_for_updates()
	
	_download_service = AdMobDownloadService.new(host)
	
	# Initialize Handlers
	_android_handler = AdMobAndroidHandler.new(_download_service)
	_ios_handler = AdMobIOSHandler.new(_download_service)
	
	_setup_menu()

func _setup_menu() -> void:
	var android_popup := PopupMenu.new()
	android_popup.name = "Android"
	add_child(android_popup)

	var ios_popup := PopupMenu.new()
	ios_popup.name = "iOS"
	add_child(ios_popup)
	
	android_popup.id_pressed.connect(_on_android_popupmenu_id_pressed)
	android_popup.add_item(str(Items.keys()[Items.LatestVersion]), Items.LatestVersion)
	android_popup.add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	android_popup.add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)
	android_popup.add_item("Copy Metadata", 98)
	android_popup.add_item("Open AndroidManifest.xml", 99)

	ios_popup.id_pressed.connect(_on_ios_popupmenu_id_pressed)
	ios_popup.add_item(str(Items.keys()[Items.LatestVersion]), Items.LatestVersion)
	ios_popup.add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	ios_popup.add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)
	ios_popup.add_item("Copy shell command", 99)
	
	id_pressed.connect(_on_popupmenu_id_pressed)
	
	add_submenu_item(android_popup.name, android_popup.name)
	add_submenu_item(ios_popup.name, ios_popup.name)
	add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)

	var documents_popup := PopupMenu.new()
	documents_popup.name = "Documents"
	documents_popup.id_pressed.connect(_on_documents_popup_id_pressed)
	documents_popup.add_item(str(DocumentsItems.keys()[DocumentsItems.Official]))
	documents_popup.add_item(str(DocumentsItems.keys()[DocumentsItems.Google]))
	add_child(documents_popup)
	add_submenu_item(documents_popup.name, documents_popup.name)

	var help_popup := PopupMenu.new()
	help_popup.name = "Help"
	help_popup.id_pressed.connect(_on_help_popup_id_pressed)
	help_popup.add_item(str(HelpItems.keys()[HelpItems.Discord]))
	help_popup.add_item(str(HelpItems.keys()[HelpItems.SDK_Developers]))
	add_child(help_popup)
	add_submenu_item(help_popup.name, help_popup.name)

	var support_popup := PopupMenu.new()
	support_popup.name = "Support"
	support_popup.id_pressed.connect(_on_support_popup_id_pressed)
	support_popup.add_item(str(SupportItems.keys()[SupportItems.Patreon]))
	support_popup.add_item(str(SupportItems.keys()[SupportItems.KoFi]))
	support_popup.add_item(str(SupportItems.keys()[SupportItems.PayPal]))
	add_child(support_popup)
	add_submenu_item(support_popup.name, support_popup.name)

func _on_android_popupmenu_id_pressed(id: int):
	match id:
		Items.LatestVersion:
			_android_handler.install(AdMobPluginVersion.godot, AdMobPluginVersion.support["android"], _android_download_path)
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(_android_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-android/tree/" + AdMobPluginVersion.support.android)
		98:
			var snippet := """<!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
			<meta-data
				android:name="com.google.android.gms.ads.APPLICATION_ID"
				android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>"""

			DisplayServer.clipboard_set(snippet)

			print_rich("[b][color=GREEN]✔ Copied AdMob Metadata to clipboard![/color][/b]\n" +
					"[color=CORNFLOWER_BLUE]" + snippet + "[/color]")

		99:
			var manifest_path := ProjectSettings.globalize_path("res://android/build/AndroidManifest.xml")
			OS.shell_open("file://" + manifest_path)

			print_rich("[b]Opened:[/b] [color=CORNFLOWER_BLUE][url]file://" + manifest_path + "[/url][/color]")

func _on_ios_popupmenu_id_pressed(id: int):
	match id:
		Items.LatestVersion:
			_ios_handler.download(AdMobPluginVersion.godot, AdMobPluginVersion.support["ios"], _ios_download_path)
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(_ios_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-ios/tree/" + AdMobPluginVersion.support.ios)
		99:
			var snippet := "chmod +x update_and_install.sh\n./update_and_install.sh"

			DisplayServer.clipboard_set(snippet)

			print_rich("[b][color=GREEN]✔ Copied install command to clipboard![/color][/b]\n" +
					"[code]" + snippet + "[/code]")

func _on_popupmenu_id_pressed(id: int):
	match id:
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(_default_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-plugin/tree/" + AdMobPluginVersion.current)

func _on_documents_popup_id_pressed(id: int):
	match id:
		DocumentsItems.Official:
			OS.shell_open("https://poingstudios.github.io/godot-admob-plugin")
		DocumentsItems.Google:
			OS.shell_open("https://developers.google.com/admob")

func _on_help_popup_id_pressed(id: int):
	match id:
		HelpItems.Discord:
			OS.shell_open("https://discord.com/invite/YEPvYjSSMk")
		HelpItems.SDK_Developers:
			OS.shell_open("https://groups.google.com/g/google-admob-ads-sdk/")

func _on_support_popup_id_pressed(id: int):
	match id:
		SupportItems.Patreon:
			OS.shell_open("https://www.patreon.com/poingstudios")
		SupportItems.KoFi:
			OS.shell_open("https://ko-fi.com/poingstudios")
		SupportItems.PayPal:
			OS.shell_open("https://www.paypal.com/donate/?hosted_button_id=EBUVPEGF4BUR8")
