tool
extends VBoxContainer

onready var AdMobEditor : Control = find_parent("AdMobEditor")

onready var godot_version : String = String(Engine.get_version_info().major) + "." + String(Engine.get_version_info().minor) + "." + String(Engine.get_version_info().patch)
var actual_downloading_file : String = ""
var downloaded_plugin_version : String = ""

var android_dictionary : Dictionary = {
		"version" : ["CURRENT", "3.4.2", "3.4.1", "3.4", "3.3.4", "3.3.3", "3.3.2", "3.3.1", "3.3", "3.2.3",  "3.2.2"],
		"download_directory" : "res://addons/admob/downloads/android"
	} setget set_android_dictionary

var ios_dictionary : Dictionary = {
		"version" : ["CURRENT", "3.4.2", "3.4.1", "3.4", "3.3.4", "3.3.3", "3.3.2", "3.3.1", "3.3"],
		"download_directory" : "res://addons/admob/downloads/ios"
	} setget set_ios_dictionary

var current_dir_download_label = "Current Download Directory: %s"
var download_complete_message = "Download of %s completed! \n%s"

func set_android_dictionary(value):
	android_dictionary = value
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % android_dictionary.download_directory
	
func set_ios_dictionary(value):
	ios_dictionary = value 
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % ios_dictionary.download_directory

func _ready():
	if godot_version[godot_version.length()-1] == "0":
		godot_version = godot_version.substr(0, godot_version.length()-2)

	set_process(false)
	$TabContainer/Android/VersionHBoxContainer/AndroidVersion.clear()
	$TabContainer/iOS/VersionHBoxContainer/iOSVersion.clear()
	for i in android_dictionary.version:
		$TabContainer/Android/VersionHBoxContainer/AndroidVersion.add_item(i)
	for i in ios_dictionary.version:
		$TabContainer/iOS/VersionHBoxContainer/iOSVersion.add_item(i)
	
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % android_dictionary.download_directory
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % ios_dictionary.download_directory

func _process(delta):
	var bodySize = $HTTPRequest.get_body_size()
	var downloadedBytes = $HTTPRequest.get_downloaded_bytes()
	var percent = int(downloadedBytes*100/bodySize)
	$ProgressBar.value = percent


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		$AdviceAcceptDialog.dialog_text = "!!!DOWNLOAD FAILED!!!"
		$ProgressBar.value = 0
	else:
		$AdviceAcceptDialog.dialog_text = download_complete_message % [actual_downloading_file, downloaded_plugin_version]

	set_process(false)
	$AdviceAcceptDialog.popup_centered()


func _on_DownloadGoogleMobileAdsSdkiOS_pressed():
	var file_name = "googlemobileadssdkios.zip"
	var plugin_version = AdMobEditor.AdMobSettings.version_support.ios
	$HTTPRequest.download_file = ios_dictionary.download_directory + "/" + file_name
	$HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-ios/releases/download/" + plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	downloaded_plugin_version = "iOS Plugin Version: " + plugin_version

	set_process(true)

func _on_DownloadiOSTemplate_pressed():
	var ios_version = $TabContainer/iOS/VersionHBoxContainer/iOSVersion.text
	if ios_version == "CURRENT":
		ios_version = godot_version

	var file_name = "ios-template-v" + ios_version + ".zip"
	var plugin_version = AdMobEditor.AdMobSettings.version_support.ios
	$HTTPRequest.download_file = ios_dictionary.download_directory + "/" + file_name
	$HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-ios/releases/download/" + plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	downloaded_plugin_version = "iOS Plugin Version: " + plugin_version
	
	set_process(true)

func _on_DownloadAndroidTemplate_pressed():
	var android_version = $TabContainer/Android/VersionHBoxContainer/AndroidVersion.text.to_lower()
	if android_version == "current":
		android_version = godot_version
	
	var android_target = $TabContainer/Android/TargetHBoxContainer/MenuButton.text.to_lower()
	
	if android_target == "current":
		android_target = "mono" if Engine.has_singleton("GodotSharp") else "standard"
	
	
	var file_name = "android-"+ android_target + "-template-v" + android_version + ".zip"
	var plugin_version = AdMobEditor.AdMobSettings.version_support.android
	$HTTPRequest.download_file = android_dictionary.download_directory + "/" + file_name
	$HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-android/releases/download/" + plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	
	downloaded_plugin_version = "Android Plugin Version: " + plugin_version
	
	set_process(true)


func _on_AndroidChangeDirectoryFileDialog_dir_selected(dir):
	self.android_dictionary.download_directory = dir

func _on_AndroidChangeDirectoryButton_pressed():
	$TabContainer/Android/ChangeDirectoryHBoxContainer/AndroidChangeDirectoryFileDialog.popup_centered()


func _on_iOSChangeDirectoryFileDialog_dir_selected(dir):
	self.ios_dictionary.download_directory = dir

func _on_iOSChangeDirectoryButton_pressed():
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/iOSChangeDirectoryFileDialog.popup_centered()


func _on_AndroidOpenDirectoryButton_pressed():
	var path_directory = ProjectSettings.globalize_path(android_dictionary.download_directory)
	OS.shell_open(str("file://", path_directory))


func _on_iOSOpenDirectoryButton_pressed():
	var path_directory = ProjectSettings.globalize_path(ios_dictionary.download_directory)
	OS.shell_open(str("file://", path_directory))
