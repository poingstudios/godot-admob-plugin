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

static func extract_zip(zip_path: String, destination_path: String, clean_destination := false) -> bool:
	if clean_destination:
		_delete_dir_recursive(destination_path)
	
	var zip_reader := ZIPReader.new()
	if zip_reader.open(ProjectSettings.globalize_path(zip_path)) != OK:
		return false
	
	var files := zip_reader.get_files()
	var root := files[0] if not files.is_empty() and files[0].ends_with("/") else ""
	
	for path in files:
		if not root.is_empty() and path == root: continue
		
		var target := destination_path.path_join(path.trim_prefix(root))
		if path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute(target)
		else:
			_store_file(target, zip_reader.read_file(path))
	
	zip_reader.close()
	_refresh_filesystem()

	print_rich("Extracted zip to: [color=CORNFLOWER_BLUE][url]%s[/url][/color]" % ProjectSettings.globalize_path(destination_path))
	return true

static func _store_file(path: String, content: PackedByteArray) -> void:
	var base_dir := path.get_base_dir()
	if not DirAccess.dir_exists_absolute(base_dir):
		DirAccess.make_dir_recursive_absolute(base_dir)
		
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_buffer(content)
		file.close()

static func _refresh_filesystem() -> void:
	if Engine.is_editor_hint() or OS.has_feature("editor"):
		EditorInterface.get_resource_filesystem().scan()
		EditorInterface.get_resource_filesystem().scan_sources()

static func _delete_dir_recursive(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path := path.path_join(file_name)
			if dir.current_is_dir():
				_delete_dir_recursive(full_path)
			else:
				DirAccess.remove_absolute(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	DirAccess.remove_absolute(path)
