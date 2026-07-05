# AdSize

The `AdSize` class represents the dimensions (width and height) of a banner ad. It contains static preset sizes and static methods to fetch orientation-dependent adaptive banner sizes.

## Predefined Constants

The following static properties provide standard banner size presets:

| Property (GDScript) | Property (C#) | Dimensions (WxH) | Description |
| :--- | :--- | :--- | :--- |
| `AdSize.BANNER` | `AdSize.Banner` | 320x50 | Standard Banner (Phones) |
| `AdSize.LARGE_BANNER` | `AdSize.LargeBanner` | 320x100 | Large Banner |
| `AdSize.MEDIUM_RECTANGLE` | `AdSize.MediumRectangle` | 300x250 | IAB Medium Rectangle |
| `AdSize.FULL_BANNER` | `AdSize.FullBanner` | 468x60 | IAB Full Banner (Tablets) |
| `AdSize.LEADERBOARD` | `AdSize.Leaderboard` | 728x90 | IAB Leaderboard (Tablets) |
| `AdSize.WIDE_SKYSCRAPER` | `AdSize.WideSkyscraper` | 160x600 | IAB Wide Skyscraper |

---

## Constructors

### `_init` / `AdSize`

Initializes a custom `AdSize` with the given width and height.

=== "GDScript"
    ```gdscript
    func _init(width: int, height: int)
    ```

    **Usage:**
    ```gdscript
    var custom_size := AdSize.new(300, 50)
    ```

=== "C#"
    ```csharp
    public AdSize(int width, int height)
    ```

    **Usage:**
    ```csharp
    AdSize customSize = new AdSize(300, 50);
    ```

---

## Properties

### `width` / `Width`

The width of the ad size.

=== "GDScript"
    ```gdscript
    var width: int
    ```

=== "C#"
    ```csharp
    public int Width { get; set; }
    ```

### `height` / `Height`

The height of the ad size.

=== "GDScript"
    ```gdscript
    var height: int
    ```

=== "C#"
    ```csharp
    public int Height { get; set; }
    ```

### `SMART_BANNER` / `SmartBanner`

Returns the smart banner size matching the device's width.

=== "GDScript"
    ```gdscript
    static var SMART_BANNER: AdSize # read-only
    ```

=== "C#"
    ```csharp
    public static AdSize SmartBanner { get; }
    ```

---

## Static Methods

### Adaptive Banners

Adaptive banners let you specify an ad width and automatically select the optimal size.

#### GDScript
```gdscript
static func get_current_orientation_anchored_adaptive_banner_ad_size(width: int) -> AdSize
static func get_portrait_anchored_adaptive_banner_ad_size(width: int) -> AdSize
static func get_landscape_anchored_adaptive_banner_ad_size(width: int) -> AdSize
```

#### C#
```csharp
public static AdSize GetCurrentOrientationAnchoredAdaptiveBannerAdSize(int width)
public static AdSize GetPortraitAnchoredAdaptiveBannerAdSize(int width)
public static AdSize GetLandscapeAnchoredAdaptiveBannerAdSize(int width)
```
