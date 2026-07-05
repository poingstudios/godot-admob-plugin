# リワード広告

リワード動画広告は、ユーザーがそれを完全に視聴することを選択できる、没入型の全画面動画広告です。視聴時間と引き換えに、ユーザーはアプリ内報酬や特典を受け取ります。

本文書は以下に基づいています。

- [Google Mobile Ads SDK Android 公式ドキュメント](https://developers.google.com/admob/android/rewarded)
- [Google Mobile Ads SDK iOS 公式ドキュメント](https://developers.google.com/admob/ios/rewarded)

## 前提条件
- [はじめに](../index.ja.md) ガイドを完了していること


## 常にテスト広告でテストする

Godot アプリを開発およびテストする際は、本番用の広告ではなくテスト広告を使用することが極めて重要です。そうしないと、AdMob アカウントがサスペンドされる可能性があります。

テスト広告を読み込む最も簡単な方法は、Android および iOS のリワード広告専用テスト広告ユニット ID を使用することです。

=== "Android"
    ```
    ca-app-pub-3940256099942544/5224354917
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/1712485313
    ```

この特定の広告ユニット ID は、すべてのリクエストに対してテスト広告を返すように特別に設定されています。コーディング、テスト、デバッグ中に安全に使用できます。ただし、アプリをリリースする準備ができたら、このテスト用広告ユニット ID をご自身の広告ユニット ID に置き換えてください。

モバイル広告 SDK のテスト広告の仕組みについての詳細は、[テスト広告](../enable_test_ads.ja.md)のドキュメントを参照してください。


## リワード広告の例

以下のコード例は、`Rewarded` の使用方法を示しています。この例では、`RewardedAd` のインスタンスを作成し、`AdRequest` を使用して広告をロードし、さまざまなライフサイクルイベントを処理して機能を強化します。


### 広告のロード
リワード広告をロードするには、[`RewardedAdLoader`](../reference/classes/RewardedAdLoader.md) クラスを使用します。ロードされた [`RewardedAd`](../reference/classes/RewardedAd.md) またはエラーを受け取るために、[`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) を渡します。他の広告フォーマットのロードコールバックと同様に、[`RewardedAdLoadCallback`](../reference/listeners/RewardedAdLoadCallback.md) は詳細なエラー情報を提供するために [`LoadAdError`](../reference/classes/LoadAdError.md) を利用します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="30"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    
    func _ready() -> void:
        # 初期化はアプリの起動時に一度だけ行うのが理想的です。
    	MobileAds.initialize()
    
    func _on_load_pressed():
    	# メモリの解放
    	if _rewarded_ad:
    		# Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
    		_rewarded_ad.destroy()
    		_rewarded_ad = null
    
    	var unit_id : String
    	if OS.get_name() == "Android":
    		unit_id = "ca-app-pub-3940256099942544/5224354917"
    	elif OS.get_name() == "iOS":
    		unit_id = "ca-app-pub-3940256099942544/1712485313"
    
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
    		print(adError.message)
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    
    	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="42"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
    
        public override void _Ready()
        {
            // 初期化はアプリの起動時に一度だけ行うのが理想的です。
            MobileAds.Initialize();
        }
    
        private void OnLoadPressed()
        {
            // メモリの解放
            if (_rewardedAd != null)
            {
                // Android/iOS のメモリを解放するために、すべての広告フォーマットで常にこのメソッドを呼び出してください
                _rewardedAd.Destroy();
                _rewardedAd = null;
            }
    
            string unitId = null;
            if (OS.GetName() == "Android")
                unitId = "ca-app-pub-3940256099942544/5224354917";
            else if (OS.GetName() == "iOS")
                unitId = "ca-app-pub-3940256099942544/1712485313";
    
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                OnAdFailedToLoad = (LoadAdError adError) => GD.Print(adError.Message),
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                }
            };
    
            new RewardedAdLoader().Load(unitId, new AdRequest(), rewardedAdLoadCallback);
        }
    }
    ```

### [オプション] サーバーサイド検証 (SSV) コールバックの検証
サーバーサイド検証（[Android](https://developers.google.com/admob/android/ssv) / [iOS](https://developers.google.com/admob/ios/ssv)）コールバックで追加データを必要とするアプリの場合、リワード広告のカスタムデータ機能は、[`ServerSideVerificationOptions`](../reference/classes/ServerSideVerificationOptions.md) を使用して構成できます。リワード広告オブジェクトに割り当てられた文字列値は、SSV コールバックの `custom_data` クエリパラメータに転送されます。カスタムデータが設定されていない場合、SSV コールバックに `custom_data` パラメータは含まれません。

以下のコードスニペットは、広告をリクエストする前にリワード広告オブジェクトにカスタムデータを設定する方法を示しています。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="4 5 6 7"
    rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
        print("rewarded ad loaded" + str(rewarded_ad._uid))
        
        var server_side_verification_options := ServerSideVerificationOptions.new()
        server_side_verification_options.custom_data = "TEST PURPOSE"
        server_side_verification_options.user_id = "user_id_test"
        rewarded_ad.set_server_side_verification_options(server_side_verification_options)
        
        _rewarded_ad = rewarded_ad
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="5 6 7 8"
    rewardedAdLoadCallback.OnAdLoaded = (RewardedAd rewardedAd) => 
    {
        GD.Print("rewarded ad loaded");
        
        var serverSideVerificationOptions = new ServerSideVerificationOptions();
        serverSideVerificationOptions.CustomData = "TEST PURPOSE";
        serverSideVerificationOptions.UserId = "user_id_test";
        rewardedAd.SetServerSideVerificationOptions(serverSideVerificationOptions);
        
        _rewardedAd = rewardedAd;
    };
    ```
!!! note

    カスタム報酬文字列は[パーセントエンコーディング（URL エンコード）](https://ja.wikipedia.org/wiki/%パーセントエンコーディング)されているため、SSV コールバックから解析する際にデコードが必要になる場合があります。

### FullScreenContentCallback の設定
[`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) は、[`RewardedAd`](../reference/classes/RewardedAd.md) の表示に関連するイベントを管理します。[`RewardedAd`](../reference/classes/RewardedAd.md) を表示する前に、必ずコールバックを設定してください。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="28"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
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
    	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
    
    	#...
    
    	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
    		print("rewarded ad loaded" + str(rewarded_ad._uid))
    		_rewarded_ad = rewarded_ad
    		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback
    
    	#...
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="34"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
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
            var rewardedAdLoadCallback = new RewardedAdLoadCallback
            {
                //...
                OnAdLoaded = (RewardedAd rewardedAd) => 
                {
                    GD.Print("rewarded ad loaded");
                    _rewardedAd = rewardedAd;
                    _rewardedAd.FullScreenContentCallback = _fullScreenContentCallback;
                }
            };
            //...
        }
    }
    ```

### 広告の表示

リワード広告を表示する際は、[`OnUserEarnedRewardListener`](../reference/listeners/OnUserEarnedRewardListener.md) オブジェクトを使用して報酬関連のイベントを管理します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14"
    extends Node2D
    
    var _rewarded_ad : RewardedAd
    var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
    
    func _ready() -> void:
    	#...
    	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
    		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
    
    #...
    func _on_show_pressed():
    	if _rewarded_ad:
    		_rewarded_ad.show(on_user_earned_reward_listener)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="27"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    
    public partial class RewardedAdExample : Node2D
    {
        private RewardedAd _rewardedAd;
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
            if (_rewardedAd != null)
                _rewardedAd.Show(_onUserEarnedRewardListener);
        }
    }
    ```

### メモリのクリーンアップ

`RewardedAd` の処理が完了したら、その参照を破棄する前に必ず `destroy()` メソッドを呼び出してください。

=== "GDScript"

    ```gdscript
    if _rewarded_ad:
        _rewarded_ad.destroy()
        _rewarded_ad = null
    ```

=== "C#"

    ```csharp
    if (_rewardedAd != null)
    {
        _rewardedAd.Destroy();
        _rewardedAd = null;
    }
    ```

これにより、オブジェクトが使用されなくなったことがプラグインに通知され、占有されていたメモリが解放されます。このメソッドを呼び出さないと、メモリリークが発生します。

## その他のリソース

### サンプル
- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：すべての広告フォーマットの使い方の最小限の実装例。
