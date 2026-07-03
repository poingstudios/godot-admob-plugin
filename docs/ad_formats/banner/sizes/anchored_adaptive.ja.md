# アンカー付きアダプティブバナー

アダプティブバナーはレスポンシブ広告を進化させたものであり、デバイスごとに広告サイズを動的に最適化することでパフォーマンスを向上させます。固定の高さのみをサポートしていたスマートバナーとは異なり、アダプティブバナーでは広告の幅を指定でき、それに基づいて最も適切な広告サイズが決定されます。

最適な広告サイズを選択するために、アダプティブバナーは固定の高さではなく、固定のアスペクト比に依存します。これにより、さまざまなデバイスで画面の一貫した割合を維持するバナー広告が表示され、パフォーマンスの向上が期待できます。

アダプティブバナーを扱う際の重要な注意点として、特定のデバイスおよび指定された幅に対しては常に一定のサイズが返されます。特定のデバイスでレイアウトを一度テストすれば、広告サイズが変わることはありません。ただし、バナーのクリエイティブのサイズはデバイスによって異なる場合があります。そのため、広告の高さの潜在的な違いに対応できるようなレイアウトにすることをお勧めします。まれに、アダプティブサイズ全体が満たされず、代わりに標準サイズのクリエイティブがそのスペースの中央に配置される場合があります。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/banner/anchored-adaptive)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/banner/anchored-adaptive)

## 前提条件
- [はじめに](../../../index.ja.md) ガイドを完了していること

## Godot におけるアダプティブバナーの実装に関する注意点

1. **幅の把握**: 広告が配置されるビューの幅を知っている必要があります。**これには、デバイスの幅と、存在する可能性のあるセーフエリアやカットアウト（ノッチ）を考慮する必要があります**。

2. **プラグインのバージョン**: Google Mobile Ads Godot プラグインの最新バージョンを使用していることを確認してください。メディエーションを使用している場合は、各メディエーションアダプタの最新バージョンも使用していることを確認してください。

3. **最適な幅の使用**: アダプティブバナーのサイズは、利用可能な幅全体を使用するときに最高のパフォーマンスを発揮します。ほとんどの場合、これはデバイスの画面の全幅に相当します。適用されるセーフエリアを考慮してください。

4. **広告のサイズ調整**: アダプティブ `AdSize` API を使用する場合、Google Mobile Ads SDK は、指定された幅に基づいて最適化された広告の高さでバナーのサイズを自動的に調整します。

5. **アダプティブバナーサイズ**: アダプティブ広告のサイズは、次の 3 つの関数を使用して取得できます。横画面用の `AdSize.get_landscape_anchored_adaptive_banner_ad_size`、縦画面用の `AdSize.get_portrait_anchored_adaptive_banner_ad_size`、および実行時の現在の画面の向きに対応する `AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` です。

6. **安定したサイズ調整**: 特定のデバイスの特定の幅に対して返されるサイズは一定です。そのため、特定のデバイスでレイアウトを一度テストすれば、広告サイズが変わらないことを確信できます。

7. **アンカー付きバナーの高さ**: アンカー付きバナーの高さは常に一定の制限内に収まります。デバイスの高さの 15% を超えることはなく、50 密度独立ピクセル (dp) を下回ることもありません。

8. **全幅バナー**: 全幅のバナーの場合は、具体的な幅を指定する代わりに `AdSize.FULL_WIDTH` 定数を使用できます。

## クイックスタートガイド

Godot でシンプルなアンカー付きアダプティブバナーを実装するには、次の手順に従います。

1. **アダプティブ広告サイズの取得**:
    - デバイスの幅を密度独立ピクセル (dp) で取得するか、画面の全幅を使用しない場合はカスタムの幅を設定します。`DisplayServer.window_get_size().x` が役立つ場合があります。
    - 全幅のバナーの場合は、`AdSize.FullWidth` フラグを使用します。
    - 広告サイズクラスの適切な静的メソッド（`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(width)` など）を利用して、現在の画面の向きに対するアダプティブな `AdSize` オブジェクトを取得します。

2. **AdView の作成**:
    - 広告ユニット ID、ステップ 1 で取得したアダプティブサイズ、および広告の希望する位置を指定して `AdView` オブジェクトをインスタンス化します。

3. **広告リクエストの作成**:
    - 広告リクエストオブジェクトを作成します。
    - 標準のバナーリクエストと同様に、準備した広告ビューで `load_ad()` 関数を呼び出して、アンカー付きアダプティブバナーをロードします。

## サンプルコード

以下は、アダプティブバナーをロードして更新するスクリプトの例です。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="25 29"
    extends Node2D
    
    var _ad_view : AdView
    var _ad_listener := AdListener.new()
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = func(initialization_status : InitializationStatus) -> void:
    		_request_ad_view()
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    	_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load
    	_ad_listener.on_ad_loaded = _on_ad_loaded
    
    func _request_ad_view() -> void:
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/6300978111"
    	
    	if (_ad_view != null):
    		_ad_view.destroy()
    		
    	var adaptive_size := AdSize.get_current_orientation_anchored_adaptive_banner_ad_size(AdSize.FULL_WIDTH)	
    	_ad_view = AdView.new(unit_id, adaptive_size, AdPosition.TOP)
    	_ad_view.ad_listener = _ad_listener
    	
    	_ad_view.load_ad(AdRequest.new())
    
    func _on_ad_failed_to_load(load_ad_error : LoadAdError) -> void:
    	print("_on_ad_failed_to_load: " + load_ad_error.message)
    
    func _on_ad_loaded() -> void:
    	print("_on_ad_loaded")
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="37 41"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class AnchoredAdaptiveExample : Node2D
    {
        private AdView _adView;
        private AdListener _adListener;
    
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = (InitializationStatus status) => RequestAdView()
            };
            MobileAds.Initialize(onInitializationCompleteListener);
            
            _adListener = new AdListener
            {
                OnAdFailedToLoad = OnAdFailedToLoad,
                OnAdLoaded = OnAdLoaded
            };
        }
    
        private void RequestAdView()
        {
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/6300978111";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/6300978111";
    
            if (_adView != null)
                _adView.Destroy();
    
            var adaptiveSize = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
            _adView = new AdView(unitId, adaptiveSize, AdPosition.Top);
            _adView.AdListener = _adListener;
    
            _adView.LoadAd(new AdRequest());
        }
    
        private void OnAdFailedToLoad(LoadAdError loadAdError)
        {
            GD.Print("_on_ad_failed_to_load: " + loadAdError.Message);
        }
    
        private void OnAdLoaded()
        {
            GD.Print("_on_ad_loaded");
        }
    }
    ```

この文脈において、現在の画面の向きに合わせるために、`AdSize.get_current_orientation_anchored_adaptive_banner_ad_size` のような関数を使用してアンカー位置のバナーサイズを取得しています。特定の向きに合わせてアンカーバナーを事前にロードするには、適切な関数である `AdSize.get_portrait_anchored_adaptive_banner_ad_size` または `AdSize.get_landscape_anchored_adaptive_banner_ad_size` のいずれかを使用できます。
