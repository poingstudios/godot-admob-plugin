# AdView

The `AdView` class is responsible for creating, loading, positioning, and displaying banner ads.

## Constructors

### `_init` / `AdView`

Initializes a new instance of the `AdView` class.

=== "GDScript"
    ```gdscript
    func _init(ad_unit_id: String, ad_size: AdSize, ad_position: AdPosition) -> void
    ```

    **Usage:**
    ```gdscript
    var ad_view := AdView.new("ca-app-pub-3940256099942544/6300978111", ad_size, ad_position)
    ```

=== "C#"
    ```csharp
    public AdView(string adUnitId, AdSize adSize, AdPosition adPosition)
    ```

    **Usage:**
    ```csharp
    AdView adView = new AdView("ca-app-pub-3940256099942544/2934735716", adSize, adPosition);
    ```

---

## Properties

### `ad_listener` / `AdListener`

The listener object that receives various ad loading and lifecycle callbacks.

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

    **Usage:**
    ```gdscript
    ad_view.ad_listener.on_ad_loaded = func():
        print("Ad loaded successfully!")
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

    **Usage:**
    ```csharp
    adView.AdListener.OnAdLoaded = () => {
        GD.Print("Ad loaded successfully!");
    };
    ```

### `on_ad_paid` / `OnAdPaid`

Callback triggered when an impression has occurred and the ad value (revenue) is calculated.

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

    **Usage:**
    ```gdscript
    ad_view.on_ad_paid = func(ad_value: AdValue):
        print("Ad revenue generated: ", ad_value.value_micros)
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

    **Usage:**
    ```csharp
    adView.OnAdPaid = (adValue) => {
        GD.Print($"Ad revenue generated: {adValue.ValueMicros}");
    };
    ```

---

## Methods

### `load_ad` / `LoadAd`

Loads an ad based on the request configuration.

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **Usage:**
    ```gdscript
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **Usage:**
    ```csharp
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

### `destroy` / `Destroy`

Destroys the banner and releases its native resources.

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

Returns information about the loaded ad's response and mediation metadata.

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

Displays the banner ad on screen.

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

Hides the banner ad from the screen.

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

Sets a new position for the banner ad.

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

Returns the width of the ad in density-independent pixels (dp).

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

Returns the height of the ad in density-independent pixels (dp).

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

Returns the width of the ad in physical screen pixels.

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

Returns the height of the ad in physical screen pixels.

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

Returns whether the loaded banner ad is a collapsible banner.

=== "GDScript"
    ```gdscript
    func is_collapsible() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCollapsible()
    ```
