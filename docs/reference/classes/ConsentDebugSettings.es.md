# ConsentDebugSettings

La clase `ConsentDebugSettings` proporciona opciones de configuración de prueba para el flujo de consentimiento, como forzar una geografía de depuración específica y especificar IDs de dispositivos de prueba.

## Propiedades

### `debug_geography` / `DebugGeography`

La geografía de depuración que se simulará con fines de prueba. Vea [`DebugGeography`](../enums/DebugGeography.md).

=== "GDScript"
    ```gdscript
    var debug_geography: DebugGeography.Values
    ```

=== "C#"
    ```csharp
    public DebugGeography DebugGeography { get; set; }
    ```

### `test_device_hashed_ids` / `TestDeviceHashedIds`

Una lista de IDs de dispositivos hasheados para usar como dispositivos de prueba en el flujo de consentimiento.

=== "GDScript"
    ```gdscript
    var test_device_hashed_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceHashedIds { get; set; }
    ```
