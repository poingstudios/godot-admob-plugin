# アプリ起動時広告 (App Open Ads)

このガイドは、Google Mobile Ads SDK を使用してアプリ起動時広告を統合するデベロッパーを対象としています。

アプリ起動時広告は、アプリのロード画面を収益化したいデベロッパー向けに設計された特別な広告フォーマットです。ユーザーがアプリをフォアグラウンドに切り替えたときに表示され、ユーザーはいつでもこの広告を閉じることができます。

!!! note

    地域によって利用可能な広告フォーマットが異なる場合があります。

アプリ起動時広告には、ユーザーがあなたのアプリ内にいることを認識できるように、小さなブランディング領域が自動的に表示されます。以下はアプリ起動時広告の表示例です。

<img src="https://developers.google.com/static/admob/images/app-open-ad.png" width="300">

## 前提条件

進める前に、以下を完了してください。

- [はじめに](../index.ja.md) ガイドの完了。

## 常にテスト広告でテストする

以下の表には、テスト広告をリクエストするために使用できる広告ユニット ID が含まれています。これは、すべてのリクエストに対して本番用の広告ではなくテスト広告を返すように特別に設定されているため、安全に使用できます。

ただし、AdMob のウェブ管理画面でアプリを登録し、アプリ内で使用する独自の広告ユニット ID を作成した後は、開発中に明示的に[デバイスをテストデバイスとして設定](../enable_test_ads.ja.md)してください。

=== "Android"

    ```
    ca-app-pub-3940256099942544/9257395921
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/5575463023
    ```

## 実装

アプリ起動時広告を統合するための主なステップは次のとおりです。

1. ユーティリティクラスの作成
2. アプリ起動時広告のロード
3. アプリ起動時広告イベントの監視
4. 広告の有効期限の考慮
5. アプリ状態イベントの監視
6. アプリ起動時広告の表示
7. アプリ起動時広告のクリーンアップ
8. 次のアプリ起動時広告のプレロード

### ユーティリティクラスの作成

広告をロードするための新しいクラス（例: `AppOpenAdManager`）を作成します。このクラスは、ロードされた広告と各プラットフォーム用の広告ユニット ID を追跡するためのインスタンス変数を制御します。

!!! tip

    必須ではありませんが、このスクリプトを **Autoload** (シングルトン) として追加することを強くお勧めします。これにより、マネージャーはシーンの変更後も破棄されず、シーンツリー内に持続し、Google が他のプラットフォームで使用している自動化システムと同様のシームレスなグローバル状態モニターを提供できます。

=== "GDScript"

    ```gdscript linenums="1"
    extends Node
    
    var _app_open_ad: AppOpenAd
    var _expire_time: int = 0
    var _is_showing_ad: bool = false
    
    # これらの広告ユニットは、常にテスト広告を配信するように設定されています。
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/9257395921"
            return "ca-app-pub-3940256099942544/5575463023"
    
    func is_ad_available() -> bool:
        return _app_open_ad != null
    
    func load_app_open_ad() -> void:
        pass # 以下で実装
    
    func show_app_open_ad() -> void:
        pass # 以下で実装
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    using System;
    
    public partial class AppOpenAdManager : Node
    {
        private AppOpenAd _appOpenAd;
        private long _expireTime;
        private bool _isShowingAd;
    
        // これらの広告ユニットは、常にテスト広告を配信するように設定されています。
        private string _adUnitId => OS.GetName() == "Android" 
            ? "ca-app-pub-3940256099942544/9257395921" 
            : "ca-app-pub-3940256099942544/5575463023";
    
        public bool IsAdAvailable => _appOpenAd != null;
    
        public void LoadAppOpenAd()
        {
            // 以下で実装
        }
    
        public void ShowAppOpenAd()
        {
            // 以下で実装
        }
    }
    ```

### アプリ起動時広告のロード

アプリ起動時広告のロードは、[`AppOpenAdLoader`](../reference/classes/AppOpenAdLoader.md) クラスの `load()` メソッドを使用して行われます。ロードメソッドには、広告ユニット ID、[`AdRequest`](../reference/classes/AdRequest.md) オブジェクト、および広告のロードが成功または失敗したときに呼び出される完了ハンドラーが必要です。ロードされた [`AppOpenAd`](../reference/classes/AppOpenAd.md) オブジェクトは、完了ハンドラーのパラメータとして提供されます。

