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

@abstract class_name AdMobDownloader extends RefCounted

signal download_completed(success: bool)

var _download_service: AdMobDownloadService
var _godot_version: String
var _download_path: String

func _init(download_service: AdMobDownloadService) -> void:
	_download_service = download_service
	_download_service.download_completed.connect(_on_download_completed)

func download(godot_version: String, version: String, download_path: String) -> void:
	_godot_version = godot_version
	_download_path = download_path
	
	var file_name = _get_zip_file_name()
	var url = _get_download_url(version, file_name)
	var destination = _download_path.path_join(file_name)
	
	_download_service.download_file(url, destination)

func _on_download_completed(success: bool) -> void:
	download_completed.emit(success)

@abstract func _get_zip_file_name() -> String;
@abstract func _get_download_url(version: String, file_name: String) -> String;
