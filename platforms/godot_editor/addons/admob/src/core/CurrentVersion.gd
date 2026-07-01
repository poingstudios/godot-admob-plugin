tool
extends Label

var ad_mob_globals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	text = "Version: " + ad_mob_globals.get_plugin_version()
