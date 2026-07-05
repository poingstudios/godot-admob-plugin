# ConsentDebugSettings

The `ConsentDebugSettings` class provides testing configuration options for the consent flow, such as forcing a specific debug geography and specifying test device IDs.

## Properties

### `debug_geography` / `DebugGeography`

The debug geography to simulate for testing purposes. See [`DebugGeography`](../enums/DebugGeography.md).

=== "GDScript"
    ```gdscript
    var debug_geography: DebugGeography.Values
    ```

=== "C#"
    ```csharp
    public DebugGeography DebugGeography { get; set; }
    ```

### `test_device_hashed_ids` / `TestDeviceHashedIds`

A list of hashed device IDs to use as test devices for the consent flow.

=== "GDScript"
    ```gdscript
    var test_device_hashed_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceHashedIds { get; set; }
    ```
