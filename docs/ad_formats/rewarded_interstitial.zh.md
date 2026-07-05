# 激励插页广告

!!! note "Godot 3 (v1) 文档"
    本页面适用于 **Godot 3.x**。如需 **Godot 4.2+**，请查看[稳定文档](https://poingstudios.github.io/godot-admob-plugin/stable/)。

激励插页是一种激励广告格式，允许您为在应用自然过渡期间自动出现的广告提供奖励。与传统激励广告不同，用户不需要选择观看激励插页。

---

## 实现激励插页广告

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_interstitial_ad_loaded", self, "_on_rewarded_interstitial_ad_loaded")
        MobileAds.connect("rewarded_interstitial_ad_failed_to_load", self, "_on_rewarded_interstitial_ad_failed_to_load")
        MobileAds.connect("rewarded_interstitial_ad_closed", self, "_on_rewarded_interstitial_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # 加载激励插页广告
        MobileAds.load_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_loaded() -> void:
        print("Rewarded Interstitial ad loaded!")
        MobileAds.show_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_failed_to_load(error_code: int) -> void:
        print("Rewarded Interstitial failed to load: ", error_code)

    func _on_rewarded_interstitial_ad_closed() -> void:
        print("Rewarded Interstitial closed.")
        # 重新加载下一个广告
        MobileAds.load_rewarded_interstitial()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("User rewarded! Type: ", currency, ", Amount: ", amount)
        # 在此处给予玩家奖励
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("rewarded_interstitial_ad_loaded", this, nameof(_on_rewarded_interstitial_ad_loaded));
        MobileAds.Connect("rewarded_interstitial_ad_failed_to_load", this, nameof(_on_rewarded_interstitial_ad_failed_to_load));
        MobileAds.Connect("rewarded_interstitial_ad_closed", this, nameof(_on_rewarded_interstitial_ad_closed));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_loaded()
    {
        GD.Print("Rewarded Interstitial loaded!");
        MobileAds.Call("show_rewarded_interstitial");
    }

    private void _on_rewarded_interstitial_ad_failed_to_load(int errorCode)
    {
        GD.Print("Rewarded Interstitial failed to load: " + errorCode);
    }

    private void _on_rewarded_interstitial_ad_closed()
    {
        GD.Print("Rewarded Interstitial closed.");
        MobileAds.Call("load_rewarded_interstitial");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("User rewarded: " + amount + " " + currency);
    }
    ```

---

## 验证

在显示激励插页广告之前，可以查询其是否已加载：

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_rewarded_interstitial_loaded():
        MobileAds.show_rewarded_interstitial()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_rewarded_interstitial_loaded"))
    {
        MobileAds.Call("show_rewarded_interstitial");
    }
    ```