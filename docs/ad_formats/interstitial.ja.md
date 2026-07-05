# インタースティシャル広告

インタースティシャル広告は、アプリのインターフェースを覆い、ユーザーによって閉じられるまで表示される全画面広告です。ゲームのステージ間やタスクの完了直後など、アプリの実行中の自然な一時停止のタイミングで戦略的に配置すると最も効果的です。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/interstitial)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/interstitial)

## 前提条件
- [はじめに](../index.ja.md) ガイドを完了していること

## 常にテスト広告でテストする

Godot アプリを開発およびテストする際は、本番用の広告ではなくテスト広告を使用することが極めて重要です。そうしないと、AdMob アカウントがサスペンドされる可能性があります。

テスト広告を読み込む最も簡単な方法は、Android および iOS のインタースティシャル専用テスト広告ユニット ID を使用することです。

=== "Android"
    ```
    ca-app-pub-3940256099942544/1033173712
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/4411468910
    ```

この特定の広告ユニット ID は、すべてのリクエストに対してテスト広告を返すように特別に設定されています。コーディング、テスト、デバッグ中に安全に使用できます。ただし、アプリをリリースする準備ができたら、このテスト用広告ユニット ID をご自身の広告ユニット ID に置き換えてください。

モバイル広告 SDK のテスト広告の仕組みについての詳細は、[テスト広告](../enable_test_ads.ja.md)のドキュメントを参照してください。


## インタースティシャル広告の例

以下のコード例は、インタースティシャル広告の使用方法を示しています。この例では、インタースティシャル広告のインスタンスを作成し、`AdRequest` を使用して広告をロードし、さまざまなライフサイクルイベントを処理して機能を強化します。


