# Godot-AdMob-Editor-Plugin
This repository is for Godot's Addons to integrate natively AdMob to your Game Project without much configurations, with a beautiful UI and directly inside Godot Editor!

<u>is pretty basic right now, but with time will be improved</u>

Tutorial Video: https://youtu.be/MW4hUR0d9lc

# Installation:
Please read this tutorial: https://docs.godotengine.org/pt_BR/stable/tutorials/plugins/editor/installing_plugins.html

Manual:
1. Go to Tags of the project: https://github.com/Poing-Studios/Godot-AdMob-Editor-Plugin/tags
2. Download and extract the `.zip` or `.tar.gz`
3. Put the "addons/admob" folder which was extracted into your "res://addons" of your Game Project

Godot Asset Library:
1. Find the Plugin `AdMob` then download and install
2. Enable the Plugin: https://docs.godotengine.org/pt_BR/stable/tutorials/plugins/editor/installing_plugins.html#enabling-a-plugin

# Usage: 

After you installed, the Plugin will automaticly add an AutoLoad called `MobileAds`, this is the AdMob for Godot and you can call methods like: `MobileAds.load_banner()` to show a banner ad!

A example scene is here: `res://addons/admob/develop/Example.tscn`

To your plugin work, you need to download the `AdMob Plugin` here: https://github.com/Poing-Studios/Godot-AdMob-Android-iOS#readme


# Signals:
```
signal initialization_complete(status, adapter_name)

signal consent_form_dismissed()
signal consent_status_changed(consent_status_message)
signal consent_form_load_failure(error_code, error_message)
signal consent_info_update_success(consent_status_message)
signal consent_info_update_failure(error_code, error_message)

signal banner_loaded()
signal banner_failed_to_load(error_code)
signal banner_opened()
signal banner_clicked()
signal banner_closed()
signal banner_recorded_impression()
signal banner_destroyed()

signal interstitial_failed_to_load(error_code)
signal interstitial_loaded()
signal interstitial_failed_to_show(error_code)
signal interstitial_opened()
signal interstitial_closed()

signal rewarded_ad_failed_to_load(error_code)
signal rewarded_ad_loaded()
signal rewarded_ad_failed_to_show(error_code)
signal rewarded_ad_opened()
signal rewarded_ad_closed()

signal rewarded_interstitial_ad_failed_to_load(error_code)
signal rewarded_interstitial_ad_loaded()
signal rewarded_interstitial_ad_failed_to_show(error_code)
signal rewarded_interstitial_ad_opened()
signal rewarded_interstitial_ad_closed()

signal user_earned_rewarded(currency, amount)

```
