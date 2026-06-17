# AdView

`AdView` 类负责请求和显示横幅广告。

## 方法

### `load_ad` / `LoadAd`
根据请求配置加载广告。

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **用法：**
    ```gdscript
    var ad_view := AdView.new()
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **用法：**
    ```csharp
    AdView adView = new AdView();
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

## 信号 / 事件

### `on_ad_loaded` / `OnAdLoaded`
在广告成功加载时触发。

=== "GDScript"
    ```gdscript
    signal on_ad_loaded()
    ```

=== "C#"
    ```csharp
    public event Action OnAdLoaded;
    ```
