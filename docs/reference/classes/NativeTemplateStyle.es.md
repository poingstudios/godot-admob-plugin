# NativeTemplateStyle

La clase `NativeTemplateStyle` configura el modelo de estilo visual y la personalización de colores para anuncios nativos superpuestos.

## Constantes

### Templates

=== "GDScript"
    - `NativeTemplateStyle.SMALL`
    - `NativeTemplateStyle.MEDIUM`

=== "C#"
    - `NativeTemplateStyle.Small`
    - `NativeTemplateStyle.Medium`

---

## Propiedades

### `template_id` / `TemplateId`

La elección del diseño de la plantilla (`"small"` o `"medium"`).

=== "GDScript"
    ```gdscript
    var template_id: String
    ```

=== "C#"
    ```csharp
    public string TemplateId { get; set; }
    ```

### `main_background_color` / `MainBackgroundColor`

El color de fondo del contenedor de diseño del anuncio nativo.

=== "GDScript"
    ```gdscript
    var main_background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? MainBackgroundColor { get; set; }
    ```

### `primary_text` / `PrimaryText`

Configuración de estilo de texto para el título/texto principal del anuncio.

=== "GDScript"
    ```gdscript
    var primary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle PrimaryText { get; set; }
    ```

### `secondary_text` / `SecondaryText`

Configuración de estilo de texto para el cuerpo/texto de descripción del anuncio.

=== "GDScript"
    ```gdscript
    var secondary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle SecondaryText { get; set; }
    ```

### `tertiary_text` / `TertiaryText`

Configuración de estilo de texto para metadatos textuales de tercer nivel.

=== "GDScript"
    ```gdscript
    var tertiary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle TertiaryText { get; set; }
    ```

### `call_to_action_text` / `CallToActionText`

Configuración de estilo de texto para el botón clicable / campo de texto de Call To Action.

=== "GDScript"
    ```gdscript
    var call_to_action_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle CallToActionText { get; set; }
    ```
