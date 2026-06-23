---
name: godot-admob-copilot
description: Technical specifications and implementation details for integrating ads using the Poing Godot AdMob Editor Plugin. Use to integrate MobileAds initialization, Banner/AdView, InterstitialAd, RewardedAd, RewardedInterstitialAd, AppOpenAd, and UMP consent flow.
metadata:
  version: 1.0
---
<!--
MIT License

Copyright (c) 2023-present Poing Studios

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->

# Poing Godot AdMob Plugin Integration Instructions

This skill provides the technical details and checklists for integrating the Poing AdMob SDK plugin in Godot Engine projects (compatible with Godot 4.x). It supports both GDScript and C#.

---

## 🚀 SDK Initialization & Request Configuration

Always initialize the AdMob SDK on startup before loading any ads.

### Checklist
- [ ] Create `OnInitializationCompleteListener` and connect callback.
- [ ] Create and configure `RequestConfiguration` (e.g. set test device IDs or child-directed rating).
- [ ] Call `MobileAds.set_request_configuration()`.
- [ ] Call `MobileAds.initialize()`.

### Code Examples

::: tab GDScript
```gdscript
# Initialize MobileAds
var on_init_listener := OnInitializationCompleteListener.new()
on_init_listener.on_initialization_complete = func(status: InitializationStatus) -> void:
	print("AdMob MobileAds initialized successfully!")

var request_config := RequestConfiguration.new()
request_config.test_device_ids = ["YOUR_TEST_DEVICE_ID_HERE"] # Use for testing on physical devices
request_config.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G

MobileAds.set_request_configuration(request_config)
MobileAds.initialize(on_init_listener)
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

// Initialize MobileAds
var onInitListener = new OnInitializationCompleteListener();
onInitListener.OnInitializationComplete = (InitializationStatus status) => {
    GD.Print("AdMob MobileAds initialized successfully!");
};

var requestConfig = new RequestConfiguration();
requestConfig.TestDeviceIds = new string[] { "YOUR_TEST_DEVICE_ID_HERE" };
requestConfig.MaxAdContentRating = RequestConfiguration.MAX_AD_CONTENT_RATING_G;

MobileAds.SetRequestConfiguration(requestConfig);
MobileAds.Initialize(onInitListener);
```
:::

---

## 📱 Banner Ads (AdView)

Banners are rectangular image/text ads that occupy a frame in the UI layout.

### Checklist
- [ ] Instantiate `AdView` with an Ad Unit ID, `AdSize`, and `AdPosition`.
- [ ] Create and configure an `AdListener` to listen to loaded, failed, opened, and closed events.
- [ ] Assign the listener to `ad_view.ad_listener`.
- [ ] Call `ad_view.load_ad(AdRequest.new())`.
- [ ] **Crucial**: Destroy the banner using `ad_view.destroy()` when changing scenes or destroying the node.

### Code Examples

::: tab GDScript
```gdscript
var ad_view: AdView

func load_banner_ad() -> void:
	var ad_unit_id := "ca-app-pub-3940256099942544/6300978111" # Test ID (replace in production)
	var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
	var ad_position := AdPosition.BOTTOM
	
	ad_view = AdView.new(ad_unit_id, ad_size, ad_position)
	
	var listener := AdListener.new()
	listener.on_ad_loaded = func() -> void:
		print("Banner loaded successfully.")
	listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		print("Banner failed to load: ", error.message)
		
	ad_view.ad_listener = listener
	ad_view.load_ad(AdRequest.new())

func _exit_tree() -> void:
	if ad_view:
		ad_view.destroy()
		ad_view = null
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

private AdView _adView;

public void LoadBannerAd()
{
    string adUnitId = "ca-app-pub-3940256099942544/6300978111"; // Test ID
    var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
    var adPosition = AdPosition.Bottom;
    
    _adView = new AdView(adUnitId, adSize, adPosition);
    
    var listener = new AdListener();
    listener.OnAdLoaded = () => GD.Print("Banner loaded successfully.");
    listener.OnAdFailedToLoad = (LoadAdError error) => GD.Print($"Banner failed to load: {error.Message}");
    
    _adView.AdListener = listener;
    _adView.LoadAd(new AdRequest());
}

public override void _ExitTree()
{
    if (_adView != null)
    {
        _adView.Destroy();
        _adView = null;
    }
}
```
:::

