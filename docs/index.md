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

After enabling the plugin, the **AdMob** tab will appear in the main workspace tabs (next to **2D**, **3D**, **AssetLib**, etc.) at the top of the editor. Open it to access the AdMob Manager.

* **Android**: Select **Download Android Template**. The plugin will automatically download and extract the required template files (`.aar` and `.gdap`) directly into your `res://android/plugins/` folder (no manual zip extraction required).
* **iOS**: Select **Download iOS Template**. The plugin will automatically download and extract the required template files (`.gdip` and library files) directly into your `res://ios/plugins/` folder (no manual zip extraction required).

---

## Configuration

Click the **AdMob** tab (next to **AssetLib** at the top of the editor) to open the configuration panel. Configure the following:

| Option | Description |
|--------|-------------|
| **App ID** | Your AdMob App ID (e.g. `ca-app-pub-3940256099942544~1458002511`). |
| **Ad Unit IDs** | IDs for each ad format you plan to use (Banner, Interstitial, Rewarded, Rewarded Interstitial). |
| **Is Enabled** | Toggle to enable/disable ads globally. |
| **Banner Position** | Choose where the banner appears (Top, Bottom, Custom). |
| **Banner Size** | Select banner size (Banner, Large Banner, Medium Rectangle, etc.). |

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

## Select an ad format

The Google Mobile Ads SDK is now successfully imported, and you are prepared to integrate an ad into your app. AdMob provides a variety of ad formats, allowing you to select the one that aligns best with your app's user experience.

### Banner
<div class="image-text-container" markdown="1">

![banner](assets/ad_formats/banner.png)

Banner ads are rectangular advertisements, consisting of either images or text, that are integrated into an app's layout. These ads remain on the screen while users engage with the app and can automatically refresh after a designated time interval. If you're new to mobile advertising, banner ads provide an excellent starting point for your ad implementation journey.

</div>

[Implement banner ads](ad_formats/banner.md){ .md-button .md-button--primary }

### Interstitial
<div class="image-text-container" markdown="1">

![interstitial](assets/ad_formats/interstitial.png)

Interstitial ads are expansive, full-screen advertisements that overlay an app's interface and persist until they are closed by the user. They are most effective when strategically placed during natural pauses in the app's execution, such as between levels of a game or immediately after the completion of a task.

</div>

[Implement interstitial ads](ad_formats/interstitial.md){ .md-button .md-button--primary }

### Rewarded
<div class="image-text-container" markdown="1">

![rewarded](assets/ad_formats/rewarded.png)

Rewarded video ads are immersive, full-screen video advertisements that provide users with the choice to watch them entirely. In return for their time and attention, users receive in-app rewards or benefits.

</div>

[Implement rewarded ads](ad_formats/rewarded.md){ .md-button .md-button--primary }

### Rewarded Interstitial
<div class="image-text-container" markdown="1">

![rewarded_interstitial](assets/ad_formats/rewarded_interstitial.png)

A Rewarded Interstitial is a specific form of incentivized ad format that allows you to provide rewards in exchange for ads that appear automatically during natural app transitions. Unlike regular rewarded ads, users are not obligated to actively opt in to view a Rewarded Interstitial; they are seamlessly integrated into the app experience.

</div>

[Implement rewarded interstitial ads](ad_formats/rewarded_interstitial.md){ .md-button .md-button--primary }

<style>
  .image-text-container {
    display: flex;
    align-items: center;
  }
  .image-text-container img {
    margin-right: 20px;
    max-width: 130px;
    height: auto;
  }
</style>
