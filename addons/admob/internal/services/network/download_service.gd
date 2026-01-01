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

class_name AdMobDownloadService

signal download_completed(success: bool)
signal download_progress(percent: int)

var _http_request: HTTPRequest
var _progress_timer: Timer

func _init(http_request: HTTPRequest, progress_timer: Timer) -> void:
	_http_request = http_request
	_progress_timer = progress_timer
	_http_request.request_completed.connect(_on_request_completed)
	_progress_timer.timeout.connect(_on_progress_timer_timeout)

func download_file(url: String, destination_path: String) -> void:
	if _http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		push_error("AdMob: Download already in progress")
		return
	
	print("Downloading " + url)
	_http_request.download_file = destination_path
	_http_request.request(url)
	_progress_timer.start()

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	_progress_timer.stop()
	
	if response_code == 200:
		var real_path = ProjectSettings.globalize_path(_http_request.download_file.get_base_dir())
		print_rich("Download completed, you can check the downloaded file at: [color=CORNFLOWER_BLUE][url]" + real_path + "[/url][/color]")
		download_completed.emit(true)
	else:
		printerr("ERR_002: It is not possible to download the Android/iOS plugin. \n" \
			+"Read more about on: res://addons/admob/docs/errors/ERR_002.md")
		download_completed.emit(false)

func _on_progress_timer_timeout() -> void:
	var body_size = _http_request.get_body_size()
	var downloaded_bytes = _http_request.get_downloaded_bytes()
	
	if body_size > 0:
		var percent = int(downloaded_bytes * 100 / body_size)
		print("Download percent: " + str(percent) + "%")
		download_progress.emit(percent)
