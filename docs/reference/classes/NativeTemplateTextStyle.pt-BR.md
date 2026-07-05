# NativeTemplateTextStyle

A classe `NativeTemplateTextStyle` configura os detalhes de estilo de primeiro plano e fundo dos campos de texto dentro de anúncios nativos de sobreposição.

## Propriedades

### `background_color` / `BackgroundColor`

A cor de fundo atrás do bloco de texto.

=== "GDScript"
    ```gdscript
    var background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? BackgroundColor { get; set; }
    ```

### `text_color` / `TextColor`

A cor do texto.

=== "GDScript"
    ```gdscript
    var text_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? TextColor { get; set; }
    ```

### `font_size` / `FontSize`

O tamanho da fonte em pontos.

=== "GDScript"
    ```gdscript
    var font_size: float
    ```

=== "C#"
    ```csharp
    public float FontSize { get; set; }
    ```

### `style` / `Style`

O estilo de peso da fonte dos elementos de texto.

=== "GDScript"
    ```gdscript
    var style: NativeTemplateFontStyle.Values
    ```

=== "C#"
    ```csharp
    public NativeTemplateFontStyle Style { get; set; }
    ```
