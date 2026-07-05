# AdView

`AdView` クラスは、バナー広告のリクエストおよび表示を処理します。

## メソッド

### `load_ad` / `LoadAd`
リクエスト構成に基づいて広告をロードします。

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **使用例:**
    ```gdscript
    var ad_view := AdView.new()
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **使用例:**
    ```csharp
    AdView adView = new AdView();
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

## シグナル / イベント

### `on_ad_loaded` / `OnAdLoaded`
広告が正常にロードされたときにトリガーされます。

=== "GDScript"
    ```gdscript
    signal on_ad_loaded()
    ```

=== "C#"
    ```csharp
    public event Action OnAdLoaded;
    ```
