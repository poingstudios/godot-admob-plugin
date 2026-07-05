# NativeTemplateTextStyle

La clase `NativeTemplateTextStyle` configura los detalles de estilo de primer plano y fondo de los campos de texto dentro de anuncios nativos superpuestos.

## Propiedades

### `background_color` / `BackgroundColor`

El color de fondo detrás del bloque de texto.

=== "GDScript"
    ```gdscript
    var background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? BackgroundColor { get; set; }
    ```

### `text_color` / `TextColor`

El color del texto.

=== "GDScript"
    ```gdscript
    var text_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? TextColor { get; set; }
    ```

### `font_size` / `FontSize`

El tamaño de la fuente en puntos.

=== "GDScript"
    ```gdscript
    var font_size: float
    ```

=== "C#"
    ```csharp
    public float FontSize { get; set; }
    ```

### `style` / `Style`

El estilo de peso de la fuente de los elementos de texto.

=== "GDScript"
    ```gdscript
    var style: NativeTemplateFontStyle.Values
    ```

=== "C#"
    ```csharp
    public NativeTemplateFontStyle Style { get; set; }
    ```
