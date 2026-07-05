# AdSize

`AdSize` 类表示横幅广告的尺寸（宽度和高度）。包含静态预设尺寸和获取基于方向的自适应横幅广告尺寸的静态方法。

## 预定义常量

以下静态属性提供标准横幅尺寸预设：

| 属性 (GDScript) | 属性 (C#) | 尺寸 (宽x高) | 描述 |
| :--- | :--- | :--- | :--- |
| `AdSize.FULL_WIDTH` | `AdSize.FullWidth` | `-1` | 请求广告填充全部可用宽度的常量（用于自适应横幅）。 |
| `AdSize.BANNER` | `AdSize.Banner` | 320x50 | 标准横幅（手机） |
| `AdSize.LARGE_BANNER` | `AdSize.LargeBanner` | 320x100 | 大横幅 |
| `AdSize.MEDIUM_RECTANGLE` | `AdSize.MediumRectangle` | 300x250 | IAB 中矩形 |
| `AdSize.FULL_BANNER` | `AdSize.FullBanner` | 468x60 | IAB 全横幅（平板） |
| `AdSize.LEADERBOARD` | `AdSize.Leaderboard` | 728x90 | IAB 排行榜（平板） |
| `AdSize.WIDE_SKYSCRAPER` | `AdSize.WideSkyscraper` | 160x600 | IAB 宽摩天大楼 |

---

## 构造函数

### `_init` / `AdSize`

使用给定的宽度和高度初始化自定义 `AdSize`。

=== "GDScript"
    ```gdscript
    func _init(width: int, height: int)
    ```

    **用法:**
    ```gdscript
    var custom_size := AdSize.new(300, 50)
    ```

=== "C#"
    ```csharp
    public AdSize(int width, int height)
    ```

    **用法:**
    ```csharp
    AdSize customSize = new AdSize(300, 50);
    ```

---

## 属性

### `width` / `Width`

广告尺寸的宽度。

=== "GDScript"
    ```gdscript
    var width: int
    ```

=== "C#"
    ```csharp
    public int Width { get; set; }
    ```

### `height` / `Height`

广告尺寸的高度。

=== "GDScript"
    ```gdscript
    var height: int
    ```

=== "C#"
    ```csharp
    public int Height { get; set; }
    ```

### `SMART_BANNER` / `SmartBanner`

返回与设备宽度匹配的智能横幅尺寸。

=== "GDScript"
    ```gdscript
    static var SMART_BANNER: AdSize # read-only
    ```

=== "C#"
    ```csharp
    public static AdSize SmartBanner { get; }
    ```

---

## 静态方法

### 自适应横幅

自适应横幅允许您指定广告宽度并自动选择最佳尺寸。

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
