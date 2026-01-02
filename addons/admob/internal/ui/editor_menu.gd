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

# Services
const AdMobVersionService := preload("res://addons/admob/internal/services/network/version_service.gd")
const AdMobDownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")

# Handlers
const AdMobAndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const AdMobIOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")

# UI Components
const AndroidMenu := preload("res://addons/admob/internal/ui/components/android_menu.gd")
const IOSMenu := preload("res://addons/admob/internal/ui/components/ios_menu.gd")
const DocumentsMenu := preload("res://addons/admob/internal/ui/components/documents_menu.gd")
const HelpMenu := preload("res://addons/admob/internal/ui/components/help_menu.gd")
const SupportMenu := preload("res://addons/admob/internal/ui/components/support_menu.gd")

const AdMobPluginVersion := preload("res://addons/admob/internal/version/admob_plugin_version.gd")

var _default_download_path := "res://addons/admob/downloads/"

enum Items {
	Folder,
	GitHub
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
	# Add Submenus
	_add_submenu(AndroidMenu.new(_android_handler))
	_add_submenu(IOSMenu.new(_ios_handler))
	
	# Add Main Items
	add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)
	id_pressed.connect(_on_id_pressed)
	
	# Add Other Submenus
	_add_submenu(DocumentsMenu.new())
	_add_submenu(HelpMenu.new())
	_add_submenu(SupportMenu.new())

func _add_submenu(menu: PopupMenu) -> void:
	add_child(menu)
	add_submenu_item(menu.name, menu.name)

func _on_id_pressed(id: int) -> void:
	match id:
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(_default_download_path)
			OS.shell_open(str("file://", path_directory))
		Items.GitHub:
			OS.shell_open("https://github.com/poingstudios/godot-admob-plugin/tree/" + AdMobPluginVersion.current)
