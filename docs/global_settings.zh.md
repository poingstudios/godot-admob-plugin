# 全局设置

`MobileAds` 类为 Google Mobile Ads SDK 提供全局设置。

## 视频广告音量控制

如果您的应用有自己的音量控制（如自定义音乐或音效音量），将应用音量报告给 Google Mobile Ads SDK 可以让视频广告尊重应用音量设置。这确保用户收到具有预期音频音量的视频广告。

设备音量由音量按钮或系统级音量滑块控制，决定设备音频输出的音量。但是，应用可以独立调整相对于设备音量的音量级别，以定制音频体验。

您可以通过在加载广告之前调用 `set_app_volume()` 方法将相对应用音量报告给 Google Mobile Ads SDK。有效的广告音量值范围为 `0.0`（静音）到 `1.0`（当前设备音量）。以下是如何向 SDK 报告相对应用音量的示例：

=== "GDScript"

    ```gdscript
    # 将应用音量设置为当前设备音量的一半。
    MobileAds.set_app_volume(0.5)
    ```

=== "C#"

    ```csharp
    // 将应用音量设置为当前设备音量的一半。
    MobileAds.SetAppVolume(0.5f);
    ```

!!! warning
    降低应用的音频音量会降低视频广告的投放资格，并可能减少应用的广告收入。只有在您的应用向用户提供自定义音量控制，并且用户的音量在应用中得到正确反映时，才应使用此方法。

要通知 SDK 应用音量已静音，请在加载广告之前调用 `set_app_muted()` 方法：

=== "GDScript"

    ```gdscript
    # 将应用设置为静音。
    MobileAds.set_app_muted(true)
    ```

=== "C#"

    ```csharp
    // 将应用设置为静音。
    MobileAds.SetAppMuted(true);
    ```

默认情况下，应用音量设置为 `1`（当前设备音量），应用未静音。

!!! warning
    静音您的应用会降低视频广告的投放资格，并可能减少应用的广告收入。只有在您的应用向用户提供自定义静音控制，并且用户的静音决定在应用中得到正确反映时，才应使用此方法。

## Cookie 同意

如果您的应用有特殊要求，您可以将可选的 `gad_has_consent_for_cookies` 键设置为零以启用[受限广告](https://support.google.com/admob/answer/10105530)：

=== "GDScript"

    ```gdscript
    # 启用受限广告
    MobileAds.set_gad_has_consent_for_cookies(false)
    ```

=== "C#"

    ```csharp
    // 启用受限广告
    MobileAds.SetGadHasConsentForCookies(false);
    ```

## 禁用崩溃报告

Google Mobile Ads SDK 收集崩溃报告用于调试和分析。要禁用崩溃报告，请参阅以下 Android 和 iOS 部分。

=== "Android"

    在应用的 `AndroidManifest.xml` 文件中添加 `DISABLE_CRASH_REPORTING` 设置为 `true` 的 `<meta-data>` 标签：

    ```xml
    <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.flag.DISABLE_CRASH_REPORTING"
               android:value="true" />
       </application>
    </manifest>
    ```

=== "iOS"

    调用 `disable_sdk_crash_reporting()` 方法以禁用 iOS 上的崩溃报告：

    === "GDScript"

        ```gdscript
        func _ready() -> void:
            MobileAds.disable_sdk_crash_reporting()
        ```

    === "C#"

        ```csharp
        public override void _Ready()
        {
            MobileAds.DisableSdkCrashReporting();
        }
        ```

## 获取插件版本

要获取插件版本，请运行以下命令：

=== "GDScript"

    ```gdscript
    # 获取插件版本。
    print("插件版本: " + MobileAds.get_version())
    ```

=== "C#"

    ```csharp
    // 获取插件版本。
    GD.Print("插件版本: " + MobileAds.GetVersion());
    ```

## 获取平台版本

Google Mobile Ads SDK 依赖于 Android 和 iOS 平台 SDK。要获取平台 SDK 的版本，请运行以下命令：

=== "GDScript"

    ```gdscript
    # 获取底层平台 SDK 版本。
    print("平台 SDK 版本: " + MobileAds.get_platform_version())
    ```

=== "C#"

    ```csharp
    // 获取底层平台 SDK 版本。
    GD.Print("平台 SDK 版本: " + MobileAds.GetPlatformVersion());
    ```
