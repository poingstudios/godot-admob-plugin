tool
extends VBoxContainer
onready var AdMobEditor : Control = find_parent("AdMobEditor")
onready var config_dictionary : Dictionary = AdMobEditor.AdMobSettings.config.banner

func _ready():
	$BannerSizeHBoxContainer/BannerSize.selected = AdMobEditor.AdMobSettings.BANNER_SIZE.find(config_dictionary.size)
	$BannerShowInstantly.pressed = config_dictionary.show_instantly
	$BannerOnTop.pressed = config_dictionary.position


func _on_BannerSize_item_selected(index):
	config_dictionary.size = AdMobEditor.AdMobSettings.BANNER_SIZE[index]

func _on_BannerShowInstantly_pressed():
	config_dictionary.show_instantly = $BannerShowInstantly.pressed#

func _on_BannerOnTop_pressed():
	config_dictionary.position = int($BannerOnTop.pressed)