---

## 🎬 Interstitial Ads

Interstitial ads are full-screen ads that cover the interface of their host app.

### Checklist
- [ ] Instantiate `InterstitialAdLoader`.
- [ ] Configure `InterstitialAdLoadCallback` with `on_ad_loaded` and `on_ad_failed_to_load` callables.
- [ ] Call `interstitial_ad_loader.load()` passing the Ad Unit ID, `AdRequest`, and the callback.
- [ ] In the `on_ad_loaded` callback, save the loaded `InterstitialAd` instance.
- [ ] Connect `FullScreenContentCallback` to the interstitial ad to listen to show, click, dismiss, and fail-to-show events.
- [ ] Call `interstitial_ad.show()` to display the ad.
- [ ] Call `interstitial_ad.destroy()` when finished to free native memory.

### Code Examples

::: tab GDScript
```gdscript
var interstitial_ad: InterstitialAd
var interstitial_loader := InterstitialAdLoader.new()

func load_interstitial() -> void:
	var ad_unit_id := "ca-app-pub-3940256099942544/1033173712" # Test ID
	var callback := InterstitialAdLoadCallback.new()
	
	callback.on_ad_loaded = func(ad: InterstitialAd) -> void:
		interstitial_ad = ad
		print("Interstitial loaded. Ready to show.")
		setup_interstitial_callbacks()
		
	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		print("Interstitial failed to load: ", error.message)
		
	interstitial_loader.load(ad_unit_id, AdRequest.new(), callback)

func setup_interstitial_callbacks() -> void:
	if not interstitial_ad:
		return
	var callbacks := FullScreenContentCallback.new()
	callbacks.on_ad_showed_full_screen_content = func() -> void:
		print("Interstitial showed.")
	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
		print("Interstitial dismissed.")
		interstitial_ad.destroy()
		interstitial_ad = null
	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
		print("Interstitial failed to show: ", error.message)
		interstitial_ad.destroy()
		interstitial_ad = null
		
	interstitial_ad.full_screen_content_callback = callbacks

func show_interstitial() -> void:
	if interstitial_ad:
		interstitial_ad.show()
	else:
		print("Interstitial not loaded yet.")
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

private InterstitialAd _interstitialAd;
private InterstitialAdLoader _interstitialLoader = new InterstitialAdLoader();

public void LoadInterstitial()
{
    string adUnitId = "ca-app-pub-3940256099942544/1033173712"; // Test ID
    var callback = new InterstitialAdLoadCallback();
    
    callback.OnAdLoaded = (InterstitialAd ad) => {
        _interstitialAd = ad;
        GD.Print("Interstitial loaded. Ready to show.");
        SetupInterstitialCallbacks();
    };
    callback.OnAdFailedToLoad = (LoadAdError error) => {
        GD.Print($"Interstitial failed to load: {error.Message}");
    };
    
    _interstitialLoader.Load(adUnitId, new AdRequest(), callback);
}

private void SetupInterstitialCallbacks()
{
    if (_interstitialAd == null) return;
    
    var callbacks = new FullScreenContentCallback();
    callbacks.OnAdShowedFullScreenContent = () => GD.Print("Interstitial showed.");
    callbacks.OnAdDismissedFullScreenContent = () => {
        GD.Print("Interstitial dismissed.");
        _interstitialAd.Destroy();
        _interstitialAd = null;
    };
    callbacks.OnAdFailedToShowFullScreenContent = (AdError error) => {
        GD.Print($"Interstitial failed to show: {error.Message}");
        _interstitialAd.Destroy();
        _interstitialAd = null;
    };
    
    _interstitialAd.FullScreenContentCallback = callbacks;
}

public void ShowInterstitial()
{
    if (_interstitialAd != null)
    {
        _interstitialAd.Show();
    }
    else
    {
        GD.Print("Interstitial not loaded yet.");
    }
}
```
:::

---

