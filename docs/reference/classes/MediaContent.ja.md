# MediaContent

`MediaContent` クラスは、ネイティブ広告に関連付けられたメディアアセット（ビデオまたは画像など）を表します。

## メソッド

### `has_video_content` / `HasVideoContent`

メディアコンテンツにビデオアセットが含まれている場合は `true` を返します。

=== "GDScript"
    ```gdscript
    func has_video_content() -> bool
    ```

=== "C#"
    ```csharp
    public bool HasVideoContent()
    ```

### `get_video_controller` / `GetVideoController`

ビデオの再生を制御し、ビデオイベントを受信するために、このメディアコンテンツに関連付けられた [`AdVideoController`](AdVideoController.ja.md) を返します。

=== "GDScript"
    ```gdscript
    func get_video_controller() -> AdVideoController
    ```

=== "C#"
    ```csharp
    public AdVideoController GetVideoController()
    ```

### `get_duration` / `GetDuration`

ビデオアセットの再生時間を秒単位で返します。ビデオコンテンツがない場合は `0.0` を返します。

=== "GDScript"
    ```gdscript
    func get_duration() -> float
    ```

=== "C#"
    ```csharp
    public float GetDuration()
    ```

### `get_aspect_ratio` / `GetAspectRatio`

メディアコンテンツのアスペクト比（幅/高さ）を返します。利用できない場合は `0.0` を返します。

=== "GDScript"
    ```gdscript
    func get_aspect_ratio() -> float
    ```

=== "C#"
    ```csharp
    public float GetAspectRatio()
    ```
