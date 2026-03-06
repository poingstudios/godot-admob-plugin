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

const EXPORT_PRESETS_PATH := "res://export_presets.cfg"

static func get_activated_plugins(platform_name: String) -> Array[String]:
	var activated_plugins: Array[String] = []
	
	if not FileAccess.file_exists(EXPORT_PRESETS_PATH):
		return activated_plugins
		
	var config := ConfigFile.new()
	var err := config.load(EXPORT_PRESETS_PATH)
	if err != OK:
		return activated_plugins
		
	for section in config.get_sections():
		if not section.begins_with("preset."):
			continue
			
		var platform = config.get_value(section, "platform", "")
		if platform != platform_name:
			continue
			
		# Check options for this preset
		var options_section = section + ".options"
		if config.has_section(options_section):
			for key in config.get_section_keys(options_section):
				if key.begins_with("plugins/"):
					var is_enabled = config.get_value(options_section, key, false)
					if is_enabled:
						var plugin_name = key.trim_prefix("plugins/")
						if not activated_plugins.has(plugin_name):
							activated_plugins.append(plugin_name)
	
	return activated_plugins
