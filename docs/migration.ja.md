# SDK バージョンの移行

このページでは、現在および以前のバージョンの移行について説明します。

## v4 から v5 への移行

以下のサブセクションでは、Godot AdMob エディタープラグインのメジャーバージョン 4 と 5 の間の破壊的変更および動作の違いについて説明します。

### スマートバナーの削除

レガシーな `スマートバナー` フォーマットは Google によって非推奨となり、v5 でプラグインから完全に削除されました。

| 言語 | 削除されたプロパティ | 代替手段 |
| :--- | :--- | :--- |
| **GDScript** | `AdSize.SMART_BANNER` | [`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size()`](reference/classes/AdSize.md#adaptive-banners) |
| **C#** | `AdSize.SmartBanner` | [`AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize()`](reference/classes/AdSize.md#adaptive-banners) |

!!! danger "破壊的変更 (Breaking Change)"
    静的プロパティ `AdSize.SMART_BANNER`（GDScript）および `AdSize.SmartBanner`（C#）は完全に削除されました。スクリプトを更新してアダプティブサイズのメソッドを使用する必要があります。

#### 移行方法
代わりに**アンカー付きアダプティブバナー**を使用してください。これらは公式のモダンな代替手段であり、デバイスの幅と画面密度に基づいて最適な高さを動的に計算します。

!!! note "後方互換性のフォールバック"
    安全のため、Android と iOS の両方のネイティブプラグインが自動的なフォールバックを実装しています。古いシーンやレイアウトが引き続き幅 `-1` ・高さ `-1` のサイズを送信した場合、ネイティブブリッジがそれをインターセプトし、画面幅に一致する標準のアンカー付きアダプティブバナーサイズを返します。

=== "v4"

    === "GDScript"

        ```gdscript
        var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
        ```

=== "v5"

    === "GDScript"

        ```gdscript
        var ad_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)
        var ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
        ```

    === "C#"

        ```csharp
        var adSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        var adView = new AdView(unitId, adSize, AdPosition.Top);
        ```

### Gradle 依存関係の変更

ネイティブ Android プラグインは、新しい Next-Gen SDK を取り込むようになりました。

* **旧依存関係:** `com.google.android.gms:play-services-ads`
* **新依存関係:** `com.google.android.libraries.ads.mobile.sdk:ads-mobile-sdk`

!!! info "メディエーションの自動除外"
    メディエーションアダプターを使用する際（それらが推移的にレガシー SDK を取り込む可能性があります）、シンボルの重複や競合を防ぐため、Godot エクスポートプラグインは Android エクスポートの `build.gradle` を自動的に修正し、`play-services-ads` と `play-services-ads-lite` を除外します。エクスポート設定で手動で除外する必要はありません。
