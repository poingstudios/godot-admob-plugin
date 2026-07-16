# AdVideoController

`AdVideoController` クラスは、ネイティブ広告内のビデオアセットに関する情報を照会し、ビデオ再生イベントを処理するコールバックを設定するメソッドを提供します。

## プロパティ

### `video_lifecycle_callbacks` / `VideoLifecycleCallbacks`

ビデオ再生イベントを受信する [`VideoLifecycleCallbacks`](../listeners/VideoLifecycleCallbacks.md) インスタンス。

=== "GDScript"
    ```gdscript
    var video_lifecycle_callbacks: VideoLifecycleCallbacks
    ```

=== "C#"
    ```csharp
    public VideoLifecycleCallbacks VideoLifecycleCallbacks { get; set; }
    ```

## メソッド

### `is_muted` / `IsMuted`

ビデオが現在ミュートされている場合は `true` を返します。

=== "GDScript"
    ```gdscript
    func is_muted() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsMuted()
    ```

### `is_custom_controls_enabled` / `IsCustomControlsEnabled`

このビデオでカスタムコントロールが有効になっている場合は `true` を返します。

=== "GDScript"
    ```gdscript
    func is_custom_controls_enabled() -> bool
    ```

=== "C#"
    ```csharp
    public bool IsCustomControlsEnabled()
    ```
