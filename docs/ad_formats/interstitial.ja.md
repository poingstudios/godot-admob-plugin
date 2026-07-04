# インタースティシャル広告

!!! note "Godot 3 (v1) ドキュメント"
    このページは **Godot 3.x** 用です。**Godot 4.2+** については、[安定版ドキュメント](https://poingstudios.github.io/godot-admob-plugin/stable/) をご覧ください。

インタースティシャル広告は、ホストアプリのインターフェースを覆うフルスクリーン広告です。通常、アプリのフロー内の自然な移行ポイント（アクティビティ間やゲームのレベル間の休憩中など）に表示されます。

---

## インタースティシャル広告の実装

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_failed_to_load", self, "_on_interstitial_failed_to_load")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        
        # インタースティシャル広告を読み込み
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Interstitial loaded! Ready to show.")
        # インタースティシャルをすぐに表示するか、後で保存
        MobileAds.show_interstitial()

    func _on_interstitial_failed_to_load(error_code: int) -> void:
        print("Interstitial failed to load: ", error_code)

    func _on_interstitial_closed() -> void:
        print("Interstitial ad closed by the user.")
        # 次のインタースティシャル広告を読み込み
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

## 検証

インタースティシャル広告を表示する前に、読み込みが完了したかどうかを確認できます：

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