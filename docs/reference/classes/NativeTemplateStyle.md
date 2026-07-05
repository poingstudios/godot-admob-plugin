# NativeTemplateStyle

The `NativeTemplateStyle` class configures the visual styling template and color customization for native overlay ads.

## Constants

### Templates

=== "GDScript"
    - `NativeTemplateStyle.SMALL`
    - `NativeTemplateStyle.MEDIUM`

=== "C#"
    - `NativeTemplateStyle.Small`
    - `NativeTemplateStyle.Medium`

---

## Properties

### `template_id` / `TemplateId`

The template layout choice (`"small"` or `"medium"`).

=== "GDScript"
    ```gdscript
    var template_id: String
    ```

=== "C#"
    ```csharp
    public string TemplateId { get; set; }
    ```

### `main_background_color` / `MainBackgroundColor`

The background color of the native ad layout container.

=== "GDScript"
    ```gdscript
    var main_background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? MainBackgroundColor { get; set; }
    ```

### `primary_text` / `PrimaryText`

TextStyle configuration for the ad's main title/heading text.

=== "GDScript"
    ```gdscript
    var primary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle PrimaryText { get; set; }
    ```

### `secondary_text` / `SecondaryText`

TextStyle configuration for the ad's body/description text.

=== "GDScript"
    ```gdscript
    var secondary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle SecondaryText { get; set; }
    ```

### `tertiary_text` / `TertiaryText`

TextStyle configuration for third-tier textual metadata.

=== "GDScript"
    ```gdscript
    var tertiary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle TertiaryText { get; set; }
    ```

### `call_to_action_text` / `CallToActionText`

TextStyle configuration for the clickable button / Call To Action text field.

=== "GDScript"
    ```gdscript
    var call_to_action_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle CallToActionText { get; set; }
    ```
