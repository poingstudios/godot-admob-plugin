# Retrieve information about the ad response

For debugging and logging purposes, successfully loaded ads provide a `ResponseInfo` object. This object contains information about the ad it loaded, in addition to information about the mediation waterfall used to load the ad.

For cases where an ad loads successfully and an impression is paid, the response info is available through the `AdValue.response_info` (`AdValue.ResponseInfo` in C#) property returned by the `on_ad_paid` callback. Additionally, for `AppOpenAd` specifically, you can retrieve it via the `get_response_info()` (`GetResponseInfo()` in C#) method.

For cases where ads fail to load and only an error is available, the response info is available through `LoadAdError.response_info` (`LoadAdError.ResponseInfo` in C#).

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

Here is sample data (JSON representation) returned for a loaded ad:

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

Methods on the `ResponseInfo` object include the following:

| Property | Description |
| -------- | ----------- |
| `adapter_responses` (`AdapterResponses`) | Returns the list of `AdapterResponseInfo` containing metadata for each adapter included in the ad response. Can be used to debug the waterfall mediation and bidding execution. The order of the list matches the order of the mediation waterfall for this ad request. See [Adapter response info](#adapter-response-info) for more information. |
| `loaded_adapter_response_info` (`LoadedAdapterResponseInfo`) | Returns the `AdapterResponseInfo` corresponding to the adapter that loaded the ad. |
| `mediation_adapter_class_name` (`MediationAdapterClassName`) | Returns the mediation adapter class name of the ad source that loaded the ad. |
| `response_id` (`ResponseId`) | The response identifier is a unique identifier for the ad response. This identifier can be used to identify and block the ad in the Ad Review Center (ARC). |
| `response_extras` (`ResponseExtras`) | Returns extra information about the ad response. Extras may return the following keys: <br> - `mediation_group_name`: The name of the mediation group <br> - `mediation_ab_test_name`: The name of the mediation A/B test, if applicable <br> - `mediation_ab_test_variant`: The variant used in the mediation A/B test, if applicable |

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

## Adapter response info

`AdapterResponseInfo` contains response information for an individual ad source in an ad response.

The following sample `AdapterResponseInfo` output shows the metadata for a loaded ad:

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

For each ad source, `AdapterResponseInfo` provides the following properties:

| Property | Description |
| -------- | ----------- |
| `ad_error` (`AdError`) | Gets the error associated with the request to the ad source. Returns `null` if the ad source successfully loaded an ad or if the ad source was not attempted. |
| `ad_source_id` (`AdSourceId`) | Gets the ad source ID associated with this adapter response. For campaigns, `6060308706800320801` is returned for a mediated ads campaign goal type, and `7068401028668408324` is returned for impression and click goal types. |
| `ad_source_instance_id` (`AdSourceInstanceId`) | Gets the ad source instance ID associated with this adapter response. |
| `ad_source_instance_name` (`AdSourceInstanceName`) | Gets the ad source instance name associated with this adapter response. |
| `ad_source_name` (`AdSourceName`) | Gets the ad source name associated with this adapter response. For campaigns, `Mediated House Ads` is returned for a mediated ads campaign goal type, and `Reservation Campaign` is returned for impression and click goal types. |
| `adapter_class_name` (`AdapterClassName`) | Gets the class name of the ad source adapter that loaded the ad. |
| `ad_unit_mapping` (`AdUnitMapping`) | Gets the ad source adapter credentials specified in the AdMob UI. |
| `latency_millis` (`LatencyMillis`) | Gets the amount of time the ad source adapter spent loading an ad (in milliseconds). Returns `0` if the ad source was not attempted. |

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
