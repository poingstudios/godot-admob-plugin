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
	if not (node is Control):
		for child in node.get_children():
			scale_ui(child, total_factor, scale_factor)
		return

	var control := node as Control
	_optimize_mouse_filter(control)
	_apply_component_scaling(control, total_factor)

	for child in control.get_children():
		scale_ui(child, total_factor, scale_factor)


static func _optimize_mouse_filter(control: Control) -> void:
	var is_interactive := (
		control is BaseButton
		or control is LineEdit
		or control is TextEdit
		or control is RichTextLabel
		or control is Slider
		or control is OptionButton
		or control is CheckButton
		or control is CheckBox
		or control is ColorPickerButton
		or control is MenuButton
	)
	if not is_interactive and not (control is PanelContainer or control is ScrollContainer or control is TabContainer):
		control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	elif is_interactive and control is BaseButton:
		control.mouse_filter = Control.MOUSE_FILTER_STOP


static func _apply_component_scaling(control: Control, total_factor: float) -> void:
	if control is OptionButton:
		_scale_option_button(control, total_factor)
	elif control is Button:
		_scale_button(control, total_factor)
	elif control is Label:
		_scale_label(control, total_factor)
	elif control is LineEdit:
		control.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))
	elif control is RichTextLabel:
		control.add_theme_font_size_override("normal_font_size", clampi(int(round(11.0 * total_factor)), 11, 80))
	elif control is CheckButton:
		_scale_check_button(control, total_factor)
	elif control is HSlider:
		_scale_slider(control, total_factor)
	elif control is TabContainer:
		_scale_tab_container(control, total_factor)

	if control.name == "Patreon":
		control.custom_minimum_size = Vector2(round(96.0 * total_factor), round(29.0 * total_factor))
	elif control.name == "Ko-fi":
		control.custom_minimum_size = Vector2(round(76.0 * total_factor), round(29.0 * total_factor))
	elif control.name == "PayPal":
		control.custom_minimum_size = Vector2(round(80.0 * total_factor), round(29.0 * total_factor))
	elif control.name == "AppIcon":
		var icon_size := clampi(int(round(40.0 * total_factor)), 32, 96)
		control.custom_minimum_size = Vector2(icon_size, icon_size)
	elif control.name == "ConsolePanel":
		control.custom_minimum_size = Vector2(0, clampi(int(round(120.0 * total_factor)), 120, 300))


static func _scale_option_button(node: OptionButton, total_factor: float) -> void:
	node.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))

	var theme_owner: Control = node
	while theme_owner != null and theme_owner.theme == null:
		theme_owner = theme_owner.get_parent() as Control
	var active_theme: Theme = theme_owner.theme if (theme_owner and theme_owner.theme) else load("res://addons/admob/assets/theme_modern.tres")

	var duplicated_theme := active_theme.duplicate() as Theme
	node.theme = duplicated_theme

	var popup_font_size := clampi(int(round(8.0 * total_factor)), 8, 52)
	duplicated_theme.set_font_size("font_size", "PopupMenu", popup_font_size)
	duplicated_theme.set_constant("v_separation", "PopupMenu", clampi(int(round(8.0 * total_factor)), 8, 40))

	var popup_panel := duplicated_theme.get_stylebox("panel", "PopupMenu")
	if popup_panel is StyleBoxFlat:
		var new_panel := popup_panel.duplicate() as StyleBoxFlat
		new_panel.content_margin_left = int(round(10.0 * total_factor))
		new_panel.content_margin_right = int(round(10.0 * total_factor))
		new_panel.content_margin_top = int(round(10.0 * total_factor))
		new_panel.content_margin_bottom = int(round(10.0 * total_factor))
		duplicated_theme.set_stylebox("panel", "PopupMenu", new_panel)

	var popup_hover := duplicated_theme.get_stylebox("hover", "PopupMenu")
	if popup_hover is StyleBoxFlat:
		var new_hover := popup_hover.duplicate() as StyleBoxFlat
		new_hover.content_margin_left = int(round(15.0 * total_factor))
		new_hover.content_margin_right = int(round(15.0 * total_factor))
		new_hover.content_margin_top = int(round(10.0 * total_factor))
		new_hover.content_margin_bottom = int(round(10.0 * total_factor))
		duplicated_theme.set_stylebox("hover", "PopupMenu", new_hover)

	var popup: PopupMenu = node.get_popup()
	if popup:
		popup.theme = duplicated_theme
		popup.set_deferred("theme", duplicated_theme)
		popup.add_theme_font_size_override("font_size", popup_font_size)
		popup.call_deferred("add_theme_font_size_override", "font_size", popup_font_size)


