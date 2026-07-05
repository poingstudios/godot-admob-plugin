# InterstitialAd

`InterstitialAd` 类表示一个全屏插页式广告格式，可以向用户展示。

## 属性

### `full_screen_content_callback` / `FullScreenContentCallback`

用于接收展示、关闭或显示失败事件的回调监听器。参见 [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md)。

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

在广告曝光被记录并产生收入时触发。接收一个 [`AdValue`](AdValue.md)。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## 方法

### `show` / `Show`

展示全屏插页式广告覆盖层。

=== "GDScript"
    ```gdscript
    func show() -> void
    ```

=== "C#"
    ```csharp
    public void Show()
    ```

---

### `destroy` / `Destroy`

销毁原生广告对象并释放资源。

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
