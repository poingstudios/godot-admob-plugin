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

static func write_file(path: String, content: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return
		
	file.store_string(content)
	file.close()
	update_file(path)

static func update_file(path: String) -> void:
	if not Engine.is_editor_hint() or path.is_empty() or not FileAccess.file_exists(path):
		return
	
	EditorInterface.get_resource_filesystem().update_file(path)
	refresh_filesystem()

static func refresh_filesystem() -> void:
	if not Engine.is_editor_hint():
		return
		
	var fs := EditorInterface.get_resource_filesystem()
	fs.scan()
	fs.scan_sources()
