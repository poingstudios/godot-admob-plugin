# AdView

`AdView` 类负责创建、加载、定位和显示横幅广告。

## Constructors

### `_init` / `AdView`

初始化 `AdView` 类的新实例。

=== "GDScript"
    ```gdscript
    func _init(ad_unit_id: String, ad_size: AdSize, ad_position: AdPosition) -> void
    ```

    **用法：**
    ```gdscript
    var ad_view := AdView.new("ca-app-pub-3940256099942544/6300978111", ad_size, ad_position)
    ```

=== "C#"
    ```csharp
    public AdView(string adUnitId, AdSize adSize, AdPosition adPosition)
    ```

    **用法：**
    ```csharp
    AdView adView = new AdView("ca-app-pub-3940256099942544/2934735716", adSize, adPosition);
    ```

---

## Properties

### `ad_listener` / `AdListener`

接收各种广告加载和生命周期回调的监听器对象。请参阅 [`AdListener`](../listeners/AdListener.md)。

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

    **用法：**
    ```gdscript
    ad_view.ad_listener.on_ad_loaded = func():
        print("Ad loaded successfully!")
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

    **用法：**
    ```csharp
    adView.AdListener.OnAdLoaded = () => {
        GD.Print("Ad loaded successfully!");
    };
    ```

### `on_ad_paid` / `OnAdPaid`

在发生展示并计算广告价值（收入）时触发的回调。接收一个 [`AdValue`](AdValue.md)。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # 接收 AdValue
    ```

    **用法：**
    ```gdscript
    ad_view.on_ad_paid = func(ad_value: AdValue):
        print("Ad revenue generated: ", ad_value.value_micros)
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

    **用法：**
    ```csharp
    adView.OnAdPaid = (adValue) => {
        GD.Print($"Ad revenue generated: {adValue.ValueMicros}");
    };
    ```

---

## Methods

### `load_ad` / `LoadAd`

根据请求配置加载广告。

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **用法：**
    ```gdscript
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **用法：**
    ```csharp
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

### `destroy` / `Destroy`

销毁横幅并释放其原生资源。

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

返回有关已加载广告的响应信息和中介元数据。

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

在屏幕上显示横幅广告。

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

从屏幕上隐藏横幅广告。

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

为横幅广告设置新位置。

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

返回广告的宽度，单位为与密度无关的像素 (dp)。

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

返回广告的高度，单位为与密度无关的像素 (dp)。

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

返回广告的物理屏幕像素宽度。

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

返回广告的物理屏幕像素高度。

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

返回加载的横幅广告是否为折叠式横幅。

=== "GDScript"
    ```gdscript
    func is_collapsible() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCollapsible()
    ```
