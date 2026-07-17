# NativeOverlayAd

A classe `NativeOverlayAd` gerencia anúncios de template nativo sobrepostos às cenas Godot.

## Propriedades

### `ad_listener` / `AdListener`

O listener de callback para receber eventos sobre apresentação, dispensa ou falha na exibição. Veja [`AdListener`](../listeners/AdListener.md).

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Acionado quando uma impressão é registrada e a receita foi gerada. Recebe um [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

### `on_template_rendered` / `OnTemplateRendered`

Acionado uma vez após o template nativo ser posicionado e renderizado na tela (a primeira vez que a view do template conclui seu pass de layout global, ou quando o template mock é posicionado no editor). Use isso para reagir ao tamanho real renderizado — por exemplo, para empurrar o conteúdo para uma `SafeArea` somente após o anúncio estar totalmente renderizado, em vez de depender de uma chamada síncrona a `get_template_height_in_pixels()`, que pode retornar dimensões desatualizadas.

=== "GDScript"
    ```gdscript
    var on_template_rendered: Callable
    ```

=== "C#"
    ```csharp
    public Action OnTemplateRendered { get; set; }
    ```

---

## Métodos Estáticos

### `load` / `Load`

Solicita e carrega assincronamente um anúncio de sobreposição de template nativo.

=== "GDScript"
    ```gdscript
    static func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        options: NativeAdOptions,
        ad_load_callback: Callable # Signature: func(ad: NativeOverlayAd, error: LoadAdError)
    ) -> void
    ```

    **Uso:**
    ```gdscript
    func _ready() -> void:
        NativeOverlayAd.load(
            "ca-app-pub-3940256099942544/2247696110",
            AdRequest.new(),
            NativeAdOptions.new(),
            _on_ad_loaded
        )

    func _on_ad_loaded(ad: NativeOverlayAd, error: LoadAdError) -> void:
        if error:
            print("Failed to load native ad: ", error.message)
            return
            
        print("Native ad loaded successfully!")
        
        # Render the native ad at the bottom of the screen with a Medium template style
        var template_style := NativeTemplateStyle.new()
        template_style.template_id = NativeTemplateStyle.MEDIUM
        ad.render_template(template_style, AdPosition.BOTTOM)
    ```

=== "C#"
    ```csharp
    public static void Load(
        string adUnitId,
        AdRequest adRequest,
        NativeAdOptions options,
        Action<NativeOverlayAd, LoadAdError> adLoadCallback
    )
    ```

    **Uso:**
    ```csharp
    public override void _Ready()
    {
        NativeOverlayAd.Load(
            "ca-app-pub-3940256099942544/2247696110",
            new AdRequest(),
            new NativeAdOptions(),
            OnAdLoaded
        );
    }

    private void OnAdLoaded(NativeOverlayAd ad, LoadAdError error)
    {
        if (error != null)
        {
            GD.Print("Failed to load native ad: " + error.Message);
            return;
        }

        GD.Print("Native ad loaded successfully!");

        // Render the native ad at the bottom of the screen with a Medium template style
        NativeTemplateStyle style = new NativeTemplateStyle();
        style.TemplateId = NativeTemplateStyle.Medium;
        ad.RenderTemplate(style, AdPosition.Bottom);
    }
    ```

---

## Métodos de Instância

### `render_template` / `RenderTemplate`

Renderiza o anúncio nativo carregado na tela usando o estilo de template, posição e limites de tamanho personalizado opcionais especificados.

=== "GDScript"
    ```gdscript
    func render_template(style: NativeTemplateStyle, ad_position: AdPosition, ad_size: AdSize = null) -> void
    ```

=== "C#"
    ```csharp
    public void RenderTemplate(NativeTemplateStyle style, AdPosition adPosition, AdSize adSize = null)
    ```

---

### `set_template_position` / `SetTemplatePosition`

Move o template renderizado para uma nova posição de layout de anúncio ou deslocamento absoluto de tela.

=== "GDScript"
    ```gdscript
    func set_template_position(ad_position: AdPosition) -> void
    ```

=== "C#"
    ```csharp
    public void SetTemplatePosition(AdPosition adPosition)
    ```

---

### `destroy` / `Destroy`

Destrói o anúncio de sobreposição de template nativo e limpa os recursos nativos.

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
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

---

### `show` / `Show`

Exibe o anúncio de template nativo oculto para torná-lo visível na tela.

=== "GDScript"
    ```gdscript
    func show() -> void
    ```

=== "C#"
    ```csharp
    public void Show()
    ```

---

### `hide` / `Hide`

Oculta temporariamente o anúncio de template nativo sem destruí-lo.

=== "GDScript"
    ```gdscript
    func hide() -> void
    ```

=== "C#"
    ```csharp
    public void Hide()
    ```

---

### `get_template_width_in_pixels` / `GetTemplateWidthInPixels`

Retorna a largura do template nativo renderizado em pixels físicos.

=== "GDScript"
    ```gdscript
    func get_template_width_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateWidthInPixels()
    ```

---

### `get_template_height_in_pixels` / `GetTemplateHeightInPixels`

Retorna a altura do template nativo renderizado em pixels físicos.

=== "GDScript"
    ```gdscript
    func get_template_height_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateHeightInPixels()
    ```
