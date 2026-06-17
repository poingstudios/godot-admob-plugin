# 広告レスポンスに関する情報の取得

デバッグおよびログ出力のために、正常にロードされた広告は `ResponseInfo` オブジェクトを提供します。このオブジェクトには、ロードされた広告に関する情報のほか、その広告のロードに使用されたメディエーションのウォーターフォールに関する情報が含まれています。

広告が正常にロードされ、インプレッション料金が支払われた場合、`on_ad_paid` コールバックから返される `AdValue.response_info`（C# では `AdValue.ResponseInfo`）プロパティを介してレスポンス情報を取得できます。また、`AppOpenAd` の場合は、`get_response_info()`（C# では `GetResponseInfo()`）メソッドを介して直接取得することもできます。

広告のロードに失敗し、エラーのみが発生した場合は、`LoadAdError.response_info`（C# では `LoadAdError.ResponseInfo`）を介してレスポンス情報を取得できます。

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var response_info: ResponseInfo = ad_value.response_info
        print(response_info)

    func _on_interstitial_ad_failed_to_load(load_ad_error: LoadAdError) -> void:
        var response_info: ResponseInfo = load_ad_error.response_info
        print(response_info)
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdPaid(AdValue adValue)
    {
        ResponseInfo responseInfo = adValue.ResponseInfo;
        GD.Print(responseInfo);
    }

    private void OnInterstitialAdFailedToLoad(LoadAdError loadAdError)
    {
        ResponseInfo responseInfo = loadAdError.ResponseInfo;
        GD.Print(responseInfo);
    }
    ```


## レスポンス情報 (Response Info)

ロードされた広告に対して返されるサンプルデータ（JSON 表現）は以下のとおりです。

```json
{
  "response_id": "COOllLGxlPoCFdAx4Aod-Q4A0g",
  "mediation_adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
  "adapter_responses": {
    "0": {
      "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
      "latency_millis": 328,
      "ad_source_name": "Reservation campaign",
      "ad_source_id": "7068401028668408324",
      "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
      "ad_source_instance_id": "4665218928925097",
      "ad_unit_mapping": {},
      "ad_error": {}
    }
  },
  "loaded_adapter_response_info": {
    "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
    "latency_millis": 328,
    "ad_source_name": "Reservation campaign",
    "ad_source_id": "7068401028668408324",
    "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
    "ad_source_instance_id": "4665218928925097",
    "ad_unit_mapping": {},
    "ad_error": {}
  },
  "response_extras": {
    "mediation_group_name": "Campaign"
  }
}
```

`ResponseInfo` オブジェクトのプロパティは以下のとおりです。

| プロパティ | 説明 |
| -------- | ----------- |
| `adapter_responses` (`AdapterResponses`) | 広告レスポンスに含まれる各アダプターのメタデータを含む `AdapterResponseInfo` のリストを返します。ウォーターフォール メディエーションおよび入札の実行のデバッグに使用できます。リストの順序は、この広告リクエストのメディエーション ウォーターフォールの順序と一致します。詳細については、[アダプター応答情報](#adapter-response-info)を参照してください。 |
| `loaded_adapter_response_info` (`LoadedAdapterResponseInfo`) | 広告をロードしたアダプターに対応する `AdapterResponseInfo` を返します。 |
| `mediation_adapter_class_name` (`MediationAdapterClassName`) | 広告をロードした広告ソースのメディエーション アダプター クラス名を返します。 |
| `response_id` (`ResponseId`) | 広告レスポンスの一意の識別子。この識別子は、広告レビュー センター（ARC）で広告を特定し、ブロックするために使用できます。 |
| `response_extras` (`ResponseExtras`) | 広告レスポンスに関する追加の情報を返します。追加情報には、次のキーが含まれる場合があります。<br> - `mediation_group_name`: メディエーション グループ名 <br> - `mediation_ab_test_name`: メディエーション A/B テスト名（該当する場合） <br> - `mediation_ab_test_variant`: メディエーション A/B テストのバリアント（該当する場合） |

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var response_info := interstitial_ad.get_response_info()

        var response_id: String = response_info.response_id
        var mediation_adapter_class_name: String = response_info.mediation_adapter_class_name
        var adapter_responses: Array[AdapterResponseInfo] = response_info.adapter_responses
        var loaded_adapter_response_info: AdapterResponseInfo = response_info.loaded_adapter_response_info
        var extras: Dictionary = response_info.response_extras
        
        var mediation_group_name = extras.get("mediation_group_name", "")
        var mediation_ab_test_name = extras.get("mediation_ab_test_name", "")
        var mediation_ab_test_variant = extras.get("mediation_ab_test_variant", "")
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdLoaded(InterstitialAd interstitialAd)
    {
        ResponseInfo responseInfo = interstitialAd.ResponseInfo;

        string responseId = responseInfo.ResponseId;
        string mediationAdapterClassName = responseInfo.MediationAdapterClassName;
        System.Collections.Generic.List<AdapterResponseInfo> adapterResponses = responseInfo.AdapterResponses;
        AdapterResponseInfo loadedAdapterResponseInfo = responseInfo.LoadedAdapterResponseInfo;
        Godot.Collections.Dictionary extras = responseInfo.ResponseExtras;
        
        string mediationGroupName = extras.ContainsKey("mediation_group_name") ? extras["mediation_group_name"].ToString() : "";
        string mediationABTestName = extras.ContainsKey("mediation_ab_test_name") ? extras["mediation_ab_test_name"].ToString() : "";
        string mediationABTestVariant = extras.ContainsKey("mediation_ab_test_variant") ? extras["mediation_ab_test_variant"].ToString() : "";
    }
    ```

