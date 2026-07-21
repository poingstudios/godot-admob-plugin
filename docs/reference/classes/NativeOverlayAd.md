# NativeOverlayAd

The `NativeOverlayAd` class manages native template ads overlaying Godot scenes.

## Properties

### `ad_listener` / `AdListener`

The callback listener to receive events about presentation, dismissal, or failure to show. See [`AdListener`](../listeners/AdListener.md).

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Triggered when an impression is recorded and revenue has been generated. Receives an [`AdValue`](AdValue.md).

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

Triggered once after the native template has been laid out and rendered on screen (the first time the template view completes its global layout pass, or when the mock template is positioned in the editor). Use this to react to the actual rendered size — for example, to push content into a [`SafeArea`](../../ad_formats/native_overlay.md#showhide-and-destroy) only after the ad is fully rendered, instead of relying on a synchronous call to `get_template_height_in_pixels()` which may return stale dimensions.

=== "GDScript"
    ```gdscript
    var on_template_rendered: Callable
    ```

=== "C#"
    ```csharp
    public Action OnTemplateRendered { get; set; }
    ```

---

## Static Methods

### `load` / `Load`

Asynchronously requests and loads a native template overlay ad.

=== "GDScript"
    ```gdscript
    static func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        options: NativeAdOptions,
        ad_load_callback: Callable # Signature: func(ad: NativeOverlayAd, error: LoadAdError)
    ) -> void
    ```

    **Usage:**
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

    **Usage:**
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

## Instance Methods

### `render_template` / `RenderTemplate`

Renders the loaded native ad on the screen using the specified template style, position, and optional custom size limits.

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

Moves the rendered template to a new ad position layout or absolute screen offset.

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

Destroys the native template overlay ad and cleans up native resources.

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

Returns the mediation response info containing adapter history for the loaded ad.

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

Unhides the native template ad to make it visible on the screen.

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

Temporarily hides the native template ad from view without destroying it.

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

Returns the rendered native template width in physical pixels.

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

Returns the rendered native template height in physical pixels.

=== "GDScript"
    ```gdscript
    func get_template_height_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateHeightInPixels()
    ```
