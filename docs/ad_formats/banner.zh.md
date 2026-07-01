# 横幅广告

横幅广告占据应用布局中的一个位置，位于屏幕顶部或底部。用户与应用交互时，广告会持续显示在屏幕上。

---

## 加载横幅

要加载横幅广告，请调用`MobileAds.load_banner()`。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.connect("banner_failed_to_load", self, "_on_banner_failed_to_load")
        
        # 使用配置的横幅广告单元ID加载横幅
        MobileAds.load_banner()

    func _on_banner_loaded() -> void:
        print("Banner loaded successfully!")

    func _on_banner_failed_to_load(error_code: int) -> void:
        print("Banner failed to load with error code: ", error_code)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("banner_loaded", this, nameof(_on_banner_loaded));
        MobileAds.Connect("banner_failed_to_load", this, nameof(_on_banner_failed_to_load));
        
        MobileAds.Call("load_banner");
    }

    private void _on_banner_loaded()
    {
        GD.Print("Banner loaded successfully!");
    }

    private void _on_banner_failed_to_load(int errorCode)
    {
        GD.Print("Banner failed to load with error code: " + errorCode);
    }
    ```

---

## 显示和隐藏横幅

如果将横幅配置为不立即显示，可以使用以下方法手动控制其可见性：

=== "GDScript"

    ```gdscript
    # 显示已加载的横幅广告
    MobileAds.show_banner()

    # 从屏幕隐藏横幅广告
    MobileAds.hide_banner()

    # 销毁横幅以释放内存
    MobileAds.destroy_banner()
    ```

=== "C#"

    ```csharp
    // 显示已加载的横幅广告
    MobileAds.Call("show_banner");

    // 从屏幕隐藏横幅广告
    MobileAds.Call("hide_banner");

    // 销毁横幅以释放内存
    MobileAds.Call("destroy_banner");
    ```

---

## 检查横幅尺寸

可以使用辅助方法检查横幅的宽度和高度：

=== "GDScript"

    ```gdscript
    var width = MobileAds.get_banner_width()
    var height = MobileAds.get_banner_height()
    var width_px = MobileAds.get_banner_width_in_pixels()
    var height_px = MobileAds.get_banner_height_in_pixels()
    ```

=== "C#"

    ```csharp
    // 使用Convert.ToInt32在iOS/Android Mono上安全获取尺寸：
    int width = System.Convert.ToInt32(MobileAds.Call("get_banner_width"));
    int height = System.Convert.ToInt32(MobileAds.Call("get_banner_height"));
    ```