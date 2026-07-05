# NativeTemplateStyle

`NativeTemplateStyle` 类配置原生叠加广告的视觉样式模板和颜色自定义。

## 常量

### 模板

=== "GDScript"
    - `NativeTemplateStyle.SMALL`
    - `NativeTemplateStyle.MEDIUM`

=== "C#"
    - `NativeTemplateStyle.Small`
    - `NativeTemplateStyle.Medium`

---

## 属性

### `template_id` / `TemplateId`

模板布局选择（`"small"` 或 `"medium"`）。

=== "GDScript"
    ```gdscript
    var template_id: String
    ```

=== "C#"
    ```csharp
    public string TemplateId { get; set; }
    ```

### `main_background_color` / `MainBackgroundColor`

原生广告布局容器的背景颜色。

=== "GDScript"
    ```gdscript
    var main_background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? MainBackgroundColor { get; set; }
    ```

### `primary_text` / `PrimaryText`

广告主标题/标题文本的 TextStyle 配置。

=== "GDScript"
    ```gdscript
    var primary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle PrimaryText { get; set; }
    ```

### `secondary_text` / `SecondaryText`

广告正文/描述文本的 TextStyle 配置。

=== "GDScript"
    ```gdscript
    var secondary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle SecondaryText { get; set; }
    ```

### `tertiary_text` / `TertiaryText`

第三级文本元数据的 TextStyle 配置。

=== "GDScript"
    ```gdscript
    var tertiary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle TertiaryText { get; set; }
    ```

### `call_to_action_text` / `CallToActionText`

可点击按钮/行动号召文本字段的 TextStyle 配置。

=== "GDScript"
    ```gdscript
    var call_to_action_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle CallToActionText { get; set; }
    ```
