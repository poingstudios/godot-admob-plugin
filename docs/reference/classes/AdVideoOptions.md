# AdVideoOptions

The `AdVideoOptions` class configures playback behavior for video elements loaded inside native template ads.

## Properties

### `click_to_expand_requested` / `ClickToExpandRequested`

Whether users can click to expand video content to full-screen.

=== "GDScript"
    ```gdscript
    var click_to_expand_requested: bool
    ```

=== "C#"
    ```csharp
    public bool ClickToExpandRequested { get; set; }
    ```

### `custom_controls_requested` / `CustomControlsRequested`

Whether custom media controls are requested for the video player.

=== "GDScript"
    ```gdscript
    var custom_controls_requested: bool
    ```

=== "C#"
    ```csharp
    public bool CustomControlsRequested { get; set; }
    ```

### `start_muted` / `StartMuted`

Whether video media elements should start playback in a muted state.

=== "GDScript"
    ```gdscript
    var start_muted: bool
    ```

=== "C#"
    ```csharp
    public bool StartMuted { get; set; }
    ```
