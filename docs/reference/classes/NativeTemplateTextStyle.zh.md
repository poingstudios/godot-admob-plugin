# NativeTemplateTextStyle

`NativeTemplateTextStyle` 类配置原生叠加广告中文本字段的前景和背景样式细节。

## 属性

### `background_color` / `BackgroundColor`

文本块后面的背景颜色。

=== "GDScript"
    ```gdscript
    var background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? BackgroundColor { get; set; }
    ```

### `text_color` / `TextColor`

文本颜色。

=== "GDScript"
    ```gdscript
    var text_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? TextColor { get; set; }
    ```

### `font_size` / `FontSize`

字号（以磅为单位）。

=== "GDScript"
    ```gdscript
    var font_size: float
    ```

=== "C#"
    ```csharp
    public float FontSize { get; set; }
    ```

### `style` / `Style`

文本元素的字重样式。

=== "GDScript"
    ```gdscript
    var style: NativeTemplateFontStyle.Values
    ```

=== "C#"
    ```csharp
    public NativeTemplateFontStyle Style { get; set; }
    ```
