# API 参考

此页面列出了 Godot AdMob 插件提供的类、枚举和回调。

## 类

| 类 | 描述 |
| :--- | :--- |
| [MobileAds](classes/MobileAds.zh.md) | 全局配置和 SDK 初始化入口点。 |
| [RequestConfiguration](classes/RequestConfiguration.zh.md) | 全局应用于所有广告请求的配置设置。 |
| [AdRequest](classes/AdRequest.zh.md) | 用于加载广告的请求参数。 |
| [AdSize](classes/AdSize.zh.md) | 横幅广告的宽度和高度定义。 |
| [AdPosition](classes/AdPosition.zh.md) | 横幅广告和原生覆盖广告的屏幕对齐布局。 |
| [AdView](classes/AdView.zh.md) | 一个用于加载和显示横幅广告的 Godot 节点。 |
| [AdVideoController](classes/AdVideoController.zh.md) | 原生广告内的视频播放控制器。 |
| [AdVideoOptions](classes/AdVideoOptions.zh.md) | 原生广告内视频元素的播放行为。 |
| [AppOpenAd](classes/AppOpenAd.zh.md) | 当用户打开应用时显示的满屏广告格式。 |
| [AppOpenAdLoader](classes/AppOpenAdLoader.zh.md) | 负责获取开屏广告的加载器类。 |
| [InterstitialAd](classes/InterstitialAd.zh.md) | 全屏插屏广告格式。 |
| [InterstitialAdLoader](classes/InterstitialAdLoader.zh.md) | 负责获取插屏广告的加载器类。 |
| [RewardedAd](classes/RewardedAd.zh.md) | 全屏激励广告格式。 |
| [RewardedAdLoader](classes/RewardedAdLoader.zh.md) | 负责获取激励广告的加载器类。 |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.zh.md) | 激励插屏广告格式（半透明覆盖层）。 |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.zh.md) | 负责获取激励插屏广告的加载器类。 |
| [NativeOverlayAd](classes/NativeOverlayAd.zh.md) | 覆盖在 Godot 场景之上的原生广告格式。 |
| [NativeAdOptions](classes/NativeAdOptions.zh.md) | 渲染原生覆盖广告的偏好设置。 |
| [NativeTemplateStyle](classes/NativeTemplateStyle.zh.md) | 原生覆盖广告的视觉样式模板。 |
| [NativeTemplateTextStyle](classes/NativeTemplateTextStyle.zh.md) | 文本元素的字体和颜色配置。 |
| [ResponseInfo](classes/ResponseInfo.zh.md) | 包含已加载广告的元数据和适配器响应信息。 |
| [AdapterResponseInfo](classes/AdapterResponseInfo.zh.md) | 来自特定中介网络适配器的元数据。 |
| [AdError](classes/AdError.zh.md) | 关于广告展示期间发生错误的信息。 |
| [LoadAdError](classes/LoadAdError.zh.md) | 关于广告加载期间发生错误的信息。 |
| [MediaContent](classes/MediaContent.zh.md) | 表示原生广告的媒体资产（视频/图像）。 |
| [AdValue](classes/AdValue.zh.md) | 表示广告展示的货币价值。 |
| [RewardedItem](classes/RewardedItem.zh.md) | 表示用户获得的奖励（数量和类型）。 |
| [InitializationStatus](classes/InitializationStatus.zh.md) | 包含 MobileAds 的初始化状态详细信息。 |
| [AdapterStatus](classes/AdapterStatus.zh.md) | 表示单个中介适配器的初始化状态。 |
| [ServerSideVerificationOptions](classes/ServerSideVerificationOptions.zh.md) | 服务器端激励回调的安全配置。 |
| [UserMessagingPlatform](classes/UserMessagingPlatform.zh.md) | GDPR 和隐私同意流程的入口点。 |
| [ConsentInformation](classes/ConsentInformation.zh.md) | 检查并更新用户的同意状态。 |
| [ConsentForm](classes/ConsentForm.zh.md) | 可以显示给用户的同意表单。 |
| [ConsentRequestParameters](classes/ConsentRequestParameters.zh.md) | 请求同意信息更新的参数。 |
| [ConsentDebugSettings](classes/ConsentDebugSettings.zh.md) | 同意流程的测试配置。 |
| [FormError](classes/FormError.zh.md) | 同意表单操作的错误信息。 |

## 枚举

| 枚举 | 描述 |
| :--- | :--- |
| [AdPosition](enums/AdPosition.zh.md) | 横幅和原生覆盖广告的屏幕对齐预设值。 |
| [AdChoicesPlacement](enums/AdChoicesPlacement.zh.md) | AdChoices 图标的角落放置位置。 |
| [NativeMediaAspectRatio](enums/NativeMediaAspectRatio.zh.md) | 原生广告的媒体宽高比偏好。 |
| [NativeTemplateFontStyle](enums/NativeTemplateFontStyle.zh.md) | 原生广告文本字段的排版字体粗细。 |
| [AdValue.PrecisionType](enums/AdValue.PrecisionType.zh.md) | 广告收入价值的精确级别。 |
| [AdapterStatus.InitializationState](enums/AdapterStatus.InitializationState.zh.md) | 指示中介适配器是否准备就绪。 |
| [RequestConfiguration.TagForChildDirectedTreatment](enums/RequestConfiguration.TagForChildDirectedTreatment.zh.md) | 儿童导向处理以符合 COPPA 合规性。 |
| [RequestConfiguration.TagForUnderAgeOfConsent](enums/RequestConfiguration.TagForUnderAgeOfConsent.zh.md) | 同意年龄以下的处理以符合 GDPR 合规性。 |
| [DebugGeography](enums/DebugGeography.zh.md) | 用于测试同意流程的调试地理位置。 |
| [ConsentInformation.ConsentStatus](enums/ConsentInformation.ConsentStatus.zh.md) | 隐私法规的用户同意状态。 |
| [ConsentInformation.PrivacyOptionsRequirementStatus](enums/ConsentInformation.PrivacyOptionsRequirementStatus.zh.md) | 是否需要隐私选项。 |

## 接口 / 回调

| 回调 | 描述 |
| :--- | :--- |
| [OnInitializationCompleteListener](listeners/OnInitializationCompleteListener.zh.md) | SDK 初始化完成时触发的回调。 |
| [AdListener](listeners/AdListener.zh.md) | 接收横幅和覆盖广告事件。 |
| [FullScreenContentCallback](listeners/FullScreenContentCallback.zh.md) | 接收全屏格式的展示事件。 |
| [OnUserEarnedRewardListener](listeners/OnUserEarnedRewardListener.zh.md) | 当用户获得奖励时接收事件。 |
| [AppOpenAdLoadCallback](listeners/AppOpenAdLoadCallback.zh.md) | 处理开屏广告的加载结果。 |
| [InterstitialAdLoadCallback](listeners/InterstitialAdLoadCallback.zh.md) | 处理插屏广告的加载结果。 |
| [RewardedAdLoadCallback](listeners/RewardedAdLoadCallback.zh.md) | 处理激励广告的加载结果。 |
| [RewardedInterstitialAdLoadCallback](listeners/RewardedInterstitialAdLoadCallback.zh.md) | 处理激励插屏广告的加载结果。 |
| [VideoLifecycleCallbacks](listeners/VideoLifecycleCallbacks.zh.md) | 接收原生广告的视频播放生命周期事件。 |
| [AdInspectorClosedListener](listeners/AdInspectorClosedListener.zh.md) | 当原生广告检查器关闭时触发。 |
