# 在编辑器中预览模拟广告

在将游戏构建到移动设备之前，使用“预览模拟广告”功能在 Godot 编辑器内测试您的广告集成。

模拟广告可直接在 Godot 编辑器中模拟广告行为、生命周期回调（如加载、展示、点击和关闭）以及 UI 展示。这有助于您在开发早期验证广告集成流程、自定义布局和 UI 放置。

## 工作原理

该插件会自动检测您的游戏是否在 Godot 编辑器内的桌面平台（Windows、macOS 或 Linux）上运行（`OS.has_feature("editor")`）。该插件不会因为缺少 Android 或 iOS 原生单例而失败，而是会自动实例化模拟单例和节点。

您无需更改任何 GDScript 或 C# 代码或配置即可使用模拟广告。所有标准的 `MobileAds` 和广告格式 API 的工作方式完全相同。

## 使用模拟广告的好处

模拟广告是开发过程中的强大工具，可帮助您：

- **验证广告集成流程**：验证初始化、加载、展示以及所有其他生命周期回调在您的游戏逻辑中是否正确触发。
- **预览视觉布局**：检查广告在游戏 UI 中的显示效果，包括不同广告格式相对于 UI 元素（如 `SafeArea`）的布局和定位。
- **快速迭代**：避免仅仅为了测试基本广告行为而编译、导出和部署应用到物理设备或模拟器的耗时过程。

## 支持的格式

模拟系统模拟每种主要广告格式的视觉外观和交互：

### 横幅广告 (Banners)
- 在屏幕上渲染一个与您选择的标准尺寸（例如标准横幅、大横幅、中等矩形、排行榜）或自定义尺寸相匹配的容器。
- 支持自定义屏幕位置（`AdPosition.custom(x, y)`）。
- **折叠式横幅广告**：如果在广告请求的 extras 中指定了 `collapsible`，模拟横幅将显示一个折叠/展开切换按钮（`^`），让您测试横幅折叠时的布局调整和回调。
- 渲染一个关闭按钮（`×`）以模拟关闭行为。

![模拟横幅广告](assets/mock_ad_banner.png)

### 开屏广告 (App Open)
- 在启动时渲染一个全屏开屏模拟广告覆盖层，以测试过渡效果。

![模拟开屏广告](assets/mock_ad_app_open.png)

### 插屏广告 (Interstitial)
- 渲染具有真实品牌标识的全屏插屏广告卡片。
- 具有一个关闭按钮（`X`），可隐藏广告并触发关闭回调。

![模拟插屏广告](assets/mock_ad_interstitial.png)

### 激励广告和激励插屏广告 (Rewarded & Rewarded Interstitial)
- 渲染全屏激励广告覆盖层。
- 播放模拟视频倒计时计时器（通常为 8 秒）。
- 如果您尝试在倒计时结束前关闭广告，会弹出一个警告窗口（“您确定要关闭吗？您将失去奖励”）。
- 倒计时完成后自动发放奖励（触发 `on_rewarded_ad_user_earned_reward` / `UserEarnedReward` 回调，包含模拟货币详细信息）。
- 关闭按钮（`X`）仅在达到最短持续时间（5 秒）或发放奖励后才显示/启用。

![模拟激励广告](assets/mock_ad_rewarded.png)

### 原生重叠广告 (Native Overlay)
- 使用 Godot Control 节点渲染模板化样式的模拟原生广告（支持 `small` 和 `medium` 布局）。
- 显示应用图标、标题、调用操作按钮和正文文本等模拟资产。

![模拟原生广告](assets/mock_ad_native.png)

## 生命周期回调

模拟插件触发与真实移动 SDK 完全相同的信号，允许您调试代码对广告事件的响应。

例如，当您请求插屏广告时，会模拟以下顺序：

=== "GDScript"

    ```gdscript
    var _interstitial_ad: InterstitialAd

    func _load_interstitial():
        var listener := InterstitialAdLoadListener.new()
        listener.on_ad_loaded = func(ad: InterstitialAd) -> void:
            _interstitial_ad = ad
            # 模拟回调在 0.5 秒后触发
            print("编辑器中广告加载成功！")
            
        listener.on_ad_failed_to_load = func(error: LoadAdError) -> void:
            print("加载失败: ", error.message)
            
        InterstitialAd.load(unit_id, AdRequest.new(), listener)

    func _show_interstitial():
        if _interstitial_ad:
            var full_screen_listener := FullScreenContentCallback.new()
            full_screen_listener.on_ad_showed_full_screen_content = func() -> void:
                print("编辑器中广告展示！")
                
            full_screen_listener.on_ad_dismissed_full_screen_content = func() -> void:
                print("编辑器中广告被关闭！")
                
            _interstitial_ad.full_screen_content_callback = full_screen_listener
            _interstitial_ad.show()
    ```

=== "C#"

    ```csharp
    private InterstitialAd _interstitialAd;

    private void LoadInterstitial()
    {
        var listener = new InterstitialAdLoadListener
        {
            OnAdLoaded = (ad) =>
            {
                _interstitialAd = ad;
                // 模拟回调在 0.5 秒后触发
                GD.Print("编辑器中广告加载成功！");
            },
            OnAdFailedToLoad = (error) =>
            {
                GD.Print("加载失败: " + error.Message);
            }
        };

        InterstitialAd.Load(unitId, new AdRequest(), listener);
    }

    private void ShowInterstitial()
    {
        if (_interstitialAd != null)
        {
            _interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
            {
                OnAdShowedFullScreenContent = () => GD.Print("编辑器中广告展示！"),
                OnAdDismissedFullScreenContent = () => GD.Print("编辑器中广告被关闭！")
            };
            _interstitialAd.Show();
        }
    }
    ```

## 局限性

!!! warning "请勿代替真机测试"

    虽然“预览模拟广告”功能非常适合验证逻辑流程和 UI 布局，但在发布游戏之前，您仍必须在物理移动设备或模拟器/真机上进行最终检查。

- 模拟广告**不**模拟网络延迟、网络失败状态或实际的中介网络适配器。
- 模拟广告**不**验证您的 AdMob App ID 或广告单元 ID 在 AdMob 服务器上是否已注册/有效。请参阅 [启用测试广告](enable_test_ads.md) 以设置测试设备进行真机验证。
