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

tool
extends GridContainer

signal ad_unit_changed(name_value, id_value, old_name_value)
signal ad_unit_removed(name_value)

var old_name_value := ""
var is_editing := true setget set_is_editing

onready var name_field := $Name
onready var id_field := $Id
onready var children_parent := get_parent().get_children()
onready var add_ad_unit_button_parent := (
	get_parent().get_parent().get_node("AddAdUnitButton")
)

func _ready():
	if get_index() == 0:
		$GridContainer/RemoveButton.disabled = true

func change_state(editing : bool) -> void:
	if editing:
		editing_state()
	else:
		not_editing_state()

func editing_state() -> void:
	$GridContainer/ConfirmButton.visible = true
	$GridContainer/EditButton.visible = false
	name_field.editable = true
	id_field.editable = true
	for ad_unit in children_parent:
		if ad_unit.get_index() != get_index():
			if ad_unit.get_index() != 0:
				ad_unit.get_node(
					"GridContainer/RemoveButton"
				).disabled = true
			ad_unit.get_node(
				"GridContainer/EditButton"
			).disabled = true
	add_ad_unit_button_parent.disabled = true

func not_editing_state():
	$GridContainer/ConfirmButton.visible = false
	$GridContainer/EditButton.visible = true
	name_field.editable = false
	id_field.editable = false
	for ad_unit in children_parent:
		if ad_unit.get_index() != 0:
			ad_unit.get_node(
				"GridContainer/RemoveButton"
			).disabled = false
		ad_unit.get_node(
			"GridContainer/EditButton"
		).disabled = false
	add_ad_unit_button_parent.disabled = false


func set_is_editing(value : bool):
	change_state(value)

func _on_RemoveButton_pressed():
	if (get_parent().get_child_count() > 1):
		self.is_editing = false
		emit_signal("ad_unit_removed", name_field.text)
		queue_free()

func _on_ConfirmButton_pressed():
	if name_field.text != "" && id_field.text != "":
		for ad_unit in children_parent:
			if ad_unit.get_index() != get_index():
				if ad_unit.name_field.text == name_field.text:
					$Alerts/UniqueNameAcceptDialog.popup_centered()
					return
	else:
		$Alerts/NameIdEmptyAcceptDialog.popup_centered()
		return
	emit_signal(
		"ad_unit_changed",
		name_field.text, id_field.text,
		old_name_value
	)
	self.is_editing = false


func _on_AdUnit_text_entered(_new_text):
	$GridContainer/ConfirmButton.emit_signal("pressed")

func _on_EditButton_pressed():
	old_name_value = name_field.text
	self.is_editing = true
