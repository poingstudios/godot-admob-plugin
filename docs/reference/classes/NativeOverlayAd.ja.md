# NativeOverlayAd

`NativeOverlayAd` クラスは、Godot シーンにオーバーレイするネイティブテンプレート広告を管理します。

## プロパティ

### `ad_listener` / `AdListener`

表示、閉じる、表示失敗のイベントを受け取るコールバックリスナー。 [`AdListener`](../listeners/AdListener.md) を参照してください。

=== "GDScript"
    ```gdscript
    var ad_listener: AdListener
    ```

=== "C#"
    ```csharp
    public AdListener AdListener { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

インプレッションが記録され収益が発生したときにトリガーされます。[`AdValue`](AdValue.md) を受け取ります。

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

ネイティブテンプレートが画面上に配置・レンダリングされた後（テンプレートビューが初めてグローバルレイアウトパスを完了した時点、またはエディタのモックテンプレートが配置された時点で）1回だけトリガーされます。これを使用して実際のレンダリングサイズに反応してください — 例えば、同期呼び出しの `get_template_height_in_pixels()`（古い寸法を返す可能性があります）に依存するのではなく、広告が完全にレンダリングされた後にのみコンテンツを `SafeArea` にプッシュするようにします。

=== "GDScript"
    ```gdscript
    var on_template_rendered: Callable
    ```

=== "C#"
    ```csharp
    public Action OnTemplateRendered { get; set; }
    ```

---

## 静的メソッド

### `load` / `Load`

ネイティブテンプレートオーバーレイ広告を非同期的にリクエストしてロードします。

=== "GDScript"
    ```gdscript
    static func load(
        ad_unit_id: String,
        ad_request: AdRequest,
        options: NativeAdOptions,
        ad_load_callback: Callable # Signature: func(ad: NativeOverlayAd, error: LoadAdError)
    ) -> void
    ```

    **使用法:**
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

    **使用法:**
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

## インスタンスメソッド

### `render_template` / `RenderTemplate`

指定されたテンプレートスタイル、位置、およびオプションのカスタムサイズ制限を使用して、ロードされたネイティブ広告を画面にレンダリングします。

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

レンダリングされたテンプレートを新しい広告位置レイアウトまたは絶対画面オフセットに移動します。

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

ネイティブテンプレートオーバーレイ広告を破棄し、ネイティブリソースをクリーンアップします。

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

読み込まれた広告のアダプター履歴を含むメディエーション応答情報を返します。

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

ネイティブテンプレート広告の非表示を解除して画面に表示します。

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

破棄せずにネイティブテンプレート広告を一時的に非表示にします。

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

レンダリングされたネイティブテンプレートの幅を物理ピクセルで返します。

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

レンダリングされたネイティブテンプレートの高さを物理ピクセルで返します。

=== "GDScript"
    ```gdscript
    func get_template_height_in_pixels() -> float
    ```

=== "C#"
    ```csharp
    public float GetTemplateHeightInPixels()
    ```
