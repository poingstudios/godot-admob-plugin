using Godot;
using System;
using System.Collections;

public class Example : Control
{
	private Node MobileAds;
	IDictionary config;

	private Button EnableBanner;
	private Button DisableBanner;
	private Button ShowBanner;
	private Button HideBanner;
	
	private Button Interstitial;
	private Button Rewarded;
	private Button RewardedInterstitial;
	
	private Button RequestUserConsent;
	private Button ResetConsentState;
	
	private RichTextLabel Advice;
	private AudioStreamPlayer Music;
	
	private CheckBox BannerPosition;
	private ItemList BannerSizes;

	private void GetAllNodes()
	{
		MobileAds = (Node) GetNode("/root/MobileAds");
		config = (IDictionary) MobileAds.Get("config");
		
		EnableBanner = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Banner/EnableBanner");
		DisableBanner = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Banner/DisableBanner");
		ShowBanner = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Banner2/ShowBanner");
		HideBanner = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Banner2/HideBanner");
		
		Interstitial = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Interstitial");
		Rewarded = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/Rewarded");
		RewardedInterstitial = (Button) GetNode("Background/TabContainer/AdFormats/VBoxContainer/RewardedInterstitial");

		RequestUserConsent = (Button) GetNode("Background/TabContainer/UMP/VBoxContainer/RequestUserConsent");
		ResetConsentState = (Button) GetNode("Background/TabContainer/UMP/VBoxContainer/ResetConsentState");

		Advice = (RichTextLabel) GetNode("Background/Advice");
		Music = (AudioStreamPlayer) GetNode("Music");

		BannerPosition = (CheckBox) GetNode("Background/TabContainer/Banner/VBoxContainer/Position");
		BannerSizes = (ItemList) GetNode("Background/TabContainer/Banner/VBoxContainer/BannerSizes");
	}
	
	private void _add_text_Advice_Node(String text_value)
	{
		Advice.BbcodeText += text_value + "\n";
	}
	
	public override void _Ready()
	{
		GetAllNodes();
		OS.CenterWindow();
		Music.Play();

		foreach(String banner_size in (IEnumerable) MobileAds.Get("BANNER_SIZE"))
		{
			BannerSizes.AddItem(banner_size);
		}
		if (OS.GetName() == "Android" || OS.GetName() == "iOS"){
			BannerPosition.Pressed = Convert.ToBoolean(((IDictionary) config["banner"])["position"]);
			MobileAds.Call("request_user_consent");
			MobileAds.Connect("consent_info_update_failure", this, nameof(_on_MobileAds_consent_info_update_failure));
			MobileAds.Connect("consent_status_changed", this, nameof(_on_MobileAds_consent_status_changed));
			MobileAds.Connect("banner_loaded", this, nameof(_on_MobileAds_banner_loaded));
			MobileAds.Connect("banner_destroyed", this, nameof(_on_MobileAds_banner_destroyed));
			MobileAds.Connect("interstitial_loaded", this, nameof(_on_MobileAds_interstitial_loaded));
			MobileAds.Connect("interstitial_closed", this, nameof(_on_MobileAds_interstitial_closed));
			MobileAds.Connect("rewarded_ad_loaded", this, nameof(_on_MobileAds_rewarded_ad_loaded));
			MobileAds.Connect("rewarded_ad_closed", this, nameof(_on_MobileAds_rewarded_ad_closed));
			MobileAds.Connect("rewarded_interstitial_ad_loaded", this, nameof(_on_MobileAds_rewarded_interstitial_ad_loaded));
			MobileAds.Connect("rewarded_interstitial_ad_closed", this, nameof(_on_MobileAds_rewarded_interstitial_ad_closed));
			MobileAds.Connect("user_earned_rewarded", this, nameof(_on_MobileAds_user_earned_rewarded));
			MobileAds.Connect("initialization_complete", this, nameof(_on_MobileAds_initialization_complete));
		}
		else
		{
		_add_text_Advice_Node("AdMob only works on Android or iOS devices!");
		}
	}

	private void _on_MobileAds_initialization_complete(int status, String _adapter_name)
	{
		if (status == (int)((IDictionary) MobileAds.Get("INITIALIZATION_STATUS"))["READY"])
		{
			MobileAds.Call("load_interstitial");
			MobileAds.Call("load_rewarded");
			MobileAds.Call("load_rewarded_interstitial");
			_add_text_Advice_Node("AdMob initialized on C#! With parameters:");
			_add_text_Advice_Node("is_real: " + config["is_real"].ToString());
			_add_text_Advice_Node("is_for_child_directed_treatment: " + config["is_for_child_directed_treatment"].ToString());
			_add_text_Advice_Node("max_ad_content_rating: " + config["max_ad_content_rating"].ToString());
			_add_text_Advice_Node("instance_id: " + GetInstanceId().ToString());
			EnableBanner.Disabled = false;
			BannerPosition.Disabled = false;
			RequestUserConsent.Disabled = false;
			ResetConsentState.Disabled = false;
		}
		else
		{
			_add_text_Advice_Node("AdMob not initialized, check your configuration");
		}
		_add_text_Advice_Node("---------------------------------------------------");
	}
	private void _on_MobileAds_interstitial_loaded()
	{
		Interstitial.Disabled = false;
		_add_text_Advice_Node("Interstitial loaded");
	}

	private void _on_MobileAds_interstitial_closed()
	{
		MobileAds.Call("load_interstitial");
		_add_text_Advice_Node("Interstitial closed");
	}

