# インプレッション レベルの広告収益

インプレッションが発生すると、Godot AdMob プラグインはそのインプレッションに関連付けられた広告収益データを提供します。このデータを使用して、ユーザーの生涯価値（LTV）を計算したり、他の関連システムにデータを転送したりできます。

このガイドは、Godot プロジェクトでインプレッション レベルの広告収益データの取得を実装するのに役立ちます。

## 前提条件
- AdMob UI で[インプレッション レベルの広告収益機能をオン](https://support.google.com/admob/answer/11322405)にしていることを確認してください。
- [スタートガイド](../index.md)を完了していること。Godot プロジェクトに Poing Studios AdMob プラグインがすでにインポートおよび構成されている必要があります。
- インプレッション レベルの広告収益データを受信するには、少なくとも 1 つの広告フォーマットを実装する必要があります。
    - [アプリオープン](../ad_formats/app_open.md)
    - [バナー](../ad_formats/banner/get_started.md)
    - [インタースティシャル](../ad_formats/interstitial.md)
    - [リワード](../ad_formats/rewarded.md)
    - [リワード インタースティシャル](../ad_formats/rewarded_interstitial.md)
    - [ネイティブ](../ad_formats/native_overlay.md)

## 支払われたイベントハンドラ（Paid Event Handler）の実装

各広告フォーマットには、`on_ad_paid`（C# では `OnAdPaid`）イベントがあります。広告イベントのライフサイクル中に、Godot AdMob プラグインはインプレッション イベントを監視し、獲得した価値を表す [`AdValue`](../reference/classes/AdValue.md) を使用してハンドラを呼び出します。この値の精度タイプは [`AdValue.PrecisionType`](../reference/enums/AdValue.PrecisionType.md) によって定義されます。

以下の例は、リワード広告の支払われたイベントを処理します。

=== "GDScript"

    ```gdscript
    var _rewarded_ad: RewardedAd

    func _load_rewarded_ad() -> void:
        # 広告をロードするためのリクエストを送信します。
        var ad_request := AdRequest.new()
        RewardedAdLoader.new().load("AD_UNIT_ID", ad_request, func(rewarded_ad: RewardedAd, error: LoadAdError):
            # 操作が何らかの理由で失敗した場合。
            if error != null:
                push_error("Rewarded ad failed to load an ad with error: %s" % error.message)
                return
            
            _rewarded_ad = rewarded_ad
            _rewarded_ad.on_ad_paid = _handle_ad_paid_event
        )

    func _handle_ad_paid_event(ad_value: AdValue) -> void:
        # TODO: このコールバック内で、インプレッション レベルの広告収益情報を
        # お好みの分析サーバーに直接送信します。

        var value_micros: int = ad_value.value_micros
        var currency: String = ad_value.currency_code
        var precision := ad_value.precision # (AdValue.PrecisionType)
        var response_info: ResponseInfo = _rewarded_ad.get_response_info()
        var response_id: String = response_info.response_id

        var loaded_adapter_response_info: AdapterResponseInfo = response_info.loaded_adapter_response_info
        if loaded_adapter_response_info:
            var ad_source_id: String = loaded_adapter_response_info.ad_source_id
            var ad_source_instance_id: String = loaded_adapter_response_info.ad_source_instance_id
            var ad_source_instance_name: String = loaded_adapter_response_info.ad_source_instance_name
            var ad_source_name: String = loaded_adapter_response_info.ad_source_name
            var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
            var latency_millis: int = loaded_adapter_response_info.latency_millis
            var credentials: Dictionary = loaded_adapter_response_info.ad_unit_mapping
        
        var extras: Dictionary = response_info.response_extras
        var mediation_group_name = extras.get("mediation_group_name", "")
        var mediation_ab_test_name = extras.get("mediation_ab_test_name", "")
        var mediation_ab_test_variant = extras.get("mediation_ab_test_variant", "")
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using Godot.Collections;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;

    private RewardedAd _rewardedAd;

    private void LoadRewardedAd()
    {
        // 広告をロードするためのリクエストを送信します。
        AdRequest adRequest = new AdRequest();
        RewardedAdLoader.Load("AD_UNIT_ID", adRequest, (rewardedAd, error) =>
        {
            // 操作が何らかの理由で失敗した場合。
            if (error != null)
            {
                GD.PrintErr("Rewarded ad failed to load an ad with error: " + error.Message);
                return;
            }

            _rewardedAd = rewardedAd;
            _rewardedAd.OnAdPaid += HandleAdPaidEvent;
        });
    }

    private void HandleAdPaidEvent(AdValue adValue)
    {
        // TODO: このコールバック内で、インプレッション レベルの広告収益情報を
        // お好みの分析サーバーに直接送信します。

        long valueMicros = adValue.ValueMicros;
        string currency = adValue.CurrencyCode;
        AdValue.PrecisionType precision = adValue.Precision;
        ResponseInfo responseInfo = _rewardedAd.GetResponseInfo();
        string responseId = responseInfo.ResponseId;

        AdapterResponseInfo loadedAdapterResponseInfo = responseInfo.LoadedAdapterResponseInfo;
        if (loadedAdapterResponseInfo != null)
        {
            string adSourceId = loadedAdapterResponseInfo.AdSourceId;
            string adSourceInstanceId = loadedAdapterResponseInfo.AdSourceInstanceId;
            string adSourceInstanceName = loadedAdapterResponseInfo.AdSourceInstanceName;
            string adSourceName = loadedAdapterResponseInfo.AdSourceName;
            string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;
            int latencyMillis = loadedAdapterResponseInfo.LatencyMillis;
            Godot.Collections.Dictionary credentials = loadedAdapterResponseInfo.AdUnitMapping;
        }

        Godot.Collections.Dictionary extras = responseInfo.ResponseExtras;
        string mediationGroupName = extras.ContainsKey("mediation_group_name") ? extras["mediation_group_name"].ToString() : "";
        string mediationABTestName = extras.ContainsKey("mediation_ab_test_name") ? extras["mediation_ab_test_name"].ToString() : "";
        string mediationABTestVariant = extras.ContainsKey("mediation_ab_test_variant") ? extras["mediation_ab_test_variant"].ToString() : "";
    }
    ```

## カスタム イベントの広告ソース名の特定

カスタム イベントの広告ソースの場合、`ad_source_name`（`AdSourceName`）プロパティは広告ソース名「Custom Event」を返します。複数のカスタム イベントを使用する場合、この広告ソース名だけでは複数のカスタム イベントを区別するのに十分ではありません。特定のカスタム イベントを特定するには、以下の手順を実行します。

1. `adapter_class_name`（`AdapterClassName`）プロパティを取得します。
2. 一意の広告ソース名を設定します。

以下の例は、カスタム イベントに対して一意の広告ソース名を設定する方法を示しています。

=== "GDScript"

    ```gdscript
    func _get_ad_source_name(loaded_adapter_response_info: AdapterResponseInfo) -> String:
        if loaded_adapter_response_info == null:
            return ""

        var ad_source_name: String = loaded_adapter_response_info.ad_source_name

        if ad_source_name == "Custom Event":
            var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
            
            if OS.get_name() == "Android":
                if adapter_class_name == "com.google.ads.mediation.sample.customevent.SampleCustomEvent":
                    ad_source_name = "Sample Ad Network (Custom Event)"
            elif OS.get_name() == "iOS":
                if adapter_class_name == "SampleCustomEvent":
                    ad_source_name = "Sample Ad Network (Custom Event)"

        return ad_source_name
    ```

=== "C#"

    ```csharp linenums="1"
    private string GetAdSourceName(AdapterResponseInfo loadedAdapterResponseInfo)
    {
        if (loadedAdapterResponseInfo == null)
        {
            return string.Empty;
        }

        string adSourceName = loadedAdapterResponseInfo.AdSourceName;

        if (adSourceName == "Custom Event")
        {
            string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;

            if (OS.GetName() == "Android")
            {
                if (adapterClassName == "com.google.ads.mediation.sample.customevent.SampleCustomEvent")
                {
                    adSourceName = "Sample Ad Network (Custom Event)";
                }
            }
            else if (OS.GetName() == "iOS")
            {
                if (adapterClassName == "SampleCustomEvent")
                {
                    adSourceName = "Sample Ad Network (Custom Event)";
                }
            }
        }
        return adSourceName;
    }
    ```

落札した広告ソースの詳細については、[広告レスポンスに関する情報の取得](response_info.ja.md)を参照してください。

## アプリ属性パートナー (AAP) との統合

広告収益データを分析プラットフォームに転送する方法の詳細については、各パートナーのガイドを参照してください。

- [Adjust](https://dev.adjust.com/en/sdk/android/integrations/admob)
- [AppsFlyer](https://support.appsflyer.com/hc/en-us/articles/4416353506833-Integrate-the-ROI360-ad-revenue-SDK-API)
- [Singular](https://support.singular.net/hc/en-us/articles/360037635452-Unity-SDK-Basic-Integration#42_Adding_Ad_Revenue_Attribution_Support)
- [Tenjin](https://tenjin.com/docs/en/send-events/android.html#impression-level-ad-revenue-integration)

## 実装のベストプラクティス

- 広告オブジェクトを作成またはアクセスできたら、すぐに、かつ広告を表示する前に `on_ad_paid`（`OnAdPaid`）イベントを設定してください。これにより、コールバックの漏れを防ぐことができます。
- `on_ad_paid` ハンドラ内で、インプレッション レベルの広告収益情報を直ちにお好みの分析サーバーに送信してください。これにより、コールバックの偶発的なドロップを防ぎ、データの不一致を回避できます。

## AdValue

!!! tip "キーポイント"
    `AdValue` の値は、各広告の価値を表すマイクロ値（Micro Value）です。たとえば、値が 5,000 の場合、その広告の推定価値は $0.005 であることを示します。

| `AdValue.PrecisionType` | 説明 |
|---|---|
| `UNKNOWN` | 精度が不明な広告値。 |
| `ESTIMATED` | 集計データから推定された広告値。 |
| `PUBLISHER_PROVIDED` | メディエーション グループ内の手動 CPM など、パブリッシャーから提供された広告値。 |
| `PRECISE` | この広告に対して支払われた正確な値。 |

メディエーションの場合、AdMob は[最適化](https://support.google.com/admob/answer/7374110)された広告ソースに対して `ESTIMATED` 値を提供しようとします。最適化されていない広告ソースや、有意義な推定値を報告するのに十分な集計データがない場合は、`PUBLISHER_PROVIDED` 値が返されます。

## 入札広告ソースからのテストインプレッション

テストリクエストを介して入札広告ソースのインプレッション レベル広告収益イベントが発生した場合、次の値のみを受け取ります。

- `UNKNOWN`: 精度タイプを示します。
- `0`: 広告値を示します。

以前は、精度タイプが `UNKNOWN` 以外の値として表示され、広告値が 0 より大きい値として表示されていた場合があります。

テスト広告リクエストの送信に関する詳細については、[テストデバイスの有効化](../enable_test_ads.md)を参照してください。
