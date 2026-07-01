# 激励广告

激励广告为用户提供与其互动以换取应用内奖励（例如额外生命、游戏内货币等）的选项。

---

## 实现激励广告

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_ad_loaded", self, "_on_rewarded_ad_loaded")
        MobileAds.connect("rewarded_ad_failed_to_load", self, "_on_rewarded_ad_failed_to_load")
        MobileAds.connect("rewarded_ad_closed", self, "_on_rewarded_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # 加载激励广告
        MobileAds.load_rewarded()

    func _on_rewarded_ad_loaded() -> void:
        print("Rewarded ad loaded successfully!")
        MobileAds.show_rewarded()

    func _on_rewarded_ad_failed_to_load(error_code: int) -> void:
        print("Rewarded ad failed to load: ", error_code)

    func _on_rewarded_ad_closed() -> void:
        print("Rewarded ad closed.")
        # 重新加载下一个广告
        MobileAds.load_rewarded()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("User rewarded! Type: ", currency, ", Amount: ", amount)
        # 在此处给予玩家奖励
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("rewarded_ad_loaded", this, nameof(_on_rewarded_ad_loaded));
        MobileAds.Connect("rewarded_ad_failed_to_load", this, nameof(_on_rewarded_ad_failed_to_load));
        MobileAds.Connect("rewarded_ad_closed", this, nameof(_on_rewarded_ad_closed));
        MobileAds.Connect("user_earned_rewarded", this, nameof(_on_user_earned_rewarded));
        
        MobileAds.Call("load_rewarded");
    }

    private void _on_rewarded_ad_loaded()
    {
        GD.Print("Rewarded ad loaded!");
        MobileAds.Call("show_rewarded");
    }

    private void _on_rewarded_ad_failed_to_load(int errorCode)
    {
        GD.Print("Rewarded ad failed to load: " + errorCode);
    }

    private void _on_rewarded_ad_closed()
    {
        GD.Print("Rewarded ad closed.");
        MobileAds.Call("load_rewarded");
    }

    private void _on_user_earned_rewarded(string currency, int amount)
    {
        GD.Print("User rewarded: " + amount + " " + currency);
    }
    ```

---

## 验证

在显示激励广告之前，可以查询其是否已加载：

=== "GDScript"

    ```gdscript
    if MobileAds.get_is_rewarded_loaded():
        MobileAds.show_rewarded()
    ```

=== "C#"

    ```csharp
    if ((bool)MobileAds.Call("get_is_rewarded_loaded"))
    {
        MobileAds.Call("show_rewarded");
    }
    ```