tool
extends HTTPRequest

signal network_status_changed(value)

enum {CONNECTED = 200}

export var server_to_test = "https://github.com/"

func _ready():
	request(server_to_test)

func _on_VerifyNetworkGithub_request_completed(
	_result, response_code, _headers, _body
):
	emit_signal("network_status_changed", response_code)


func _on_VerifyAgainTimer_timeout():
	request(server_to_test)
