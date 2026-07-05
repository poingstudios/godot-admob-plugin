# AppOpenAdLoader

The `AppOpenAdLoader` class is responsible for executing asynchronous ad requests to load [`AppOpenAd`](AppOpenAd.md) instances.

## Methods

### `load` / `Load`

Sends a load request for an App Open ad.

=== "GDScript"
    ```gdscript
    func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        app_open_ad_load_callback := AppOpenAdLoadCallback.new()
    ) -> void
    ```

    **Usage:**
    ```gdscript
    var loader := AppOpenAdLoader.new()
    var callback := AppOpenAdLoadCallback.new()
    
    callback.on_ad_loaded = func(app_open_ad: AppOpenAd):
        print("Ad loaded!")
        app_open_ad.show()
        
    callback.on_ad_failed_to_load = func(load_ad_error: LoadAdError):
        print("Failed to load: ", load_ad_error.message)
        
    loader.load("ca-app-pub-3940256099942544/9257395921", AdRequest.new(), callback)
    ```

=== "C#"
    ```csharp
    public void Load(string adUnitId, AdRequest adRequest, AppOpenAdLoadCallback callback = null)
    ```

    **Usage:**
    ```csharp
    AppOpenAdLoader loader = new AppOpenAdLoader();
    AppOpenAdLoadCallback callback = new AppOpenAdLoadCallback();
    
    callback.OnAdLoaded = (appOpenAd) => {
        GD.Print("Ad loaded!");
        appOpenAd.Show();
    };
    callback.OnAdFailedToLoad = (loadAdError) => {
        GD.Print("Failed to load: " + loadAdError.Message);
    };
    
    loader.Load("ca-app-pub-3940256099942544/9257395921", new AdRequest(), callback);
    ```
