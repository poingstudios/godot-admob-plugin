@tool
extends Control
var AdMobSettings = preload("res://addons/admob/src/utils/AdMobSettings.gd").new()


func _on_AndroidButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-android#installation") 

func _on_iOSButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-ios#installation") 

func _on_AdMobButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios/godot-admob-editor") 

func _on_PoingButton_pressed():
	OS.shell_open("https://github.com/Poing-Studios") 
