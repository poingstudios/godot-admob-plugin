# NativeTemplateTextStyle

`NativeTemplateTextStyle` クラスは、ネイティブオーバーレイ広告内のテキストフィールドの前景と背景のスタイル詳細を設定します。

## プロパティ

### `background_color` / `BackgroundColor`

テキストブロックの後ろの背景色。

=== "GDScript"
    ```gdscript
    var background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? BackgroundColor { get; set; }
    ```

### `text_color` / `TextColor`

テキストの色。

=== "GDScript"
    ```gdscript
    var text_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? TextColor { get; set; }
    ```

### `font_size` / `FontSize`

ポイント単位のフォントサイズ。

=== "GDScript"
    ```gdscript
    var font_size: float
    ```

=== "C#"
    ```csharp
    public float FontSize { get; set; }
    ```

### `style` / `Style`

テキスト要素のフォントウェイトスタイル。

=== "GDScript"
    ```gdscript
    var style: NativeTemplateFontStyle.Values
    ```

=== "C#"
    ```csharp
    public NativeTemplateFontStyle Style { get; set; }
    ```
