@tool
extends HTTPRequest

enum {CONNECTED = 200}

signal network_status_changed(value)

@export var server_to_test = "https://github.com/"

func _ready():
	request(server_to_test)

func _on_VerifyNetworkGithub_request_completed(result, response_code, headers, body):
	emit_signal("network_status_changed", response_code)
	

func _on_VerifyAgainTimer_timeout():
	request(server_to_test)
