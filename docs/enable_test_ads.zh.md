# 启用测试广告

本指南提供了关于在广告集成中启用测试广告 class_name 的说明。在开发阶段启用测试广告至关重要，这样可以允许点击它们而不会对 Google 广告主产生费用。在未处于测试模式下点击过多广告可能会导致您的账号因无效活动而被标记。

要在开发期间测试您的广告，您可以：

1. **在编辑器中预览模拟广告**：直接在 Godot 编辑器中测试您的广告集成和视觉布局，而无需部署到设备。参见 [在编辑器中预览模拟广告](editor_mock_ads.md)。
2. **使用 Google 的示例广告单元**：在物理设备或模拟器/真机上加载测试广告。参见 [示例广告单元](#sample-ad-units)。
3. **启用测试设备**：通过注册您的测试设备，使用您自己的生产广告单元进行测试。参见 [启用测试设备](#enable-test-devices)。

本文档基于：

- [Google Mobile Ads SDK Android 文档](https://developers.google.com/admob/android/test-ads)
- [Google Mobile Ads SDK iOS 文档](https://developers.google.com/admob/ios/test-ads)

## 前提条件
- 完成 [开始使用指南](index.md)

## 示例广告单元 {: #sample-ad-units }

启用测试最简便的方法是使用 Google 提供的测试广告单元。这些广告单元与您的 AdMob 账号分离，从而确保在使用它们时您的账号不会产生无效流量的风险。

请记住，您应根据测试的平台选择适当的 Google 提供的测试广告单元。在 iOS 上进行测试广告请求时使用 iOS 测试广告单元，在 Android 上进行请求时使用 Android 测试广告单元。

!!! note "注意"

    **重要提示**：在发布您的应用之前，请务必将这些测试 ID 替换为您自己的广告单元 ID。

以下是 Android 和 iOS 上每种可用格式的示例广告单元：

=== "Android"
    | 广告格式             | 示例广告单元 ID                         |
    |-----------------------|----------------------------------------|
    | 横幅广告 (Banner)     | ca-app-pub-3940256099942544/6300978111 |
    | 开屏广告 (App Open)   | ca-app-pub-3940256099942544/9257395921 |
    | 插屏广告 (Interstitial) | ca-app-pub-3940256099942544/1033173712 |
    | 激励广告 (Rewarded)   | ca-app-pub-3940256099942544/5224354917 |
    | 激励插屏广告 (Rewarded Interstitial) | ca-app-pub-3940256099942544/5354046379 |
    | 原生重叠广告 (Native) | ca-app-pub-3940256099942544/2247696110 |

=== "iOS"

    | 广告格式             | 示例广告单元 ID                         |
    |-----------------------|----------------------------------------|
    | 横幅广告 (Banner)     | ca-app-pub-3940256099942544/2934735716 |
    | 开屏广告 (App Open)   | ca-app-pub-3940256099942544/5575463023 |
    | 插屏广告 (Interstitial) | ca-app-pub-3940256099942544/4411468910 |
    | 激励广告 (Rewarded)   | ca-app-pub-3940256099942544/1712485313 |
    | 激励插屏广告 (Rewarded Interstitial) | ca-app-pub-3940256099942544/6978759866 |
    | 原生重叠广告 (Native) | ca-app-pub-3940256099942544/3986624511 |

### 专用测试标识符
虽然上述标准广告单元可以通过添加额外参数（如 `collapsible`）来使用，但以下专用广告单元 ID **保证**在测试您的 UI/UX 时返回特定功能：

| 功能 | Android | iOS |
| :--- | :--- | :--- |
| **折叠式横幅广告** | `ca-app-pub-3940256099942544/2014213617` | `ca-app-pub-3940256099942544/8388050270` |



## 启用测试设备 {: #enable-test-devices }
要使用类似生产环境的广告进行更彻底的测试，您可以将您的设备配置为测试设备，并利用您在 AdMob UI 中创建的自己的广告单元 ID。您可以通过 AdMob UI 或使用 Google 移动广告 SDK 以编程方式添加测试设备。

以下是将您的设备添加为测试设备的步骤：

!!! note "注意"

    **重要提示**：Android 模拟器和 iOS 模拟器会自动配置为测试设备。这意味着您可以在这些虚拟设备上测试广告，而无需手动将它们添加到测试设备列表中。


### 在 AdMob UI 中添加您的测试设备

若要使用一种简单、非编程的方法来包含测试设备并测试新版或现有的应用构建，您可以使用 AdMob UI。[具体操作如下](https://support.google.com/admob/answer/9691433)。


!!! note "注意"

    **重要提示**：新添加的测试设备通常会在 15 分钟内开始在您的应用中展示测试广告，但也可能需要长达 24 小时才能生效。


### 以编程方式添加您的测试设备

如果您希望在开发阶段测试应用内的广告并以编程方式注册您的测试设备，请遵循以下步骤：


1. 打开集成了广告的应用并发起广告请求。
2. 检查 logcat 输出以查找类似于以下内容的信息，该信息显示了您的设备 ID 以及如何将其添加为测试设备：

    === "Android"
        ```java
        I/Ads: Use RequestConfiguration.Builder.setTestDeviceIds(Arrays.asList("33BE2250B43518CCDA7DE426D04EE231")) 
        to get test ads on this device."
        ```

    === "iOS"

        ```swift
        <Google> To get test ads on this device, set:
        GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
        @[ @"2077ef9a63d2b398840261c8221a0c9b" ];
        ```
将您的测试设备 ID 复制到剪贴板。

3. 更新您的代码，将测试设备 ID 包含在您的 `RequestConfiguration.test_device_ids` 数组中，如下所示：

=== "GDScript"

    ```gdscript linenums="1" hl_lines="3 4"
    func _ready() -> void:
    	var request_configuration := RequestConfiguration.new()
    	request_configuration.test_device_ids = ["2077ef9a63d2b398840261c8221a0c9b"]
    	MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="10 11"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    
    public partial class TestAdsExample : Node2D
    {
        public override void _Ready()
        {
            var requestConfiguration = new RequestConfiguration();
            requestConfiguration.TestDeviceIds.Add("2077ef9a63d2b398840261c8221a0c9b");
            MobileAds.SetRequestConfiguration(requestConfiguration);
        }
    }
    ```
!!! info "信息"

    记得在发布您的应用之前删除负责定义这些测试设备的代码。

4. 重新启动您的应用。如果广告是 Google 广告，您会观察到广告顶部中央位置有一个 **Test Ad**（测试广告）标签，无论是横幅、插屏还是激励视频广告：
![测试广告](https://developers.google.com/static/admob/images/android-testad-0-admob.png)

!!! info "信息"
    
    请注意，中介广告_不会_显示 **Test Ad** 标签。请参阅下文以获取更多信息。


### 使用中介进行测试

Google 的示例广告单元仅展示 Google 广告。为了有效测试您的中介设置，您必须采用 [启用测试设备](#enable-test-devices) 的方法。

中介广告不会展示 “Test Ad” 标签。因此，您有责任确保为您调用的每个中介网络启用测试广告，以防止这些网络因无效活动而标记您的账号。请参阅每个网络的单独 [中介指南](mediate/get_started.md) 获取详细说明。

如果您不确定某个中介广告网络适配器是否支持测试广告，建议在开发阶段避免点击来自该网络的广告。您可以使用任何广告格式中的 [ResponseInfo.mediation_adapter_class_name](https://github.com/poingstudios/godot-admob-plugin/blob/master/addons/admob/src/api/core/ResponseInfo.gd) 属性来确定哪个广告网络投放了当前的广告。
