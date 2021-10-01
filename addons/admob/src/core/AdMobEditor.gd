tool
extends Control
var AdMobSettings = preload("res://addons/admob/src/utils/AdMobSettings.gd").new()
var support_version_text = "[rainbow sat=10]iOS[/rainbow][color=black]:%s[/color] [rainbow sat=10]Android[/rainbow][color=black]:%s[/color]"

onready var SupportVersion := $BottomPanel/SupportVersion
onready var CurrentVersion := $BottomPanel/CurrentVersion

func _ready():
	SupportVersion.bbcode_text = support_version_text % [AdMobSettings.version_support.ios, AdMobSettings.version_support.android]

	var plugin_config_file := ConfigFile.new()
	plugin_config_file.load("res://addons/admob/plugin.cfg")
	CurrentVersion.text = "Version: " + plugin_config_file.get_value("plugin", "version")


func _on_AndroidButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-android#installation") 

func _on_iOSButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-ios#installation") 

func _on_AdMobButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-editor") 

func _on_PoingButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios") 
