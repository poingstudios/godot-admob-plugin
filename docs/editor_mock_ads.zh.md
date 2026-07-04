# 在编辑器中预览模拟广告

!!! note "Godot 3 (v1) 文档"
    本页面适用于 **Godot 3.x**。如需 **Godot 4.2+**，请查看[稳定文档](https://poingstudios.github.io/godot-admob-plugin/stable/)。

插件内置了模拟广告系统。这让您可以直接在Godot编辑器内测试广告集成的视觉布局和逻辑流程，而无需部署到物理设备。

模拟广告模拟广告行为，并触发与真实移动SDK完全相同的生命周期回调（如加载、展示、点击和关闭）。

---

## 工作原理

插件会自动检测您的游戏是否在Godot编辑器内的桌面平台（Windows、macOS或Linux）上运行。插件不会因为缺少Android或iOS原生单例而失败，而是自动实例化模拟单例和节点。

您无需更改任何C#或GDScript代码。所有标准的`MobileAds`单例API的功能完全相同。

---

## 支持的格式

模拟系统模拟以下广告格式的视觉外观和交互：

### 横幅
- 在屏幕上渲染与您配置的位置和尺寸（标准、大、中矩形或排行榜）匹配的模拟横幅容器。
- 包含关闭按钮（`×`）以模拟关闭。

### 插页
- 渲染全屏插页覆盖层。
- 包含关闭按钮（`X`），隐藏广告并触发`interstitial_closed`回调。

### 激励和激励插页
- 渲染全屏激励视频模拟。
- 播放模拟视频倒计时器。
- 倒计时完成后自动触发`user_earned_rewarded`回调。
- 显示关闭按钮（`X`）返回游戏。

---

## 调试生命周期回调

模拟插件触发与真实移动SDK完全相同的信号：

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Ad loaded in Editor!")
        MobileAds.show_interstitial()

    func _on_interstitial_closed() -> void:
        print("Ad dismissed in Editor!")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Ad loaded in Editor!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Ad dismissed in Editor!");
    }
    ```