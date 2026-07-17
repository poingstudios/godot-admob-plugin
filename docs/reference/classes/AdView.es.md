# AdView

La clase `AdView` es responsable de crear, cargar, posicionar y mostrar anuncios de banner.

## Constructors

### `_init` / `AdView`

Inicializa una nueva instancia de la clase `AdView`.

=== "GDScript"
    ```gdscript
    func _init(ad_unit_id: String, ad_size: AdSize, ad_position: AdPosition) -> void
    ```

    **Uso:**
    ```gdscript
    var ad_view := AdView.new("ca-app-pub-3940256099942544/6300978111", ad_size, ad_position)
    ```

=== "C#"
    ```csharp
    public AdView(string adUnitId, AdSize adSize, AdPosition adPosition)
    ```

    **Uso:**
    ```csharp
    AdView adView = new AdView("ca-app-pub-3940256099942544/2934735716", adSize, adPosition);
    ```

---

## Properties

### `ad_listener` / `AdListener`

El objeto de escucha que recibe varias llamadas de retorno de carga de anuncios y del ciclo de vida. Consulta [`AdListener`](../listeners/AdListener.md).

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

    **Uso:**
    ```gdscript
    ad_view.ad_listener.on_ad_loaded = func():
        print("Ad loaded successfully!")
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

    **Uso:**
    ```csharp
    adView.AdListener.OnAdLoaded = () => {
        GD.Print("Ad loaded successfully!");
    };
    ```

### `on_ad_paid` / `OnAdPaid`

Llamada de retorno que se activa cuando se produce una impresión y se calcula el valor del anuncio (ingresos). Recibe un [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Recibe AdValue
    ```

    **Uso:**
    ```gdscript
    ad_view.on_ad_paid = func(ad_value: AdValue):
        print("Ad revenue generated: ", ad_value.value_micros)
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

    **Uso:**
    ```csharp
    adView.OnAdPaid = (adValue) => {
        GD.Print($"Ad revenue generated: {adValue.ValueMicros}");
    };
    ```

---

## Methods

### `load_ad` / `LoadAd`

Carga un anuncio basado en la configuración de la solicitud.

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **Uso:**
    ```gdscript
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **Uso:**
    ```csharp
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

### `destroy` / `Destroy`

Destruye el banner y libera sus recursos nativos.

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

Devuelve información sobre la respuesta del anuncio cargado y los metadatos de mediación.

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

Muestra el anuncio de banner en la pantalla.

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

Oculta el anuncio de banner de la pantalla.

=== "GDScript"
    ```gdscript
    func hide() -> void
    ```

=== "C#"
    ```csharp
    public void Hide()
    ```

---

### `set_position` / `SetPosition`

Establece una nueva posición para el anuncio de banner.

=== "GDScript"
    ```gdscript
    func set_position(ad_position: AdPosition) -> void
    ```

=== "C#"
    ```csharp
    public void SetPosition(AdPosition adPosition)
    ```

---

### `get_width` / `GetWidth`

Devuelve el ancho del anuncio en píxeles independientes de la densidad (dp).

=== "GDScript"
    ```gdscript
    func get_width() -> int
    ```

=== "C#"
    ```csharp
    public int GetWidth()
    ```

---

### `get_height` / `GetHeight`

Devuelve la altura del anuncio en píxeles independientes de la densidad (dp).

=== "GDScript"
    ```gdscript
    func get_height() -> int
    ```

=== "C#"
    ```csharp
    public int GetHeight()
    ```

---

### `get_width_in_pixels` / `GetWidthInPixels`

Devuelve el ancho del anuncio en píxeles físicos de la pantalla.

=== "GDScript"
    ```gdscript
    func get_width_in_pixels() -> int
    ```

=== "C#"
    ```csharp
    public int GetWidthInPixels()
    ```

---

### `get_height_in_pixels` / `GetHeightInPixels`

Devuelve la altura del anuncio en píxeles físicos de la pantalla.

=== "GDScript"
    ```gdscript
    func get_height_in_pixels() -> int
    ```

=== "C#"
    ```csharp
    public int GetHeightInPixels()
    ```

---

### `is_collapsible` / `IsCollapsible`

Devuelve si el anuncio de banner cargado es un banner colapsable.

=== "GDScript"
    ```gdscript
    func is_collapsible() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCollapsible()
    ```
