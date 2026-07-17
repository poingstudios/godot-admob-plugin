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


static func create_package_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		var content := """# This file is dynamically generated.
# It defines the current installed version of the platform plugin.
# Do not modify this manually.

const VERSION := "%s"
""" % PluginVersion.current
		file.store_string(content)
		file.close()

	var gitignore_path := path.get_base_dir().get_base_dir().path_join(".gitignore")
	if not FileAccess.file_exists(gitignore_path):
		var gitignore_file := FileAccess.open(gitignore_path, FileAccess.WRITE)
		if gitignore_file:
			var gitignore_content := """# Remove the line below if you want to commit the binaries to your repository
/bin
"""
			gitignore_file.store_string(gitignore_content)
			gitignore_file.close()