## 🎁 Rewarded Ads

Rewarded ads reward users for interacting with video ads, playable ads, or surveys.

### Checklist
- [ ] Instantiate `RewardedAdLoader`.
- [ ] Set up `RewardedAdLoadCallback` with load success and failure callbacks.
- [ ] Call `rewarded_loader.load()` passing the Ad Unit ID, `AdRequest`, and load callback.
- [ ] Store the loaded `RewardedAd` object.
- [ ] Create `OnUserEarnedRewardListener` with `on_user_earned_reward` callback to handle the player rewards.
- [ ] Set up `FullScreenContentCallback` on the rewarded ad to handle ad closing/dismissal and cleanup.
- [ ] Call `rewarded_ad.show(reward_listener)` to display the ad.
- [ ] Call `rewarded_ad.destroy()` when finished to free native memory.

### Code Examples

::: tab GDScript
```gdscript
var rewarded_ad: RewardedAd
var rewarded_loader := RewardedAdLoader.new()

func load_rewarded_ad() -> void:
	var ad_unit_id := "ca-app-pub-3940256099942544/5224354917" # Test ID
	var callback := RewardedAdLoadCallback.new()
	
	callback.on_ad_loaded = func(ad: RewardedAd) -> void:
		rewarded_ad = ad
		print("Rewarded ad loaded.")
		setup_rewarded_callbacks()
		
	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		print("Rewarded ad failed to load: ", error.message)
		
	rewarded_loader.load(ad_unit_id, AdRequest.new(), callback)

func setup_rewarded_callbacks() -> void:
	if not rewarded_ad:
		return
	var callbacks := FullScreenContentCallback.new()
	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
		print("Rewarded ad dismissed.")
		rewarded_ad.destroy()
		rewarded_ad = null
	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
		print("Rewarded ad failed to show: ", error.message)
		rewarded_ad.destroy()
		rewarded_ad = null
		
	rewarded_ad.full_screen_content_callback = callbacks

func show_rewarded_ad() -> void:
	if not rewarded_ad:
		print("Rewarded ad not loaded.")
		return
		
	var reward_listener := OnUserEarnedRewardListener.new()
	reward_listener.on_user_earned_reward = func(rewarded_item: RewardedItem) -> void:
		print("Player rewarded! Amount: ", rewarded_item.amount, ", Type: ", rewarded_item.type)
		
	rewarded_ad.show(reward_listener)
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

private RewardedAd _rewardedAd;
private RewardedAdLoader _rewardedLoader = new RewardedAdLoader();

public void LoadRewardedAd()
{
    string adUnitId = "ca-app-pub-3940256099942544/5224354917"; // Test ID
    var callback = new RewardedAdLoadCallback();
    
    callback.OnAdLoaded = (RewardedAd ad) => {
        _rewardedAd = ad;
        GD.Print("Rewarded ad loaded.");
        SetupRewardedCallbacks();
    };
    callback.OnAdFailedToLoad = (LoadAdError error) => {
        GD.Print($"Rewarded ad failed to load: {error.Message}");
    };
    
    _rewardedLoader.Load(adUnitId, new AdRequest(), callback);
}

private void SetupRewardedCallbacks()
{
    if (_rewardedAd == null) return;
    
    var callbacks = new FullScreenContentCallback();
    callbacks.OnAdDismissedFullScreenContent = () => {
        GD.Print("Rewarded ad dismissed.");
        _rewardedAd.Destroy();
        _rewardedAd = null;
    };
    callbacks.OnAdFailedToShowFullScreenContent = (AdError error) => {
        GD.Print($"Rewarded ad failed to show: {error.Message}");
        _rewardedAd.Destroy();
        _rewardedAd = null;
    };
    
    _rewardedAd.FullScreenContentCallback = callbacks;
}

public void ShowRewardedAd()
{
    if (_rewardedAd == null)
    {
        GD.Print("Rewarded ad not loaded.");
        return;
    }
    
    var rewardListener = new OnUserEarnedRewardListener();
    rewardListener.OnUserEarnedReward = (RewardedItem rewardedItem) => {
        GD.Print($"Player rewarded! Amount: {rewardedItem.Amount}, Type: {rewardedItem.Type}");
    };
    
    _rewardedAd.Show(rewardListener);
}
```
:::

