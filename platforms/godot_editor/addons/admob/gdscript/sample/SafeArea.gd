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

extends MarginContainer

const Registry = preload("res://addons/admob/internal/sample_registry.gd")

var _ad_margin_top := 0.0
var _ad_margin_bottom := 0.0

func _ready() -> void:
	Registry.safe_area = self
	_update_safe_area()
	get_viewport().size_changed.connect(_update_safe_area)

func update_ad_overlap(ad_view: AdView) -> void:
	reset_ad_overlap()
	
	if not ad_view:
		return
		
	var pos := ad_view.ad_position
	var height := float(ad_view.get_height_in_pixels())
	
	# Mapping AdPosition enum values to top/bottom margins
	if pos in [AdPosition.Values.TOP, AdPosition.Values.TOP_LEFT, AdPosition.Values.TOP_RIGHT]:
		_ad_margin_top = height
	elif pos in [AdPosition.Values.BOTTOM, AdPosition.Values.BOTTOM_LEFT, AdPosition.Values.BOTTOM_RIGHT]:
		_ad_margin_bottom = height
		
	_update_safe_area()

func reset_ad_overlap() -> void:
	_ad_margin_top = 0.0
	_ad_margin_bottom = 0.0
	_update_safe_area()

func _update_safe_area() -> void:
	# Only apply safe area on mobile platforms
	var platform := OS.get_name()
	if platform != "iOS" and platform != "Android":
		_apply_margins(0, 0, 0, 0)
		return

	var safe_area := DisplayServer.get_display_safe_area()
	var window_size := DisplayServer.window_get_size()
	
	if window_size.x == 0 or window_size.y == 0:
		return
		
	# Scale factor calculation to convert physical pixels to logical UI pixels
	var viewport_size := Vector2(get_viewport().get_visible_rect().size)
	var scale_factor := viewport_size.y / float(window_size.y)
	
	# DisplayServer returns physical screen coordinates for the safe area
	var safe_top := float(safe_area.position.y)
	var safe_left := float(safe_area.position.x)
	var safe_bottom := float(window_size.y - (safe_area.position.y + safe_area.size.y))
	var safe_right := float(window_size.x - (safe_area.position.x + safe_area.size.x))
	
	# Apply final margins scaled to the viewport
	_apply_margins(
		(safe_top + _ad_margin_top) * scale_factor,
		safe_left * scale_factor,
		(safe_bottom + _ad_margin_bottom) * scale_factor,
		safe_right * scale_factor
	)

func _apply_margins(top: float, left: float, bottom: float, right: float) -> void:
	add_theme_constant_override("margin_top", int(top))
	add_theme_constant_override("margin_left", int(left))
	add_theme_constant_override("margin_bottom", int(bottom))
	add_theme_constant_override("margin_right", int(right))
