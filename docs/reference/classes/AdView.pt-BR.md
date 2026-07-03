# AdView

A classe `AdView` é responsável por solicitar e exibir anúncios de banner.

## Métodos

### `load_ad` / `LoadAd`
Carrega um anúncio com base nas configurações da solicitação.

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **Uso:**
    ```gdscript
    var ad_view := AdView.new()
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **Uso:**
    ```csharp
    AdView adView = new AdView();
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

## Sinais / Eventos

### `on_ad_loaded` / `OnAdLoaded`
Disparado quando um anúncio é carregado com sucesso.

=== "GDScript"
    ```gdscript
    signal on_ad_loaded()
    ```

=== "C#"
    ```csharp
    public event Action OnAdLoaded;
    ```
