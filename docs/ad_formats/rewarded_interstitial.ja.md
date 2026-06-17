# リワード インタースティシャル広告 (ベータ版)

[リワード インタースティシャル](https://support.google.com/admob/answer/9884467)は、アプリの自然な遷移の際に自動的に表示される広告と引き換えに報酬を提供する、インセンティブ付き広告フォーマットの一種です。通常のリワード広告とは異なり、ユーザーはリワード インタースティシャルを表示するために明示的にオプトインする必要はなく、アプリの体験にシームレスに統合されます。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/rewarded-interstitial)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/rewarded-interstitial)

## 前提条件
- [スタートガイド](../index.md)を完了していること


## 常にテスト広告でテストする

Godot アプリの開発およびテスト時には、実際の配信広告ではなく、テスト広告を使用することが極めて重要です。これを怠ると、AdMob アカウントが停止される可能性があります。

テスト広告を読み込む最も簡単な方法は、Android および iOS のリワード インタースティシャル専用のテスト広告ユニット ID を使用することです。

=== "Android"
    ```
    ca-app-pub-3940256099942544/5354046379
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/6978759866
    ```

この広告ユニット ID は、すべてのリクエストに対してテスト広告を配信するように特別に構成されています。コーディング、テスト、デバッグの段階で安全に使用できます。ただし、アプリをリリースする準備ができたら、このテスト広告ユニット ID を独自の広告ユニット ID に置き換えることを忘れないでください。

Mobile Ads SDK のテスト広告の仕組みについての詳細は、[テスト広告](../enable_test_ads.md)のドキュメントを参照してください。

## リワード インタースティシャルの例

以下のコード例は、リワード インタースティシャルの使用方法を示しています。この例では、リワード インタースティシャル インスタンスを作成し、`AdRequest` を使用して広告をロードし、さまざまなライフサイクル イベントを処理して機能を強化します。


### 広告のロード
リワード インタースティシャル広告をロードするには、`RewardedInterstitialAdLoader` クラスを使用します。ロードされた広告または発生したエラーを受け取るために、`RewardedInterstitialAdLoadCallback` を渡します。他の広告フォーマットのロード コールバックと同様に、`RewardedInterstitialAdLoadCallback` は `LoadAdError` を使用して詳細なエラー情報を提供します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
    
    func _ready() -> void:
    	#初期化はアプリの起動時に一度だけ行うのが理想的です。
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	#メモリを解放
    	if _rewarded_interstitial_ad:
    		#Android/iOS のメモリを解放するために、すべての AdFormat で必ずこのメソッドを呼び出してください
    		_rewarded_interstitial_ad.destroy()
    		_rewarded_interstitial_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/5354046379"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/6978759866"
    
    	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
    	rewarded_interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
    		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    		_rewarded_interstitial_ad = rewarded_interstitial_ad
    
    	RewardedInterstitialAdLoader.new().load(unit_id, AdRequest.new(), rewarded_interstitial_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
    
        public override void _Ready()
        {
            //初期化はアプリの起動時に一度だけ行うのが理想的です。
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            //メモリを解放
            if (_rewardedInterstitialAd != null)
            {
                //Android/iOS のメモリを解放するために、すべての AdFormat で必ずこのメソッドを呼び出してください
                _rewardedInterstitialAd.Destroy();
                _rewardedInterstitialAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/5354046379";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/6978759866";
    
            var rewardedInterstitialAdLoadCallback = new RewardedInterstitialAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
                {
                    GD.Print("rewarded interstitial ad loaded");
                    _rewardedInterstitialAd = rewardedInterstitialAd;
                }
            };
    
            new RewardedInterstitialAdLoader().Load(unitId, new AdRequest(), rewardedInterstitialAdLoadCallback);
        }
    }
    ```


### [任意] サーバー側検証 (SSV) コールバックの検証
サーバー側検証（[Android](https://developers.google.com/admob/android/ssv) / [iOS](https://developers.google.com/admob/ios/ssv)）コールバックで追加のデータを必要とするアプリでは、リワード広告のカスタムデータ機能を利用できます。リワード広告オブジェクトに設定された文字列値は、SSV コールバックの `custom_data` クエリパラメータとして送信されます。カスタムデータが設定されていない場合、SSV コールバックに `custom_data` パラメータは含まれません。

以下のコードスニペットは、広告をリクエストする前に、リワード インタースティシャル広告オブジェクトにカスタムデータを設定する方法を示しています。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5 6 7"
    rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
        print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    
        var server_side_verification_options := ServerSideVerificationOptions.new()
        server_side_verification_options.custom_data = "TEST PURPOSE"
        server_side_verification_options.user_id = "user_id_test"
        rewarded_interstitial_ad.set_server_side_verification_options(server_side_verification_options)
    
        _rewarded_interstitial_ad = rewarded_interstitial_ad
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6 7 8"
    rewardedInterstitialAdLoadCallback.OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
    {
        GD.Print("rewarded interstitial ad loaded");
        
        var serverSideVerificationOptions = new ServerSideVerificationOptions();
        serverSideVerificationOptions.CustomData = "TEST PURPOSE";
        serverSideVerificationOptions.UserId = "user_id_test";
        rewardedInterstitialAd.SetServerSideVerificationOptions(serverSideVerificationOptions);
        
        _rewardedInterstitialAd = rewardedInterstitialAd;
    };
    ```
!!! note

    カスタム報酬文字列は[パーセントエンコード（URLエンコード）](https://ja.wikipedia.org/wiki/%パーセントエンコーディング)されているため、SSV コールバックから解析する際にデコードが必要になる場合があります。

### FullScreenContentCallback の設定
`FullScreenContentCallback` は、`RewardedInterstitialAd` の表示に関連するイベントを管理します。`RewardedInterstitialAd` を表示する前に、コールバックを設定してください。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
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
    	var rewarded_interstitial_ad_load_callback := RewardedInterstitialAdLoadCallback.new()
    
    	#...
    
    	rewarded_interstitial_ad_load_callback.on_ad_loaded = func(rewarded_interstitial_ad : RewardedInterstitialAd) -> void:
    		print("rewarded interstitial ad loaded" + str(rewarded_interstitial_ad._uid))
    		_rewarded_interstitial_ad = rewarded_interstitial_ad
    		_rewarded_interstitial_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
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
            var rewardedInterstitialAdLoadCallback = new RewardedInterstitialAdLoadCallback
            {
                //...
                OnAdLoaded = (RewardedInterstitialAd rewardedInterstitialAd) => 
                {
                    GD.Print("rewarded interstitial ad loaded");
                    _rewardedInterstitialAd = rewardedInterstitialAd;
                    _rewardedInterstitialAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### 広告の表示

リワード インタースティシャル広告を表示する際は、`OnUserEarnedRewardListener` オブジェクトを使用して、報酬関連のイベントを管理します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14"
    extends Node2D
    
    var _rewarded_interstitial_ad : RewardedInterstitialAd
    var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
    
    func _ready() -> void:
    	#...
    	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
    		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
    
    #...
    func _on_show_pressed():
    	if _rewarded_interstitial_ad:
    		_rewarded_interstitial_ad.show(on_user_earned_reward_listener)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="27"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedInterstitialAdExample : Node2D
    {
        private RewardedInterstitialAd _rewardedInterstitialAd;
        private OnUserEarnedRewardListener _onUserEarnedRewardListener;
    
        public override void _Ready()
        {
            //...
            _onUserEarnedRewardListener = new OnUserEarnedRewardListener
            {
                OnUserEarnedReward = (RewardedItem rewardedItem) =>
                {
                    GD.Print($"on_user_earned_reward, rewarded_item: rewarded {rewardedItem.Amount} {rewardedItem.Type}");
                }
            };
        }
    
        //...
        private void OnShowPressed()
        {
            if (_rewardedInterstitialAd != null)
                _rewardedInterstitialAd.Show(_onUserEarnedRewardListener);
        }
    }
    ```

### メモリのクリーンアップ

`RewardedInterstitialAd` の使用が終了したら、参照を解放する前に `destroy()` 関数を呼び出すことが重要です。

=== "GDScript"

    ```gdscript linenums="1"
    if _rewarded_interstitial_ad:
        _rewarded_interstitial_ad.destroy()
        _rewarded_interstitial_ad = null
    ```

=== "C#"

    ```csharp linenums="1"
    if (_rewardedInterstitialAd != null)
    {
        _rewardedInterstitialAd.Destroy();
        _rewardedInterstitialAd = null;
    }
    ```

この処理により、オブジェクトが使用されなくなったことがプラグインに伝わり、そのオブジェクトが占有していたメモリを回収できるようになります。このメソッドの呼び出しを怠ると、メモリリークが発生する可能性があります。

## その他の参考資料

### サンプル
- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): すべての広告フォーマットの使用方法を示す最小限の例
