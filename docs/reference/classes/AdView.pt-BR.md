# AdView

A classe `AdView` é responsável por criar, carregar, posicionar e exibir anúncios de banner.

## Constructors

### `_init` / `AdView`

Inicializa uma nova instância da classe `AdView`.

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

O objeto listener que recebe vários callbacks de carregamento de anúncios e ciclo de vida. Consulte [`AdListener`](../listeners/AdListener.md).

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

Callback acionado quando ocorre uma impressão e o valor do anúncio (receita) é calculado. Recebe um [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Recebe AdValue
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

Carrega um anúncio com base na configuração da solicitação.

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

Destrói o banner e libera seus recursos nativos.

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

Retorna informações sobre a resposta do anúncio carregado e metadados de mediação.

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

Exibe o anúncio de banner na tela.

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

Oculta o anúncio de banner da tela.

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

Define uma nova posição para o anúncio de banner.

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

Retorna a largura do anúncio em pixels independentes de densidade (dp).

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

Retorna a altura do anúncio em pixels independentes de densidade (dp).

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

Retorna a largura do anúncio em pixels físicos da tela.

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

Retorna a altura do anúncio em pixels físicos da tela.

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

Retorna se o anúncio de banner carregado é um banner colapsável.

=== "GDScript"
    ```gdscript
    func is_collapsible() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCollapsible()
    ```
