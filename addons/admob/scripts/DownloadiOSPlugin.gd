tool
extends Button
# Instance the gdunzip script

func _on_DownloadiOSPlugin_pressed():
	var godot_version : String = String(Engine.get_version_info().major) + "." + String(Engine.get_version_info().minor) + "." + String(Engine.get_version_info().patch)
	print(godot_version)
	$HTTPRequest.download_file = "ios-template-v3.3.2.zip"
	$HTTPRequest.request("https://github.com/Poing-Studios/Godot-AdMob-Android-iOS/releases/download/iOS_v3.3%2B/ios-template-v3.3.2.zip")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Request completed ", result, ", ", response_code)
	# Uncompress a file, getting a PoolByteArray in return 
	# (or false if it failed uncompressing) 
