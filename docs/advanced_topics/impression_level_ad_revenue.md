# Impression-Level Ad Revenue

When an impression occurs, Godot AdMob Plugin provides ad revenue data associated with that impression. You can use the data to calculate a user's lifetime value, or forward the data downstream to other relevant systems.

This guide is intended to help you implement the impression-level ad revenue data capture in your Godot project.

## Prerequisites
- Make sure you have [turned on the impression-level ad revenue feature](https://support.google.com/admob/answer/11322405) in the AdMob UI.
- Complete [Get Started](../README.md). Your Godot project should already have the Poing Studios AdMob plugin imported and configured.
- Before you can receive any impression-level ad revenue data, you need to implement at least one ad format:
    - [App open](../ad_formats/app_open.md)
    - [Banner](../ad_formats/banner/get_started.md)
    - [Interstitial](../ad_formats/interstitial.md)
    - [Rewarded](../ad_formats/rewarded.md)
    - [Rewarded interstitial](../ad_formats/rewarded_interstitial.md)
    - [Native](../ad_formats/native_overlay.md)

## Implementing a paid event handler

Each ad format has an `on_ad_paid` (`OnAdPaid` in C#) event. During the lifecycle of an ad event, the Godot AdMob Plugin monitors impression events and invokes the handler with an `AdValue` representing the earned value.

The following example handles paid events for a rewarded ad:

=== "GDScript"

    ```gdscript
    var _rewarded_ad: RewardedAd

    func _load_rewarded_ad() -> void:
        # Send the request to load the ad.
        var ad_request := AdRequest.new()
        RewardedAdLoader.new().load("AD_UNIT_ID", ad_request, func(rewarded_ad: RewardedAd, error: LoadAdError):
            # If the operation failed with a reason.
            if error != null:
                push_error("Rewarded ad failed to load an ad with error: %s" % error.message)
                return
            
            _rewarded_ad = rewarded_ad
            _rewarded_ad.on_ad_paid = _handle_ad_paid_event
        )

    func _handle_ad_paid_event(ad_value: AdValue) -> void:
        # TODO: Send the impression-level ad revenue information to your
        # preferred analytics server directly within this callback.

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
        // Send the request to load the ad.
        AdRequest adRequest = new AdRequest();
        RewardedAdLoader.Load("AD_UNIT_ID", adRequest, (rewardedAd, error) =>
        {
            // If the operation failed with a reason.
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
        // TODO: Send the impression-level ad revenue information to your
        // preferred analytics server directly within this callback.

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

## Identify a custom event ad source name

For custom event ad sources, the `ad_source_name` (`AdSourceName`) property gives you the ad source name Custom Event. If you use multiple custom events, the ad source name isn't granular enough to distinguish between multiple custom events. To locate a specific custom event, do the following steps:

1. Get the `adapter_class_name` (`AdapterClassName`) property.
2. Set a unique ad source name.

The following example sets a unique ad source name for a custom event:

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

For more information on the winning ad source, see [Retrieve information about the ad response](response_info.md).

## Integrate with App Attribution Partners (AAP)

For complete details on forwarding ad revenue data to analytics platforms, refer to the partner's guide:

- [Adjust](https://dev.adjust.com/en/sdk/android/integrations/admob)
- [AppsFlyer](https://support.appsflyer.com/hc/en-us/articles/4416353506833-Integrate-the-ROI360-ad-revenue-SDK-API)
- [Singular](https://support.singular.net/hc/en-us/articles/360037635452-Unity-SDK-Basic-Integration#42_Adding_Ad_Revenue_Attribution_Support)
- [Tenjin](https://tenjin.com/docs/en/send-events/android.html#impression-level-ad-revenue-integration)

## Implementation best practices

- Set the `on_ad_paid` (`OnAdPaid`) event immediately once you create or get access to the ad object, and definitely before showing the ad. This makes sure that you don't miss any callbacks.
- Send the impression-level ad revenue information to your preferred analytics server immediately in your `on_ad_paid` handler. This makes sure that you don't accidentally drop any callbacks and avoids data discrepancies.

## AdValue

!!! tip "Key Point"
    The value of `AdValue` is a micro value that represents each ad's worth. For example, a value of 5,000 indicates that this ad is estimated to be worth $0.005.

| `AdValue.PrecisionType` | Description |
|---|---|
| `UNKNOWN` | An ad value with unknown precision. |
| `ESTIMATED` | An ad value estimated from aggregated data. |
| `PUBLISHER_PROVIDED` | A publisher-provided ad value, such as manual CPMs in a mediation group. |
| `PRECISE` | The precise value paid for this ad. |

In case of mediation, AdMob tries to provide an `ESTIMATED` value for ad sources that are [optimized](https://support.google.com/admob/answer/7374110). For non-optimized ad sources, or in cases where there aren't enough aggregated data to report a meaningful estimation, the `PUBLISHER_PROVIDED` value is returned.

## Test impressions from bidding ad sources

After an impression-level ad revenue event occurs for a bidding ad source through a test request, you receive only the following values:

- `UNKNOWN`: indicates the precision type.
- `0`: indicates the ad value.

Previously, you might have seen the precision type as a value other than `UNKNOWN` and an ad value more than 0.

For details on sending a test ad request, see [Enable test devices](../enable_test_ads.md).

