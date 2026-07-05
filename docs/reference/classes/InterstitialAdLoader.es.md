# InterstitialAdLoader

La clase `InterstitialAdLoader` es responsable de ejecutar solicitudes de anuncios asíncronas para cargar instancias de [`InterstitialAd`](InterstitialAd.md).

## Métodos

### `load` / `Load`

Envía una solicitud de carga para un anuncio Interstitial.

=== "GDScript"
    ```gdscript
    func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
    ) -> void
    ```

    **Uso:**
    ```gdscript
    var loader := InterstitialAdLoader.new()
    var callback := InterstitialAdLoadCallback.new()
    
    callback.on_ad_loaded = func(interstitial_ad: InterstitialAd):
        print("Ad loaded!")
        interstitial_ad.show()
        
    callback.on_ad_failed_to_load = func(load_ad_error: LoadAdError):
        print("Failed to load: ", load_ad_error.message)
        
    loader.load("ca-app-pub-3940256099942544/1033173712", AdRequest.new(), callback)
    ```

=== "C#"
    ```csharp
    public void Load(string adUnitId, AdRequest adRequest, InterstitialAdLoadCallback callback = null)
    ```

    **Uso:**
    ```csharp
    InterstitialAdLoader loader = new InterstitialAdLoader();
    InterstitialAdLoadCallback callback = new InterstitialAdLoadCallback();
    
    callback.OnAdLoaded = (interstitialAd) => {
        GD.Print("Ad loaded!");
        interstitialAd.Show();
    };
    callback.OnAdFailedToLoad = (loadAdError) => {
        GD.Print("Failed to load: " + loadAdError.Message);
    };
    
    loader.Load("ca-app-pub-3940256099942544/1033173712", new AdRequest(), callback);
    ```
