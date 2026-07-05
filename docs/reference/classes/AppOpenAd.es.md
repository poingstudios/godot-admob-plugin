# AppOpenAd

La clase `AppOpenAd` representa un formato de anuncio a pantalla completa que se presenta cuando el usuario abre o regresa a la aplicación.

## Propiedades

### `full_screen_content_callback` / `FullScreenContentCallback`

El listener de callback para recibir eventos sobre presentación, descarte o fallo al mostrar. Véase [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md).

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

Se activa cuando se registra una impresión de anuncio y se han generado ingresos. Recibe un [`AdValue`](AdValue.md).

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

### `placement_id` / `PlacementId`

Un entero que representa el índice de colocación de la posición del layout actual del anuncio.

=== "GDScript"
    ```gdscript
    var placement_id: int
    ```

=== "C#"
    ```csharp
    public int PlacementId { get; set; }
    ```

---

## Métodos

### `show` / `Show`

Presenta la superposición de anuncio App Open a pantalla completa.

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

Destruye el objeto de anuncio nativo y libera recursos.

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

Devuelve el ID de la unidad de anuncio asociada al anuncio cargado.

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

Devuelve la información de respuesta de mediación que contiene el historial de adaptadores para el anuncio cargado.

=== "GDScript"
    ```gdscript
    func get_response_info() -> ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo GetResponseInfo()
    ```
