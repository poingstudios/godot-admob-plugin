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

const PluginVersion := preload("res://addons/admob/internal/version/plugin_version.gd")
const IOSHandler := preload("res://addons/admob/internal/handlers/ios_handler.gd")

var _handler: IOSHandler

func _init(handler: IOSHandler) -> void:
	super._init()
	name = "iOS"
	_handler = handler
	
	add_menu_item("Download & Install", func(): _handler.install())
	add_menu_item("Copy shell command", _copy_shell_command)
	add_menu_item("GitHub", func(): OS.shell_open("https://github.com/poingstudios/godot-admob-ios/tree/" + PluginVersion.support.ios))

func _copy_shell_command() -> void:
	var snippet := "chmod +x update_and_install.sh\n./update_and_install.sh"

	DisplayServer.clipboard_set(snippet)

	print_rich("[b][color=GREEN]✔ Copied install command to clipboard![/color][/b]\n" +
			"[code]" + snippet + "[/code]")
