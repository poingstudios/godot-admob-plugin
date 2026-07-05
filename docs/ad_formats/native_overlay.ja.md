# ネイティブオーバーレイ広告 (Native Overlay Ads)

ネイティブオーバーレイ広告は、アプリのコンテンツの上に[ネイティブ広告](https://support.google.com/admob/answer/6329630)を表示できる特別な広告フォーマットです。UI を自分で構築する必要がある標準のネイティブ広告とは異なり、ネイティブオーバーレイ広告は**テンプレート**を使用して、他のプラットフォームと同様の一貫した統合しやすい体験を提供します。

!!! note

    このフォーマットは、手動での複雑な UI レイアウトを行うことなく、アプリのルック＆フィールに合わせた広告を表示したいゲームやアプリに最適です。

## 前提条件

進める前に、以下を完了してください。

- [はじめに](../index.ja.md) ガイドの完了。

## 常にテスト広告でテストする

以下の表には、テスト広告をリクエストするために使用できる広告ユニット ID が含まれています。これらは、すべてのリクエストに対して本番用の広告ではなくテスト広告を返すように特別に設定されているため、安全に使用できます。

ただし、AdMob のウェブ管理画面でアプリを登録し、アプリ内で使用する独自の広告ユニット ID を作成した後は、開発中に明示的に[デバイスをテストデバイスとして設定](../enable_test_ads.ja.md)してください。

=== "Android"

    ```
    ca-app-pub-3940256099942544/2247696110
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/3986624511
    ```

## 実装

ネイティブオーバーレイ広告を統合するための主なステップは次のとおりです。

1. ネイティブ広告のロード
2. テンプレートスタイルの定義
3. テンプレートのレンダリング
4. 広告イベントの監視
5. 広告の表示/非表示または破棄

### ネイティブ広告のロード

ネイティブ広告のロードは、[`NativeOverlayAd`](../reference/classes/NativeOverlayAd.md) クラスの `load()` メソッドを使用して行われます。広告ユニット ID、[`AdRequest`](../reference/classes/AdRequest.md)、[`NativeAdOptions`](../reference/classes/NativeAdOptions.md)、および完了コールバックを提供する必要があります。

=== "GDScript"

    ```gdscript linenums="1"
    var _native_overlay_ad: NativeOverlayAd
    
    # これらの広告ユニットは、常にテスト広告を配信するように設定されています。
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/2247696110"
            return "ca-app-pub-3940256099942544/3986624511"
    
    func _load_native_ad() -> void:
        var ad_request := AdRequest.new()
        var options := NativeAdOptions.new()
        
        # オプション: オプションの設定
        options.ad_choices_placement = AdChoicesPlacement.Values.TOP_RIGHT
        options.media_aspect_ratio = NativeMediaAspectRatio.Values.ANY
    
        NativeOverlayAd.load(_ad_unit_id, ad_request, options, _on_ad_load_finished)
    
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            print("Native ad failed to load: ", error.message)
            return
        
        print("Native ad loaded successfully")
        _native_overlay_ad = ad
        _render_native_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    private NativeOverlayAd _nativeOverlayAd;
    
    // これらの広告ユニットは、常にテスト広告を配信するように設定されています。
    private string _adUnitId => OS.GetName() == "Android" 
        ? "ca-app-pub-3940256099942544/2247696110" 
        : "ca-app-pub-3940256099942544/3986624511";
    
    private void LoadNativeAd()
    {
        var adRequest = new AdRequest();
        var options = new NativeAdOptions();
    
        // オプション: オプションの設定
        options.AdChoicesPlacement = AdChoicesPlacement.Values.TopRight;
        options.MediaAspectRatio = NativeMediaAspectRatio.Values.Any;
    
        NativeOverlayAd.Load(_adUnitId, adRequest, options, OnAdLoadFinished);
    }
    
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null)
        {
            GD.Print("Native ad failed to load: " + error.Message);
            return;
        }
    
        GD.Print("Native ad loaded successfully");
        _nativeOverlayAd = ad;
        RenderNativeAd();
    }
    ```

### テンプレートスタイルの定義

[`NativeTemplateStyle`](../reference/classes/NativeTemplateStyle.md) と [`NativeTemplateTextStyle`](../reference/classes/NativeTemplateTextStyle.md) を使用して、広告の見た目をカスタマイズできます。主に `SMALL` と `MEDIUM` の 2 つのテンプレートを利用できます。

=== "GDScript"

    ```gdscript linenums="1"
    func _render_native_ad() -> void:
        var style := NativeTemplateStyle.new()
        
        # テンプレートを選択: SMALL または MEDIUM
        style.template_id = NativeTemplateStyle.MEDIUM
        
        # 背景色をカスタマイズ
        style.main_background_color = Color.WHITE
        
        # Call To Action (CTA) ボタンをカスタマイズ
        var cta_style := NativeTemplateTextStyle.new()
        cta_style.background_color = Color.DODGER_BLUE
        cta_style.text_color = Color.WHITE
        cta_style.font_size = 15.0
        cta_style.style = NativeTemplateFontStyle.Values.BOLD
        
        style.call_to_action_text = cta_style
        
        # 特定の位置にテンプレートをレンダリング
        _native_overlay_ad.render_template(style, AdPosition.BOTTOM)
    ```

=== "C#"

    ```csharp linenums="1"
    private void RenderNativeAd()
    {
        var style = new NativeTemplateStyle();
    
        // テンプレートを選択: Small または Medium
        style.TemplateId = NativeTemplateStyle.Medium;
    
        // 背景色をカスタマイズ
        style.MainBackgroundColor = Colors.White;
    
        // Call To Action (CTA) ボタンをカスタマイズ
        var ctaStyle = new NativeTemplateTextStyle();
        ctaStyle.BackgroundColor = Colors.DodgerBlue;
        ctaStyle.TextColor = Colors.White;
        ctaStyle.FontSize = 15.0f;
        ctaStyle.Style = NativeTemplateFontStyle.Bold;
    
        style.CallToActionText = ctaStyle;
    
        // 特定の位置にテンプレートをレンダリング
        _nativeOverlayAd.RenderTemplate(style, AdPosition.Bottom);
    }
    ```

### 広告の位置 (Ad Positions)

[`AdPosition`](../reference/classes/AdPosition.md) の事前定義された配置を使用して、事前定義されたいくつかの位置、またはカスタムの XY 座標に広告を配置できます。

- `AdPosition.TOP`
- `AdPosition.BOTTOM`
- `AdPosition.CENTER`
- `AdPosition.TOP_LEFT` / `AdPosition.TOP_RIGHT`
- `AdPosition.BOTTOM_LEFT` / `AdPosition.BOTTOM_RIGHT`
- `AdPosition.custom(x, y)`

### 広告イベントの監視

ユーザーのインタラクションを処理するには、[`NativeOverlayAd`](../reference/classes/NativeOverlayAd.md) インスタンスの `ad_listener` プロパティを使用します。これは [`AdListener`](../reference/listeners/AdListener.md) を受け入れます。

=== "GDScript"

    ```gdscript linenums="1"
    func _on_ad_load_finished(ad: NativeOverlayAd, error: LoadAdError) -> void:
        # ... ロードチェック ...
        
        ad.ad_listener.on_ad_clicked = func(): print("Ad Clicked")
        ad.ad_listener.on_ad_impression = func(): print("Ad Impression")
        ad.ad_listener.on_ad_opened = func(): print("Ad Opened")
        ad.ad_listener.on_ad_closed = func(): print("Ad Closed")
    ```

=== "C#"

    ```csharp linenums="1"
    private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
    {
        // ... ロードチェック ...
    
        ad.AdListener.OnAdClicked = () => GD.Print("Ad Clicked");
        ad.AdListener.OnAdImpression = () => GD.Print("Ad Impression");
        ad.AdListener.OnAdOpened = () => GD.Print("Ad Opened");
        ad.AdListener.OnAdClosed = () => GD.Print("Ad Closed");
    }
    ```

### 表示/非表示と破棄

レンダリングされた後、広告の表示/非表示をコントロールしたり、リソースを解放するために完全に破棄したりできます。

=== "GDScript"

    ```gdscript linenums="1"
    # 広告を非表示にする場合
    _native_overlay_ad.hide()
    
    # 再び表示する場合
    _native_overlay_ad.show()
    
    # 破棄する場合（使用終了時に必須）
    _native_overlay_ad.destroy()
    _native_overlay_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    // 広告を非表示にする場合
    _nativeOverlayAd.Hide();
    
    // 再び表示する場合
    _nativeOverlayAd.Show();
    
    // 破棄する場合（使用終了時に必須）
    _nativeOverlayAd.Destroy();
    _nativeOverlayAd = null;
    ```

## ベストプラクティス

- **破棄**: ネイティブプラットフォームでのメモリリークを防ぐため、広告が不要になったら必ず `destroy()` を呼び出してください。
- **バックグラウンドロード**: 広告をバックグラウンドでロードしておき、表示する準備ができたときにのみ `render_template()` を呼び出すことができます。
- **テンプレートの選択**: リストや狭いスペースには `SMALL` テンプレートを使用し、レベル遷移画面などの目立つ配置には `MEDIUM` を使用します。

## その他のリソース

- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): 完全な実装については、`Native` タブを参照してください。
