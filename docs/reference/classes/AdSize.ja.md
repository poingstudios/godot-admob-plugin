# AdSize

`AdSize` クラスは、バナー広告の寸法（幅と高さ）を表します。標準的なプリセットサイズと、向きに応じたアダプティブバナーサイズを取得する静的メソッドを含みます。

## 定義済み定数

以下の静的プロパティは、標準的なバナーサイズのプリセットを提供します：

| プロパティ (GDScript) | プロパティ (C#) | 寸法 (WxH) | 説明 |
| :--- | :--- | :--- | :--- |
| `AdSize.FULL_WIDTH` | `AdSize.FullWidth` | `-1` | 利用可能な全幅を埋める広告をリクエストする定数（アダプティブバナーで使用）。 |
| `AdSize.BANNER` | `AdSize.Banner` | 320x50 | 標準バナー（スマートフォン） |
| `AdSize.LARGE_BANNER` | `AdSize.LargeBanner` | 320x100 | 大バナー |
| `AdSize.MEDIUM_RECTANGLE` | `AdSize.MediumRectangle` | 300x250 | IAB 中矩形 |
| `AdSize.FULL_BANNER` | `AdSize.FullBanner` | 468x60 | IAB フルバナー（タブレット） |
| `AdSize.LEADERBOARD` | `AdSize.Leaderboard` | 728x90 | IAB リーダーボード（タブレット） |
| `AdSize.WIDE_SKYSCRAPER` | `AdSize.WideSkyscraper` | 160x600 | IAB ワイドスカイスクレイパー |

---

## コンストラクタ

### `_init` / `AdSize`

指定された幅と高さでカスタム `AdSize` を初期化します。

=== "GDScript"
    ```gdscript
    func _init(width: int, height: int)
    ```

    **使用法:**
    ```gdscript
    var custom_size := AdSize.new(300, 50)
    ```

=== "C#"
    ```csharp
    public AdSize(int width, int height)
    ```

    **使用法:**
    ```csharp
    AdSize customSize = new AdSize(300, 50);
    ```

---

## プロパティ

### `width` / `Width`

広告サイズの幅。

=== "GDScript"
    ```gdscript
    var width: int
    ```

=== "C#"
    ```csharp
    public int Width { get; set; }
    ```

### `height` / `Height`

広告サイズの高さ。

=== "GDScript"
    ```gdscript
    var height: int
    ```

=== "C#"
    ```csharp
    public int Height { get; set; }
    ```

### `SMART_BANNER` / `SmartBanner`

デバイスの幅に一致するスマートバナーサイズを返します。

=== "GDScript"
    ```gdscript
    static var SMART_BANNER: AdSize # read-only
    ```

=== "C#"
    ```csharp
    public static AdSize SmartBanner { get; }
    ```

---

## 静的メソッド

### アダプティブバナー

アダプティブバナーは、広告の幅を指定すると最適なサイズが自動的に選択されます。

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
