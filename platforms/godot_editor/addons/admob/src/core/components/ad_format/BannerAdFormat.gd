tool
extends VBoxContainer
onready var ad_mob_editor : Control = find_parent("AdMobEditor")

func _ready():
	$RespectSafeArea.connect(
		"value_changed", self,
		"_on_RespectSafeArea_value_changed"
	)

	$BannerSizeHBoxContainer/BannerSize.selected = (
		ad_mob_editor.ad_mob_settings.BANNER_SIZE.find(
			ad_mob_editor.ad_mob_settings.config.banner.size
		)
	)
	$RespectSafeArea.pressed = ad_mob_editor.ad_mob_settings.config.banner.respect_safe_area
	$BannerShowInstantly.pressed = ad_mob_editor.ad_mob_settings.config.banner.show_instantly
	$BannerOnTop.pressed = ad_mob_editor.ad_mob_settings.config.banner.position

func _on_BannerSize_item_selected(index):
	ad_mob_editor.ad_mob_settings.config.banner.size = (
		ad_mob_editor.ad_mob_settings.BANNER_SIZE[index]
	)

func _on_BannerShowInstantly_pressed():
	ad_mob_editor.ad_mob_settings.config.banner.show_instantly = $BannerShowInstantly.pressed

func _on_BannerOnTop_pressed():
	ad_mob_editor.ad_mob_settings.config.banner.position = int($BannerOnTop.pressed)

func _on_RespectSafeArea_value_changed(value : bool):
	ad_mob_editor.ad_mob_settings.config.banner.respect_safe_area = value
