# GDPR IAB 支持

本指南概述了作为 UMP SDK 的一部分支持 GDPR IAB TCF v2 消息所需的步骤。它旨在与[入门指南](get_started.zh.md)结合使用，该指南概述了如何使用 UMP SDK 运行您的应用以及设置消息的基础知识。以下指南专门针对 GDPR IAB TCF v2 消息。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/privacy/gdpr)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/privacy/gdpr)

## 前提条件

- 完成[入门指南](get_started.zh.md)
- 创建[适用于应用的 GDPR 消息](https://support.google.com/admob/answer/10113207)。

## 延迟应用测量 (Delay app measurement)

默认情况下，Google Mobile Ads SDK 会在应用启动时立即初始化应用测量并开始向 Google 发送用户级事件数据。此初始化行为确保您无需进行额外的代码修改即可启用 AdMob 用户指标。

但是，如果您的应用在发送这些事件之前需要用户同意，您可以将应用测量延迟，直到您显式[初始化 Mobile Ads SDK](../../index.zh.md) 或加载广告。

=== "Android"
    要延迟应用测量，请在您的 `res://android/build/AndroidManifest.xml` 中添加以下 `<meta-data>` 标签。
    ```xml
    <manifest>
        <application>
        <!-- 延迟应用测量，直到调用 MobileAds.initialize()。 -->
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        </application>
    </manifest>
    ```

=== "iOS"
    要延迟应用测量，请在您导出的 Xcode 项目的应用 `Info.plist` 中，添加 `GADDelayAppMeasurementInit` 键，布尔值为 `YES`。您可以以编程方式进行此更改：

    ```xml
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    ```

## 撤销同意

[同意撤销](https://support.google.com/admob/answer/10113915) 是“隐私和消息”用户同意计划的一项要求。您必须在应用菜单中提供一个链接，允许想要撤销同意的用户执行此操作，然后再次向这些用户展示同意消息。

要实现此目的：

1. 每次用户启动应用时[加载表单](get_started.zh.md#load-a-form-if-available)，以便在用户希望更改其同意设置时，表单已准备好显示。
2. 当用户在应用菜单中选择该链接时，展示该表单。

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func present_form() -> void:
    	_consent_form.show(_on_consent_form_dismissed)
    	
    func _on_consent_form_dismissed(form_error : FormError):
    	# 通过重新加载表单来处理关闭事件。
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void PresentForm()
    {
        _consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        // 通过重新加载表单来处理关闭事件。
        LoadForm();
    }
    ```

## 中介
按照[在已发布的 GDPR 消息中添加广告合作伙伴](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)中的步骤，将您的中介合作伙伴添加到广告合作伙伴列表中。否则可能会导致合作伙伴无法在您的应用上投放广告。

中介合作伙伴可能也有其他工具来帮助遵守 GDPR。欲了解更多详情，请参阅特定合作伙伴的[集成指南](../../mediate/get_started.zh.md)。


## 故障排除

**错误 3.3：TC 字符串的上次更新日期是 13 个月前**

- 必须向用户[重新获得同意](https://support.google.com/admob/answer/9999955#grace-period-2)。您应该在每次启动应用会话时调用 `UserMessagingPlatform.consent_information.update()`。如果 TC 字符串已过期，UMP SDK 会通过将 `ConsentInformation.ConsentStatus` 设置为 `ConsentInformation.ConsentStatus.REQUIRED` 来指示必须重新获取同意。如果尚未实现，请在应用中实现[加载和展示新 UMP 表单](get_started.zh.md#present-the-form-if-required)的请求。

- TC 字符串有可能会在会话中期过期，从而导致少量的 `3.3` 错误。如果在使用 `UserMessagingPlatform.consent_information.update()` 进行检查的同时开始加载广告，这些广告请求也可能会给出 `3.3` 错误，直到 `UserMessagingPlatform.consent_information.update()` 完成。但这应该占整体 `3.3` 错误中极小的比例（小于 0.1%）。
