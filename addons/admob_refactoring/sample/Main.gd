extends Control

var adView1: AdView

func _ready() -> void:
	var request_configuration := RequestConfiguration.new()
	request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G

	MobileAds.initialize(OnInitializationCompleteListener.new(_on_initialization_complete))
	adView1 = AdView.new("ca-app-pub-3940256099942544/6300978111", AdPosition.BOTTOM, AdSize.BANNER)
	_on_load_banner_pressed()
	
func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
	print_all_values(initialization_status)

func _on_get_initialization_status_pressed() -> void:
	var initialization_status := MobileAds.get_initialization_status()
	print_all_values(initialization_status)

func print_all_values(initialization_status : InitializationStatus) -> void:
	for key in initialization_status.adapter_status_map:
		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
		prints(key, adapterStatus.latency, adapterStatus.initialization_status, adapterStatus.description)

func _on_load_banner_pressed():
	var adRequest1 := AdRequest.new()
	var adColonyMediationExtras := AdColonyMediationExtras.new()
	adColonyMediationExtras.show_post_popup = true
	adRequest1.mediation_extras.append_array([adColonyMediationExtras])
	adRequest1.keywords.append_array(["tip", "bonus"])
	print(adRequest1.convert_to_dictionary())
	adView1.load_ad(adRequest1)

func _on_destroy_banner_pressed():
	adView1.destroy()

func _on_show_banner_pressed():
	adView1.show()

func _on_hide_banner_pressed():
	adView1.hide()

func _on_get_width_pressed():
	if adView1:
		print(adView1.get_width(), adView1.get_height(), adView1.get_width_in_pixels(), adView1.get_height_in_pixels())
