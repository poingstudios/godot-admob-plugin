# NativeOverlayAd

`NativeOverlayAd` 类管理叠加在 Godot 场景上的原生模板广告。

## 属性

### `ad_listener` / `AdListener`

用于接收展示、关闭或显示失败事件的回调监听器。参见 [`AdListener`](../listeners/AdListener.md)。

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

在曝光被记录并产生收入时触发。接收一个 [`AdValue`](AdValue.md)。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## 静态方法

### `load` / `Load`

异步请求并加载原生模板叠加广告。

=== "GDScript"
    ```gdscript
    static func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        options: NativeAdOptions,
        ad_load_callback: Callable # Signature: func(ad: NativeOverlayAd, error: LoadAdError)
    ) -> void
    ```

    **用法:**
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

    **用法:**
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

## 实例方法

### `render_template` / `RenderTemplate`

使用指定的模板样式、位置和可选的自定义大小限制在屏幕上渲染已加载的原生广告。

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

将渲染的模板移动到新的广告位置布局或绝对屏幕偏移。

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

销毁原生模板叠加广告并清理原生资源。

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

返回包含已加载广告的适配器历史记录的 mediation 响应信息。

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

取消隐藏原生模板广告以使其在屏幕上可见。

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

在不销毁的情况下临时隐藏原生模板广告。

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

返回渲染的原生模板宽度（物理像素）。

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

返回渲染的原生模板高度（物理像素）。

=== "GDScript"
    ```gdscript
    func get_template_height_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateHeightInPixels()
    ```