---

## 🧪 Rewarded Interstitial Ads

Rewarded Interstitial is a type of incentivized format that lets you offer rewards for ads that appear automatically during natural app transitions.

### Checklist
- [ ] Instantiate `RewardedInterstitialAdLoader`.
- [ ] Create `RewardedInterstitialAdLoadCallback` and configure the callbacks.
- [ ] Call `loader.load()` passing the Ad Unit ID, `AdRequest`, and the callback.
- [ ] Save the loaded `RewardedInterstitialAd` object.
- [ ] Prepare `OnUserEarnedRewardListener` with `on_user_earned_reward` callback to issue the rewards.
- [ ] Call `rewarded_interstitial_ad.show(reward_listener)`.
- [ ] Destroy the ad reference when dismissed or failed to show.

### Code Examples

::: tab GDScript
```gdscript
var rewarded_interstitial_ad: RewardedInterstitialAd
var rewarded_interstitial_loader := RewardedInterstitialAdLoader.new()

func load_rewarded_interstitial() -> void:
	var ad_unit_id := "ca-app-pub-3940256099942544/5354046379" # Test ID
	var callback := RewardedInterstitialAdLoadCallback.new()
	
	callback.on_ad_loaded = func(ad: RewardedInterstitialAd) -> void:
		rewarded_interstitial_ad = ad
		print("Rewarded Interstitial loaded.")
		setup_rewarded_interstitial_callbacks()
		
	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		print("Rewarded Interstitial failed to load: ", error.message)
		
	rewarded_interstitial_loader.load(ad_unit_id, AdRequest.new(), callback)

func setup_rewarded_interstitial_callbacks() -> void:
	if not rewarded_interstitial_ad:
		return
	var callbacks := FullScreenContentCallback.new()
	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
		print("Rewarded Interstitial dismissed.")
		rewarded_interstitial_ad.destroy()
		rewarded_interstitial_ad = null
	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
		print("Rewarded Interstitial failed to show: ", error.message)
		rewarded_interstitial_ad.destroy()
		rewarded_interstitial_ad = null
		
	rewarded_interstitial_ad.full_screen_content_callback = callbacks

func show_rewarded_interstitial() -> void:
	if not rewarded_interstitial_ad:
		print("Rewarded Interstitial ad not loaded.")
		return
		
	var reward_listener := OnUserEarnedRewardListener.new()
	reward_listener.on_user_earned_reward = func(rewarded_item: RewardedItem) -> void:
		print("Rewarded Interstitial earned: ", rewarded_item.amount, " ", rewarded_item.type)
		
	rewarded_interstitial_ad.show(reward_listener)
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

private RewardedInterstitialAd _rewardedInterstitialAd;
private RewardedInterstitialAdLoader _rewardedInterstitialLoader = new RewardedInterstitialAdLoader();

public void LoadRewardedInterstitial()
{
    string adUnitId = "ca-app-pub-3940256099942544/5354046379"; // Test ID
    var callback = new RewardedInterstitialAdLoadCallback();
    
    callback.OnAdLoaded = (RewardedInterstitialAd ad) => {
        _rewardedInterstitialAd = ad;
        GD.Print("Rewarded Interstitial loaded.");
        SetupRewardedInterstitialCallbacks();
    };
    callback.OnAdFailedToLoad = (LoadAdError error) => {
        GD.Print($"Rewarded Interstitial failed to load: {error.Message}");
    };
    
    _rewardedInterstitialLoader.Load(adUnitId, new AdRequest(), callback);
}

private void SetupRewardedInterstitialCallbacks()
{
    if (_rewardedInterstitialAd == null) return;
    
    var callbacks = new FullScreenContentCallback();
    callbacks.OnAdDismissedFullScreenContent = () => {
        GD.Print("Rewarded Interstitial dismissed.");
        _rewardedInterstitialAd.Destroy();
        _rewardedInterstitialAd = null;
    };
    callbacks.OnAdFailedToShowFullScreenContent = (AdError error) => {
        GD.Print($"Rewarded Interstitial failed to show: {error.Message}");
        _rewardedInterstitialAd.Destroy();
        _rewardedInterstitialAd = null;
    };
    
    _rewardedInterstitialAd.FullScreenContentCallback = callbacks;
}

public void ShowRewardedInterstitial()
{
    if (_rewardedInterstitialAd == null)
    {
        GD.Print("Rewarded Interstitial not loaded.");
        return;
    }
    
    var rewardListener = new OnUserEarnedRewardListener();
    rewardListener.OnUserEarnedReward = (RewardedItem rewardedItem) => {
        GD.Print($"Rewarded Interstitial earned: {rewardedItem.Amount} {rewardedItem.Type}");
    };
    
    _rewardedInterstitialAd.Show(rewardListener);
}
```
:::

