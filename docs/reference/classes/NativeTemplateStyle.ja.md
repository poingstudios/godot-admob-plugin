# NativeTemplateStyle

`NativeTemplateStyle` クラスは、ネイティブオーバーレイ広告のビジュアルスタイルテンプレートと色のカスタマイズを設定します。

## 定数

### テンプレート

=== "GDScript"
    - `NativeTemplateStyle.SMALL`
    - `NativeTemplateStyle.MEDIUM`

=== "C#"
    - `NativeTemplateStyle.Small`
    - `NativeTemplateStyle.Medium`

---

## プロパティ

### `template_id` / `TemplateId`

テンプレートレイアウトの選択（`"small"` または `"medium"`）。

=== "GDScript"
    ```gdscript
    var template_id: String
    ```

=== "C#"
    ```csharp
    public string TemplateId { get; set; }
    ```

### `main_background_color` / `MainBackgroundColor`

ネイティブ広告レイアウトコンテナの背景色。

=== "GDScript"
    ```gdscript
    var main_background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? MainBackgroundColor { get; set; }
    ```

### `primary_text` / `PrimaryText`

広告のメインタイトル/見出しテキストの TextStyle 設定。

=== "GDScript"
    ```gdscript
    var primary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle PrimaryText { get; set; }
    ```

### `secondary_text` / `SecondaryText`

広告の本文/説明テキストの TextStyle 設定。

=== "GDScript"
    ```gdscript
    var secondary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle SecondaryText { get; set; }
    ```

### `tertiary_text` / `TertiaryText`

第3レベルのテキストメタデータの TextStyle 設定。

=== "GDScript"
    ```gdscript
    var tertiary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle TertiaryText { get; set; }
    ```

### `call_to_action_text` / `CallToActionText`

クリック可能なボタン / Call To Action テキストフィールドの TextStyle 設定。

=== "GDScript"
    ```gdscript
    var call_to_action_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle CallToActionText { get; set; }
    ```
