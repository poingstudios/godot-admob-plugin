# ConsentDebugSettings

`ConsentDebugSettings` クラスは、特定のデバッグ地域を強制したり、テストデバイスIDを指定したりするなど、同意フローのテスト設定オプションを提供します。

## プロパティ

### `debug_geography` / `DebugGeography`

テスト目的でシミュレートするデバッグ地域。[`DebugGeography`](../enums/DebugGeography.md) を参照してください。

=== "GDScript"
    ```gdscript
    var debug_geography: DebugGeography.Values
    ```

=== "C#"
    ```csharp
    public DebugGeography DebugGeography { get; set; }
    ```

### `test_device_hashed_ids` / `TestDeviceHashedIds`

同意フローでテストデバイスとして使用するハッシュ化されたデバイスIDのリスト。

=== "GDScript"
    ```gdscript
    var test_device_hashed_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceHashedIds { get; set; }
    ```
