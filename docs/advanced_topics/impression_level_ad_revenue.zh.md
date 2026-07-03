# 展示级广告收入 (Impression-Level Ad Revenue)

当发生展示（impression）时，Godot AdMob 插件会提供与该展示关联的广告收入数据。您可以使用该数据来计算用户的生命周期价值，或将数据转发给其他相关的下游系统。

本指南旨在帮助您在 Godot 项目中实现展示级广告收入数据捕获。

## 前提条件
- 确保您已在 AdMob UI 中[开启了展示级广告收入功能](https://support.google.com/admob/answer/11322405)。
- 完成[入门指南](../index.zh.md)。您的 Godot 项目中应当已经导入并配置好了 Poing Studios AdMob 插件。
- 在接收任何展示级广告收入数据之前，您需要至少实现一种广告格式：
    - [开屏广告](../ad_formats/app_open.zh.md)
    - [横幅广告](../ad_formats/banner/get_started.zh.md)
    - [插页式广告](../ad_formats/interstitial.zh.md)
    - [激励广告](../ad_formats/rewarded.zh.md)
    - [插页式激励广告](../ad_formats/rewarded_interstitial.zh.md)
    - [原生广告](../ad_formats/native_overlay.zh.md)

## 实现付费事件处理程序

每种广告格式都有一个 `on_ad_paid`（C# 中为 `OnAdPaid`）事件。在广告事件的生命周期中，Godot AdMob 插件会监控展示事件，并使用代表所获价值的 `AdValue` 调用处理程序。

以下示例处理了激励广告的付费事件：

=== "GDScript"

    ```gdscript
    var _rewarded_ad: RewardedAd
    
    func _load_rewarded_ad() -> void:
        # 发送加载广告的请求。
        var ad_request := AdRequest.new()
        RewardedAdLoader.new().load("AD_UNIT_ID", ad_request, func(rewarded_ad: RewardedAd, error: LoadAdError):
            # 如果操作由于某种原因失败。
            if error != null:
                push_error("Rewarded ad failed to load an ad with error: %s" % error.message)
                return
            
            _rewarded_ad = rewarded_ad
            _rewarded_ad.on_ad_paid = _handle_ad_paid_event
        )
    
    func _handle_ad_paid_event(ad_value: AdValue) -> void:
        # TODO: 在此回调中直接将展示级广告收入信息发送到您首选的分析服务器。
    
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
        // 发送加载广告的请求。
        AdRequest adRequest = new AdRequest();
        RewardedAdLoader.Load("AD_UNIT_ID", adRequest, (rewardedAd, error) =>
        {
            // 如果操作由于某种原因失败。
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
        // TODO: 在此回调中直接将展示级广告收入信息发送到您首选的分析服务器。
    
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

## 识别自定义事件的广告源名称

对于自定义事件广告源，`ad_source_name`（C# 中为 `AdSourceName`）属性会向您提供广告源名称“Custom Event”。如果您使用多个自定义事件，则广告源名称不够细致，无法区分多个自定义事件。要定位特定的自定义事件，请执行以下步骤：

1. 获取 `adapter_class_name`（C# 中为 `AdapterClassName`）属性。
2. 设置唯一的广告源名称。

以下示例为自定义事件设置了唯一的广告源名称：

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

有关胜出广告源的更多信息，请参阅[检索有关广告响应的信息](response_info.zh.md)。

## 与应用归因合作伙伴 (AAP) 集成

有关将广告收入数据转发到分析平台的完整详细信息，请参阅合作伙伴指南：

- [Adjust](https://dev.adjust.com/en/sdk/android/integrations/admob)
- [AppsFlyer](https://support.appsflyer.com/hc/en-us/articles/4416353506833-Integrate-the-ROI360-ad-revenue-SDK-API)
- [Singular](https://support.singular.net/hc/en-us/articles/360037635452-Unity-SDK-Basic-Integration#42_Adding_Ad_Revenue_Attribution_Support)
- [Tenjin](https://tenjin.com/docs/en/send-events/android.html#impression-level-ad-revenue-integration)

## 实现最佳实践

- 在您创建或获得广告对象访问权限后立即设置 `on_ad_paid`（C# 中为 `OnAdPaid`）事件，并且绝对要在展示广告之前设置。这可以确保您不会漏掉任何回调。
- 立即在您的 `on_ad_paid` 处理程序中将展示级广告收入信息发送给您首选的分析服务器。这可以确保您不会意外丢失任何回调并避免数据差异。

## AdValue

!!! tip "关键点"
    `AdValue` 的值是一个微单位值（micro value），代表每次广告的价值。例如，值 5,000 表示估计该广告价值为 0.005 美元。

| `AdValue.PrecisionType` | 描述 |
|---|---|
| `UNKNOWN` | 精度未知的广告价值。 |
| `ESTIMATED` | 根据汇总数据估算出的广告价值。 |
| `PUBLISHER_PROVIDED` | 发布商提供的广告价值，例如中介组中的手动 CPM。 |
| `PRECISE` | 为该广告支付的精确价值。 |

在中介的情况下，AdMob 会尝试为已[优化](https://support.google.com/admob/answer/7374110)的广告源提供 `ESTIMATED` 值。对于未优化的广告源，或者在没有足够汇总数据来报告有意义的估算的情况下，将返回 `PUBLISHER_PROVIDED` 值。

## 来自竞价广告源的测试展示

通过测试请求触发竞价广告源的展示级广告收入事件后，您将仅收到以下值：

- `UNKNOWN`：指示精度类型。
- `0`：指示广告价值。

在以前，您看到的精度类型可能是 `UNKNOWN` 以外的值，并且广告价值大于 0。

有关发送测试广告请求的详细信息，请参阅[启用测试设备](../enable_test_ads.zh.md)。
