# 开屏广告 (App Open Ads)

本指南适用于集成使用 Google 移动广告 SDK 的开屏广告的发布商。

开屏广告是一种特殊的广告格式，适用于希望将其应用加载屏幕变现的发布商。开屏广告可以随时关闭，并且设计在用户将应用切换到前台时显示。

!!! note "注意"
    具体的广告格式可能会因地区而异。

开屏广告会自动显示一个小的品牌区域，以便用户知道他们正处于您的应用中。以下是开屏广告外观的示例：

<img src="https://developers.google.com/static/admob/images/app-open-ad.png" width="300">

## 前提条件

在您继续之前，请执行以下操作：

- 完成 [开始使用指南](../index.md)。

## 始终使用测试广告进行测试

下表包含一个广告单元 ID，您可以使用它来请求测试广告。它已特别配置为对每个请求都返回测试广告而不是生产广告，因此可以安全使用。

但是，在您在 AdMob 网页界面中注册应用并创建了自己的广告单元 ID 以在应用中使用之后，请在开发期间显式地 [将您的设备配置为测试设备](../enable_test_ads.md)。

=== "Android"

    ```
    ca-app-pub-3940256099942544/9257395921
    ```

=== "iOS"
    ```
    ca-app-pub-3940256099942544/5575463023
    ```

## 实现

集成开屏广告的主要步骤有：

1. 创建工具类
2. 加载开屏广告
3. 监听开屏广告事件
4. 考虑广告过期
5. 监听应用状态事件
6. 展示开屏广告
7. 清理开屏广告
8. 预加载下一个开屏广告

### 创建工具类

创建一个新类（例如 `AppOpenAdManager`）来加载广告。此类控制一个实例变量以跟踪已加载的广告和每个平台的广告单元 ID。

!!! tip "提示"
    虽然不是严格要求，但强烈建议将此脚本添加为 **Autoload**（单例）。这可确保管理器在场景更改时继续存在，并在场景树中保持持久，从而提供与 Google 在其他平台中使用的自动化系统完全相同的无缝全局状态监测器。

=== "GDScript"

    ```gdscript linenums="1"
    extends Node

    var _app_open_ad: AppOpenAd
    var _expire_time: int = 0
    var _is_showing_ad: bool = false

    # 这些广告单元配置为始终投放测试广告。
    var _ad_unit_id: String:
        get:
            if OS.get_name() == "Android":
                return "ca-app-pub-3940256099942544/9257395921"
            return "ca-app-pub-3940256099942544/5575463023"

    func is_ad_available() -> bool:
        return _app_open_ad != null

    func load_app_open_ad() -> void:
        pass # 实现见下文

    func show_app_open_ad() -> void:
        pass # 实现见下文
    ```

=== "C#"

    ```csharp linenums="1"
    using Godot;
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
    using PoingStudios.AdMob.Api.Listeners;
    using System;

    public partial class AppOpenAdManager : Node
    {
        private AppOpenAd _appOpenAd;
        private long _expireTime;
        private bool _isShowingAd;

        // 这些广告单元配置为始终投放测试广告。
        private string _adUnitId => OS.GetName() == "Android" 
            ? "ca-app-pub-3940256099942544/9257395921" 
            : "ca-app-pub-3940256099942544/5575463023";

        public bool IsAdAvailable => _appOpenAd != null;

        public void LoadAppOpenAd()
        {
            // 实现见下文
        }

        public void ShowAppOpenAd()
        {
            // 实现见下文
        }
    }
    ```

### 加载开屏广告

加载开屏广告是通过使用 [`AppOpenAdLoader`](../reference/classes/AppOpenAdLoader.md) 类上的 `load()` 方法完成的。加载方法需要广告单元 ID、一个 [`AdRequest`](../reference/classes/AdRequest.md) 对象以及一个在广告加载成功或失败时调用的完成回调。加载成功的 [`AppOpenAd`](../reference/classes/AppOpenAd.md) 对象作为参数提供在完成回调中。

