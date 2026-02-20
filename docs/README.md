# Get Started

Integrating the AdMob plugin into your Godot project, specifically for Godot v4.2+, is the initial and crucial step in enabling ad displays and revenue generation. After successfully incorporating this plugin, you'll have the flexibility to select from various ad formats, like Banner or Interstitial, and proceed with the necessary implementation steps.

This document is based on:

- [Google Mobile Ads SDK Android Documentation](https://developers.google.com/admob/android/quick-start)
- [Google Mobile Ads SDK iOS Documentation](https://developers.google.com/admob/ios/quick-start)

## Prerequisites

- Use Godot v4.2 or higher
- Deploy Android:
	- `minSdkVersion` of 24 or higher
	- `compileSdkVersion` of 36 or higher
- Deploy iOS:
	- Use Xcode 26.2 or higher
	- Target iOS 16.0 or higher
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
5. Once the download is complete, go to `Project → Project Settings` within the Godot editor.
6. In the `Plugins` section, find the `AdMob` plugin and activate it.
![activate_plugin](assets/activate_plugin.png)
7. The Android and iOS libraries will be downloaded and installed automatically.
8. With these steps, you'll have successfully integrated the AdMob plugin into your Godot project without the need for additional manual file imports.

## Download & Install
!!! info
    This section is typically **not required**, as the plugin handles libraries automatically. Only follow these steps if the automatic download failed or you need a specific legacy version.

=== "Android"

	To integrate the required Android library for AdMob in Godot, follow these steps:

	1. In Godot, navigate to `Project → Tools → AdMob Manager → Android → Download & Install`.
	1. This action will download and install the appropriate Android library into your project, which is located at `res://addons/admob/android/bin/`.

	If you encounter any issues with the download, you can try downloading the library manually by clicking [here](https://github.com/poingstudios/godot-admob-android/releases/latest).

=== "iOS"

	To integrate the required iOS library for AdMob in Godot, follow these steps:

	1. In Godot, navigate to `Project → Tools → AdMob Manager → iOS → Install`.
	1. This action will automatically download and install the two required zip files (internal implementation and external dependencies) into your project at `res://ios/plugins/`.

	If you encounter any issues with the download, you can try downloading the libraries manually from the [releases tab](https://github.com/poingstudios/godot-admob-ios/releases). You will need both the `internal` (specific to your Godot version) and the `sdk-external-dependencies` zip files. Extract both into `res://ios/plugins/`.

### Exporting 

=== "Android"

	1. Install the [Android Build Template](https://docs.godotengine.org/en/stable/tutorials/export/android_gradle_build.html) by navigating to `Project → Install Android Build Template`.
	1. Add your [AdMob App ID](https://support.google.com/admob/answer/7356431) to your app's `res://addons/admob/android/config.gd` file by changing the variable `APPLICATION_ID`.
	
	    !!! tip "App ID vs Ad Unit ID"
	        - **App ID** (contains `~`): Used for app registration and internal configuration.
	        - **Ad Unit ID** (contains `/`): Used to load specific ad formats in your code.
	
	1. If you have Mediation, set true the libraries at `res://addons/admob/android/config.gd`, such as: `adcolony`, `meta`, `vungle`, etc...
	1. When exporting your project, select `Use Gradle Build`.
	
	    ![export](assets/android/export.png)

=== "iOS"

    1. Within `res://ios/plugins/poing-godot-admob-ads.gdip`, if you are using Mediation, locate the `SKAdNetworkItems` section. Here, you can remove the comments associated with the [Mediation Networks](https://developers.google.com/admob/ios/choose-networks) that you are using.
    
        ![export](assets/ios/skadnetworkitems.png)
    
    1. When exporting your project, update the `GADApplicationIdentifier` with your [AdMob App ID](https://support.google.com/admob/answer/7356431) and ensure that `Ad Mob` is enabled in the Plugins section of the Export dialog. If you have Mediation, also mark `Ad Mob Meta`, `Ad Mob AdColony`, etc...
    
        ![gadapplicationidentifier](assets/ios/gadapplicationidentifier.png)
    
        !!! tip "App ID vs Ad Unit ID"
            - **App ID** (contains `~`): Used for app registration and internal configuration.
            - **Ad Unit ID** (contains `/`): Used to load specific ad formats in your code.
    
    1. **That's it!** Since this plugin uses `.xcframework` bundles, Godot 4.2+ will automatically integrate all necessary libraries and frameworks into your Xcode project. No manual terminal commands, CocoaPods, or Xcode configuration steps are required.
    
    1. [If you are facing "__swift_FORCE_LOAD_" error, read this](https://github.com/poingstudios/godot-admob-ios/issues/127).

        1. Create a `Untitled.swift` file in your Xcode project.
        2. Xcode will ask you to `Create Bridge Header → Accept`.
        3. Your project should now build normally.
            ![untitled.swift](assets/ios/untitled.swift.png)
    
    1. Run the Game.
    
    1. [If you are trying to run on Simulator and it is not working, read this](https://github.com/godotengine/godot/issues/44681#issuecomment-751399783).

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
