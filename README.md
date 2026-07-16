<div align="center">
  <h1>
    <img src="https://i.imgur.com/T3Beai0.png" width="40" style="vertical-align: middle;"> Godot AdMob Plugin
  </h1>

  [![VersionBadge]][Releases] [![StarsBadge]][Stargazers] [![DiscordBadge]][DiscordLink] [![LicenseBadge]][LicenseLink] <br>
  [![DownloadsBadge]][Releases] [![AssetStoreBadge]][AssetStore] <br>
  [![AndroidBadge]][AndroidPlatform] [![iOSBadge]][iOSPlatform] [![GDScriptBadge]][Examples] [![CSharpBadge]][Examples]

  **The complete solution for AdMob integration in Godot using GDScript or C#.**  
  Supports [Android][AndroidPlatform] and [iOS][iOSPlatform] natively.

  ![Plugin Usage](docs/assets/usage.webp)

  [🎬 Watch Video Tutorial](https://youtu.be/TB7WhP8mieo) • [📖 Read Documentation][DocumentationLink]

  ---

  [📦 Installation](#-installation) • [📋 Examples](#-examples) • [🙏 Support](#-support)

</div>

## 📦 Installation

### 📥 Godot Asset Store (recommended)

1. Find the [AdMob plugin](https://store.godotengine.org/asset/poingstudios/admob/) by `Poing Studios` \
   <img height=120 src="docs/assets/asset_store.png">
2. Click **Download** and **Install**.

<details>
<summary><b>Manual installation for custom versions</b></summary>

1. Pick a [specific version](https://github.com/poingstudios/godot-admob-plugin/releases) from tags.
2. Download the `poing-godot-admob-v*.zip` file from the assets.
3. Extract the ZIP file in the root of your project.

</details>

### ⚙️ Post-installation

1. Enable the plugin in `Project → Project Settings → Plugins`.
2. **Setup Platform Dependencies**:
    - **Android**: Follow the [Android Setup Guide][AndroidPlatform].
    - **iOS**: Follow the [iOS Setup Guide][iOSPlatform].

> [!TIP]
> If the automatic download fails, you can manually trigger it via `Project → Tools → AdMob Manager → (Android/iOS) → Download & Install`.

## 🙋‍♂️ How to use
After installation, the `MobileAds` singleton becomes available in any script.

## 📋 Examples

## 🏁Initialize AdMob
<details>
<summary>GDScript</summary>

```gdscript
func _ready() -> void:
	#just need to call once
	MobileAds.initialize()
```

</details>

<details>
<summary>C#</summary>

```csharp
using PoingStudios.AdMob.Api;

public override void _Ready()
{
	//just need to call once
	MobileAds.Initialize();
}
```

</details>

## 📱App Open Ads
<details>
<summary>GDScript</summary>

### Load
```gdscript
var app_open_ad : AppOpenAd
var app_open_ad_load_callback := AppOpenAdLoadCallback.new()

func _ready():
	app_open_ad_load_callback.on_ad_failed_to_load = on_app_open_ad_failed_to_load
	app_open_ad_load_callback.on_ad_loaded = on_app_open_ad_loaded

# button signal on scene
func _on_load_app_open_pressed() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/9257395921"
		unit_id = "ca-app-pub-3940256099942544/5575463023"
	
	AppOpenAdLoader.new().load(unit_id, AdRequest.new(), app_open_ad_load_callback)

func on_app_open_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_app_open_ad_loaded(app_open_ad : AppOpenAd) -> void:
	self.app_open_ad = app_open_ad
```

### Show
```gdscript
# button signal on scene
func _on_show_pressed():
	if app_open_ad:
		app_open_ad.show()
```

</details>

<details>
<summary>C#</summary>

### Load
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;

private AppOpenAd _appOpenAd;

// button signal on scene
private void OnLoadAppOpenPressed()
{
	string unitId = "";
	if (OS.GetName() == "Android")
	{
		unitId = "ca-app-pub-3940256099942544/9257395921";
	}
	else if (OS.GetName() == "iOS")
	{
		unitId = "ca-app-pub-3940256099942544/5575463023";
	}
	
	new AppOpenAdLoader().Load(unitId, new AdRequest(), new AppOpenAdLoadCallback
	{
		OnAdLoaded = ad => _appOpenAd = ad,
		OnAdFailedToLoad = err => GD.Print(err.Message)
	});
}
```

### Show
```csharp
// button signal on scene
private void OnShowPressed()
{
	if (_appOpenAd != null)
	{
		_appOpenAd.Show();
	}
}
```

</details>

## 🎏Banner Ads

<details>
<summary>GDScript</summary>

### Load (will automatically show)
```gdscript
# button signal on scene
func _on_load_banner_pressed() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/6300978111"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/2934735716"

	var ad_view := AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.TOP)
	ad_view.load_ad(AdRequest.new())
```

</details>

<details>
<summary>C#</summary>

### Load (will automatically show)
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;

// button signal on scene
private void OnLoadBannerPressed()
{
	string unitId = "";
	if (OS.GetName() == "Android")
	{
		unitId = "ca-app-pub-3940256099942544/6300978111";
	}
	else if (OS.GetName() == "iOS")
	{
		unitId = "ca-app-pub-3940256099942544/2934735716";
	}

	var adView = new AdView(unitId, AdSize.Banner, AdPosition.Top);
	adView.LoadAd(new AdRequest());
}
```

</details>

## 📺Interstitial Ads
<details>
<summary>GDScript</summary>

### Load
```gdscript
var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
func _ready():
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded

# button signal on scene
func _on_load_interstitial_pressed() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/1033173712"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/4411468910"

	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)

func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)

func on_interstitial_ad_loaded(interstitial_ad : InterstitialAd) -> void:
	self.interstitial_ad = interstitial_ad
```

### Show
```gdscript
# button signal on scene
func _on_show_pressed():
	if interstitial_ad:
		interstitial_ad.show()
```

</details>

<details>
<summary>C#</summary>

### Load
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;

private InterstitialAd _interstitialAd;

// button signal on scene
private void OnLoadInterstitialPressed()
{
	string unitId = "";
	if (OS.GetName() == "Android")
	{
		unitId = "ca-app-pub-3940256099942544/1033173712";
	}
	else if (OS.GetName() == "iOS")
	{
		unitId = "ca-app-pub-3940256099942544/4411468910";
	}
	
	new InterstitialAdLoader().Load(unitId, new AdRequest(), new InterstitialAdLoadCallback
	{
		OnAdLoaded = ad => _interstitialAd = ad,
		OnAdFailedToLoad = err => GD.Print(err.Message)
	});
}
```

### Show
```csharp
// button signal on scene
private void OnShowPressed()
{
	if (_interstitialAd != null)
	{
		_interstitialAd.Show();
	}
}
```

</details>

## 🖼️Native Overlay Ads
<details>
<summary>GDScript</summary>

### Load
```gdscript
var native_overlay_ad: NativeOverlayAd

# button signal on scene
func _on_load_native_pressed() -> void:
	var unit_id := "ca-app-pub-3940256099942544/2247696110" if OS.get_name() == "Android" else "ca-app-pub-3940256099942544/3986624511"
	
	var ad_request := AdRequest.new()
	var options := NativeAdOptions.new()

	NativeOverlayAd.load(unit_id, ad_request, options, _on_ad_load_finished)

func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
	if error:
		print("Native ad failed to load: ", error.message)
		return
	
	native_overlay_ad = ad
	_render_native_ad()
```

### Render
```gdscript
func _render_native_ad() -> void:
	var style := NativeTemplateStyle.new()
	style.template_id = NativeTemplateStyle.MEDIUM
	native_overlay_ad.render_template(style, AdPosition.BOTTOM)
```

</details>

<details>
<summary>C#</summary>

### Load
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;

private NativeOverlayAd _nativeOverlayAd;

// button signal on scene
private void OnLoadNativePressed()
{
	string unitId = OS.GetName() == "Android" 
		? "ca-app-pub-3940256099942544/2247696110" 
		: "ca-app-pub-3940256099942544/3986624511";

	var adRequest = new AdRequest();
	var options = new NativeAdOptions();

	NativeOverlayAd.Load(unitId, adRequest, options, OnAdLoadFinished);
}

private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
{
	if (error != null)
	{
		GD.Print("Native ad failed to load: " + error.Message);
		return;
	}

	_nativeOverlayAd = ad;
	RenderNativeAd();
}
```

### Render
```csharp
private void RenderNativeAd()
{
	var style = new NativeTemplateStyle();
	style.TemplateId = NativeTemplateStyle.Medium;
	_nativeOverlayAd.RenderTemplate(style, AdPosition.Bottom);
}
```

</details>

## 🎁Rewarded Ads

<details>
<summary>GDScript</summary>

### Load
```gdscript
var rewarded_ad : RewardedAd
var rewarded_ad_load_callback := RewardedAdLoadCallback.new()

func _ready():
	rewarded_ad_load_callback.on_ad_failed_to_load = on_rewarded_ad_failed_to_load
	rewarded_ad_load_callback.on_ad_loaded = on_rewarded_ad_loaded

# button signal on scene
func _on_load_rewarded_pressed() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5224354917"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/1712485313"

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)

func on_rewarded_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_ad_loaded(rewarded_ad : RewardedAd) -> void:
	self.rewarded_ad = rewarded_ad
```

### Show
```gdscript
# button signal on scene
func _on_show_pressed():
	if rewarded_ad:
		rewarded_ad.show()
```

</details>

<details>
<summary>C#</summary>

### Load
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;

private RewardedAd _rewardedAd;

// button signal on scene
private void OnLoadRewardedPressed()
{
	string unitId = "";
	if (OS.GetName() == "Android")
	{
		unitId = "ca-app-pub-3940256099942544/5224354917";
	}
	else if (OS.GetName() == "iOS")
	{
		unitId = "ca-app-pub-3940256099942544/1712485313";
	}

	new RewardedAdLoader().Load(unitId, new AdRequest(), new RewardedAdLoadCallback
	{
		OnAdLoaded = ad => _rewardedAd = ad,
		OnAdFailedToLoad = err => GD.Print(err.Message)
	});
}
```

### Show
```csharp
// button signal on scene
private void OnShowPressed()
{
	if (_rewardedAd != null)
	{
		_rewardedAd.Show(new OnUserEarnedRewardListener
		{
			OnUserEarnedReward = reward => GD.Print($"Reward: {reward.Amount} {reward.Type}")
		});
	}
}
```

</details>

## 🎁📺Rewarded Interstitial Ads
<details>
<summary>GDScript</summary>

### Load
```gdscript
var rewarded_interstitial_ad : RewardedInterstitialAd
var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()

func _ready():
	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = on_rewarded_interstitial_ad_failed_to_load
	rewarded_interstitial_ad_load_callback.on_ad_loaded = on_rewarded_interstitial_ad_loaded

# button signal on scene
func _on_load_rewarded_interstitial_pressed() -> void:
	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5354046379"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/6978759866"
	
	RewardedInterstitialAdLoader.new().load(unit_id, AdRequest.new(), rewarded_interstitial_ad_load_callback)

func on_rewarded_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	print(adError.message)
	
func on_rewarded_interstitial_ad_loaded(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
	self.rewarded_interstitial_ad = rewarded_interstitial_ad
```

### Show
```gdscript
# button signal on scene
func _on_show_pressed():
	if rewarded_interstitial_ad:
		rewarded_interstitial_ad.show(on_user_earned_reward_listener)
```

</details>

<details>
<summary>C#</summary>

### Load
```csharp
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;

private RewardedInterstitialAd _rewardedInterstitialAd;

// button signal on scene
private void OnLoadRewardedInterstitialPressed()
{
	string unitId = "";
	if (OS.GetName() == "Android")
	{
		unitId = "ca-app-pub-3940256099942544/5354046379";
	}
	else if (OS.GetName() == "iOS")
	{
		unitId = "ca-app-pub-3940256099942544/6978759866";
	}
	
	new RewardedInterstitialAdLoader().Load(unitId, new AdRequest(), new RewardedInterstitialAdLoadCallback
	{
		OnAdLoaded = ad => _rewardedInterstitialAd = ad,
		OnAdFailedToLoad = err => GD.Print(err.Message)
	});
}
```

### Show
```csharp
// button signal on scene
private void OnShowPressed()
{
	if (_rewardedInterstitialAd != null)
	{
		_rewardedInterstitialAd.Show(new OnUserEarnedRewardListener
		{
			OnUserEarnedReward = reward => GD.Print($"Reward: {reward.Amount} {reward.Type}")
		});
	}
}
```

</details>

## 📎 Useful links

- 🍎 [iOS Platform Setup][iOSPlatform]
- 🤖 [Android Platform Setup][AndroidPlatform]
- ⏳ [Godot 3 Support](https://github.com/poingstudios/godot-admob-plugin/tree/v1)

## 📄 Documentation

For complete documentation including mediation setup: **[Official Documentation][DocumentationLink]**.

Alternatively, check AdMob's original docs for [Android](https://developers.google.com/admob/android/quick-start) or [iOS](https://developers.google.com/admob/ios/quick-start).

## 🙏 Support

If you find our work valuable and would like to support us, consider contributing via these platforms:

[![PatreonBadge]][PatreonLink]

[![KofiBadge]][KofiLink]

[![PaypalBadge]][PaypalLink]

Your support helps us continue to improve and maintain this plugin. Thank you for being a part of our community!

## 🆘 Getting help

[![DiscussionsBadge]][DiscussionsLink] [![DiscordHelpBadge]][DiscordLink]



## Star History

[![Star History Chart](https://api.star-history.com/chart?repos=poingstudios/godot-admob-plugin&type=date&legend=top-left&sealed_token=ATUzb1mXlOQI3jnGm7Rpn_8YkMDh9y4DoyF-IOZ97Uw0oaShFtR9I5Srrxhrf_jaMaqgO5YKfVp9-UyqlLamx_epOX88rpSpr3g9utgVLd7xThQRsYWhJHM2lWd6WUg-wjEDVgZ7xpRrkzPHC4rGbTeXRrnvmPMagKmVDcL5_gX300ftiun-vv5iarNh)](https://www.star-history.com/?repos=poingstudios%2Fgodot-admob-plugin&type=date&legend=top-left)

[VersionBadge]: https://badgen.net/github/release/poingstudios/godot-admob-plugin/latest
[StarsBadge]: https://badgen.net/github/stars/poingstudios/godot-admob-plugin
[DiscordBadge]: https://badgen.net/badge/_/Discord/7289DA?label=&icon=discord
[LicenseBadge]: https://badgen.net/github/license/poingstudios/godot-admob-plugin?label=License
[DownloadsBadge]: https://badgen.net/github/assets-dl/poingstudios/godot-admob-plugin?label=Downloads&color=green
[AssetStoreBadge]: https://badgen.net/badge/Download/Asset%20Store/green
[AndroidBadge]: https://badgen.net/badge/_/Android/3DDC84?label=&icon=android
[iOSBadge]: https://badgen.net/badge/_/iOS/000000?label=&icon=apple
[GDScriptBadge]: https://badgen.net/badge/_/GDScript/478CBF?label=&icon=godotengine
[CSharpBadge]: https://badgen.net/badge/_/C%23/239120?label=&icon=csharp
[PatreonBadge]: https://badgen.net/badge/Support%20us%20on/Patreon/orange?icon=patreon
[KofiBadge]: https://badgen.net/badge/Buy%20us%20a/coffee/yellow?icon=kofi
[PaypalBadge]: https://badgen.net/badge/Donate/via%20Paypal/blue?icon=paypal
[DiscussionsBadge]: https://badgen.net/badge/_/Discussions/green?label=
[DiscordHelpBadge]: https://badgen.net/badge/_/Discord/7289DA?label=&icon=discord

[DocumentationLink]: https://poingstudios.github.io/godot-admob-plugin/latest/
[Releases]: https://github.com/poingstudios/godot-admob-plugin/releases
[Stargazers]: https://github.com/poingstudios/godot-admob-plugin/stargazers
[DiscordLink]: https://discord.com/invite/YEPvYjSSMk
[LicenseLink]: https://github.com/poingstudios/godot-admob-plugin/blob/master/LICENSE
[AssetStore]: https://store.godotengine.org/asset/poingstudios/admob/
[AndroidPlatform]: https://github.com/poingstudios/godot-admob-plugin/tree/master/platforms/android
[iOSPlatform]: https://github.com/poingstudios/godot-admob-plugin/tree/master/platforms/ios
[Examples]: #-examples
[PatreonLink]: https://patreon.com/poingstudios
[KofiLink]: https://ko-fi.com/poingstudios
[PaypalLink]: https://www.paypal.com/donate/?hosted_button_id=EBUVPEGF4BUR8
[DiscussionsLink]: https://github.com/poingstudios/godot-admob-plugin/discussions
