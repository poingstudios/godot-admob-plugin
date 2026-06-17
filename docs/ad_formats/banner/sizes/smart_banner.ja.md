# スマートバナー ⚠️ (非推奨)

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/banner/smart)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/banner/smart)

!!! note

    代わりに新しい [アダプティブバナー](anchored_adaptive.ja.md) を試してください。

スマートバナーを使用するには、`AdView` を作成する際に、広告サイズのプロパティとして `AdSize.SMART_BANNER`（C# では `AdSize.SmartBanner`）を使用します。例：

=== "GDScript"

    ```gdscript linenums="1"
    # 画面上部にスマートバナーを作成します。
    var ad_view := AdView.new(unit_id, AdSize.SMART_BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    // 画面上部にスマートバナーを作成します。
    var adView = new AdView(unitId, AdSize.SmartBanner, AdPosition.Top);
    ```
