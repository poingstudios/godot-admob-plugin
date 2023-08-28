# Get started

AdMob mediation is a valuable feature that allows you to deliver ads to your applications from various sources. These sources encompass the AdMob Network, third-party ad networks, and [AdMob campaigns](https://support.google.com/admob/answer/6162747). The primary goal of AdMob mediation is to optimize your fill rate and enhance your monetization efforts. It achieves this by directing ad requests to multiple networks, ensuring that your app utilizes the most suitable network available to serve ads. This approach is exemplified through a [case study](https://admob.google.com/home/resources/cookapps-grows-ad-revenue-86-times-with-admob-rewarded-ads-and-mediation/).


This comprehensive guide serves as your all-inclusive resource for integrating mediation into your AdMob app. It encompasses both bidding and waterfall integration methods, providing you with a complete reference for optimizing your ad serving strategy.

!!! info
    
    **Crucial Note**: Before proceeding with mediation configuration, it's essential to ensure that you possess the required account permissions. These permissions encompass access to inventory management, app access, and privacy and messaging features. For further details, please refer to the [New User Roles](https://support.google.com/admob/answer/2784628) article.

- Prior to integrating mediation for a specific ad format, you must first integrate that ad format into your app. These ad formats include:
    - [Banner Ads](../ad_formats/banner/get_started.md)
    - [Interstitial Ads](../ad_formats/interstitial.md)
    - [Rewarded Ads](../ad_formats/rewarded.md)
    - [Rewarded Interstitial Ads](../ad_formats/rewarded_interstitial.md)

If you are new to mediation, it's advisable to review the [Overview of AdMob mediation](https://support.google.com/admob/answer/13420272) for a better understanding of the concept.

## Initialize the Mobile Ads SDK

The quick start guide provides instructions on how to [initialize the Mobile Ads SDK](../README.md#initialize-the-google-mobile-ads-sdk). During this initialization process, mediation and bidding adapters are also initialized. It's crucial to wait for this initialization to complete before loading ads to ensure that every ad network fully participates in the first ad request.

The following sample code demonstrates how you can verify the initialization status of each adapter before initiating an ad request.


```gdscript
extends Control

func _ready() -> void:
	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
	MobileAds.initialize(on_initialization_complete_listener)
	
func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
	print("MobileAds initialization complete")
	for key in initialization_status.adapter_status_map:
		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
		prints(
			"Key:", key, 
			"Latency:", adapterStatus.latency, 
			"Initialization Status:", adapterStatus.initialization_status, 
			"Description:", adapterStatus.description
		)
		
```

## Banner ads mediation
When utilizing banner ads in AdMob mediation, it's essential to disable refresh settings in all third-party ad networks' user interfaces for the banner ad units you're using in mediation. This action prevents the occurrence of double refreshes, as AdMob also triggers a refresh based on your banner ad unit's predefined refresh rate.

## Rewarded ads mediation
We strongly advise you to customize all default reward values by configuring reward values within the AdMob UI. To accomplish this, select the **Apply to all networks in Mediation groups** option to ensure that the reward remains uniform across all networks. Keep in mind that certain ad networks may not provide a reward value or type. By overriding the reward value, you guarantee a consistent reward, regardless of the ad network responsible for serving the ad.
![apply_all_networks](https://developers.google.com/static/admob/images/mediation/admob_apply_all_networks.png)

For more information on setting reward values in the AdMob UI, refer to create a rewarded ad unit.

For comprehensive details on how to set reward values within the AdMob UI, please consult the [Create a Rewarded Ad Unit](https://support.google.com/admob/answer/7311747) documentation.


## CCPA and GDPR

!!! warning
    
    **Critical Note**: Before proceeding with the configuration for EU Consent, GDPR, CCPA, and User Messaging Platform, it is crucial to ensure that you have the necessary Account Management permission. These permissions are essential for managing privacy-related settings. To obtain more information, please refer to the [New User Roles](https://support.google.com/admob/answer/2784628) article.

If your app needs to adhere to the [California Consumer Privacy Act (CCPA)](https://support.google.com/admob/answer/9561022) or the [General Data Protection Regulation (GDPR)](https://support.google.com/admob/answer/7666366), please adhere to the steps outlined in the CCPA settings or GDPR settings to include your mediation partners in AdMob Privacy & Messaging's [CCPA](https://support.google.com/admob/answer/10860309) or [GDPR](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) ad partners list. Failing to do so may result in your partners being unable to serve ads on your app.

To acquire further insights, explore the process of [enabling CCPA restricted data processing](../privacy/regulatory_solutions/us_states_privacy_laws.md) and [obtaining GDPR consent using the Google User Messaging Platform (UMP) SDK](../privacy/user_menssaging_tools/get_started.md).