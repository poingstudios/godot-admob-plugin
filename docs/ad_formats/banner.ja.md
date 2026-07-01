# バナー広告

バナー広告はアプリのレイアウト内の特定の場所（画面上部または下部）を占めます。ユーザーがアプリと対話している間、画面上に残ります。

---

## バナーの読み込み

バナー広告を読み込むには、`MobileAds.load_banner()`を呼びます。

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("banner_loaded", self, "_on_banner_loaded")
        MobileAds.connect("banner_failed_to_load", self, "_on_banner_failed_to_load")
        
        # 設定済みのバナー広告ユニットIDを使用してバナーを読み込み
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

## バナーの表示と非表示

バナーが即座に表示されるように設定していない場合、以下のメソッドを使用して手動で表示制御できます：

=== "GDScript"

    ```gdscript
    # 読み込まれたバナー広告を表示
    MobileAds.show_banner()

    # 画面からバナー広告を非表示
    MobileAds.hide_banner()

    # バナーを破棄してメモリを解放
    MobileAds.destroy_banner()
    ```

=== "C#"

    ```csharp
    // 読み込まれたバナー広告を表示
    MobileAds.Call("show_banner");

    // 画面からバナー広告を非表示
    MobileAds.Call("hide_banner");

    // バナーを破棄してメモリを解放
    MobileAds.Call("destroy_banner");
    ```

---

## バナーの寸法確認

ヘルパーメソッドを使用してバナーの幅と高さを確認できます：

=== "GDScript"

    ```gdscript
    var width = MobileAds.get_banner_width()
    var height = MobileAds.get_banner_height()
    var width_px = MobileAds.get_banner_width_in_pixels()
    var height_px = MobileAds.get_banner_height_in_pixels()
    ```

=== "C#"

    ```csharp
    // iOS/Android Monoで安全にサイズを取得するにはConvert.ToInt32を使用：
    int width = System.Convert.ToInt32(MobileAds.Call("get_banner_width"));
    int height = System.Convert.ToInt32(MobileAds.Call("get_banner_height"));
    ```