=== "GDScript"

    ```gdscript linenums="1"
    func load_app_open_ad() -> void:
        # 新しい広告をロードする前に古い広告をクリーンアップします。
        if _app_open_ad:
            _app_open_ad.destroy()
            _app_open_ad = null
    
        print("Loading the app open ad.")
    
        # 広告のロードに使用するリクエストを作成します。
        var ad_request := AdRequest.new()
    
        # 広告をロードするリクエストを送信します。
        var load_callback := AppOpenAdLoadCallback.new()
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            print("App open ad loaded with response : " + ad.get_response_info().response_id)
            _app_open_ad = ad
            _register_event_handlers(ad)
    
        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            print("App open ad failed to load an ad with error : " + error.message)
    
        AppOpenAdLoader.new().load(_ad_unit_id, ad_request, load_callback)
    ```

=== "C#"

    ```csharp linenums="1"
    public void LoadAppOpenAd()
    {
        // 新しい広告をロードする前に古い広告をクリーンアップします。
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }
    
        GD.Print("Loading the app open ad.");
    
        // 広告のロードに使用するリクエストを作成します。
        var adRequest = new AdRequest();
    
        // 広告をロードするリクエストを送信します。
        var loadCallback = new AppOpenAdLoadCallback();
        loadCallback.OnAdLoaded = (ad) =>
        {
            GD.Print("App open ad loaded with response : " + ad.GetResponseInfo().ResponseId);
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            GD.Print("App open ad failed to load an ad with error : " + error.Message);
        };
    
        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

!!! warning

    広告のロードに失敗したときに、広告リクエストの完了ブロックから新しい広告のロードを試みることは強く推奨されません。ネットワーク接続が制限されている状況などで広告の失敗リクエストが継続するのを避けるため、完了ブロックからロードを行う場合はリトライ回数を制限してください。

### アプリ起動時広告イベントの監視

広告の挙動をさらにカスタマイズするには、広告のライフサイクルにおける開く、閉じるなどのさまざまなイベントにフックできます。[`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) を登録し、[`AdValue`](../reference/classes/AdValue.md) を受け取る `on_ad_paid` / `OnAdPaid` コールバックプロパティを設定して、以下のようにこれらのイベントをリッスンします。

=== "GDScript"

    ```gdscript linenums="1"
    func _register_event_handlers(ad: AppOpenAd) -> void:
        # 広告が収益を上げたと推定されるときに発生します。
        ad.on_ad_paid = func(ad_value: AdValue):
            print("App open ad paid %d %s." % [ad_value.value_micros, ad_value.currency_code])
    
        var content_callback := FullScreenContentCallback.new()
        # 広告のインプレッションが記録されたときに発生します。
        content_callback.on_ad_impression = func():
            print("App open ad recorded an impression.")
        # 広告のクリックが記録されたときに発生します。
        content_callback.on_ad_clicked = func():
            print("App open ad was clicked.")
        # 広告が全画面コンテンツを開いたときに発生します。
        content_callback.on_ad_showed_full_screen_content = func():
            print("App open ad full screen content opened.")
        # 広告が全画面コンテンツを閉じたときに発生します。
        content_callback.on_ad_dismissed_full_screen_content = func():
            print("App open ad full screen content closed.")
        # 広告が全画面コンテンツの表示に失敗したときに発生します。
        content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
            print("App open ad failed to open full screen content with error : " + error.message)
    
        ad.full_screen_content_callback = content_callback
    ```

=== "C#"

    ```csharp linenums="1"
    private void RegisterEventHandlers(AppOpenAd ad)
    {
        // 広告が収益を上げたと推定されるときに発生します。
        ad.OnAdPaid = (adValue) =>
        {
            GD.Print($"App open ad paid {adValue.ValueMicros} {adValue.CurrencyCode}.");
        };
    
        var contentCallback = new FullScreenContentCallback();
        // 広告のインプレッションが記録されたときに発生します。
        contentCallback.OnAdImpression = () => GD.Print("App open ad recorded an impression.");
        // 広告のクリックが記録されたときに発生します。
        contentCallback.OnAdClicked = () => GD.Print("App open ad was clicked.");
        // 広告が全画面コンテンツを開いたときに発生します。
        contentCallback.OnAdShowedFullScreenContent = () => GD.Print("App open ad full screen content opened.");
        // 広告が全画面コンテンツを閉じたときに発生します。
        contentCallback.OnAdDismissedFullScreenContent = () => GD.Print("App open ad full screen content closed.");
        // 広告が全画面コンテンツの表示に失敗したときに発生します。
        contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
            GD.Print("App open ad failed to open full screen content with error : " + error.Message);
    
        ad.FullScreenContentCallback = contentCallback;
    }
    ```

