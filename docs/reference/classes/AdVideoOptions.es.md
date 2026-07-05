# AdVideoOptions

La clase `AdVideoOptions` configura el comportamiento de reproducción de elementos de video cargados dentro de anuncios de plantilla nativa.

## Propiedades

### `click_to_expand_requested` / `ClickToExpandRequested`

Si los usuarios pueden hacer clic para expandir el contenido de video a pantalla completa.

=== "GDScript"
    ```gdscript
    var click_to_expand_requested: bool
    ```

=== "C#"
    ```csharp
    public bool ClickToExpandRequested { get; set; }
    ```

### `custom_controls_requested` / `CustomControlsRequested`

Si se solicitan controles de medios personalizados para el reproductor de video.

=== "GDScript"
    ```gdscript
    var custom_controls_requested: bool
    ```

=== "C#"
    ```csharp
    public bool CustomControlsRequested { get; set; }
    ```

### `start_muted` / `StartMuted`

Si los elementos de video deben iniciar la reproducción en estado silenciado.

=== "GDScript"
    ```gdscript
    var start_muted: bool
    ```

=== "C#"
    ```csharp
    public bool StartMuted { get; set; }
    ```
