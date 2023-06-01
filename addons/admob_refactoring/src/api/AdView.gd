class_name AdView

var _plugin : Object
var _uid : int

var ad_position : int

const PLATFORM_PLUGIN_NAME := "PoingGodotAdMobAdView"

func _init(ad_unit_id : String, ad_position : int, ad_size : AdSize) -> void:
	self.ad_position = ad_position

	if (Engine.has_singleton(PLATFORM_PLUGIN_NAME)):
		_plugin = Engine.get_singleton(PLATFORM_PLUGIN_NAME)
		var ad_view_dictionary := {
			"ad_unit_id" : ad_unit_id,
			"ad_position" : ad_position,
			"ad_size" : {
				"width" : ad_size.width,
				"height" : ad_size.height
			}
		}
		print(ad_view_dictionary)
		_uid = _plugin.create(ad_view_dictionary)
		_plugin.connect("on_ad_clicked", func(uid : int): 
			if uid == _uid:
				print("AdClicked", uid)
			)
		_plugin.connect("on_ad_closed", func(uid : int): 
			if uid == _uid:
				print("AdClosed", uid)
			)
		_plugin.connect("on_ad_failed_to_load", func(uid : int): 
			if uid == _uid:
				print("AdFailedToLoad", uid)
			)
		_plugin.connect("on_ad_impression", func(uid : int): 
			if uid == _uid:
				print("AdImpression", uid)
			)
		_plugin.connect("on_ad_loaded", func(uid : int): 
			if uid == _uid:
				print("AdLoaded", uid)
			)
		_plugin.connect("on_ad_opened", func(uid : int): 
			if uid == _uid:
				print("AdOpened", uid)
			)

func load_ad(ad_request : AdRequest) -> void:
	if _plugin:
		_plugin.load_ad(_uid, ad_request.convert_to_dictionary(), ad_request.keywords)

func destroy() -> void:
	if _plugin:
		_plugin.destroy(_uid)

func hide() -> void:
	if _plugin:
		_plugin.hide(_uid)

func show() -> void:
	if _plugin:
		_plugin.show(_uid)

func get_width() -> int:
	if _plugin:
		return _plugin.get_width(_uid)
	return -1
	
func get_height() -> int:
	if _plugin:
		return _plugin.get_height(_uid)
	return -1
	
func get_width_in_pixels() -> int:
	if _plugin:
		return _plugin.get_width_in_pixels(_uid)
	return -1
	
func get_height_in_pixels() -> int:
	if _plugin:
		return _plugin.get_height_in_pixels(_uid)
	return -1
