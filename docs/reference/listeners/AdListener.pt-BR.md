# AdListener

A classe `AdListener` permite que você ouça eventos do ciclo de vida de anúncios banner carregados via [`AdView`](../classes/AdView.md) e anúncios nativos de sobreposição carregados via [`NativeOverlayAd`](../classes/NativeOverlayAd.md).

## Propriedades

Todas as propriedades são delegados callable (ou delegados Action em C#) que são acionados quando o respectivo evento de anúncio ocorre:

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

### `on_ad_closed` / `OnAdClosed`

Acionado quando o usuário fecha a sobreposição de um anúncio ou retorna ao aplicativo.

=== "GDScript"
    ```gdscript
    var on_ad_closed: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClosed { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

Acionado quando o anúncio falha ao carregar. Recebe um [`LoadAdError`](../classes/LoadAdError.md) detalhando o erro.

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
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

### `on_ad_loaded` / `OnAdLoaded`

Acionado quando o anúncio é carregado com sucesso.

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdLoaded { get; set; }
    ```

### `on_ad_opened` / `OnAdOpened`

Acionado quando o anúncio abre uma sobreposição em tela cheia sobre o aplicativo.

=== "GDScript"
    ```gdscript
    var on_ad_opened: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdOpened { get; set; }
    ```
