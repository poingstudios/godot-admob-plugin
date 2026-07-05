# AdVideoOptions

A classe `AdVideoOptions` configura o comportamento de reprodução de elementos de vídeo carregados em anúncios de template nativo.

## Propriedades

### `click_to_expand_requested` / `ClickToExpandRequested`

Se os usuários podem clicar para expandir o conteúdo de vídeo para tela cheia.

=== "GDScript"
    ```gdscript
    var click_to_expand_requested: bool
    ```

=== "C#"
    ```csharp
    public bool ClickToExpandRequested { get; set; }
    ```

### `custom_controls_requested` / `CustomControlsRequested`

Se controles de mídia personalizados são solicitados para o player de vídeo.

=== "GDScript"
    ```gdscript
    var custom_controls_requested: bool
    ```

=== "C#"
    ```csharp
    public bool CustomControlsRequested { get; set; }
    ```

### `start_muted` / `StartMuted`

Se os elementos de mídia de vídeo devem iniciar a reprodução no estado mudo.

=== "GDScript"
    ```gdscript
    var start_muted: bool
    ```

=== "C#"
    ```csharp
    public bool StartMuted { get; set; }
    ```