=== "GDScript"

    ```gdscript linenums="1"
    func load_app_open_ad() -> void:
        # 在加载新广告之前清理旧广告。
        if _app_open_ad:
            _app_open_ad.destroy()
            _app_open_ad = null

        print("正在加载开屏广告。")

        # 创建用于加载广告的请求。
        var ad_request := AdRequest.new()

        # 发送加载广告的请求。
        var load_callback := AppOpenAdLoadCallback.new()
        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            print("开屏广告加载成功，响应 ID 为: " + ad.get_response_info().response_id)
            _app_open_ad = ad
            _register_event_handlers(ad)

        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            print("开屏广告加载失败，错误为: " + error.message)

        AppOpenAdLoader.new().load(_ad_unit_id, ad_request, load_callback)
    ```

=== "C#"

    ```csharp linenums="1"
    public void LoadAppOpenAd()
    {
        // 在加载新广告之前清理旧广告。
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }

        GD.Print("正在加载开屏广告。");

        // 创建用于加载广告的请求。
        var adRequest = new AdRequest();

        // 发送加载广告的请求。
        var loadCallback = new AppOpenAdLoadCallback();
        loadCallback.OnAdLoaded = (ad) =>
        {
            GD.Print("开屏广告加载成功，响应 ID 为: " + ad.GetResponseInfo().ResponseId);
            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };
        loadCallback.OnAdFailedToLoad = (error) =>
        {
            GD.Print("开屏广告加载失败，错误为: " + error.Message);
        };

        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

!!! warning "警告"
    强烈不建议在广告加载失败时从广告请求完成块中尝试加载新广告。如果必须从广告请求完成块中加载广告，请限制广告加载重试次数，以避免在网络连接受限等情况下连续发送失败的广告请求。

### 监听开屏广告事件

为了进一步自定义广告的行为，您可以挂接到广告生命周期中的许多事件：打开、关闭等。通过注册一个 [`FullScreenContentCallback`](../reference/listeners/FullScreenContentCallback.md) 并设置接收 [`AdValue`](../reference/classes/AdValue.md) 的 `on_ad_paid` / `OnAdPaid` 回调属性来监听这些事件，如下所示。

=== "GDScript"

    ```gdscript linenums="1"
    func _register_event_handlers(ad: AppOpenAd) -> void:
        # 当估计广告赚了钱时触发。
        ad.on_ad_paid = func(ad_value: AdValue):
            print("开屏广告支付了 %d %s。" % [ad_value.value_micros, ad_value.currency_code])

        var content_callback := FullScreenContentCallback.new()
        # 当记录广告展示时触发。
        content_callback.on_ad_impression = func():
            print("开屏广告记录了一次展示。")
        # 当记录广告点击时触发。
        content_callback.on_ad_clicked = func():
            print("开屏广告被点击。")
        # 当广告打开全屏内容时触发。
        content_callback.on_ad_showed_full_screen_content = func():
            print("开屏广告全屏内容已打开。")
        # 当广告关闭全屏内容时触发。
        content_callback.on_ad_dismissed_full_screen_content = func():
            print("开屏广告全屏内容已关闭。")
        # 当广告无法打开全屏内容时触发。
        content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
            print("开屏广告无法打开全屏内容，错误为: " + error.message)

        ad.full_screen_content_callback = content_callback
    ```

=== "C#"

    ```csharp linenums="1"
    private void RegisterEventHandlers(AppOpenAd ad)
    {
        // 当估计广告赚了钱时触发。
        ad.OnAdPaid = (adValue) =>
        {
            GD.Print($"开屏广告支付了 {adValue.ValueMicros} {adValue.CurrencyCode}。");
        };

        var contentCallback = new FullScreenContentCallback();
        // 当记录广告展示时触发。
        contentCallback.OnAdImpression = () => GD.Print("开屏广告记录了一次展示。");
        // 当记录广告点击时触发。
        contentCallback.OnAdClicked = () => GD.Print("开屏广告被点击。");
        // 当广告打开全屏内容时触发。
        contentCallback.OnAdShowedFullScreenContent = () => GD.Print("开屏广告全屏内容已打开。");
        // 当广告关闭全屏内容时触发。
        contentCallback.OnAdDismissedFullScreenContent = () => GD.Print("开屏广告全屏内容已关闭。");
        // 当广告无法打开全屏内容时触发。
        contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
            GD.Print("开屏广告无法打开全屏内容，错误为: " + error.Message);

        ad.FullScreenContentCallback = contentCallback;
    }
    ```

### 考虑广告过期

!!! info "关键点"
    开屏广告将在四个小时后超时。在请求时间超过四个小时后渲染的广告将不再有效，且可能无法赚取收入。

为了确保您不展示过期的广告，请在 `AppOpenAdManager` 中添加一个方法，以检查自广告加载以来已经过去了多长时间。然后，使用该方法检查广告是否仍然有效。

开屏广告有 4 小时的超时限制。将加载时间缓存在 `_expire_time` 变量中。

=== "GDScript"

    ```gdscript linenums="1" hl_lines="14-15"
    func load_app_open_ad() -> void:
        # ...
        # 发送加载广告的请求。
        var load_callback := AppOpenAdLoadCallback.new()

        load_callback.on_ad_failed_to_load = func(error: LoadAdError):
            # 如果操作失败，则返回错误。
            print("开屏广告加载失败，错误为: " + error.message)

        load_callback.on_ad_loaded = func(ad: AppOpenAd):
            # 如果操作成功完成，则不返回错误。
            print("开屏广告加载成功，响应 ID 为: " + ad.get_response_info().response_id)

            # 开屏广告最多可以预加载 4 小时。
            _expire_time = Time.get_unix_time_from_system() + (4 * 60 * 60)

            _app_open_ad = ad
            _register_event_handlers(ad)
    ```

    ```gdscript linenums="1"
    func is_ad_available() -> bool:
        return _app_open_ad != null \
               and Time.get_unix_time_from_system() < _expire_time
    ```

=== "C#"

    ```csharp linenums="1" hl_lines="29-30"
    public void LoadAppOpenAd()
    {
        // 在加载新广告之前清理旧广告。
        if (_appOpenAd != null)
        {
            _appOpenAd.Destroy();
            _appOpenAd = null;
        }

        GD.Print("正在加载开屏广告。");

        // 创建用于加载广告的请求。
        var adRequest = new AdRequest();

        // 发送加载广告的请求。
        var loadCallback = new AppOpenAdLoadCallback();

        loadCallback.OnAdFailedToLoad = (error) =>
        {
            // 如果操作失败，则返回错误。
            GD.Print("开屏广告加载失败，错误为: " + error.Message);
        };

        loadCallback.OnAdLoaded = (ad) =>
        {
            // 如果操作成功完成，则不返回错误。
            GD.Print("开屏广告加载成功，响应 ID 为: " + ad.GetResponseInfo().ResponseId);

            // 开屏广告最多可以预加载 4 小时。
            _expireTime = DateTimeOffset.UtcNow.ToUnixTimeSeconds() + (4 * 60 * 60);

            _appOpenAd = ad;
            RegisterEventHandlers(ad);
        };

        new AppOpenAdLoader().Load(_adUnitId, adRequest, loadCallback);
    }
    ```

    ```csharp linenums="1"
    public bool IsAdAvailable
    {
        get
        {
            return _appOpenAd != null 
                   && DateTimeOffset.UtcNow.ToUnixTimeSeconds() < _expireTime;
        }
    }
    ```

### 监听应用状态事件

使用 Godot 的焦点通知来监听应用前台和后台事件。

=== "GDScript"

    ```gdscript linenums="1"
    func _notification(what: int) -> void:
        if what == NOTIFICATION_APPLICATION_FOCUS_IN:
            # 如果应用处于前台且广告可用，则展示它。
            if is_ad_available():
                show_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    public override void _Notification(int what)
    {
        if (what == NotificationApplicationFocusIn)
        {
            // 如果应用处于前台且广告可用，则展示它。
            if (IsAdAvailable)
            {
                ShowAppOpenAd();
            }
        }
    }
    ```

### 展示开屏广告

要展示已加载的开屏广告，请在 `AppOpenAd` 实例上调用 `show()` 方法。

!!! note "注意"
    开屏广告应该在应用流程中的自然暂停期间显示。例如在游戏的关卡之间，或者在用户完成一项任务之后。

=== "GDScript"

    ```gdscript linenums="1"
    func show_app_open_ad() -> void:
        if _app_open_ad:
            print("展示开屏广告。")
            _app_open_ad.show()
        else:
            print("开屏广告尚未准备好。")
    ```

=== "C#"

    ```csharp linenums="1"
    public void ShowAppOpenAd()
    {
        if (_appOpenAd != null)
        {
            GD.Print("展示开屏广告。");
            _appOpenAd.Show();
        }
        else
        {
            GD.Print("开屏广告尚未准备好。");
        }
    }
    ```

### 清理开屏广告

当您处理完 `AppOpenAd` 后，请务必在放弃对它的引用之前调用 `destroy()` 方法：

=== "GDScript"

    ```gdscript
    _app_open_ad.destroy()
    ```

=== "C#"

    ```csharp
    _appOpenAd.Destroy();
    ```

这会通知插件该对象不再被使用，其占用的内存可以被回收。未能调用此方法将导致内存泄漏。

### 预加载下一个开屏广告

`AppOpenAd` 是一个一次性使用的对象。这意味着一旦开屏广告被展示，该对象就不能再次使用。要请求另一个开屏广告，您需要创建一个新的 `AppOpenAd` 对象。

为了为下一次展示机会准备开屏广告，请在 `on_ad_dismissed_full_screen_content` 或 `on_ad_failed_to_show_full_screen_content` 事件触发时预加载开屏广告。

=== "GDScript"

    ```gdscript linenums="1"
    # 在 _register_event_handlers 内部...
    content_callback.on_ad_dismissed_full_screen_content = func():
        print("开屏广告全屏内容已关闭。")
        # 重新加载广告，以便我们可以尽快展示另一个广告。
        load_app_open_ad()

    content_callback.on_ad_failed_to_show_full_screen_content = func(error: AdError):
        print("开屏广告未能打开全屏内容。")
        # 重新加载广告，以便我们可以尽快展示另一个广告。
        load_app_open_ad()
    ```

=== "C#"

    ```csharp linenums="1"
    // 在 RegisterEventHandlers 内部...
    contentCallback.OnAdDismissedFullScreenContent = () => 
    {
        GD.Print("开屏广告全屏内容已关闭。");
        // 重新加载广告，以便我们可以尽快展示另一个广告。
        LoadAppOpenAd();
    };

    contentCallback.OnAdFailedToShowFullScreenContent = (error) => 
    {
        GD.Print("开屏广告未能打开全屏内容。");
        // 重新加载广告，以便我们可以尽快展示另一个广告。
        LoadAppOpenAd();
    };
    ```

## 冷启动和加载屏幕

迄今为止，文档假设您只在用户将挂起在内存中的应用切换到前台时才展示开屏广告。当您的应用启动但之前未挂起在内存中时，就会发生“冷启动”。

冷启动的一个例子是用户第一次打开您的应用。在冷启动时，您将没有事先加载好的开屏广告可供立即展示。在您请求广告并接收广告返回之间的延迟可能会造成一种情况，即用户在被广告打扰之前能够短暂使用您的应用。应该避免这种情况，因为这是一种糟糕的用户体验。

在冷启动时使用开屏广告的优选方式是使用加载屏幕来加载游戏或应用资产，并且只从加载屏幕展示广告。如果应用已完成加载并将用户送至应用的主要内容，则不要展示广告。

!!! info "关键点"
    为了在展示开屏广告的同时继续加载应用资产，请始终在后台线程中加载资产。

## 最佳实践

开屏广告可以帮助您在应用首次启动以及应用切换期间将应用的加载屏幕变现，但请务必牢记以下最佳实践，以确保您的用户喜欢使用您的应用。

*   在您的用户使用过几次您的应用后再展示您的第一个开屏广告。
*   在用户本来就要等待应用加载的这段时间展示开屏广告。
*   如果您在开屏广告下方有一个加载屏幕，并且您的加载屏幕在广告被关闭之前完成了加载，请在 `on_ad_dismissed_full_screen_content` 事件处理程序中关闭您的加载屏幕。
*   确保您的 `AppOpenAdManager`（实现应用状态监听器的节点）存在于场景树中。生命周期通知（如 `NOTIFICATION_APPLICATION_FOCUS_IN`）是触发事件所必需的，因此不要移除此节点；如果该节点从树中移除，事件将停止触发。

## 其他资源

- [示例项目](https://github.com/poingstudios/godot-admob-plugin/tree/master/addons/admob/sample)：所有广告格式的极简实现。
