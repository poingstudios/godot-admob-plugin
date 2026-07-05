# リワードインタースティシャル広告

!!! note "Godot 3 (v1) ドキュメント"
    このページは **Godot 3.x** 用です。**Godot 4.2+** については、[安定版ドキュメント](https://poingstudios.github.io/godot-admob-plugin/stable/) をご覧ください。

リワードインタースティシャルは、アプリの自然な移行中に自動的に表示される広告に報酬を提供できるインセンティブ付き広告フォーマットの一種です。従来のリワード広告とは異なり、ユーザーがリワードインタースティシャルを表示するためにオプトインする必要はありません。

---

## リワードインタースティシャル広告の実装

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("rewarded_interstitial_ad_loaded", self, "_on_rewarded_interstitial_ad_loaded")
        MobileAds.connect("rewarded_interstitial_ad_failed_to_load", self, "_on_rewarded_interstitial_ad_failed_to_load")
        MobileAds.connect("rewarded_interstitial_ad_closed", self, "_on_rewarded_interstitial_ad_closed")
        MobileAds.connect("user_earned_rewarded", self, "_on_user_earned_rewarded")
        
        # リワードインタースティシャル広告を読み込み
        MobileAds.load_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_loaded() -> void:
        print("Rewarded Interstitial ad loaded!")
        MobileAds.show_rewarded_interstitial()

    func _on_rewarded_interstitial_ad_failed_to_load(error_code: int) -> void:
        print("Rewarded Interstitial failed to load: ", error_code)

    func _on_rewarded_interstitial_ad_closed() -> void:
        print("Rewarded Interstitial closed.")
        # 次の広告を再読み込み
        MobileAds.load_rewarded_interstitial()

    func _on_user_earned_rewarded(currency: String, amount: int) -> void:
        print("User rewarded! Type: ", currency, ", Amount: ", amount)
        # ここでプレイヤーに報酬を付与
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

## 検証

リワードインタースティシャル広告を表示する前に、読み込み完了を確認できます：

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