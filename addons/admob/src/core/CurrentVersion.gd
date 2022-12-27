@tool
extends Label

var AdMobGlobals = preload("res://addons/admob/src/utils/AdMobGlobals.gd")

func _ready():
	text = "Version: " + AdMobGlobals.get_plugin_version()
