# AdView

`AdView` クラスは、バナー広告の作成、読み込み、配置、および表示を担当します。

## Constructors

### `_init` / `AdView`

`AdView` クラスの新しいインスタンスを初期化します。

=== "GDScript"
    ```gdscript
    func _init(ad_unit_id: String, ad_size: AdSize, ad_position: AdPosition) -> void
    ```

    **使い方:**
    ```gdscript
    var ad_view := AdView.new("ca-app-pub-3940256099942544/6300978111", ad_size, ad_position)
    ```

=== "C#"
    ```csharp
    public AdView(string adUnitId, AdSize adSize, AdPosition adPosition)
    ```

    **使い方:**
    ```csharp
    AdView adView = new AdView("ca-app-pub-3940256099942544/2934735716", adSize, adPosition);
    ```

---

## Properties

### `ad_listener` / `AdListener`

さまざまな広告の読み込みおよびライフサイクルのコールバックを受信するリスナーオブジェクト。[`AdListener`](../listeners/AdListener.md) を参照してください。

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

    **使い方:**
    ```gdscript
    ad_view.ad_listener.on_ad_loaded = func():
        print("Ad loaded successfully!")
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

    **使い方:**
    ```csharp
    adView.AdListener.OnAdLoaded = () => {
        GD.Print("Ad loaded successfully!");
    };
    ```

### `on_ad_paid` / `OnAdPaid`

インプレッションが発生し、広告の価値（収益）が計算されたときにトリガーされるコールバック。[`AdValue`](AdValue.md) を受信します。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # AdValue を受信します
    ```

    **使い方:**
    ```gdscript
    ad_view.on_ad_paid = func(ad_value: AdValue):
        print("Ad revenue generated: ", ad_value.value_micros)
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

    **使い方:**
    ```csharp
    adView.OnAdPaid = (adValue) => {
        GD.Print($"Ad revenue generated: {adValue.ValueMicros}");
    };
    ```

---

## Methods

### `load_ad` / `LoadAd`

リクエスト設定に基づいて広告を読み込みます。

=== "GDScript"
    ```gdscript
    func load_ad(ad_request: AdRequest) -> void
    ```

    **使い方:**
    ```gdscript
    var ad_request := AdRequest.new()
    ad_view.load_ad(ad_request)
    ```

=== "C#"
    ```csharp
    public void LoadAd(AdRequest adRequest)
    ```

    **使い方:**
    ```csharp
    AdRequest adRequest = new AdRequest();
    adView.LoadAd(adRequest);
    ```

---

### `destroy` / `Destroy`

バナーを破棄し、そのネイティブ リソースを解放します。

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

読み込まれた広告の応答情報とメディエーションのメタデータを返します。

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

画面にバナー広告を表示します。

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

画面からバナー広告を非表示にします。

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

バナー広告の新しい位置を設定します。

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

密度独立ピクセル（dp）単位で広告の幅を返します。

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

密度独立ピクセル（dp）単位で広告の高さを返します。

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

物理的な画面ピクセル単位で広告の幅を返します。

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

物理的な画面ピクセル単位で広告の高さを返します。

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

読み込まれたバナー広告が折りたたみ可能バナーかどうかを返します。

=== "GDScript"
    ```gdscript
    func is_collapsible() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCollapsible()
    ```
