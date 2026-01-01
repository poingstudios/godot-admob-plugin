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

@abstract class_name AdMobInstaller
extends AdMobDownloader

signal installation_completed(success: bool)

func install(godot_version: String, version: String, download_path: String) -> void:
	download(godot_version, version, download_path)

func _on_download_completed(success: bool) -> void:
	if not success:
		installation_completed.emit(false)
		return
	
	_extract()

func _extract() -> void:
	var file_name = _get_zip_file_name()
	var zip_path = _download_path.path_join(file_name)
	var extract_path = _get_extract_path()
	
	var success = AdMobZipService.extract_zip(zip_path, extract_path, true)
	installation_completed.emit(success)

@abstract func _get_extract_path() -> String;
