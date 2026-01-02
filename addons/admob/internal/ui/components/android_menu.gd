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

const AdMobPluginVersion := preload("res://addons/admob/internal/version/admob_plugin_version.gd")

enum Items {
	LatestVersion,
	Folder,
	GitHub
}

var _handler: Object
var _download_path: String = "res://addons/admob/downloads/android/"

func _init(handler: Object) -> void:
	name = "Android"
	_handler = handler
	
	add_item(str(Items.keys()[Items.LatestVersion]), Items.LatestVersion)
	add_item(str(Items.keys()[Items.Folder]), Items.Folder)
	add_item(str(Items.keys()[Items.GitHub]), Items.GitHub)
	add_item("Copy Metadata", 98)
	add_item("Open AndroidManifest.xml", 99)
	
	id_pressed.connect(_on_id_pressed)

func _on_id_pressed(id: int) -> void:
	match id:
		Items.LatestVersion:
			_handler.install(AdMobPluginVersion.godot, AdMobPluginVersion.support["android"], _download_path)
		Items.Folder:
			var path_directory = ProjectSettings.globalize_path(_download_path)
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
