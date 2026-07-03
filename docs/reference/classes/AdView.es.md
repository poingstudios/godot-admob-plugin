# Vista publicitaria

La clase `AdView` es responsable de solicitar y mostrar anuncios publicitarios.

## Métodos

### `load_ad`/`cargar anuncio`
Carga un anuncio según la configuración de la solicitud.

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

**Uso:**    ```gdscript
    var ad_view := AdView.new()
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

**Uso:**    ```csharp
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
