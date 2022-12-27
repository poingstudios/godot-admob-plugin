@tool
extends RichTextLabel

var support_version_text = "[rainbow sat=10]iOS[/rainbow][color=black]:%s[/color] [rainbow sat=10]Android[/rainbow][color=black]:%s[/color]"


func _on_VersionSupportedHTTPRequest_supported_version_changed(value_dictionary):
	text = support_version_text % [value_dictionary.ios, value_dictionary.android]
