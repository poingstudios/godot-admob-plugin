@tool
extends HBoxContainer

var AdUnit = preload("res://addons/admob/src/core/components/ad_format/unit_ids/ad_unit_operational_system/ad_unit/AdUnit.tscn")

@onready var AdMobEditor : Control = find_parent("AdMobEditor")
@onready var ad_format_name = AdMobEditor.AdMobSettings.pascal2snake(get_parent().name)

func _ready():
	for operational_system in $OperationalSystemTabContainer.get_children():
		for unit_name in (AdMobEditor.AdMobSettings.config[ad_format_name].unit_ids[operational_system.name] as Dictionary):
			var unit_id = AdMobEditor.AdMobSettings.config[ad_format_name].unit_ids[operational_system.name][unit_name]
			instance_ad_unit(operational_system.name, false, unit_name, unit_id)
		get_node("OperationalSystemTabContainer/"+operational_system.name+"/AddAdUnitButton").connect("pressed",Callable(self,"_on_AddAdUnitButton_pressed").bind(operational_system.name))


func _on_AdUnitChanged(name_value: String, id_value: String, old_name_value :String, system):
	remove_ad_unit(system, name_value)
	remove_ad_unit(system, old_name_value)
	add_ad_unit(system, name_value, id_value)

func _on_AdUnitRemoved(name_value : String, system):
	remove_ad_unit(system, name_value)
	
func _on_AddAdUnitButton_pressed(system):
	instance_ad_unit(system, true)


func add_ad_unit(operational_system : String, name_value: String, id_value : String):
	AdMobEditor.AdMobSettings.config[ad_format_name].unit_ids[operational_system][name_value] = id_value

func remove_ad_unit(operational_system : String, name_value: String):
	AdMobEditor.AdMobSettings.config[ad_format_name].unit_ids[operational_system].erase(name_value)
	AdMobEditor.AdMobSettings.save_config()

func instance_ad_unit(system : String, is_editing : bool, unit_name : String = "", unit_id : String = ""):
	var tab_container = get_node("OperationalSystemTabContainer/"+system+"/AdUnitVBoxContainer")
	var ad_unit = AdUnit.instantiate()
	tab_container.add_child(ad_unit)
	ad_unit.connect("AdUnitChanged",Callable(self,"_on_AdUnitChanged").bind(system))
	ad_unit.connect("AdUnitRemoved",Callable(self,"_on_AdUnitRemoved").bind(system))
	ad_unit.Name.text = unit_name
	ad_unit.Id.text = unit_id
	ad_unit.is_editing = is_editing
