# RewardedInterstitialAdLoadCallback

A classe `RewardedInterstitialAdLoadCallback` é usada para ouvir o resultado do carregamento de uma solicitação de [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md).

## Propriedades

### `on_ad_loaded` / `OnAdLoaded`

Acionado quando o anúncio é carregado com sucesso. Recebe a instância de [`RewardedInterstitialAd`](../classes/RewardedInterstitialAd.md) carregada.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives RewardedInterstitialAd
    ```

=== "C#"
    ```csharp
    public Action<RewardedInterstitialAd> OnAdLoaded { get; set; }
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
