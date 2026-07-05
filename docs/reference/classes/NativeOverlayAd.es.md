# NativeOverlayAd

La clase `NativeOverlayAd` gestiona anuncios de plantilla nativa superpuestos a las escenas de Godot.

## Propiedades

### `ad_listener` / `AdListener`

El listener de callback para recibir eventos sobre presentación, descarte o fallo al mostrar. Véase [`AdListener`](../listeners/AdListener.md).

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Se activa cuando se registra una impresión y se han generado ingresos. Recibe un [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## Métodos Estáticos

### `load` / `Load`

Solicita y carga asíncronamente un anuncio de superposición de plantilla nativa.

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

## Métodos de Instancia

### `render_template` / `RenderTemplate`

Renderiza el anuncio nativo cargado en la pantalla usando el estilo de plantilla, posición y límites de tamaño personalizado opcionales especificados.

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

Mueve la plantilla renderizada a una nueva posición de diseño de anuncio o desplazamiento absoluto de pantalla.

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

Destruye el anuncio de superposición de plantilla nativa y limpia los recursos nativos.

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

Devuelve la información de respuesta de mediación que contiene el historial de adaptadores para el anuncio cargado.

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

Muestra el anuncio de plantilla nativa oculto para hacerlo visible en la pantalla.

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

Oculta temporalmente el anuncio de plantilla nativa sin destruirlo.

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

Devuelve el ancho de la plantilla nativa renderizada en píxeles físicos.

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

Devuelve la altura de la plantilla nativa renderizada en píxeles físicos.

=== "GDScript"
    ```gdscript
    func get_template_height_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateHeightInPixels()
    ```
