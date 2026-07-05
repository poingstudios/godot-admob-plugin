# FullScreenContentCallback

A classe `FullScreenContentCallback` registra gatilhos para eventos relacionados à exibição de formatos de anúncio em tela cheia ([App Open](../classes/AppOpenAd.md), [Interstitial](../classes/InterstitialAd.md), [Rewarded](../classes/RewardedAd.md) e [Rewarded Interstitial](../classes/RewardedInterstitialAd.md)).

## Propriedades

### `on_ad_clicked` / `OnAdClicked`

Acionado quando o usuário clica no anúncio.

=== "GDScript"
    ```gdscript
    var on_ad_clicked: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClicked { get; set; }
    ```

### `on_ad_dismissed_full_screen_content` / `OnAdDismissedFullScreenContent`

Acionado quando o anúncio é fechado/dispensado e o usuário retorna ao aplicativo.

=== "GDScript"
    ```gdscript
    var on_ad_dismissed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdDismissedFullScreenContent { get; set; }
    ```

### `on_ad_failed_to_show_full_screen_content` / `OnAdFailedToShowFullScreenContent`

Acionado quando o anúncio falha ao apresentar. Recebe um [`AdError`](../classes/AdError.md) detalhando o erro de apresentação.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_show_full_screen_content: Callable # Receives AdError
    ```

=== "C#"
    ```csharp
    public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; }
    ```

### `on_ad_impression` / `OnAdImpression`

Acionado quando uma impressão de anúncio é registrada.

=== "GDScript"
    ```gdscript
    var on_ad_impression: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdImpression { get; set; }
    ```

### `on_ad_showed_full_screen_content` / `OnAdShowedFullScreenContent`

Acionado quando o anúncio é apresentado com sucesso na tela.

=== "GDScript"
    ```gdscript
    var on_ad_showed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdShowedFullScreenContent { get; set; }
    ```