---

## 🚪 App Open Ads

App Open ads are shown to users when they open or switch back to the app, covering the loading screen.

### Checklist
- [ ] Instantiate `AppOpenAdLoader`.
- [ ] Configure `AppOpenAdLoadCallback` with load success and failure listeners.
- [ ] Call `app_open_loader.load()` passing the Ad Unit ID, `AdRequest`, and callback.
- [ ] Implement `FullScreenContentCallback` to clean up and destroy the ad upon dismissal or show failure.
- [ ] Call `app_open_ad.show()` to show the ad to the user when they return to the game.

### Code Examples

::: tab GDScript
```gdscript
var app_open_ad: AppOpenAd
var app_open_loader := AppOpenAdLoader.new()

func load_app_open_ad() -> void:
	var ad_unit_id := "ca-app-pub-3940256099942544/9257395921" # Test ID
	var callback := AppOpenAdLoadCallback.new()
	
	callback.on_ad_loaded = func(ad: AppOpenAd) -> void:
		app_open_ad = ad
		print("App Open ad loaded.")
		setup_app_open_callbacks()
		
	callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		print("App Open ad failed to load: ", error.message)
		
	app_open_loader.load(ad_unit_id, AdRequest.new(), callback)

func setup_app_open_callbacks() -> void:
	if not app_open_ad:
		return
	var callbacks := FullScreenContentCallback.new()
	callbacks.on_ad_dismissed_full_screen_content = func() -> void:
		print("App Open ad dismissed.")
		app_open_ad.destroy()
		app_open_ad = null
	callbacks.on_ad_failed_to_show_full_screen_content = func(error: AdError) -> void:
		print("App Open ad failed to show: ", error.message)
		app_open_ad.destroy()
		app_open_ad = null
		
	app_open_ad.full_screen_content_callback = callbacks

func show_app_open_ad() -> void:
	if app_open_ad:
		app_open_ad.show()
	else:
		print("App Open ad not loaded yet.")
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Api.Core;

private AppOpenAd _appOpenAd;
private AppOpenAdLoader _appOpenLoader = new AppOpenAdLoader();

public void LoadAppOpenAd()
{
    string adUnitId = "ca-app-pub-3940256099942544/9257395921"; // Test ID
    var callback = new AppOpenAdLoadCallback();
    
    callback.OnAdLoaded = (AppOpenAd ad) => {
        _appOpenAd = ad;
        GD.Print("App Open ad loaded.");
        SetupAppOpenCallbacks();
    };
    callback.OnAdFailedToLoad = (LoadAdError error) => {
        GD.Print($"App Open ad failed to load: {error.Message}");
    };
    
    _appOpenLoader.Load(adUnitId, new AdRequest(), callback);
}

private void SetupAppOpenCallbacks()
{
    if (_appOpenAd == null) return;
    
    var callbacks = new FullScreenContentCallback();
    callbacks.OnAdDismissedFullScreenContent = () => {
        GD.Print("App Open ad dismissed.");
        _appOpenAd.Destroy();
        _appOpenAd = null;
    };
    callbacks.OnAdFailedToShowFullScreenContent = (AdError error) => {
        GD.Print($"App Open ad failed to show: {error.Message}");
        _appOpenAd.Destroy();
        _appOpenAd = null;
    };
    
    _appOpenAd.FullScreenContentCallback = callbacks;
}

public void ShowAppOpenAd()
{
    if (_appOpenAd != null)
    {
        _appOpenAd.Show();
    }
    else
    {
        GD.Print("App Open ad not loaded yet.");
    }
}
```
:::

