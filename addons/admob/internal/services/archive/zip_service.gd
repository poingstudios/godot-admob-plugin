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

const FileService := preload("res://addons/admob/internal/services/ui/file_service.gd")

enum StripMode {NONE, AUTO_DETECT, FORCE}

static func extract_zip(zip_path: String, destination_path: String, clean_destination: bool, strip_mode: StripMode = StripMode.NONE) -> bool:
	if clean_destination:
		_delete_dir_recursive(destination_path)
	return _extract(zip_path, destination_path, strip_mode)

static func _extract(zip_path: String, destination_path: String, strip_mode: StripMode) -> bool:
	var reader := _open_zip(zip_path)
	if not reader:
		return false
	
	var files := reader.get_files()
	var common_root := _detect_common_root(files) if strip_mode == StripMode.AUTO_DETECT else ""
	
	_extract_files(reader, files, destination_path, strip_mode, common_root)
	reader.close()
	
	FileService.refresh_filesystem()
	_print_success(destination_path)
	return true

static func _open_zip(zip_path: String) -> ZIPReader:
	var reader := ZIPReader.new()
	if reader.open(ProjectSettings.globalize_path(zip_path)) != OK:
		return null
	return reader

static func _detect_common_root(files: PackedStringArray) -> String:
	if files.is_empty() or not files[0].ends_with("/"):
		return ""
	
	var candidate := files[0]
	for file in files:
		if not file.begins_with(candidate):
			return ""
	return candidate

static func _extract_files(reader: ZIPReader, files: PackedStringArray, destination: String, strip_mode: StripMode, common_root: String) -> void:
	for file_path in files:
		var relative_path := _calculate_relative_path(file_path, strip_mode, common_root)
		if relative_path.is_empty():
			continue
		
		var target_path := destination.path_join(relative_path)
		
		if file_path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute(target_path)
		else:
			_write_file(target_path, reader.read_file(file_path))

static func _calculate_relative_path(file_path: String, strip_mode: StripMode, common_root: String) -> String:
	if strip_mode == StripMode.FORCE:
		var parts := file_path.split("/", false)
		if parts.size() <= 1 and file_path.ends_with("/"):
			return ""
		parts.remove_at(0)
		return "/".join(parts)
	
	if not common_root.is_empty():
		if file_path == common_root:
			return ""
		return file_path.trim_prefix(common_root)
		
	return file_path

static func _write_file(path: String, content: PackedByteArray) -> void:
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_buffer(content)


static func _print_success(destination: String) -> void:
	var path := ProjectSettings.globalize_path(destination)
	print_rich("[color=GREEN]Extracted[/color] zip to: [color=CORNFLOWER_BLUE][url]%s[/url][/color]" % path)

static func _delete_dir_recursive(path: String) -> void:
	var dir := DirAccess.open(path)
	if not dir:
		return
	
	for item in _list_directory_contents(dir):
		var full_path := path.path_join(item)
		if dir.current_is_dir():
			_delete_dir_recursive(full_path)
		else:
			DirAccess.remove_absolute(full_path)
	
	DirAccess.remove_absolute(path)

static func _list_directory_contents(dir: DirAccess) -> Array[String]:
	var contents: Array[String] = []
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if name not in [".", ".."]:
			contents.append(name)
		name = dir.get_next()
	dir.list_dir_end()
	return contents