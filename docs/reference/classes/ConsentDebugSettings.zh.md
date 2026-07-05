# ConsentDebugSettings

`ConsentDebugSettings` 类为同意流程提供测试配置选项，例如强制特定的调试地理位置和指定测试设备 ID。

## 属性

### `debug_geography` / `DebugGeography`

用于测试目的的模拟调试地理位置。参见 [`DebugGeography`](../enums/DebugGeography.md)。

=== "GDScript"
    ```gdscript
    var debug_geography: DebugGeography.Values
    ```

=== "C#"
    ```csharp
    public DebugGeography DebugGeography { get; set; }
    ```

### `test_device_hashed_ids` / `TestDeviceHashedIds`

在同意流程中用作测试设备的哈希设备 ID 列表。

=== "GDScript"
    ```gdscript
    var test_device_hashed_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceHashedIds { get; set; }
    ```
