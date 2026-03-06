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

extends "res://addons/admob/internal/editor/popup_menu.gd"

# Services
const VersionService := preload("res://addons/admob/internal/services/network/version_service.gd")
const DownloadService := preload("res://addons/admob/internal/services/network/download_service.gd")

# Handlers
const AndroidHandler := preload("res://addons/admob/internal/handlers/android_handler.gd")
const IOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")

# UI Components
const AndroidMenu := preload("res://addons/admob/internal/editor/components/android_menu.gd")
const IOSMenu := preload("res://addons/admob/internal/editor/components/ios_menu.gd")
const DocumentsMenu := preload("res://addons/admob/internal/editor/components/documents_menu.gd")
const HelpMenu := preload("res://addons/admob/internal/editor/components/help_menu.gd")
const SupportMenu := preload("res://addons/admob/internal/editor/components/support_menu.gd")
const DialogService := preload("res://addons/admob/internal/services/ui/dialog_service.gd")

const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")

const DEFAULT_DOWNLOAD_PATH := "res://addons/admob/downloads/"

var _version_service: VersionService
var _dialog_service: DialogService
var _android_handler: AndroidHandler
var _ios_handler: IOSHandler

func _init(host: Node) -> void:
	super._init()
	# Initialize Services
	_version_service = VersionService.new(host)
	_version_service.version_received.connect(_on_version_received)
	_version_service.check_for_updates()
	
	# Initialize Dialog Service
	_dialog_service = DialogService.new()
	
	# Initialize Handlers
	_android_handler = AndroidHandler.new(DownloadService.new(host), _dialog_service)
	_ios_handler = IOSHandler.new(DownloadService.new(host), _dialog_service)
	
	_setup_menu()

func _setup_menu() -> void:
	# Add Submenus
	_add_submenu(AndroidMenu.new(_android_handler))
	_add_submenu(IOSMenu.new(_ios_handler))
	_add_submenu(DocumentsMenu.new())
	_add_submenu(HelpMenu.new())
	_add_submenu(SupportMenu.new())

	# Add Main Items
	add_menu_item("Downloads Folder", func(): OS.shell_open(str("file://", ProjectSettings.globalize_path(DEFAULT_DOWNLOAD_PATH))))
	add_menu_item("GitHub", func(): OS.shell_open("https://github.com/poingstudios/godot-admob-plugin/tree/" + PluginVersion.current))

func _add_submenu(menu: PopupMenu) -> void:
	add_child(menu)
	add_submenu_item(menu.name, menu.name)

func _on_version_received() -> void:
	_android_handler.check_dependencies()
	_ios_handler.check_dependencies()
