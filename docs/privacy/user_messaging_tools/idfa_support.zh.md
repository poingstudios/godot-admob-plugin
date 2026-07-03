# IDFA 支持

本指南概述了作为 UMP SDK 的一部分支持 IDFA 消息所需的步骤。它旨在与[入门指南](get_started.zh.md)结合使用，该指南概述了如何使用 UMP SDK 运行您的应用以及设置消息的基础知识。以下指南专门针对 IDFA 消息。

!!! note

    如果您同时启用了 GDPR 和 IDFA 消息，请参阅[您的用户将看到哪条消息](https://support.google.com/admob/answer/10115027#which_message)以了解可能的结果。

本文档基于：

- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/privacy/idfa)

## 前提条件

- 完成[入门指南](get_started.zh.md)
- 创建 [IDFA 消息](https://support.google.com/admob/answer/10115331)。

## 更新 Info.plist

如果您计划使用 UMP SDK 来处理 Apple 的应用跟踪透明度 (ATT) 要求，请确保您已在 AdMob UI 中创建、配置并发布了您的 [IDFA 说明消息](https://support.google.com/admob/answer/10115027)。

为了使 UMP SDK 能够在 iOS 系统对话框中显示自定义提醒消息，请更新您的 `Info.plist`，添加 `NSUserTrackingUsageDescription` 键，并提供描述您用途的自定义消息字符串。

```xml
<key>NSUserTrackingUsageDescription</key>
<string>此标识符将用于向您投放个性化广告。</string>
```

当您展示同意表单时，该使用说明将作为 ATT 对话框的一部分显示：

![idfa-alert](https://developers.google.com/static/admob/ump/images/idfa-alert.png)

然后，链接 `AppTrackingTransparency` 框架：

![link-att-framework](https://developers.google.com/static/admob/ump/images/link-att-framework.png)

就是这样！您的应用现在将在 IDFA ATT 对话框之前显示 IDFA 说明消息。

### 测试

在测试时，请记住 IDFA ATT 对话框仅出现一次，因为 [`requestTrackingAuthorization`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/requesttrackingauthorization(completionhandler:)) 是一次性请求。UMP SDK 仅在授权状态为 [`ATTrackingManagerAuthorizationStatusNotDetermined`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/notdetermined?language=objc) 时才会有可用的表单加载。

要使该提醒出现第二次，您必须在测试设备上卸载并重新安装您的应用。
