[![Download Asset Library](https://img.shields.io/badge/Download-Asset%20Library-darkgreen?style=for-the-badge)](https://godotengine.org/asset-library/asset/1108)
![Stars](https://img.shields.io/github/stars/Poing-Studios/godot-admob-editor?style=for-the-badge)
![License](https://img.shields.io/github/license/Poing-Studios/godot-admob-editor?style=for-the-badge)

# Godot AdMob Editor Plugin

This addon provides an easy and beautiful way to configure AdMob directly through the editor. Supports [godot-admob-android](https://github.com/Poing-Studios/godot-admob-android) and [godot-admob-ios](https://github.com/Poing-Studios/godot-admob-ios).

### [Installation and Usage Tutorial](https://www.youtube.com/watch?v=ZnlH3INcAGs)

# Installation

Godot Asset Library (recommended):
1. Find the AdMob plugin by `poing.studios` \
   <img height=100 src="static/asset_library.png">
2. Click Download and Install
3. Enable in Project→Project Settings→Plugins
4. Install [godot-admob-android](https://github.com/Poing-Studios/godot-admob-android) and/or [godot-admob-ios](https://github.com/Poing-Studios/godot-admob-ios)

Manual install for custom versions:
1. Pick a [specific version](https://github.com/Poing-Studios/godot-admob-editor/tags) from tags
2. Download and extract as a `.zip` or `.tar.gz`
3. Copy the extracted `addons/admob` folder into `res://addons` on your project
4. Install [godot-admob-android](https://github.com/Poing-Studios/godot-admob-android) and/or [godot-admob-ios](https://github.com/Poing-Studios/godot-admob-ios)

# Usage

After installation, the singleton `MobileAds` will be available. Try it out by calling `MobileAds.load_banner()`!

# API

### Methods:

```gdscript
void load_banner(ad_unit_name = "standard")
void load_interstitial(ad_unit_name = "standard")
void load_rewarded(ad_unit_name = "standard")
void load_rewarded_interstitial(ad_unit_name = "standard")

void destroy_banner()
void show_banner()
void hide_banner()
void show_interstitial()
void show_rewarded()
void show_rewarded_interstitial()

void request_user_consent()
void reset_consent_state(will_request_user_consent = false)

int get_banner_width()
int get_banner_width_in_pixels()
int get_banner_height()
int get_banner_height_in_pixels()
bool get_is_banner_loaded()
bool get_is_interstitial_loaded()
bool get_is_rewarded_loaded()
bool get_is_rewarded_interstitial_loaded()
```

### Signals:

```gdscript
initialization_complete(status, adapter_name)

consent_form_dismissed()
consent_status_changed(consent_status_message)
consent_form_load_failure(error_code, error_message)
consent_info_update_success(consent_status_message)
consent_info_update_failure(error_code, error_message)

banner_loaded()
banner_failed_to_load(error_code)
banner_opened()
banner_clicked()
banner_closed()
banner_recorded_impression()
banner_destroyed()

interstitial_failed_to_load(error_code)
interstitial_loaded()
interstitial_failed_to_show(error_code)
interstitial_opened()
interstitial_closed()

rewarded_ad_failed_to_load(error_code)
rewarded_ad_loaded()
rewarded_ad_failed_to_show(error_code)
rewarded_ad_opened()
rewarded_ad_closed()

rewarded_interstitial_ad_failed_to_load(error_code)
rewarded_interstitial_ad_loaded()
rewarded_interstitial_ad_failed_to_show(error_code)
rewarded_interstitial_ad_opened()
rewarded_interstitial_ad_closed()

user_earned_rewarded(currency, amount)
```
