# InterstitialAdLoadCallback

A classe `InterstitialAdLoadCallback` é usada para ouvir o resultado do carregamento de uma solicitação de [`InterstitialAd`](../classes/InterstitialAd.md).

## Propriedades

### `on_ad_loaded` / `OnAdLoaded`

Acionado quando o anúncio é carregado com sucesso. Recebe a instância de [`InterstitialAd`](../classes/InterstitialAd.md) carregada.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives InterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<InterstitialAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Acionado quando a solicitação de carregamento falha. Recebe um [`LoadAdError`](../classes/LoadAdError.md) detalhando o erro de carregamento.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
