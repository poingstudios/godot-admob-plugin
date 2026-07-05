# AppOpenAd

A classe `AppOpenAd` representa um formato de anúncio em tela cheia que é apresentado quando o usuário abre ou retorna ao aplicativo.

## Propriedades

### `full_screen_content_callback` / `FullScreenContentCallback`

O listener de callback para receber eventos sobre apresentação, dispensa ou falha na exibição. Veja [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md).

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Acionado quando uma impressão de anúncio é registrada e a receita foi gerada. Recebe um [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

### `placement_id` / `PlacementId`

Um inteiro que representa o índice de posicionamento do layout atual do anúncio.

=== "GDScript"
    ```gdscript
    var placement_id: int
    ```

=== "C#"
    ```csharp
    public int PlacementId { get; set; }
    ```

---

## Métodos

### `show` / `Show`

Apresenta a sobreposição de anúncio App Open em tela cheia.

=== "GDScript"
    ```gdscript
    func show() -> void
    ```

=== "C#"
    ```csharp
    public void Show()
    ```

---

### `destroy` / `Destroy`

Destrói o objeto de anúncio nativo e libera recursos.

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
    ```

---

### `get_ad_unit_id` / `GetAdUnitId`

Retorna o ID da unidade de anúncio associado ao anúncio carregado.

=== "GDScript"
    ```gdscript
    func get_ad_unit_id() -> String
    ```

=== "C#"
    ```csharp
    public string GetAdUnitId()
    ```

---

### `get_response_info` / `GetResponseInfo`

Retorna as informações de resposta de mediação contendo o histórico de adaptadores para o anúncio carregado.

=== "GDScript"
    ```gdscript
    func get_response_info() -> ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo GetResponseInfo()
    ```
