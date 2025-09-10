# Get Started

Integrating the AdMob plugin into your Godot project, specifically for Godot v4.1+, is the initial and crucial step in enabling ad displays and revenue generation. After successfully incorporating this plugin, you'll have the flexibility to select from various ad formats, like Banner or Interstitial, and proceed with the necessary implementation steps.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/quick-start)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/quick-start)

## Prerequisites

- Use Godot v4.1 or higher
- Deploy Android:
	- `minSdkVersion` of 19 or higher
	- `compileSdkVersion` of 28 or higher
- Deploy iOS:
	- Use Xcode 14.1 or higher
	- Target iOS 11.0 or higher
	- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
- Recommended: [Create an AdMob account](https://support.google.com/admob/answer/7356219?visit_id=638286911958663013-3847536692&rd=1) and [register an app](https://support.google.com/admob/answer/9989980?visit_id=638286911964685099-3190075945&rd=1).

## Download the Godot AdMob Plugin from Poing Studios

The Godot AdMob Plugin from Poing Studios simplifies the process for Godot developers to incorporate Google Mobile Ads into their Android and iOS apps, eliminating the need to write Java/Kotlin or Objective-C++ code. Instead, this plugin offers a GDScript-based interface for ad requests, which can be seamlessly integrated into your Godot project. 

To access the plugin, you can either download the Godot package provided or explore its source code on GitHub through the links below.

[Download from GitHub](https://github.com/poingstudios/godot-admob-plugin/releases/latest){ .md-button .md-button--primary } [Download from AssetLibrary](https://godotengine.org/asset-library/asset/2063){ .md-button .md-button--primary } [Source Code](https://github.com/poingstudios/godot-admob-plugin){ .md-button .md-button--primary }

### Importing the Godot AdMob Plugin on Project

The AdMob plugin for Godot is conveniently available via AssetLib. To import this plugin into your Godot project, follow these steps:

1. Open your Godot project.
2. Navigate to AssetLib within the Godot editor.
3. In the search bar, enter `AdMob` and ensure that the publisher is set to `poing.studios`.
![activate_plugin](assets/asset_library.png)
4. Locate the AdMob plugin and click the `Download` button.
5. Once the download is complete, go to `Project > Project Settings` within the Godot editor.
6. In the `Plugins` section, find the `AdMob` plugin and activate it.
![activate_plugin](assets/activate_plugin.png)
7. With these steps, you'll have successfully integrated the AdMob plugin into your Godot project without the need for additional manual file imports.

## Obtaining external libraries

=== "Android"
	To integrate the required Android library for AdMob in Godot, follow these steps:

	1. In Godot, navigate to `Project > Tools > AdMob Download Manager > Android > LatestVersion`.
	2. This action will download the appropriate Android library into your project, which is located at `res://addons/admob/downloads/android/`.

	If you encounter any issues with the download, you can try downloading the library manually by clicking [here](https://github.com/poingstudios/godot-admob-android/releases/latest).

=== "iOS"

	To integrate the required iOS library for AdMob in Godot, follow these steps:

	1. In Godot, navigate to `Project > Tools > AdMob Download Manager > iOS > LatestVersion`.
	2. This action will download the appropriate iOS library into your project, which is located at `res://addons/admob/downloads/ios/`.

	If you encounter any issues with the download, you can try downloading the library manually by clicking [here](https://github.com/poingstudios/godot-admob-ios/releases/latest).

### Installing 
=== "Android"
    1. Install the **Android Build Template**: `Project > Install Android Build Template`.
    2. Go to `res://android/plugins/` and extract the `ads` folder from the downloaded ZIP located at:
       `res://addons/admob/downloads/android/`.  
       If you use **Mediation**, also extract `meta`, `adcolony`, etc.
       ![folder](assets/android/folder.png)
    3. Add your AdMob App ID to `res://android/build/AndroidManifest.xml` by adding a `<meta-data>` tag with name
       `com.google.android.gms.ads.APPLICATION_ID`. If you don't add this the app may crash on start-up:
       
       ```xml
       <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
       <meta-data
           android:name="com.google.android.gms.ads.APPLICATION_ID"
           android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
       ```
    4. **Important — App ID vs Ad Unit ID**
       - **App ID** (contains `~`): used for app registration and manifest.
       - **Ad Unit ID** (contains `/`): used to load specific ad formats (banner, rewarded, etc.).
    5. When exporting your project, select **Use Custom Build** and ensure **Ad Mob** is enabled.  
       If you use Mediation also enable the corresponding mediation plugins (`Ad Mob Meta`, `Ad Mob AdColony`, ...).
       ![export](assets/android/export.png)

=== "iOS"

    1. Create `res://ios/plugins/` if it does not already exist.
    2. Go to `res://ios/plugins/` and extract the `ads` folder from the ZIP at:
       `res://addons/admob/downloads/ios/`.  
       If you use **Mediation**, also extract `meta`, `adcolony`, etc.
       ![folder](assets/ios/folder.png)
    3. If using Mediation, open `res://ios/plugins/poing-godot-admob-ads.gdip` and locate the `SKAdNetworkItems` section.
       Uncomment (remove the comments from) the SKAdNetwork entries for the mediation networks you use.
       ![skadnetworkitems](assets/ios/skadnetworkitems.png)
    4. When exporting, update `GADApplicationIdentifier` to your AdMob App ID and ensure **Ad Mob** is enabled.
       If you use Mediation, enable the related iOS mediation options as well.
       ![gadapplicationidentifier](assets/ios/gadapplicationidentifier.png)
    5. **Important — App ID vs Ad Unit ID**
       - **App ID** (contains `~`): used for app registration and manifest.
       - **Ad Unit ID** (contains `/`): used to load specific ad formats (banner, rewarded, etc.).
    6. After export, open a terminal in:
       `{{ ios_xcode_export_folder }}/{{your_project_name}}/ios/plugins/poing-godot-admob/scripts/` and run:
       
       ```bash
       chmod +x update_and_install.sh
       ./update_and_install.sh
       ```
       ![update_and_installsh](assets/ios/update_and_installsh.png)
    7. The script will create `{{ your_project_name }}.xcworkspace` (example: `AdMobAddon.xcworkspace`) in
       `{{ ios_xcode_export_folder }}`. Open that workspace in Xcode.
    8. In your app target: `General -> Frameworks, Libraries, and Embedded Content` — add all the Pods listed.
       ![add_libraries](assets/ios/add_libraries.png)
    9. Select all frameworks (⌘ + A) and set them to **Do Not Embed**.
       ![do_not_embed](assets/ios/do_not_embed.png)
    10. Build and run the game on device.  
    11. If you have problems running on the Simulator, see:  
        https://github.com/godotengine/godot/issues/44681#issuecomment-751399783

## Initialize the Google Mobile Ads SDK
Prior to loading ads, ensure that your application initializes the Google Mobile Ads SDK. You can accomplish this by calling MobileAds.initialize(). This function initializes the SDK and triggers a completion listener once the initialization process is finished, or if it exceeds a 30-second timeout. It's important to note that this initialization should occur only once, ideally during the app's launch phase.

```gdscript
func _ready() -> void:
	MobileAds.initialize()
```

If you are utilizing mediation, it's essential to wait for the completion handler to be called before proceeding with ad loading. This step ensures that all mediation adapters are properly initialized before ad requests are made.

## Select an ad format
The Google Mobile Ads SDK is now successfully imported, and you are prepared to integrate an ad into your app. AdMob provides a variety of ad formats, allowing you to select the one that aligns best with your app's user experience.

### Banner
<div class="image-text-container">
  <img src="assets/ad_formats/banner.png" alt="banner">
  <p>Banner ads are rectangular advertisements, consisting of either images or text, that are integrated into an app's layout. These ads remain on the screen while users engage with the app and can automatically refresh after a designated time interval. If you're new to mobile advertising, banner ads provide an excellent starting point for your ad implementation journey.</p>
</div>

[Implement banner ads](ad_formats/banner/get_started.md){ .md-button .md-button--primary }

### Interstitial
<div class="image-text-container">
  <img src="assets/ad_formats/interstitial.png" alt="interstitial">
  <p>Interstitial ads are expansive, full-screen advertisements that overlay an app's interface and persist until they are closed by the user. They are most effective when strategically placed during natural pauses in the app's execution, such as between levels of a game or immediately after the completion of a task.</p>
</div>

[Implement interstitial ads](ad_formats/interstitial.md){ .md-button .md-button--primary }

### Rewarded
<div class="image-text-container">
  <img src="assets/ad_formats/rewarded.png" alt="rewarded">
  <p>Rewarded video ads are immersive, full-screen video advertisements that provide users with the choice to watch them entirely. In return for their time and attention, users receive in-app rewards or benefits.</p>
</div>

[Implement rewarded ads](ad_formats/rewarded.md){ .md-button .md-button--primary }

### Rewarded Interstitial
<div class="image-text-container">
  <img src="assets/ad_formats/rewarded_interstitial.png" alt="rewarded_interstitial">
  <p>A Rewarded Interstitial is a specific form of incentivized ad format that allows you to provide rewards in exchange for ads that appear automatically during natural app transitions. Unlike regular rewarded ads, users are not obligated to actively opt in to view a Rewarded Interstitial; they are seamlessly integrated into the app experience.</p>
</div>

[Implement rewarded interstitial ads](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 200px;
    height: auto;
  }
</style>
