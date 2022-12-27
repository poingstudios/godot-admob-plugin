@tool
extends VBoxContainer

@onready var AdMobEditor : Control = find_parent("AdMobEditor")

@onready var godot_version : String = "v" + str(Engine.get_version_info().major) + "." + str(Engine.get_version_info().minor) + "." + str(Engine.get_version_info().patch)
var string_dont_have_connection := "[b]You don't have connection to the Server: %s, please verify your connection in order to Download[/b]"
var actual_downloading_file : String = ""
var downloaded_plugin_version : String = ""
var version_support : Dictionary

var android_dictionary : Dictionary = {
		"version" : ["CURRENT"],
		"download_directory" : "res://addons/admob/downloads/android"
	} : 
		set(value):
			android_dictionary = value
			$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % android_dictionary.download_directory

var ios_dictionary : Dictionary = {
		"version" : ["CURRENT"],
		"download_directory" : "res://addons/admob/downloads/ios"
	} : 
		set(value):
			ios_dictionary = value 
			$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % ios_dictionary.download_directory

var current_dir_download_label = "Current Download Directory: %s"
var download_complete_message = "Download of %s completed! \n%s"

func _ready():
	$DontHaveConnectionPanelContainer/Label.text = string_dont_have_connection % $VerifyNetworkGithub.server_to_test

	if godot_version[godot_version.length()-1] == "0":
		godot_version = godot_version.substr(0, godot_version.length()-2)

	set_process(false)
	set_version_platform_supported("ios")
	set_version_platform_supported("android")
	$TabContainer/Android/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % android_dictionary.download_directory
	$TabContainer/iOS/ChangeDirectoryHBoxContainer/DownloadDirectoryLabel.text =  current_dir_download_label % ios_dictionary.download_directory

func set_version_platform_supported(platform):
	if platform == "android":
		$TabContainer/Android/VersionHBoxContainer/AndroidVersion.clear()
		for i in android_dictionary.version:
			$TabContainer/Android/VersionHBoxContainer/AndroidVersion.add_item(i)
	elif platform == "ios":
		$TabContainer/iOS/VersionHBoxContainer/iOSVersion.clear()
		for i in ios_dictionary.version:
			$TabContainer/iOS/VersionHBoxContainer/iOSVersion.add_item(i)
	

func _process(delta):
	var bodySize = $TabContainer/HTTPRequest.get_body_size()
	var downloadedBytes = $TabContainer/HTTPRequest.get_downloaded_bytes()
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
	var plugin_version = version_support.ios
	$TabContainer/HTTPRequest.download_file = ios_dictionary.download_directory + "/" + file_name
	$TabContainer/HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-ios/releases/download/" + plugin_version + "/" + file_name)
	actual_downloading_file = file_name
	downloaded_plugin_version = "iOS Plugin Version: " + plugin_version

	set_process(true)

func _on_DownloadiOSTemplate_pressed():
	var ios_version = $TabContainer/iOS/VersionHBoxContainer/iOSVersion.text
	if ios_version == "CURRENT":
		ios_version = godot_version

	var file_name = "ios-template-" + ios_version + ".zip"
	var plugin_version = version_support.ios
	$TabContainer/HTTPRequest.download_file = ios_dictionary.download_directory + "/" + file_name
	$TabContainer/HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-ios/releases/download/" + plugin_version + "/" + file_name)
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
	
	
	var file_name = "android-"+ android_target + "-template-" + android_version + ".zip"
	var plugin_version = version_support.android
	$TabContainer/HTTPRequest.download_file = android_dictionary.download_directory + "/" + file_name
	$TabContainer/HTTPRequest.request("https://github.com/Poing-Studios/godot-admob-android/releases/download/" + plugin_version + "/" + file_name)
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


func _on_VerifyNetworkGithub_network_status_changed(value : int):
	if value == $VerifyNetworkGithub.CONNECTED:
		$TabContainer.visible = true
		$DontHaveConnectionPanelContainer.visible = false
	else:
		$TabContainer.visible = false
		$DontHaveConnectionPanelContainer.visible = true


func _on_VersionSupportedHTTPRequest_supported_version_changed(value_dictionary : Dictionary):
	version_support = value_dictionary
	$VersionsAndroidSupportedHTTPRequest.request("https://api.github.com/repos/Poing-Studios/godot-admob-android/releases/tags/"+version_support["android"])
	$VersionsiOSSupportedHTTPRequest.request("https://api.github.com/repos/Poing-Studios/godot-admob-ios/releases/tags/"+version_support["ios"])


func get_versions_platform_supported(body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var json = test_json_conv.get_data()

	var regex = RegEx.new()
	regex.compile("[v](([0-9])+(\\.{0,1}([0-9]))*)+")
	
	var versions_supported : Array

	for asset in json["assets"]:
		var godot_version = asset["name"]
		
		var regex_result = regex.search(godot_version)
		if regex_result:
			if not versions_supported.has(regex_result.get_string()):
				versions_supported.append(regex_result.get_string())
	
	return versions_supported



func _on_VersionsiOSSupportedHTTPRequest_request_completed(result, response_code, headers, body):
	ios_dictionary.version.append_array(get_versions_platform_supported(body))
	set_version_platform_supported("ios")

func _on_VersionsAndroidSupportedHTTPRequest_request_completed(result, response_code, headers, body):
	android_dictionary.version.append_array(get_versions_platform_supported(body))
	set_version_platform_supported("android")
