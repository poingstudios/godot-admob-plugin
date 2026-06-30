# Google Play 数据披露

2021年5月，Google Play [宣布了新的数据安全部分](https://android-developers.googleblog.com/2021/05/new-safety-section-in-google-play-will.html)，这是开发者提供的关于应用数据收集、共享和安全实践的披露。

此页面可帮助您完成关于使用 Godot AdMob 插件的数据披露要求。在此页面上，您可以找到关于 Google Mobile Ads SDK 是否以及如何处理终端用户数据的信息，包括您作为应用开发者可以控制的任何适用设置或配置。

!!! note
    **重要**：作为应用开发者，您有责任决定如何响应 Google Play 数据安全部分表单中关于您应用数据收集、共享和安全实践的问题。

本文档基于：

- [Google Mobile Ads SDK for Android - Google Play 数据披露](https://developers.google.com/admob/android/privacy/play-data-disclosure)

## 如何使用此页面上的信息

此页面列出了 Google Mobile Ads SDK 最新版本收集的终端用户数据。如果您使用的是早期版本，请考虑更新到最新版本以确保您的应用披露准确。

要完成数据披露，您可以使用 Android 的[数据类型指南](https://developer.android.com/guide/topics/data/collect-share)来帮助确定哪些数据类型和目的最适合描述收集的数据。在数据披露中，请确保还考虑您的特定应用如何共享和使用收集的数据。

## 自动收集和共享的数据

Google Mobile Ads SDK *自动*收集和共享以下数据类型，用于广告、分析和防欺诈目的。

| 数据 | 默认情况下，Google Mobile Ads SDK... |
|------|---------------------------------------|
| **IP 地址** | 收集设备的 IP 地址，可用于估计设备的大致位置。 |
| **用户产品交互** | 收集用户产品交互和交互信息，包括应用启动、点击和视频观看。 |
| **诊断信息** | 收集与应用和 SDK 性能相关的信息，包括应用启动时间、挂起率和能源使用情况。 |
| **设备和帐户标识符** | 收集 [Android 广告 ID](https://support.google.com/googleplay/android-developer/answer/6048248)、[应用集 ID](https://developer.android.com/training/articles/app-set-id)，以及（如适用）与设备上登录帐户相关的其他标识符。 |

Google Mobile Ads SDK 收集的所有用户数据在传输时都使用传输层安全（TLS）协议加密。

## 数据处理

Android 广告 ID 收集是可选的。用户可以使用 Android 设置菜单中的广告 ID 控制重置或删除广告 ID。作为应用开发者，您可以通过[更新应用的清单文件](https://support.google.com/googleplay/android-developer/answer/6048248)来防止广告 ID 的收集。

Google Mobile Ads SDK 中的某些其他功能（如 [Limited Ads](https://support.google.com/admob/answer/10105530) 功能）也可能禁用广告 ID 和其他数据的传输。

## 根据您的使用情况收集和共享的数据

如果您使用涉及额外数据的可选产品功能（如高级报告）或参与涉及额外数据的新产品功能测试，请确保检查这些功能或测试是否需要额外的数据披露。

## 其他有用的资源

- 宣布 Google Play Console 中数据安全表单的[博客文章](https://android-developers.googleblog.com/2021/10/launching-data-safety-in-play-console.html)。
- Play Console 的数据安全表单可在[应用内容](https://play.google.com/console/developers/app/app-content/summary)页面上找到。
