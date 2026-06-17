# 入门指南

根据 Google 的[欧盟地区用户同意策略](https://www.google.com/about/company/user-consent-policy/)，您必须向欧洲经济区 (EEA) 以及英国的用户进行某些披露，并在法律要求时获得他们对使用 Cookie 或其他本地存储的同意，以及对使用个人数据（例如广告 ID / AdID）投放广告的同意。此策略反映了欧盟电子隐私指令 (ePrivacy Directive) 和通用数据保护条例 (GDPR) 的要求。

为了支持发布商履行该策略下的义务，Google 提供了用户消息平台 (UMP) SDK。UMP SDK 已更新以支持最新的 IAB 标准。所有这些配置现在都可以方便地在 AdMob 的“隐私和消息”中进行处理。

本文档基于：

- [Google Mobile Ads SDK Android 官方文档](https://developers.google.com/admob/android/privacy)
- [Google Mobile Ads SDK iOS 官方文档](https://developers.google.com/admob/ios/privacy)

## 前提条件

- 完成[入门指南](../../index.zh.md)
- 如果您正在处理与 GDPR 相关的要求，请阅读[关于 IAB 要求对欧盟地区用户同意消息的影响](https://support.google.com/admob/answer/10207733)。

## 创建消息类型
在您的 AdMob 帐号的**隐私和消息**选项卡下，使用[可用的用户消息类型](https://support.google.com/admob/answer/10114020)之一创建用户消息。UMP SDK 会尝试显示根据您项目中设置的 AdMob 应用 ID 所创建的用户消息。如果没有为您的应用配置任何消息，SDK 将返回错误。

欲了解更多详情，请参阅[关于隐私和消息](https://support.google.com/admob/answer/10107561)。

## 确定是否需要显示消息
您应该在每次应用启动时，在加载表单之前使用 `update()` 请求更新用户的同意信息。这可以确定如果您的用户尚未提供同意或其同意已过期，他们是否需要提供同意。

当需要时，使用在您[展示表单](#present-the-form-if-required)时存储在 `consentInformation` 对象中的信息。

!!! warning

    强烈建议不要使用其他方式来检查同意状态（例如检查您应用使用的缓存或在存储中查找同意字符串），因为自用户上次同意以来，广告技术合作伙伴的集合可能已经发生了变化。

以下是如何在应用启动时检查状态的示例：

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
        # 设置是否为未达到同意年龄的用户。false 表示用户已达到同意年龄。
    	request.tag_for_under_age_of_consent = false
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# 同意信息状态已更新。
    	# 您现在可以准备检查表单是否可用。
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# 处理错误。
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            // 设置是否为未达到同意年龄的用户。false 表示用户已达到同意年龄。
            request.TagForUnderAgeOfConsent = false;
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // 同意信息状态已更新。
            // 您现在可以准备检查表单是否可用。
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // 处理错误。
        }
    }
    ```

<span id="load-a-form-if-available"></span>
## 如果有表单，则进行加载

在显示表单之前，您首先需要确定是否有可用的表单。由于用户启用了限制广告跟踪，或者如果您已将他们标记为未达到同意年龄，可能会导致没有可用的表单。

要检查表单的可用性，请在 `UserMessagingPlatform` 类的静态 `consent_information` 实例上使用 `get_is_consent_form_available()` 函数。

然后，添加一个包装函数来加载表单：

=== "GDScript"

    ```gdscript
    #...
    func _on_consent_info_updated_success():
    	# 同意信息状态已更新。
    	# 您现在可以准备检查表单是否可用。
    	if UserMessagingPlatform.consent_information.get_is_consent_form_available():
    		load_form()
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# 处理错误。
    	pass
    
    func load_form():
    	pass
    ```

=== "C#"

    ```csharp
    //...
    private void OnConsentInfoUpdatedSuccess()
    {
        // 同意信息状态已更新。
        // 您现在可以准备检查表单是否可用。
        if (UserMessagingPlatform.ConsentInformation.GetIsConsentFormAvailable())
            LoadForm();
    }
    
    private void OnConsentInfoUpdatedFailure(FormError formError)
    {
        // 处理错误。
    }
    
    private void LoadForm()
    {
    }
    ```

要加载表单，请使用 `UserMessagingPlatform` 类上的静态 `load_consent_form()` 函数。

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# 处理错误。
    	pass
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // 处理错误。
    }
    ```

<span id="present-form"></span>
<span id="present-the-form-if-required"></span>
## 如果需要，则展示表单
在您确定表单可用并加载了表单之后，在 ConsentForm 实例上使用 `show()` 函数来展示表单。

使用 `UserMessagingPlatform` 类的静态 `consent_information` 实例来检查同意状态，并更新您的 `load_form()` 函数：

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func load_form():
    	UserMessagingPlatform.load_consent_form(_on_consent_form_load_success, _on_consent_form_load_failure)
    
    func _on_consent_form_load_success(consent_form : ConsentForm):
    	_consent_form = consent_form
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.REQUIRED:
    		consent_form.show(_on_consent_form_dismissed)
    
    func _on_consent_form_load_failure(form_error : FormError):
    	# 处理错误。
    	pass
    
    func _on_consent_form_dismissed(form_error : FormError):
    	if UserMessagingPlatform.consent_information.get_consent_status() == UserMessagingPlatform.consent_information.ConsentStatus.OBTAINED:
    		# 应用可以开始请求广告。
    		pass
    	# 通过重新加载表单来处理关闭事件
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void LoadForm()
    {
        UserMessagingPlatform.LoadConsentForm(OnConsentFormLoadSuccess, OnConsentFormLoadFailure);
    }
    
    private void OnConsentFormLoadSuccess(ConsentForm consentForm)
    {
        _consentForm = consentForm;
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Required)
            consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormLoadFailure(FormError formError)
    {
        // 处理错误。
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        if (UserMessagingPlatform.ConsentInformation.GetConsentStatus() == ConsentStatus.Values.Obtained)
        {
            // 应用可以开始请求广告。
        }
        // 通过重新加载表单来处理关闭事件
        LoadForm();
    }
    ```

如果您需要在用户做出选择或关闭表单后执行任何操作，请将该逻辑放置在表单的完成处理程序或回调中。

## 测试

### 强制指定地理位置

UMP SDK 提供了一种方式，可以使用 `ConsentDebugSettings` 上的 `debug_geography` 属性，测试您的应用行为，就好像该设备位于欧洲经济区 (EEA) 或英国一样。

您必须在应用的调试设置中提供测试设备的哈希 ID 才能使用调试功能。如果您调用 `UserMessagingPlatform.consent_information.update()` 而不设置此值，您的应用在运行时会输出所需的哈希 ID。

=== "GDScript"

    ```gdscript
    extends Node
    
    func _ready():
    	var request := ConsentRequestParameters.new()
    	var consent_debug_settings := ConsentDebugSettings.new()
    	consent_debug_settings.debug_geography = DebugGeography.Values.EEA
    	consent_debug_settings.test_device_hashed_ids.append("test_device_hashed_id")
    	request.consent_debug_settings = consent_debug_settings
    	
    	UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated_success, _on_consent_info_updated_failure)
    
    func _on_consent_info_updated_success():
    	# 同意信息状态已更新。
    	# 您现在可以准备检查表单是否可用。
    	pass
    
    func _on_consent_info_updated_failure(form_error : FormError):
    	# 处理错误。
    	pass
    ```

=== "C#"

    ```csharp
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;
    
    public partial class UmpExample : Node
    {
        public override void _Ready()
        {
            var request = new ConsentRequestParameters();
            var consentDebugSettings = new ConsentDebugSettings();
            consentDebugSettings.DebugGeography = DebugGeography.Eea;
            consentDebugSettings.TestDeviceHashedIds.Add("test_device_hashed_id");
            request.ConsentDebugSettings = consentDebugSettings;
            
            UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdatedSuccess, OnConsentInfoUpdatedFailure);
        }
    
        private void OnConsentInfoUpdatedSuccess()
        {
            // 同意信息状态已更新。
            // 您现在可以准备检查表单是否可用。
        }
    
        private void OnConsentInfoUpdatedFailure(FormError formError)
        {
            // 处理错误。
        }
    }
    ```

使用 `DebugGeography.Values` 枚举，您可以选择将地理位置强制设为以下选项之一：

| DebugGeography | 描述                                            |
|----------------|--------------------------------------------------------|
| DISABLED       | 调试地理位置已禁用。                              |
| EEA            | 对于调试设备，地理位置显示在 EEA 内。         |
| NOT_EEA        | 对于调试设备，地理位置显示在 EEA 外。 |

请注意，调试设置仅在测试设备上起作用。模拟器无需添加到您的设备 ID 列表中，因为它们默认已启用了测试。


### 重置同意状态

在用 UMP SDK 测试您的应用时，您可能会发现重置 SDK 的状态会很有帮助，这样您就可以模拟用户首次安装的体验。SDK 提供了 `reset()` 函数来实现这一点。

=== "GDScript"

    ```gdscript
    UserMessagingPlatform.consent_information.reset()
    ```

=== "C#"

    ```csharp
    UserMessagingPlatform.ConsentInformation.Reset();
    ```

如果您决定从项目中完全删除 UMP SDK，您也应该调用 `reset()`。

!!! warning

    此函数仅供测试使用。您不应在生产环境代码中调用 `reset()`。
