# 插页广告

插页广告是全屏广告，覆盖其主应用的界面。通常在应用流程中的自然过渡点显示，例如在活动之间或游戏关卡之间的暂停期间。

---

## 实现插页广告

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_failed_to_load", self, "_on_interstitial_failed_to_load")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        
        # 加载插页广告
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Interstitial loaded! Ready to show.")
        # 立即显示插页广告或保存以备后用
        MobileAds.show_interstitial()

    func _on_interstitial_failed_to_load(error_code: int) -> void:
        print("Interstitial failed to load: ", error_code)

    func _on_interstitial_closed() -> void:
        print("Interstitial ad closed by the user.")
        # 加载下一个插页广告
        MobileAds.load_interstitial()
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_failed_to_load", this, nameof(_on_interstitial_failed_to_load));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Interstitial loaded!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_failed_to_load(int errorCode)
    {
        GD.Print("Interstitial failed to load: " + errorCode);
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Interstitial closed.");
        MobileAds.Call("load_interstitial");
    }
    ```

---

## 验证

在展示插页广告之前，可以查询其是否已完成加载：

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_interstitial_loaded():
        MobileAds.show_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_interstitial_loaded"))
    {
        MobileAds.Call("show_interstitial");
    }
    ```