<div align="center">
  <h1>
    <img src="https://i.imgur.com/T3Beai0.png" width="40" style="vertical-align: middle;"> Godot AdMob Plugin (Godot 3)
  </h1>

  [![VersionBadge]][Releases] [![StarsBadge]][Stargazers] [![DiscordBadge]][DiscordLink] [![LicenseBadge]][LicenseLink] <br>
  [![DownloadsBadge]][Releases] [![AssetStoreBadge]][AssetStore] <br>
  [![AndroidBadge]][AndroidPlatform] [![iOSBadge]][iOSPlatform] [![GDScriptBadge]][DocumentationLink] [![CSharpBadge]][DocumentationLink]

  **The complete solution for AdMob integration in Godot 3 using GDScript or C#.**  
  Supports Android and iOS natively.

  ![Plugin Usage](docs/assets/usage.webp)

  [🎬 Watch Video Tutorial](https://www.youtube.com/watch?v=ZnlH3INcAGs) • [📖 Read Documentation][DocumentationLink]

  ---

  [📦 Installation](#-installation) • [📋 Examples](#-examples) • [🙏 Support](#-support)
</div>

## 📦 Installation

### Godot Asset Library (Recommended)
1. Open the AssetLib tab inside your Godot 3 project.
2. Search for `AdMob` by `Poing Studios`.
3. Download and Install the plugin.
4. Enable the plugin under **Project -> Project Settings -> Plugins**.
5. Use the AdMob Editor panel (**Project -> Tools -> AdMob Manager**) to download the iOS/Android platform templates.

---

## 📋 Examples

### 🏁 Initialize AdMob

Prior to loading ads, you must initialize the SDK.

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        # Connect to initialization signal
        MobileAds.connect("initialization_complete", self, "_on_AdMob_initialization_complete")
        MobileAds.initialize()

    func _on_AdMob_initialization_complete(status: int, adapter_name: String) -> void:
        print("AdMob Initialized: ", status)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("initialization_complete", this, nameof(_on_AdMob_initialization_complete));
        MobileAds.Call("initialize");
    }

    private void _on_AdMob_initialization_complete(int status, string adapterName)
    {
        GD.Print("AdMob Initialized: " + status);
    }
    ```

---

### 📱 Banner Ads

=== "GDScript"

    ```gdscript
    func load_and_show_banner() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.load_banner()

    func _on_banner_loaded() -> void:
        MobileAds.show_banner()
    ```

=== "C#"

    ```csharp
    public void LoadAndShowBanner()
    {
        MobileAds.Connect("banner_loaded", this, nameof(_on_banner_loaded));
        MobileAds.Call("load_banner");
    }

    private void _on_banner_loaded()
    {
        MobileAds.Call("show_banner");
    }
    ```

---

### 🎬 Interstitial Ads

=== "GDScript"

    ```gdscript
    func show_interstitial_ad() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        MobileAds.show_interstitial()
    ```

=== "C#"

    ```csharp
    public void ShowInterstitialAd()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        MobileAds.Call("show_interstitial");
    }
    ```

---

### 🎁 Rewarded Video Ads

=== "GDScript"

    ```gdscript
    func show_rewarded_ad() -> void:
        MobileAds.connect("rewarded_ad_loaded", self, "_on_rewarded_ad_loaded")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        MobileAds.load_rewarded()

    func _on_rewarded_ad_loaded() -> void:
        MobileAds.show_rewarded()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("Rewarded! Type: ", currency, ", Amount: ", amount)
    ```

=== "C#"

    ```csharp
    public void ShowRewardedAd()
    {
        MobileAds.Connect("rewarded_ad_loaded", this, nameof(_on_rewarded_ad_loaded));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        MobileAds.Call("load_rewarded");
    }

    private void _on_rewarded_ad_loaded()
    {
        MobileAds.Call("show_rewarded");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("Rewarded! Type: " + currency + ", Amount: " + amount);
    }
    ```

For the complete list of methods and signals, check out the [API Reference][DocumentationLink].

---

## 🙏 Support

If you find our work valuable and would like to support us, consider contributing via these platforms:

[![PatreonBadge]][PatreonLink]
[![KofiBadge]][KofiLink]
[![PaypalBadge]][PaypalLink]

[VersionBadge]: https://badgen.net/github/release/poingstudios/godot-admob-plugin/stable?label=Version
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

[DocumentationLink]: https://poingstudios.github.io/godot-admob-plugin/v1/
[Releases]: https://github.com/poingstudios/godot-admob-plugin/releases
[Stargazers]: https://github.com/poingstudios/godot-admob-plugin/stargazers
[DiscordLink]: https://discord.com/invite/YEPvYjSSMk
[LicenseLink]: https://github.com/poingstudios/godot-admob-plugin/blob/v1/LICENSE
[AssetStore]: https://store.godotengine.org/asset/poingstudios/admob/
[AndroidPlatform]: https://github.com/poingstudios/godot-admob-plugin/tree/v1/platforms/android
[iOSPlatform]: https://github.com/poingstudios/godot-admob-plugin/tree/v1/platforms/ios
[PatreonLink]: https://patreon.com/poingstudios
[KofiLink]: https://ko-fi.com/poingstudios
[PaypalLink]: https://www.paypal.com/donate/?hosted_button_id=EBUVPEGF4BUR8
