@tool
extends GridContainer

signal AdUnitChanged(name_value, id_value, old_name_value)
signal AdUnitRemoved(name_value)

@onready var Name := $Name
@onready var Id := $Id
@onready var ChildrenParent := get_parent().get_children()
@onready var AddAdUnitButtonParent := get_parent().get_parent().get_node("AddAdUnitButton")

var old_name_value := ""
var is_editing := true : set = set_is_editing

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
	Name.editable = true
	Id.editable = true
	for ad_unit in ChildrenParent:
		if ad_unit.get_index() != get_index():
			if ad_unit.get_index() != 0: ad_unit.get_node("GridContainer/RemoveButton").disabled = true
			ad_unit.get_node("GridContainer/EditButton").disabled = true
	AddAdUnitButtonParent.disabled = true

func not_editing_state():
	$GridContainer/ConfirmButton.visible = false
	$GridContainer/EditButton.visible = true
	Name.editable = false
	Id.editable = false
	for ad_unit in ChildrenParent:
		if ad_unit.get_index() != 0: ad_unit.get_node("GridContainer/RemoveButton").disabled = false
		ad_unit.get_node("GridContainer/EditButton").disabled = false
	AddAdUnitButtonParent.disabled = false


func set_is_editing(value : bool):
	change_state(value)

func _on_RemoveButton_pressed():
	if (get_parent().get_child_count() > 1):
		self.is_editing = false
		emit_signal("AdUnitRemoved", Name.text)
		queue_free()

func _on_ConfirmButton_pressed():
	if Name.text != "" && Id.text != "":
		for ad_unit in ChildrenParent:
			if ad_unit.get_index() != get_index():
				if ad_unit.Name.text == Name.text:
					$Alerts/UniqueNameAcceptDialog.popup_centered()
					return
	else:
		$Alerts/NameIdEmptyAcceptDialog.popup_centered()
		return
	emit_signal("AdUnitChanged", Name.text, Id.text, old_name_value)
	self.is_editing = false


func _on_AdUnit_text_entered(new_text):
	$GridContainer/ConfirmButton.emit_signal("pressed")

func _on_EditButton_pressed():
	old_name_value = Name.text
	self.is_editing = true