---

## 🛡️ UMP Consent Flow

The User Messaging Platform (UMP) SDK helps you handle privacy options and consent, complying with GDPR and CCPA.

### Checklist
- [ ] Configure `ConsentRequestParameters` (e.g. set consent debug settings if testing).
- [ ] Call `ConsentInformation.request_consent_info_update(params, on_consent_info_update_listener)`.
- [ ] In the success callback, check `ConsentInformation.get_consent_status()`.
- [ ] If status is `REQUIRED` or form is available, call `ConsentForm.load_and_show_consent_form_if_required(on_consent_form_dismissed_listener)`.
- [ ] If status is `OBTAINED` or `NOT_REQUIRED`, you can safely initialize the `MobileAds` SDK.

### Code Examples

::: tab GDScript
```gdscript
func request_user_consent() -> void:
	var params := ConsentRequestParameters.new()
	# Optional debug settings for testing GDPR/CCPA flows:
	# var debug_settings := ConsentDebugSettings.new()
	# debug_settings.debug_geography = ConsentDebugSettings.DebugGeography.EEA
	# debug_settings.test_device_hashed_ids = ["YOUR_TEST_DEVICE_HASH_ID"]
	# params.consent_debug_settings = debug_settings
	
	var on_update_listener := OnConsentInfoUpdateListener.new()
	on_update_listener.on_consent_info_update_success = func() -> void:
		print("Consent info updated successfully.")
		if ConsentInformation.is_consent_form_available():
			load_and_show_form()
		else:
			# Form is not required/available, we can initialize MobileAds
			initialize_ads()
			
	on_update_listener.on_consent_info_update_failure = func(error: FormError) -> void:
		print("Consent info update failed: ", error.message)
		initialize_ads() # Fallback to initialize ads
		
	ConsentInformation.request_consent_info_update(params, on_update_listener)

func load_and_show_form() -> void:
	var on_dismissed_listener := OnConsentFormDismissedListener.new()
	on_dismissed_listener.on_consent_form_dismissed = func(error: FormError) -> void:
		if error:
			print("Consent form dismissed with error: ", error.message)
		else:
			print("Consent form dismissed successfully.")
		initialize_ads()
		
	ConsentForm.load_and_show_consent_form_if_required(on_dismissed_listener)

func initialize_ads() -> void:
	# Proceed with MobileAds initialization
	pass
```
:::

::: tab C#
```csharp
using PoingStudios.AdMob.Api.Ump;
using PoingStudios.AdMob.Api.Ump.Listeners;
using PoingStudios.AdMob.Api.Ump.Core;

public void RequestUserConsent()
{
    var @params = new ConsentRequestParameters();
    
    var onUpdateListener = new OnConsentInfoUpdateListener();
    onUpdateListener.OnConsentInfoUpdateSuccess = () => {
        GD.Print("Consent info updated successfully.");
        if (ConsentInformation.IsConsentFormAvailable())
        {
            LoadAndShowForm();
        }
        else
        {
            InitializeAds();
        }
    };
    onUpdateListener.OnConsentInfoUpdateFailure = (FormError error) => {
        GD.Print($"Consent info update failed: {error.Message}");
        InitializeAds();
    };
    
    ConsentInformation.RequestConsentInfoUpdate(@params, onUpdateListener);
}

private void LoadAndShowForm()
{
    var onDismissedListener = new OnConsentFormDismissedListener();
    onDismissedListener.OnConsentFormDismissed = (FormError error) => {
        if (error != null)
        {
            GD.Print($"Consent form dismissed with error: {error.Message}");
        }
        else
        {
            GD.Print("Consent form dismissed successfully.");
        }
        InitializeAds();
    };
    
    ConsentForm.LoadAndShowConsentFormIfRequired(onDismissedListener);
}

private void InitializeAds()
{
    // Proceed with MobileAds initialization
}
```
:::
