# AdVideoOptions

`AdVideoOptions` クラスは、ネイティブテンプレート広告内に読み込まれた動画要素の再生動作を設定します。

## プロパティ

### `click_to_expand_requested` / `ClickToExpandRequested`

ユーザーがクリックして動画コンテンツを全画面に拡大できるかどうか。

=== "GDScript"
    ```gdscript
    var click_to_expand_requested: bool
    ```

=== "C#"
    ```csharp
    public bool ClickToExpandRequested { get; set; }
    ```

### `custom_controls_requested` / `CustomControlsRequested`

動画プレーヤーにカスタムメディアコントロールが要求されているかどうか。

=== "GDScript"
    ```gdscript
    var custom_controls_requested: bool
    ```

=== "C#"
    ```csharp
    public bool CustomControlsRequested { get; set; }
    ```

### `start_muted` / `StartMuted`

動画メディア要素がミュート状態で再生を開始するかどうか。

=== "GDScript"
    ```gdscript
    var start_muted: bool
    ```

=== "C#"
    ```csharp
    public bool StartMuted { get; set; }
    ```
