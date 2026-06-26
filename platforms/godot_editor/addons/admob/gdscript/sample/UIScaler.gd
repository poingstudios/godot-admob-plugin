# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends RefCounted


static func scale_ui(node: Node, total_factor: float, scale_factor: float) -> void:
	if node is Control:
		# 1. Mouse filter optimization
		var is_interactive := (
			node is Button
			or node is LineEdit
			or node is TextEdit
			or node is Slider
			or node is OptionButton
			or node is CheckButton
			or node is CheckBox
			or node is ColorPickerButton
			or node is MenuButton
		)
		if not is_interactive and not (node is PanelContainer or node is ScrollContainer or node is TabContainer):
			node.mouse_filter = Control.MOUSE_FILTER_IGNORE

		# 2. Font scaling and StyleBox overrides based on node type
		if node is Button:
			if node.get_parent() and node.get_parent().name == "PositionGrid":
				# Predefined position buttons
				var target_size := clampi(int(round(60.0 * total_factor)), 45, 150)
				node.custom_minimum_size = Vector2(target_size, target_size)
				var margin_size := clampi(int(round(10.0 * total_factor)), 6, 30)
				var style_names := ["normal", "hover", "pressed", "disabled"]
				for style_name: String in style_names:
					var original_sb: StyleBox = node.get_theme_stylebox(style_name)
					if original_sb is StyleBoxFlat:
						var new_sb: StyleBoxFlat = original_sb.duplicate() as StyleBoxFlat
						new_sb.content_margin_left = margin_size
						new_sb.content_margin_right = margin_size
						new_sb.content_margin_top = margin_size
						new_sb.content_margin_bottom = margin_size
						node.add_theme_stylebox_override(style_name, new_sb)
			else:
				var font_size := clampi(int(round(12.5 * total_factor)), 12, 80)
				node.add_theme_font_size_override("font_size", font_size)
				# Scale Button StyleBoxes for padding
				var stylebox_names := ["normal", "hover", "pressed", "disabled"]
				for sb_name in stylebox_names:
					var sb: StyleBox = node.get_theme_stylebox(sb_name)
					if sb is StyleBoxFlat:
						var new_sb: StyleBoxFlat = sb.duplicate() as StyleBoxFlat
						new_sb.content_margin_top = int(round(8.0 * scale_factor))
						new_sb.content_margin_bottom = int(round(8.0 * scale_factor))
						node.add_theme_stylebox_override(sb_name, new_sb)

		elif node is Label:
			if node.name == "AppTitle":
				node.add_theme_font_size_override("font_size", clampi(int(round(16.0 * total_factor)), 16, 120))
			elif node.name == "SupportLabel":
				node.add_theme_font_size_override("font_size", clampi(int(round(10.5 * total_factor)), 10, 70))
			else:
				node.add_theme_font_size_override("font_size", clampi(int(round(13.0 * total_factor)), 12, 80))

		elif node is OptionButton:
			node.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))

		elif node is LineEdit:
			node.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))

		elif node is RichTextLabel:
			node.add_theme_font_size_override("normal_font_size", clampi(int(round(11.0 * total_factor)), 11, 80))

		elif node is CheckButton:
			node.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))

		elif node is TabContainer:
			node.add_theme_font_size_override("font_size", clampi(int(round(11.5 * total_factor)), 11, 80))
			# Scale TabContainer Header StyleBoxes
			var tab_styleboxes := ["tab_selected", "tab_unselected", "tab_hovered"]
			for sb_name in tab_styleboxes:
				var sb: StyleBox = node.get_theme_stylebox(sb_name)
				if sb is StyleBoxFlat:
					var new_sb: StyleBoxFlat = sb.duplicate() as StyleBoxFlat
					new_sb.content_margin_top = int(round(6.0 * scale_factor))
					new_sb.content_margin_bottom = int(round(6.0 * scale_factor))
					new_sb.content_margin_left = int(round(10.0 * scale_factor))
					new_sb.content_margin_right = int(round(10.0 * scale_factor))
					node.add_theme_stylebox_override(sb_name, new_sb)

		# 3. Dynamic sizing for custom components/panels
		if node.name == "Patreon":
			node.custom_minimum_size = Vector2(round(120.0 * total_factor), round(36.0 * total_factor))
		elif node.name == "Ko-fi":
			node.custom_minimum_size = Vector2(round(95.0 * total_factor), round(36.0 * total_factor))
		elif node.name == "PayPal":
			node.custom_minimum_size = Vector2(round(100.0 * total_factor), round(36.0 * total_factor))
		elif node.name == "AppIcon" or node.name == "CenteringSpacer":
			var icon_size := clampi(int(round(50.0 * total_factor)), 40, 120)
			node.custom_minimum_size = Vector2(icon_size, icon_size if node.name == "AppIcon" else 0)
		elif node.name == "ConsolePanel":
			node.custom_minimum_size = Vector2(0, clampi(int(round(120.0 * total_factor)), 120, 300))

	for child in node.get_children():
		scale_ui(child, total_factor, scale_factor)
