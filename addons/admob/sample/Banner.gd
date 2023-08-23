# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends VBoxContainer

var ad_view : AdView
var ad_listener := AdListener.new()
var adPosition := AdPosition.Values.TOP
@onready var LoadButton := $LoadBanner
@onready var DestroyButton := $DestroyBanner
@onready var ShowButton := $ShowBanner
@onready var HideButton := $HideBanner
@onready var GetWidthButton := $GetWidth

func _ready() -> void:
	ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
	ad_listener.on_ad_clicked = _on_ad_clicked
	ad_listener.on_ad_closed = _on_ad_closed
	ad_listener.on_ad_impression = _on_ad_impression
	ad_listener.on_ad_loaded = _on_ad_loaded
	ad_listener.on_ad_opened = _on_ad_opened

func _on_load_banner_pressed() -> void:
	if ad_view:
		ad_view.destroy() #always try to destroy the ad_view if won't use anymore to clear memory

	var adSizecurrent_orientation := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizecurrent_orientation: ", adSizecurrent_orientation.width, ", ", adSizecurrent_orientation.height)
	var adSizeportrait := AdSize.get_portrait_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizeportrait: ", adSizeportrait.width, ", ", adSizeportrait.height)
	var adSizelandscape := AdSize.get_landscape_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	print("adSizelandscape: ", adSizelandscape.width, ", ", adSizelandscape.height)
	var adSizesmart := AdSize.get_smart_banner_ad_size()
	print("adSizesmart: ", adSizesmart.width, ", ",adSizesmart.height)
	ad_view = AdView.new("ca-app-pub-3940256099942544/2934735716", adSizecurrent_orientation, adPosition)
	ad_view.ad_listener = ad_listener
	var ad_request := AdRequest.new()
	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
	vungle_mediation_extras.all_placements = ["placement1", "placement2"]
	vungle_mediation_extras.sound_enabled = true
	vungle_mediation_extras.user_id = "testuserid"
	
	var ad_colony_mediation_extras := AdColonyMediationExtras.new()
	ad_colony_mediation_extras.show_post_popup = false
	ad_colony_mediation_extras.show_pre_popup = true
	ad_request.mediation_extras.append(vungle_mediation_extras)
	ad_request.mediation_extras.append(ad_colony_mediation_extras)
	ad_request.keywords.append("21313")
	ad_request.extras["ID"] = "value"

	ad_view.load_ad(ad_request)

func _on_destroy_banner_pressed() -> void:
	if ad_view:
		ad_view.destroy()
		ad_view = null

func _on_show_banner_pressed() -> void:
	if ad_view:
		ad_view.show()

func _on_hide_banner_pressed() -> void:
	if ad_view:
		ad_view.hide()

func _on_get_width_pressed() -> void:
	if ad_view:
		print(ad_view.get_width(), ", ", ad_view.get_height(), ", ", ad_view.get_width_in_pixels(), ", ", ad_view.get_height_in_pixels())

func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
	print("_on_ad_failed_to_load: " + load_ad_error.message)
	
func _on_ad_clicked() -> void:
	print("_on_ad_clicked")
	
func _on_ad_closed() -> void:
	print("_on_ad_closed")
	
func _on_ad_impression() -> void:
	print("_on_ad_impression")
	
func _on_ad_loaded() -> void:
	print("_on_ad_loaded")
	DestroyButton.disabled = false
	ShowButton.disabled = false
	HideButton.disabled = false
	GetWidthButton.disabled = false
	
func _on_ad_opened() -> void:
	print("_on_ad_opened")


func _on_top_pressed():
	adPosition = AdPosition.Values.TOP


func _on_bottom_pressed():
	adPosition = AdPosition.Values.BOTTOM


func _on_left_pressed():
	adPosition = AdPosition.Values.LEFT


func _on_right_pressed():
	adPosition = AdPosition.Values.RIGHT


func _on_top_left_pressed():
	adPosition = AdPosition.Values.TOP_LEFT


func _on_top_right_pressed():
	adPosition = AdPosition.Values.TOP_RIGHT


func _on_bottom_left_pressed():
	adPosition = AdPosition.Values.BOTTOM_LEFT


func _on_bottom_right_pressed():
	adPosition = AdPosition.Values.BOTTOM_RIGHT


func _on_center_pressed():
	adPosition = AdPosition.Values.CENTER