## アダプター応答情報 {: #adapter-response-info }

`AdapterResponseInfo` には、広告レスポンス内の個々の広告ソースに対する応答情報が含まれています。

ロードされた広告のメタデータを示す `AdapterResponseInfo` の出力例は以下のとおりです。

```json
{
  "adapter_class_name": "com.google.ads.mediation.admob.AdMobAdapter",
  "latency_millis": 328,
  "ad_source_name": "Reservation campaign",
  "ad_source_id": "7068401028668408324",
  "ad_source_instance_name": "[DO NOT EDIT] Publisher Test Interstitial",
  "ad_source_instance_id": "4665218928925097",
  "ad_unit_mapping": {},
  "ad_error": {}
}
```

各広告ソースに対して、`AdapterResponseInfo` は以下のプロパティを提供します。

| プロパティ | 説明 |
| -------- | ----------- |
| `ad_error` (`AdError`) | 広告ソースへのリクエストに関連付けられたエラーを取得します。広告ソースが正常に広告をロードした場合、または広告ソースが試行されなかった場合は `null` を返します。 |
| `ad_source_id` (`AdSourceId`) | このアダプター応答に関連付けられた広告ソース ID を取得します。キャンペーンの場合、メディエーション広告キャンペーンの目標タイプに対しては `6060308706800320801` が返され、インプレッションおよびクリックの目標タイプに対しては `7068401028668408324` が返されます。 |
| `ad_source_instance_id` (`AdSourceInstanceId`) | このアダプター応答に関連付けられた広告ソース インスタンス ID を取得します。 |
| `ad_source_instance_name` (`AdSourceInstanceName`) | このアダプター応答に関連付けられた広告ソース インスタンス名を取得します。 |
| `ad_source_name` (`AdSourceName`) | このアダプター応答に関連付けられた広告ソース名を取得します。キャンペーンの場合、メディエーション広告キャンペーンの目標タイプに対しては `Mediated House Ads` が返され、インプレッションおよびクリックの目標タイプに対しては `Reservation Campaign` が返されます。 |
| `adapter_class_name` (`AdapterClassName`) | 広告をロードした広告ソース アダプターのクラス名を取得します。 |
| `ad_unit_mapping` (`AdUnitMapping`) | AdMob UI で指定された広告ソース アダプターの認証情報を取得します。 |
| `latency_millis` (`LatencyMillis`) | 広告ソース アダプターが広告のロードに費やした時間（ミリ秒単位）を取得します。広告ソースが試行されなかった場合は `0` を返します。 |

=== "GDScript"

    ```gdscript
    func _on_interstitial_ad_paid(ad_value: AdValue) -> void:
        var loaded_adapter_response_info := interstitial_ad.get_response_info().loaded_adapter_response_info

        var ad_error: AdError = loaded_adapter_response_info.ad_error
        var ad_source_id: String = loaded_adapter_response_info.ad_source_id
        var ad_source_instance_id: String = loaded_adapter_response_info.ad_source_instance_id
        var ad_source_instance_name: String = loaded_adapter_response_info.ad_source_instance_name
        var ad_source_name: String = loaded_adapter_response_info.ad_source_name
        var adapter_class_name: String = loaded_adapter_response_info.adapter_class_name
        var ad_unit_mapping: Dictionary = loaded_adapter_response_info.ad_unit_mapping
        var latency_millis: int = loaded_adapter_response_info.latency_millis
    ```

=== "C#"

    ```csharp
    private void OnInterstitialAdPaid(AdValue adValue)
    {
        AdapterResponseInfo loadedAdapterResponseInfo = interstitialAd.GetResponseInfo().LoadedAdapterResponseInfo;

        AdError adError = loadedAdapterResponseInfo.AdError;
        string adSourceId = loadedAdapterResponseInfo.AdSourceId;
        string adSourceInstanceId = loadedAdapterResponseInfo.AdSourceInstanceId;
        string adSourceInstanceName = loadedAdapterResponseInfo.AdSourceInstanceName;
        string adSourceName = loadedAdapterResponseInfo.AdSourceName;
        string adapterClassName = loadedAdapterResponseInfo.AdapterClassName;
        Godot.Collections.Dictionary adUnitMapping = loadedAdapterResponseInfo.AdUnitMapping;
        int latencyMillis = loadedAdapterResponseInfo.LatencyMillis;
    }
    ```
