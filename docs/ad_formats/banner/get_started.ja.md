# はじめに

バナー広告は、画像やテキストで構成される長方形の広告であり、アプリのレイアウトに統合されます。これらの広告はユーザーがアプリを操作している間も画面上に残り、指定した時間間隔で自動的に更新されます。モバイル広告を初めて利用する場合は、バナー広告から始めるのが最適です。

このガイドでは、AdMob のバナー広告を Godot アプリにシームレスに統合する方法を説明します。コードスニペットと詳細な手順に加えて、適切なバナーサイズに関するガイダンスを提供し、詳細なサポートのための追加リソースを紹介します。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/banner)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/banner)

## 前提条件
- [はじめに](../../index.ja.md) ガイドを完了していること

## 常にテスト広告でテストする

Godot アプリを開発およびテストする際は、本番用の広告ではなくテスト広告を使用することが極めて重要です。そうしないと、AdMob アカウントがサスペンドされる可能性があります。

テスト広告を読み込む最も簡単な方法は、Android および iOS のバナー専用テスト広告ユニット ID を使用することです。

=== "Android"
    ```
    ca-app-pub-3940256099942544/6300978111
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/2934735716
    ```

この特定の広告ユニット ID は、すべてのリクエストに対してテスト広告を返すように特別に設定されています。コーディング、テスト、デバッグ中に安全に使用できます。ただし、アプリをリリースする準備ができたら、このテスト用広告ユニット ID をご自身の広告ユニット ID に置き換えてください。

モバイル広告 SDK のテスト広告の仕組みについての詳細は、[テスト広告](../../enable_test_ads.ja.md)のドキュメントを参照してください。

## AdView の例

以下のコード例は、`AdView` の使用方法を示しています。この例では、`AdView` のインスタンスを作成し、`AdRequest` を使用して広告をロードし、さまざまなライフサイクルイベントを処理して機能を強化します。

