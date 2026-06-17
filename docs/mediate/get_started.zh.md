# 入门指南

AdMob 中介（Mediation）是一项极具价值的功能，允许您向您的应用程序投放来自各种来源的广告。这些来源包括 AdMob 网络、第三方广告网络以及 [AdMob 广告系列](https://support.google.com/admob/answer/6162747)。AdMob 中介的主要目标是优化您的填充率并增强您的变现效果。它通过将广告请求分发到多个网络来实现这一点，从而确保您的应用使用最合适的可用网络来展示广告。这种方法的优势在[案例研究](https://admob.google.com/home/resources/cookapps-grows-ad-revenue-86-times-with-admob-rewarded-ads-and-mediation/)中得到了印证。

本指南是您将中介集成到 AdMob 应用中的全方位资源。它涵盖了竞价（bidding）和瀑布流（waterfall）集成方法，为您优化广告投放策略提供完整的参考。

!!! info

    **重要提示**：在继续配置中介之前，请务必确保您拥有所需的帐号权限。这些权限包括访问广告资源管理、应用访问权限以及隐私和消息设置。欲了解更多详情，请参阅[新用户角色](https://support.google.com/admob/answer/2784628)文章。

- 在为特定广告格式集成中介之前，您必须首先将该广告格式集成到您的应用中。这些广告格式包括：
    - [横幅广告](../ad_formats/banner/get_started.zh.md)
    - [插页式广告](../ad_formats/interstitial.zh.md)
    - [激励广告](../ad_formats/rewarded.zh.md)
    - [插页式激励广告](../ad_formats/rewarded_interstitial.zh.md)

如果您对中介还不太熟悉，建议阅读 [AdMob 中介概述](https://support.google.com/admob/answer/13420272)以更好地理解该概念。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/mediate)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/mediate)

## 初始化 Mobile Ads SDK

快速入门指南提供了有关如何[初始化 Mobile Ads SDK](../index.zh.md#initialize-the-google-mobile-ads-sdk)的说明。在此初始化过程中，中介和竞价适配器（adapters）也会被初始化。在加载广告之前，务必等待此初始化完成，以确保每个广告网络都能充分参与第一次广告请求。

以下示例代码演示了如何在发起广告请求之前验证每个适配器的初始化状态。

=== "GDScript"

    ```gdscript
    extends Control
    
    func _ready() -> void:
    	var on_initialization_complete_listener := OnInitializationCompleteListener.new()
    	on_initialization_complete_listener.on_initialization_complete = _on_initialization_complete
    	MobileAds.initialize(on_initialization_complete_listener)
    	
    func _on_initialization_complete(initialization_status : InitializationStatus) -> void:
    	print("MobileAds initialization complete")
    	for key in initialization_status.adapter_status_map:
    		var adapterStatus : AdapterStatus = initialization_status.adapter_status_map[key]
    		prints(
    			"Key:", key, 
    			"Latency:", adapterStatus.latency, 
    			"Initialization Status:", adapterStatus.initialization_status, 
    			"Description:", adapterStatus.description
    		)
    		
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Listeners;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class MediationExample : Control
    {
        public override void _Ready()
        {
            var onInitializationCompleteListener = new OnInitializationCompleteListener
            {
                OnInitializationComplete = OnInitializationComplete
            };
            MobileAds.Initialize(onInitializationCompleteListener);
        }
    
        private void OnInitializationComplete(InitializationStatus initializationStatus)
        {
            GD.Print("MobileAds initialization complete");
            foreach (var kvp in initializationStatus.AdapterStatusMap)
            {
                string key = kvp.Key;
                AdapterStatus adapterStatus = kvp.Value;
                GD.Print(
                    "Key: ", key, 
                    " Latency: ", adapterStatus.Latency, 
                    " Initialization Status: ", adapterStatus.State, 
                    " Description: ", adapterStatus.Description
                );
            }
        }
    }
    ```

## 横幅广告中介
在 AdMob 中介中使用横幅广告时，必须在所有第三方广告网络的用户界面中，针对您在中介中使用的横幅广告单元停用自动刷新设置。这可以防止发生双重刷新，因为 AdMob 也会根据您横幅广告单元的预定义刷新率触发刷新。

## 激励广告中介
我们强烈建议您通过在 AdMob UI 中配置奖励值来自定义所有默认奖励值。为此，请选择**应用到中介组中的所有网络**选项，以确保奖励在所有网络中保持一致。请记住，某些广告网络可能不提供奖励值或类型。通过覆盖奖励值，无论由哪个广告网络负责投放该广告，您都能保证获得一致的奖励。
![apply_all_networks](https://developers.google.com/static/admob/images/mediation/admob_apply_all_networks.png)

有关在 AdMob UI 中设置奖励值的更多信息，请参阅创建激励广告单元。

有关如何在 AdMob UI 中设置奖励值的详细信息，请参阅[创建激励广告单元](https://support.google.com/admob/answer/7311747)文档。


## CCPA 和 GDPR

!!! warning

    **重要提示**：在继续配置欧盟地区用户同意（EU Consent）、GDPR、CCPA 和用户消息平台（User Messaging Platform）之前，请务必确保您拥有必要的“帐号管理”权限。这些权限对于管理隐私相关设置至关重要。欲获取更多信息，请参阅[新用户角色](https://support.google.com/admob/answer/2784628)文章。

如果您的应用需要遵守[加州消费者隐私法案 (CCPA)](https://support.google.com/admob/answer/9561022)或[通用数据保护条例 (GDPR)](https://support.google.com/admob/answer/7666366)，请按照 CCPA 设置或 GDPR 设置中概述的步骤，将您的中介合作伙伴添加到 AdMob“隐私和消息”的 [CCPA](https://support.google.com/admob/answer/10860309) 或 [GDPR](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages) 广告合作伙伴列表中。否则可能会导致您的合作伙伴无法在您的应用上投放广告。

欲获取进一步的了解，请探索[启用 CCPA 限制性数据处理](../privacy/regulatory_solutions/us_states_privacy_laws.md)以及[使用 Google 用户消息平台 (UMP) SDK 获取 GDPR 同意](../privacy/user_messaging_tools/get_started.zh.md)的过程。
