# NativeTemplateTextStyle

The `NativeTemplateTextStyle` class configures the foreground and background styling details of text fields inside native overlay ads.

## Properties

### `background_color` / `BackgroundColor`

The background color behind the text block.

=== "GDScript"
    ```gdscript
    var background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? BackgroundColor { get; set; }
    ```

### `text_color` / `TextColor`

The text color.

=== "GDScript"
    ```gdscript
    var text_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? TextColor { get; set; }
    ```

### `font_size` / `FontSize`

The size of the font in points.

=== "GDScript"
    ```gdscript
    var font_size: float
    ```

=== "C#"
    ```csharp
    public float FontSize { get; set; }
    ```

### `style` / `Style`

The font weight style of the text elements.

=== "GDScript"
    ```gdscript
    var style: NativeTemplateFontStyle.Values
    ```

=== "C#"
    ```csharp
    public NativeTemplateFontStyle Style { get; set; }
    ```