	private void _on_Interstitial_pressed()
	{
		MobileAds.Call("show_interstitial");
		MobileAds.Call("load_interstitial");
		Interstitial.Disabled = true;
	}

	private void reset_banner_buttons()
	{
		DisableBanner.Disabled = true;
		EnableBanner.Disabled = false;
		ShowBanner.Disabled = true;
		HideBanner.Disabled = true;
	}

	private void _on_MobileAds_banner_destroyed()
	{
		reset_banner_buttons();
		_add_text_Advice_Node("Banner destroyed");
	}

	private void _on_MobileAds_banner_loaded()
	{
		DisableBanner.Disabled = false;
		EnableBanner.Disabled = true;
		ShowBanner.Disabled = false;
		HideBanner.Disabled = false;
		_add_text_Advice_Node("Banner loaded");
		_add_text_Advice_Node("Banner width: " + MobileAds.Call("get_banner_width"));
		_add_text_Advice_Node("Banner height: " + MobileAds.Call("get_banner_height"));
		_add_text_Advice_Node("Banner width in pixels: " + MobileAds.Call("get_banner_width_in_pixels"));
		_add_text_Advice_Node("Banner height in pixels: " + MobileAds.Call("get_banner_height_in_pixels"));
	}

	private void _on_EnableBanner_pressed()
	{
		EnableBanner.Disabled = true;
		MobileAds.Call("load_banner");
	}

	private void _on_DisableBanner_pressed()
	{
		DisableBanner.Disabled = true;
		EnableBanner.Disabled = false;
		MobileAds.Call("destroy_banner");
	}

	private void _on_Rewarded_pressed()
	{
		MobileAds.Call("show_rewarded");
		MobileAds.Call("load_rewarded");
		Rewarded.Disabled = true;
	}

	private void _on_RewardedInterstitial_pressed()
	{
		MobileAds.Call("show_rewarded_interstitial");
		MobileAds.Call("load_rewarded_interstitial");
		RewardedInterstitial.Disabled = true;
	}

	private void _on_MobileAds_rewarded_ad_loaded()
	{
		Rewarded.Disabled = false;
		_add_text_Advice_Node("Rewarded ad loaded");
	}
	
	private void _on_MobileAds_rewarded_ad_closed()
	{
		MobileAds.Call("load_rewarded");
		_add_text_Advice_Node("Rewarded ad closed");
	}

	private void _on_MobileAds_rewarded_interstitial_ad_loaded()
	{
		RewardedInterstitial.Disabled = false;
		_add_text_Advice_Node("Rewarded Interstitial ad loaded");
	}
	
	private void _on_MobileAds_rewarded_interstitial_ad_closed()
	{
		MobileAds.Call("load_rewarded_interstitial");
		_add_text_Advice_Node("Rewarded Interstitial ad closed");
	}
	
	private void _on_MobileAds_user_earned_rewarded(String currency, int amount)
	{
		Advice.BbcodeText += "EARNED " + currency + " with amount: " + amount.ToString() + "\n";
	}

	private void _on_MobileAds_consent_info_update_failure(int _error_code, String error_message)
	{
		_add_text_Advice_Node(error_message);
	}

	private void _on_MobileAds_consent_status_changed(String status_message)
	{
		_add_text_Advice_Node(status_message);
	}


	private void _on_BannerSizes_item_selected(int index)
	{
		if ((bool) MobileAds.Call("get_is_initialized"))
		{
			String item_text = (String) BannerSizes.GetItemText(index);

			((IDictionary)config["banner"])["size"] = index;
			_add_text_Advice_Node("Banner Size changed:" + item_text);
			if ((bool) MobileAds.Call("get_is_banner_loaded"))
			{
				MobileAds.Call("load_banner");
			}
		}
	}

	private void _on_ResetConsentState_pressed()
	{
		MobileAds.Call("reset_consent_state", true);
	}

	private void _on_RequestUserConsent_pressed()
	{
		MobileAds.Call("request_user_consent");
	}


	private void _on_Position_pressed()
	{
		((IDictionary)config["banner"])["position"] = BannerPosition.Pressed;
		if ((bool)MobileAds.Call("get_is_banner_loaded"))
		{
			MobileAds.Call("load_banner");
		}
	}


	private void _on_IsInitialized_pressed()
	{
		_add_text_Advice_Node("Is initialized: " + MobileAds.Call("get_is_initialized"));
	}


	private void _on_IsBannerLoaded_pressed()
	{
		_add_text_Advice_Node("Is Banner loaded: " + MobileAds.Call("get_is_banner_loaded"));
	}


	private void _on_IsInterstitialLoaded_pressed()
	{
		_add_text_Advice_Node("Is Interstitial loaded: " + MobileAds.Call("get_is_interstitial_loaded"));
	}


	private void _on_IsRewardedLoaded_pressed(){
		_add_text_Advice_Node("Is Rewarded loaded: " + MobileAds.Call("get_is_rewarded_loaded"));
	}


	private void _on_IsRewardedInterstitialLoaded_pressed(){
		_add_text_Advice_Node("Is RewardedInterstitial loaded: " + MobileAds.Call("get_is_rewarded_interstitial_loaded"));
	}


	private void _on_ShowBanner_pressed()
	{
		MobileAds.Call("show_banner");
	}
	

	private void _on_HideBanner_pressed()
	{
		MobileAds.Call("hide_banner");
	}
}
