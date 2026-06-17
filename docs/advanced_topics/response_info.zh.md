# 检索有关广告响应的信息

出于调试和记录日志的目的，成功加载的广告会提供一个 `ResponseInfo` 对象。此对象包含已加载广告的信息，以及用于加载广告的中介瀑布流（mediation waterfall）信息。

在广告成功加载并且展示已付费的情况下，可以通过 `on_ad_paid` 回调返回的 `AdValue.response_info`（C# 中为 `AdValue.ResponseInfo`）属性来获取响应信息。此外，特别是针对 `AppOpenAd`，您可以通过 `get_response_info()`（C# 中为 `GetResponseInfo()`）方法来检索它。

在广告加载失败且仅有错误可用的情况下，可以通过 `LoadAdError.response_info`（C# 中为 `LoadAdError.ResponseInfo`）获取响应信息。

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


## Response Info

以下是已加载广告返回的示例数据（JSON 格式）：

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

`ResponseInfo` 对象上的属性包括：

| 属性 | 描述 |
| -------- | ----------- |
| `adapter_responses` (`AdapterResponses`) | 返回 `AdapterResponseInfo` 列表，其中包含广告响应中包含的每个适配器的元数据。可用于调试瀑布流中介和竞价的执行情况。列表的顺序与此广告请求的中介瀑布流顺序相匹配。有关更多信息，请参阅[适配器响应信息](#adapter-response-info)。 |
| `loaded_adapter_response_info` (`LoadedAdapterResponseInfo`) | 返回加载了广告的适配器所对应的 `AdapterResponseInfo`。 |
| `mediation_adapter_class_name` (`MediationAdapterClassName`) | 返回加载了广告的广告源的中介适配器类名。 |
| `response_id` (`ResponseId`) | 响应标识符是广告响应的唯一标识符。此标识符可用于在广告评审中心 (ARC) 中识别和屏蔽该广告。 |
| `response_extras` (`ResponseExtras`) | 返回有关广告响应的附加信息。附加信息可能会返回以下键：<br> - `mediation_group_name`：中介组的名称 <br> - `mediation_ab_test_name`：中介 A/B 测试的名称（如适用） <br> - `mediation_ab_test_variant`：中介 A/B 测试中使用的变体（如适用） |

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

## 适配器响应信息 {: #adapter-response-info }

`AdapterResponseInfo` 包含广告响应中单个广告源的响应信息。

以下示例 `AdapterResponseInfo` 输出显示了已加载广告的元数据：

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

对于每个广告源，`AdapterResponseInfo` 提供以下属性：

| 属性 | 描述 |
| -------- | ----------- |
| `ad_error` (`AdError`) | 获取与向该广告源发起请求相关的错误。如果广告源成功加载了广告或未尝试请求该广告源，则返回 `null`。 |
| `ad_source_id` (`AdSourceId`) | 获取与此适配器响应相关联的广告源 ID。对于广告系列，如果是非直接购买（mediated ads）广告系列的目标类型，将返回 `6060308706800320801`；如果是展示和点击目标类型，将返回 `7068401028668408324`。 |
| `ad_source_instance_id` (`AdSourceInstanceId`) | 获取与此适配器响应相关联的广告源实例 ID。 |
| `ad_source_instance_name` (`AdSourceInstanceName`) | 获取与此适配器响应相关联的广告源实例名称。 |
| `ad_source_name` (`AdSourceName`) | 获取与此适配器响应相关联的广告源名称。对于广告系列，如果是非直接购买广告系列的目标类型，将返回 `Mediated House Ads`；如果是展示和点击目标类型，将返回 `Reservation Campaign`。 |
| `adapter_class_name` (`AdapterClassName`) | 获取加载广告的广告源适配器的类名。 |
| `ad_unit_mapping` (`AdUnitMapping`) | 获取在 AdMob UI 中指定的广告源适配器凭据。 |
| `latency_millis` (`LatencyMillis`) | 获取广告源适配器加载广告所花费的时间（以毫秒为单位）。如果未尝试请求该广告源，则返回 `0`。 |

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
