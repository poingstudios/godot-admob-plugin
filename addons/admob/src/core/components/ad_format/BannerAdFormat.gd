tool
extends VBoxContainer
onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready():
	$BannerSizeHBoxContainer/BannerSize.selected = AdMobEditor.AdMobSettings.BANNER_SIZE.find(AdMobEditor.AdMobSettings.config.banner.size)
	$BannerShowInstantly.pressed = AdMobEditor.AdMobSettings.config.banner.show_instantly
	$BannerOnTop.pressed = AdMobEditor.AdMobSettings.config.banner.position

func _on_BannerSize_item_selected(index):
	AdMobEditor.AdMobSettings.config.banner.size = AdMobEditor.AdMobSettings.BANNER_SIZE[index]

func _on_BannerShowInstantly_pressed():
	AdMobEditor.AdMobSettings.config.banner.show_instantly = $BannerShowInstantly.pressed#

func _on_BannerOnTop_pressed():
	AdMobEditor.AdMobSettings.config.banner.position = int($BannerOnTop.pressed)
