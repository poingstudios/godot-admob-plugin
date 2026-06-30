# Apple App Store 数据披露

Apple 要求在 App Store 上发布应用的开发者提供有关其应用数据使用的[ certain information](https://developer.apple.com/app-store/app-privacy-details/)。本指南解释了 Google Mobile Ads SDK 的数据收集实践，以帮助 AdMob 开发者回答 App Store Connect 中的问题。

!!! note
    **重要**：作为应用开发者，您有责任决定如何响应 App Store Connect 关于您应用数据收集和使用实践的隐私问题。

本文档基于：

- [Google Mobile Ads SDK for iOS - Apple App Store 数据披露](https://developers.google.com/admob/ios/privacy/data-disclosure)

## Google Mobile Ads SDK 收集的数据

为了提高 AdMob 的性能，Google Mobile Ads SDK 可能会从应用中收集某些信息，包括：

| 数据类型 | 目的 |
|----------|------|
| **IP 地址** | 可用于估计设备的大致位置。 |
| **非用户相关的崩溃日志** | 可用于诊断问题和改进 SDK。诊断信息也可能用于广告和分析目的。 |
| **用户相关的性能数据** | 如应用启动时间、挂起率或能源使用情况，可用于评估用户行为、了解现有产品功能的有效性以及规划新功能。性能数据也可用于展示广告，包括与展示广告的其他实体共享。 |
| **设备 ID** | 如设备的广告标识符或其他应用或开发者绑定的设备标识符，可用于第三方广告和分析目的。 |
| **广告数据** | 如用户看到的广告，可用于驱动分析和广告功能。 |
| **其他用户产品交互** | 如应用启动点击和交互信息（如视频观看），可用于改善广告性能。 |

Google Mobile Ads SDK 收集的所有用户数据在传输时都使用传输层安全（TLS）协议加密。

## Apple 的隐私清单文件

Google Mobile Ads SDK 11.2.0 及更高版本支持隐私清单声明。您有责任检查隐私清单并确保应用的数据披露是最新的。

有关解释隐私报告的详细信息，请参阅 [Apple 文档](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_data_use_in_privacy_manifests)。有关应用提交要求的[实施更新](https://developer.apple.com/news/?id=pvszzano)也请参阅。

## 额外数据披露

如果您使用涉及额外数据的可选产品功能（如高级报告）或参与涉及额外数据的新产品功能测试，请确保检查这些功能或测试是否需要额外的数据披露。

如果您使用的是早期版本的 Google Mobile Ads SDK，请考虑更新到最新版本以确保应用的数据披露准确。Google Mobile Ads SDK 将随着时间的推移继续更新。请务必根据需要检查和更新您的披露。