### 広告のロード
インタースティシャル広告をロードするには、[`InterstitialAdLoader`](../reference/classes/InterstitialAdLoader.md) クラスを使用します。ロードされた [`InterstitialAd`](../reference/classes/InterstitialAd.md) またはエラーを受け取るために、[`InterstitialAdLoadCallback`](../reference/listeners/InterstitialAdLoadCallback.md) を渡します。他の広告フォーマットのロードコールバックと同様に、[`InterstitialAdLoadCallback`](../reference/listeners/InterstitialAdLoadCallback.md) は詳細なエラー情報を提供するために [`LoadAdError`](../reference/classes/LoadAdError.md) を利用します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    
    func _ready() -> void:
        # 初期化はアプリの起動時に一度だけ行うのが理想的です。
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	# メモリの解放
    	if _interstitial_ad:
    		# Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
    		_interstitial_ad.destroy()
    		_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/1033173712"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/4411468910"
    
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    
    	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
    
        public override void _Ready()
        {
            // 初期化はアプリの起動時に一度だけ行うのが理想的です。
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            // メモリの解放
            if (_interstitialAd != null)
            {
                // Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
                _interstitialAd.Destroy();
                _interstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/1033173712";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/4411468910";
    
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                }
            };
    
            new InterstitialAdLoader().Load(unitId, new AdRequest(), interstitialAdLoadCallback);
        }
    }
    ```

### FullScreenContentCallback の設定
[`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) は、[`InterstitialAd`](../reference/classes/InterstitialAd.md) の表示に関連するイベントを管理します。[`InterstitialAd`](../reference/classes/InterstitialAd.md) を表示する前に、必ずコールバックを設定してください。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _interstitial_ad : InterstitialAd
    var _full_screen_content_callback := FullScreenContentCallback.new()
    
    func _ready() -> void:
    	#...
    	_full_screen_content_callback.on_ad_clicked = func() -> void:
    		print("on_ad_clicked")
    	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
    		print("on_ad_dismissed_full_screen_content")
    	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
    		print("on_ad_failed_to_show_full_screen_content")
    	_full_screen_content_callback.on_ad_impression = func() -> void:
    		print("on_ad_impression")
    	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
    		print("on_ad_showed_full_screen_content")
    
    func _on_load_pressed():
    	#...
    	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    
    	#...
    
    	interstitial_ad_load_callback.on_ad_loaded = func(interstitial_ad : InterstitialAd) -> void:
    		print("interstitial ad loaded" + str(interstitial_ad._uid))
    		_interstitial_ad = interstitial_ad
    		_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class InterstitialAdExample : Node2D
    {
        private InterstitialAd _interstitialAd;
        private FullScreenContentCallback _fullScreenContentCallback;
    
        public override void _Ready()
        {
            //...
            _fullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdClicked = () => GD.Print("on_ad_clicked"),
                OnAdDismissedFullScreenContent = () => GD.Print("on_ad_dismissed_full_screen_content"),
                OnAdFailedToShowFullScreenContent = (AdError adError) => GD.Print("on_ad_failed_to_show_full_screen_content"),
                OnAdImpression = () => GD.Print("on_ad_impression"),
                OnAdShowedFullScreenContent = () => GD.Print("on_ad_showed_full_screen_content")
            };
        }
    
        private void OnLoadPressed()
        {
            //...
            var interstitialAdLoadCallback = new InterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (InterstitialAd interstitialAd) => 
                {
                    GD.Print("interstitial ad loaded");
                    _interstitialAd = interstitialAd;
                    _interstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### 広告の表示

インタースティシャル広告は、アプリの進行における自然な一時停止のタイミングで表示するのが理想的です。ゲームのステージ間やユーザーがタスクを完了した直後などがその例です。インタースティシャル広告を表示するには、`show()` 関数を使用します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3"
    func _on_show_pressed():
    	if _interstitial_ad:
    		_interstitial_ad.show()
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="4"
    private void OnShowPressed()
    {
        if (_interstitialAd != null)
            _interstitialAd.Show();
    }
    ```

### メモリのクリーンアップ

`InterstitialAd` の処理が完了したら、その参照を破棄する前に必ず `destroy()` メソッドを呼び出してください。

=== "GDScript"

    ```gdscript 
    if _interstitial_ad:
    	_interstitial_ad.destroy()
    	_interstitial_ad = null
    ```

=== "C#"

    ```csharp
    if (_interstitialAd != null)
    {
        _interstitialAd.Destroy();
        _interstitialAd = null;
    }
    ```

これにより、オブジェクトが使用されなくなったことがプラグインに通知され、占有されていたメモリが解放されます。このメソッドを呼び出さないと、メモリリークが発生します。

## インタースティシャル広告のベストプラクティス

1. **適合性の検討**:
    - インタースティシャル広告がご自身のアプリに適しているかどうかを慎重に評価してください。
    - インタースティシャル広告は、ゲームのレベルアップやタスクの完了など、アプリ内の自然な遷移ポイントがある場合に最適です。ユーザーのゲーム体験を阻害しない最適なタイミングを選択してください。

2. **アプリのアクティビティの一時停止**:
    - インタースティシャル広告を表示するときは、広告がリソースを効果的に使用できるように、アプリ内の特定のアクティビティ（オーディオの再生など）を一時停止してください。

3. **ロード時間の最適化**:
    - 広告を表示する前に、事前に `InterstitialAdLoader.new().load()` を呼び出してインタースティシャル広告をロードしておいてください。これにより、表示するタイミングで完全にロードされた広告が手元にある状態を作ることができます。

4. **広告の出しすぎに注意する**:
    - ユーザーに過剰な量のインタースティシャル広告を表示することは避けてください。
    - 頻繁に広告を表示すると、ユーザー体験が低下し、クリック率が低下する可能性があります。ユーザーがストレスなくアプリを楽しめるよう、バランスを保ってください。

広告の実装は、アプリのユーザー体験を阻害するものではなく、向上させるものであるべきです。

## その他のリソース

### サンプル
- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：すべての広告フォーマットの使い方の最小限の実装例。
