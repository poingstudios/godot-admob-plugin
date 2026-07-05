# AppOpenAd

The `AppOpenAd` class represents a full-screen ad format that is presented when the user opens or returns to the application.

## Properties

### `full_screen_content_callback` / `FullScreenContentCallback`

The callback listener to receive events about presentation, dismissal, or failure to show. See [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md).

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Triggered when an ad impression is recorded and revenue has been generated. Receives an [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

### `placement_id` / `PlacementId`

An integer representing the current layout position placement index of the ad.

=== "GDScript"
    ```gdscript
    var placement_id: int
    ```

=== "C#"
    ```csharp
    public int PlacementId { get; set; }
    ```

---

## Methods

### `show` / `Show`

Presents the full-screen App Open ad overlay.

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

Destroys the native ad object and frees up resources.

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
    ```

---

### `get_ad_unit_id` / `GetAdUnitId`

Returns the ad unit ID associated with the loaded ad.

=== "GDScript"
    ```gdscript
    func get_ad_unit_id() -> String
    ```

=== "C#"
    ```csharp
    public string GetAdUnitId()
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
