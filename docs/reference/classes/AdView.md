# AdView

The `AdView` class is responsible for requesting and displaying banner ads.

## Methods

### `load_ad` / `LoadAd`
Loads an ad based on the request configuration.

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **Usage:**
    ```gdscript
    var ad_view := AdView.new()
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **Usage:**
    ```csharp
    AdView adView = new AdView();
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

## Signals / Events

### `on_ad_loaded` / `OnAdLoaded`
Fired when an ad is successfully loaded.

=== "GDScript"
    ```gdscript
    signal on_ad_loaded()
    ```

=== "C#"
    ```csharp
    public event Action OnAdLoaded;
    ```
