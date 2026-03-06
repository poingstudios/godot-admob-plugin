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
signal version_received()

var _http_request: HTTPRequest

func _init(host: Node) -> void:
	_http_request = HTTPRequest.new()
	host.add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)

func check_for_updates() -> void:
	var url = "https://raw.githubusercontent.com/poingstudios/godot-admob-versions/" + PluginVersion.current + "/versions.json"
	_http_request.request(url)

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.new()
		if json.parse(body.get_string_from_utf8()) == OK:
			PluginVersion.support = PluginVersion.PlatformSupport.create(json.get_data())
			version_received.emit()
			return

	printerr("ERR_001: Couldn't get version supported dynamic for AdMob, the latest supported version listed may be outdated. \n" +
	"Read more about on: res://addons/admob/docs/errors/ERR_001.md")
