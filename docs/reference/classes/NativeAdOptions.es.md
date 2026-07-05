# NativeAdOptions

La clase `NativeAdOptions` configura las preferencias para la representación de anuncios nativos superpuestos.

## Propiedades

### `media_aspect_ratio` / `MediaAspectRatio`

La relación de aspecto preferida para el contenido multimedia mostrado dentro del anuncio nativo.

=== "GDScript"
    ```gdscript
    var media_aspect_ratio: NativeMediaAspectRatio.Values
    ```

=== "C#"
    ```csharp
    public NativeMediaAspectRatio MediaAspectRatio { get; set; }
    ```

### `ad_choices_placement` / `AdChoicesPlacement`

La posición preferida en la esquina de la pantalla para la superposición del ícono de AdChoices.

=== "GDScript"
    ```gdscript
    var ad_choices_placement: AdChoicesPlacement.Values
    ```

=== "C#"
    ```csharp
    public AdChoicesPlacement AdChoicesPlacement { get; set; }
    ```

### `video_options` / `VideoOptions`

Las configuraciones de video personalizadas aplicadas a cualquier elemento de video dentro del anuncio nativo.

=== "GDScript"
    ```gdscript
    var video_options: AdVideoOptions
    ```

=== "C#"
    ```csharp
    public AdVideoOptions VideoOptions { get; set; }
    ```
