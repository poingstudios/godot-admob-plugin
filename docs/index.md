# Get Started

Integrating the AdMob plugin into your Godot project for **Godot 3** allows you to easily display Google Mobile Ads on Android and iOS devices.

---

## Prerequisites

- **Godot Engine 3.x Mono/Standard Edition** (v3.3 or higher).
- **For Android Export**:
  - Godot Android Build Template enabled.
  - Target Android SDK version configured.
- **For iOS Export**:
  - macOS machine with Xcode installed.
  - Active Apple Developer account.
- **Recommended**: An active [AdMob Account](https://admob.google.com/) with registered Android/iOS apps.

---

## Download & Import the Plugin

1. Download the latest release from the [GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases) page.
2. Extract the archive and copy the `addons/admob` folder into your Godot project's `res://addons/` directory.
3. Open Godot Editor, navigate to **Project -> Project Settings -> Plugins** and toggle the status of the **AdMob** plugin to **Enabled**.

Once enabled, the plugin automatically registers the `MobileAds` autoload singleton into your project.

---

## Download Platform Templates

Open the AdMob Manager inside the Godot editor (**Project -> Tools -> AdMob Manager** or click the **AdMob** panel tab).

* **Android**: Select **Download Android Template** to fetch and extract the `.aar` and `.gdap` files into your `res://android/plugins/` folder.
* **iOS**: Select **Download iOS Template** to fetch and extract the `.gdip` and library files into your `res://ios/plugins/` folder.

---

## Configuration

In the AdMob Editor panel:
1. Set up your **AdMob App IDs** (e.g. `ca-app-pub-3940256099942544~1458002511`).
2. Input your **Ad Unit IDs** for the formats you wish to use (Banner, Interstitial, Rewarded, Rewarded Interstitial).
3. Toggle whether ads are enabled, and configure default behaviors like Banner position and size.

---

## Initialize the SDK

Prior to loading ads, the Google Mobile Ads SDK must be initialized. If **Is Enabled** is active in your configuration, the plugin will initialize itself automatically on startup.

If you prefer to initialize manually, or want to monitor completion, connect to the `initialization_complete` signal:

=== "GDScript"

    ```gdscript
    func _ready() -> void:
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

## Select an Ad Format

Now that the SDK is initialized, you can select and implement the ad formats that best fit your game's layout:

* [Banner Ads](ad_formats/banner.md)
* [Interstitial Ads](ad_formats/interstitial.md)
* [Rewarded Video Ads](ad_formats/rewarded.md)
* [Rewarded Interstitial Ads](ad_formats/rewarded_interstitial.md)