### 広告の有効期限の考慮

!!! info "重要なポイント"
    アプリ起動時広告はリクエスト後 4 時間でタイムアウトします。リクエストされてから 4 時間以上経過した広告は無効となり、表示しても収益が発生しない場合があります。

期限切れの広告を表示しないようにするために、`AppOpenAdManager` に広告のロード完了から経過した時間を確認するロジックを追加します。そして、その情報を用いて広告がまだ有効であるかチェックします。

ロードした時間を `_expire_time` 変数に記録し、4 時間のタイムアウトを判定します。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14-15"
    func load_app_open_ad() -> void:
        # ...
        # 広告をロードするリクエストを送信
        var load_callback := AppOpenAdLoadCallback.new()
    
        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            print("App open ad failed to load an ad with error : " + error.message)
    
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            print("App open ad loaded with response : " + ad.get_response_info().response_id)
    
            # アプリ起動時広告は最大 4 時間プリロードできます。
            _expire_time = Time.get_unix_time_from_system() + (4 * 60 * 60)
    
            _app_open_ad = ad
            _register_event_handlers(ad)
    ```

    ```gdscript linenums="1"
    func is_ad_available() -> bool:
        return _app_open_ad != null \
               and Time.get_unix_time_from_system() < _expire_time
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="29-30"
    public void LoadAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }
    
        GD.Print("Loading the app open ad.");
    
        var adRequest = new AdRequest();
        var loadCallback = new AppOpenAdLoadCallback();
    
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            GD.Print("App open ad failed to load an ad with error : " + error.Message);
        };
    
        loadCallback.OnAdLoaded = (ad) =>
        {
            GD.Print("App open ad loaded with response : " + ad.GetResponseInfo().ResponseId);
    
            // アプリ起動時広告は最大 4 時間プリロードできます。
            _expireTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + (4 * 60 * 60);
    
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
    
        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

    ```csharp linenums="1"
    public bool IsAdAvailable
    {
        get
        {
            return _appOpenAd != null 
                   && DateTimeOffset.UtcNow.ToUnixTimeSeconds() < _expireTime;
        }
    }
    ```

### アプリ状態イベントの監視

Godot のフォーカス通知を使用して、アプリケーションがフォアグラウンドまたはバックグラウンドに切り替わるイベントをリッスンします。

=== "GDScript"

    ```gdscript linenums="1"
    func _notification(what: int) -> void:
        if what == NOTIFICATION_APPLICATION_FOCUS_IN:
            # アプリがフォアグラウンドになり、広告が利用可能な場合は表示します。
            if is_ad_available():
                show_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    public override void _Notification(int what)
    {
        if (what == NotificationApplicationFocusIn)
        {
            // アプリがフォアグラウンドになり、広告が利用可能な場合は表示します。
            if (IsAdAvailable)
            {
                ShowAppOpenAd();
            }
        }
    }
    ```

### アプリ起動時広告の表示

ロードされたアプリ起動時広告を表示するには、`AppOpenAd` インスタンスの `show()` メソッドを呼び出します。

!!! note

    アプリ起動時広告は、アプリの自然な一時停止のタイミングで表示する必要があります。ゲームのレベル間や、ユーザーがタスクを完了した直後などが良い例です。

=== "GDScript"

    ```gdscript linenums="1"
    func show_app_open_ad() -> void:
        if _app_open_ad:
            print("Showing app open ad.")
            _app_open_ad.show()
        else:
            print("App open ad is not ready yet.")
    ```

=== "C#"

    ```csharp linenums="1"
    public void ShowAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            GD.Print("Showing app open ad.");
            _appOpenAd.Show();
        }
        else
        {
            GD.Print("App open ad is not ready yet.");
        }
    }
    ```

### アプリ起動時広告のクリーンアップ

`AppOpenAd` の処理が完了したら、その参照を破棄する前に必ず `destroy()` メソッドを呼び出してください。

=== "GDScript"

    ```gdscript
    _app_open_ad.destroy()
    ```

=== "C#"

    ```csharp
    _appOpenAd.Destroy();
    ```

これにより、オブジェクトが使用されなくなったことがプラグインに通知され、占有されていたメモリが解放されます。このメソッドを呼び出さないと、メモリリークが発生します。

### 次のアプリ起動时広告のプレロード

`AppOpenAd` は使い捨てのオブジェクトです。つまり、アプリ起動時広告が一度表示されると、そのオブジェクトを再利用することはできません。別の広告を表示するには、新しい `AppOpenAd` オブジェクトをロードする必要があります。

次の表示機会に備えて、`on_ad_dismissed_full_screen_content` または `on_ad_failed_to_show_full_screen_content` イベントが発生した後に、次の広告をプリロードしてください。

=== "GDScript"

    ```gdscript linenums="1"
    # _register_event_handlers の内部...
    content_callback.on_ad_dismissed_full_screen_content = func():
        print("App open ad full screen content closed.")
        # できるだけ早く次の広告を表示できるように、再ロードします。
        load_app_open_ad()
    
    content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
        print("App open ad failed to open full screen content.")
        # できる should reload
        load_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    // RegisterEventHandlers の内部...
    contentCallback.OnAdDismissedFullScreenContent = () => 
    {
        GD.Print("App open ad full screen content closed.");
        // できるだけ早く次の広告を表示できるように、再ロードします。
        LoadAppOpenAd();
    };
    
    contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
    {
        GD.Print("App open ad failed to open full screen content.");
        // できるだけ早く次の広告を表示できるように、再ロードします。
        LoadAppOpenAd();
    };
    ```

## コールドスタートとロード画面

これまでのドキュメントでは、アプリがメモリにサスペンド（一時停止）されている状態でフォアグラウンドに戻ったときにのみ、アプリ起動時広告を表示することを想定していました。「コールドスタート」は、アプリが以前にサスペンドされておらず、新しく起動されたときに発生します。

コールドスタートの例は、ユーザーがアプリを初めて開くときです。コールドスタートの場合、すぐに表示できる以前にロードされた広告はありません。広告をリクエストしてから受け取るまでの遅延により、ユーザーがアプリを短時間使用し始めた後に、突然広告が表示されて驚かせる状況が発生する可能性があります。これはユーザー体験として好ましくないため、避けるべきです。

コールドスタート時にアプリ起動時広告を使用する好ましい方法は、ロード画面を使用してゲームやアプリのアセットを読み込み、ロード画面が表示されている間のみ広告を表示することです。アプリの読み込みが完了し、ユーザーがアプリのメインコンテンツに移動した後は、広告を表示しないようにしてください。

!!! info "重要なポイント"
    アプリ起動時広告が表示されている間もアセットの読み込みを継続できるように、アセットのロードは常にバックグラウンドスレッドで行ってください。

## ベストプラクティス

アプリ起動時広告は、アプリの初回起動時やアプリの切り替え時にロード画面を収益化するのに役立ちますが、ユーザーにアプリを快適に使用してもらうために、以下のベストプラクティスを念頭に置いてください。

*   ユーザーがアプリを数回使用した後に、最初のアプリ起動時広告を表示するようにします。
*   ユーザーがアプリの読み込みを待っている時間帯にアプリ起動时広告を表示します。
*   アプリ起動時広告の下にロード画面があり、広告が閉じられる前にロード画面の読み込みが完了した場合は、`on_ad_dismissed_full_screen_content` イベントハンドラー内でロード画面を閉じてください。
*   アプリ状態リスナーを実装しているノード（`AppOpenAdManager`）がシーンツリーに存在することを確認してください。イベントをトリガーするには、`NOTIFICATION_APPLICATION_FOCUS_IN` などのライフサイクル通知が必要であるため、このノードをシーンツリーから削除しないでください。削除されるとイベントがトリガーされなくなります。

## その他のリソース

- [サンプルプロジェクト](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample): すべての広告フォーマットの最小限の実装例。
