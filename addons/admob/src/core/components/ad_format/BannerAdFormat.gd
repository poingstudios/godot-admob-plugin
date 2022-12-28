@tool
extends VBoxContainer
@onready var AdMobEditor : Control = find_parent("AdMobEditor")

func _ready():
	for item in AdMobEditor.AdMobSettings.BANNER_SIZE:
		$BannerSizeHBoxContainer/BannerSize.add_item(item)
	
	$RespectSafeArea.connect("value_changed",Callable(self,"_on_RespectSafeArea_value_changed"))
	
	$BannerSizeHBoxContainer/BannerSize.selected = AdMobEditor.AdMobSettings.BANNER_SIZE.find(AdMobEditor.AdMobSettings.config.banner.size)
	$RespectSafeArea.button_pressed = AdMobEditor.AdMobSettings.config.banner.respect_safe_area
	$BannerShowInstantly.button_pressed = AdMobEditor.AdMobSettings.config.banner.show_instantly
	$BannerOnTop.button_pressed = AdMobEditor.AdMobSettings.config.banner.position

func _on_BannerSize_item_selected(index):
	AdMobEditor.AdMobSettings.config.banner.size = AdMobEditor.AdMobSettings.BANNER_SIZE[index]

func _on_BannerShowInstantly_pressed():
	AdMobEditor.AdMobSettings.config.banner.show_instantly = $BannerShowInstantly.pressed#

func _on_BannerOnTop_pressed():
	AdMobEditor.AdMobSettings.config.banner.position = int($BannerOnTop.pressed)

func _on_RespectSafeArea_value_changed(value : bool):
	AdMobEditor.AdMobSettings.config.banner.respect_safe_area = value
