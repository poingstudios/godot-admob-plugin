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

signal download_completed(success: bool)
signal download_progress(percent: int)

var _http_request: HTTPRequest
var _progress_timer: Timer

func _init(host: Node) -> void:
	_http_request = HTTPRequest.new()
	host.add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)
	
	_progress_timer = Timer.new()
	host.add_child(_progress_timer)
	_progress_timer.timeout.connect(_on_progress_timer_timeout)

func download_file(url: String, destination_path: String) -> void:
	if _http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		push_error("AdMob: Download already in progress")
		return
	
	DirAccess.make_dir_recursive_absolute(destination_path.get_base_dir())
	
	print("Downloading " + url)
	_http_request.download_file = destination_path
	_http_request.request(url)
	_progress_timer.start(3.0)

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	_progress_timer.stop()
	
	var is_success := response_code == 200

	if is_success:
		var download_path := ProjectSettings.globalize_path(_http_request.download_file.get_base_dir())
		print_rich("[color=GREEN]Downloaded[/color] at: [color=CORNFLOWER_BLUE][url]" + download_path + "[/url][/color]")
	else:
		printerr("ERR_002: It is not possible to download the Android/iOS plugin. \n" +
				"Read more about on: res://addons/admob/docs/errors/ERR_002.md")
	
	download_completed.emit(is_success)

func _on_progress_timer_timeout() -> void:
	var body_size = _http_request.get_body_size()
	var downloaded_bytes = _http_request.get_downloaded_bytes()
	
	if body_size > 0:
		var percent = int(downloaded_bytes * 100 / body_size)
		print("Download percent: " + str(percent) + "%")
		download_progress.emit(percent)