### AdView (バナー) の作成
バナー広告を使用するための最初のステップは、ノードにアタッチされた GDScript または C# スクリプト内で `AdView` のインスタンスを作成することです。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="20"
    extends Node2D
    
    var _ad_view : AdView
    
    func _ready():
    	# 初期化はアプリの起動時に一度だけ行うのが理想的です。
    	MobileAds.initialize()
    
    func _create_ad_view() -> void:
    	# メモリの解放
    	if _ad_view:
    		destroy_ad_view()
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/2934735716"
    
    	_ad_view = AdView.new(unit_id, AdSize.BANNER, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="28"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class BannerAd : Node2D
    {
        private AdView _adView;
    
        public override void _Ready()
        {
            // 初期化はアプリの起動時に一度だけ行うのが理想的です。
            MobileAds.Initialize();
        }
    
        private void CreateAdView()
        {
            // メモリの解放
            if (_adView != null)
                DestroyAdView();
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/2934735716";
    
            _adView = new AdView(unitId, AdSize.Banner, AdPosition.Top);
        }
    }
    ```

Godot の `AdView` のコンストラクタには、以下のパラメータがあります。

- `unit_id`: `AdView` が広告を読み込むための AdMob 広告ユニット ID。
- `AdSize`: 使用する AdMob 広告のサイズ（詳細は [AdView のサイズ](#adview-sizes) を参照）。
- `AdPosition`: バナー広告を配置する位置。`AdPosition`（GDScript）または `AdPosition`（C#）クラスは、有効な広告位置の静的インスタンス（例: `AdPosition.TOP`）を公開しています。

プラットフォームに応じて異なる広告ユニットを使用するように注意してください。iOS で広告リクエストを行う場合は iOS の広告ユニットを、Android の場合は Android の広告ユニットを使用する必要があります。

#### (オプション) カスタム位置を指定した AdView の生成
`Top` や `Bottom` などの標準的なアンカーを使用する代わりに、特定の `x` および `y` 座標を定義して、バナーをカスタムの位置に配置できます。これらの座標は、画面上におけるバナービューの左上隅の位置を決定します。

=== "GDScript"

    ```gdscript linenums="1"
    # 画面上の座標 (0, 50) にバナーを作成します。
    var custom_position := AdPosition.custom(0, 50)
    _ad_view := AdView.new(unit_id, AdSize.BANNER, custom_position)
    ```

=== "C#"

    ```csharp linenums="1"
    // 画面上の座標 (0, 50) にバナーを作成します。
    var customPosition = AdPosition.Custom(0, 50);
    _adView = new AdView(unitId, AdSize.Banner, customPosition);
    ```

#### (オプション) カスタムサイズを指定した AdView の生成
定義済みの `AdSize` 定数を使用するだけでなく、広告にカスタムのサイズを指定することもできます。

=== "GDScript"

    ```gdscript linenums="1"
    var ad_size := AdSize.new(200, 200)
    _ad_view := AdView.new(unit_id, ad_size, AdPosition.TOP)
    ```

=== "C#"

    ```csharp linenums="1"
    var adSize = new AdSize(200, 200);
    _adView = new AdView(unitId, adSize, AdPosition.Top);
    ```

### AdView (バナー) のロード
`AdView` を使用する第 2 段階では、`AdRequest` を構築し、それを `load_ad()` メソッドに渡します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5"
    func _on_load_banner_pressed():
    	if _ad_view == null:
    		_create_ad_view()
    	var ad_request := AdRequest.new()
    	_ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6"
    private void OnLoadBannerPressed()
    {
        if (_adView == null)
            CreateAdView();
        var adRequest = new AdRequest();
        _adView.LoadAd(adRequest);
    }
    ```

### AdView シグナルの受信
広告の動作をカスタマイズするために、読み込み、表示、クリック、非表示など、広告のライフサイクルにおけるさまざまなイベントに接続できます。これらのイベントをリッスンするには、`AdListener` を登録します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 18"
    func register_ad_listener() -> void:
    	if _ad_view != null:
    		var ad_listener := AdListener.new()
    		
    		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
    			print("_on_ad_failed_to_load: " + load_ad_error.message)
    		ad_listener.on_ad_clicked = func() -> void:
    			print("_on_ad_clicked")
    		ad_listener.on_ad_closed = func() -> void:
    			print("_on_ad_closed")
    		ad_listener.on_ad_impression = func() -> void:
    			print("_on_ad_impression")
    		ad_listener.on_ad_loaded = func() -> void:
    			print("_on_ad_loaded")
    		ad_listener.on_ad_opened = func() -> void:
    			print("_on_ad_opened")
    			
    		_ad_view.ad_listener = ad_listener
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5"
    private void RegisterAdListener()
    {
        if (_adView != null)
        {
            _adView.AdListener = new AdListener
            {
                OnAdFailedToLoad = (LoadAdError loadAdError) => GD.Print("_on_ad_failed_to_load: " + loadAdError.Message),
                OnAdClicked = () => GD.Print("_on_ad_clicked"),
                OnAdClosed = () => GD.Print("_on_ad_closed"),
                OnAdImpression = () => GD.Print("_on_ad_impression"),
                OnAdLoaded = () => GD.Print("_on_ad_loaded"),
                OnAdOpened = () => GD.Print("_on_ad_opened")
            };
        }
    }
    ```

### AdView (バナー) の破棄
`AdView` の使用が終了したら、`destroy()` を呼び出して割り当てられたリソースを解放し、メモリを解放してください。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4"
    func destroy_ad_view() -> void:
    	if _ad_view:
    		# Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
    		_ad_view.destroy()
    		_ad_view = null
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="6"
    private void DestroyAdView()
    {
        if (_adView != null)
        {
            // Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
            _adView.Destroy();
            _adView = null;
        }
    }
    ```

以上で完了です。これでアプリで AdMob のバナー広告を表示する準備が整いました。

## AdView のサイズ {: #adview-sizes }

以下の表は、標準のバナー広告のサイズを示しています。

| サイズ dp (幅x高さ)                   | 説明                                          | 利用可能デバイス             | AdSize 定数      |
|----------------------------------|-----------------------------------------------|--------------------|------------------|
| 320x50                           | 標準バナー                                 | モバイルとタブレット     | BANNER           |
| 320x100                          | 大型バナー                                 | モバイルとタブレット     | LARGE_BANNER     |
| 300x250                          | IAB 中型の長方形                             | モバイルとタブレット     | MEDIUM_RECTANGLE |
| 468x60                           | IAB フルサイズバナー                           | タブレット           | FULL_BANNER      |
| 728x90                           | IAB リーダーボード                           | タブレット           | LEADERBOARD      |
| 指定された幅 x アダプティブな高さ            | [アンカー付きアダプティブバナー](sizes/anchored_adaptive.md)  | モバイルとタブレット     | N/A              |

## その他のリソース

### サンプル
- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：すべての広告フォーマットの使い方の最小限の実装例。