static func _scale_button(node: Button, total_factor: float) -> void:
	if node.get_parent() and node.get_parent().name == "PositionGrid":
		var target_size := clampi(int(round(51.0 * total_factor)), 38, 130)
		node.custom_minimum_size = Vector2(target_size, target_size)
		var margin_size := clampi(int(round(8.5 * total_factor)), 5, 25)
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
		var stylebox_names := ["normal", "hover", "pressed", "disabled"]
		for sb_name in stylebox_names:
			var sb: StyleBox = node.get_theme_stylebox(sb_name)
			if sb is StyleBoxFlat:
				var new_sb: StyleBoxFlat = sb.duplicate() as StyleBoxFlat
				new_sb.content_margin_top = int(round(8.0 * total_factor))
				new_sb.content_margin_bottom = int(round(8.0 * total_factor))
				new_sb.content_margin_left = int(round(16.0 * total_factor))
				new_sb.content_margin_right = int(round(16.0 * total_factor))
				node.add_theme_stylebox_override(sb_name, new_sb)


static func _scale_label(node: Label, total_factor: float) -> void:
	if node.name == "AppTitle":
		node.add_theme_font_size_override("font_size", clampi(int(round(16.0 * total_factor)), 16, 120))
	elif node.name == "AppSubtitle":
		node.add_theme_font_size_override("font_size", clampi(int(round(10.0 * total_factor)), 10, 50))
	elif node.name == "SupportLabel":
		node.add_theme_font_size_override("font_size", clampi(int(round(10.5 * total_factor)), 10, 70))
	else:
		node.add_theme_font_size_override("font_size", clampi(int(round(13.0 * total_factor)), 12, 80))


static func _scale_check_button(node: CheckButton, total_factor: float) -> void:
	node.add_theme_font_size_override("font_size", clampi(int(round(12.0 * total_factor)), 12, 80))
	var min_h := clampi(int(round(50.0 * total_factor)), 50, 200)
	node.custom_minimum_size = Vector2(node.custom_minimum_size.x, min_h)


static func _scale_slider(node: HSlider, total_factor: float) -> void:
	var min_h := clampi(int(round(30.0 * total_factor)), 30, 100)
	var min_w := clampi(int(round(200.0 * total_factor)), 100, 800)
	node.custom_minimum_size = Vector2(min_w, min_h)


static func _scale_tab_container(node: TabContainer, total_factor: float) -> void:
	node.add_theme_font_size_override("font_size", clampi(int(round(11.5 * total_factor)), 11, 80))
	var panel_sb: StyleBox = node.get_theme_stylebox("panel")
	if panel_sb is StyleBoxFlat:
		var new_panel_sb: StyleBoxFlat = panel_sb.duplicate() as StyleBoxFlat
		new_panel_sb.content_margin_top = int(round(12.0 * total_factor))
		new_panel_sb.content_margin_bottom = int(round(12.0 * total_factor))
		new_panel_sb.content_margin_left = int(round(12.0 * total_factor))
		new_panel_sb.content_margin_right = int(round(12.0 * total_factor))
		node.add_theme_stylebox_override("panel", new_panel_sb)
	var tab_styleboxes := ["tab_selected", "tab_unselected", "tab_hovered"]
	for sb_name in tab_styleboxes:
		var sb: StyleBox = node.get_theme_stylebox(sb_name)
		if sb is StyleBoxFlat:
			var new_sb: StyleBoxFlat = sb.duplicate() as StyleBoxFlat
			new_sb.content_margin_top = int(round(6.0 * total_factor))
			new_sb.content_margin_bottom = int(round(6.0 * total_factor))
			new_sb.content_margin_left = int(round(11.0 * total_factor))
			new_sb.content_margin_right = int(round(11.0 * total_factor))
			node.add_theme_stylebox_override(sb_name, new_sb)
