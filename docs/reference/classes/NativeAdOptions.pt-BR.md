# NativeAdOptions

A classe `NativeAdOptions` configura preferências para renderização de anúncios nativos de sobreposição.

## Propriedades

### `media_aspect_ratio` / `MediaAspectRatio`

A proporção de aspecto preferida para conteúdo de mídia exibido dentro do anúncio nativo.

=== "GDScript"
    ```gdscript
    var media_aspect_ratio: NativeMediaAspectRatio.Values
    ```

=== "C#"
    ```csharp
    public NativeMediaAspectRatio MediaAspectRatio { get; set; }
    ```

### `ad_choices_placement` / `AdChoicesPlacement`

A posição preferida do canto da tela para a sobreposição do ícone AdChoices.

=== "GDScript"
    ```gdscript
    var ad_choices_placement: AdChoicesPlacement.Values
    ```

=== "C#"
    ```csharp
    public AdChoicesPlacement AdChoicesPlacement { get; set; }
    ```

### `video_options` / `VideoOptions`

As configurações de vídeo personalizadas aplicadas a quaisquer elementos de vídeo dentro do anúncio nativo.

=== "GDScript"
    ```gdscript
    var video_options: AdVideoOptions
    ```

=== "C#"
    ```csharp
    public AdVideoOptions VideoOptions { get; set; }
    ```
