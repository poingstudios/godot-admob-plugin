# NativeTemplateStyle

A classe `NativeTemplateStyle` configura o modelo de estilo visual e a personalização de cores para anúncios nativos de sobreposição.

## Constantes

### Templates

=== "GDScript"
    - `NativeTemplateStyle.SMALL`
    - `NativeTemplateStyle.MEDIUM`

=== "C#"
    - `NativeTemplateStyle.Small`
    - `NativeTemplateStyle.Medium`

---

## Propriedades

### `template_id` / `TemplateId`

A escolha do layout do template (`"small"` ou `"medium"`).

=== "GDScript"
    ```gdscript
    var template_id: String
    ```

=== "C#"
    ```csharp
    public string TemplateId { get; set; }
    ```

### `main_background_color` / `MainBackgroundColor`

A cor de fundo do contêiner de layout do anúncio nativo.

=== "GDScript"
    ```gdscript
    var main_background_color: Color # Or null
    ```

=== "C#"
    ```csharp
    public Color? MainBackgroundColor { get; set; }
    ```

### `primary_text` / `PrimaryText`

Configuração de estilo de texto para o título/texto principal do anúncio.

=== "GDScript"
    ```gdscript
    var primary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle PrimaryText { get; set; }
    ```

### `secondary_text` / `SecondaryText`

Configuração de estilo de texto para o corpo/texto de descrição do anúncio.

=== "GDScript"
    ```gdscript
    var secondary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle SecondaryText { get; set; }
    ```

### `tertiary_text` / `TertiaryText`

Configuração de estilo de texto para metadados textuais de terceiro nível.

=== "GDScript"
    ```gdscript
    var tertiary_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle TertiaryText { get; set; }
    ```

### `call_to_action_text` / `CallToActionText`

Configuração de estilo de texto para o botão clicável / campo de texto de Call To Action.

=== "GDScript"
    ```gdscript
    var call_to_action_text: NativeTemplateTextStyle
    ```

=== "C#"
    ```csharp
    public NativeTemplateTextStyle CallToActionText { get; set; }
    ```
