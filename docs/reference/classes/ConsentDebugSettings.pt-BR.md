# ConsentDebugSettings

A classe `ConsentDebugSettings` fornece opções de configuração de teste para o fluxo de consentimento, como forçar uma geografia de depuração específica e especificar IDs de dispositivos de teste.

## Propriedades

### `debug_geography` / `DebugGeography`

A geografia de depuração a ser simulada para fins de teste. Veja [`DebugGeography`](../enums/DebugGeography.md).

=== "GDScript"
    ```gdscript
    var debug_geography: DebugGeography.Values
    ```

=== "C#"
    ```csharp
    public DebugGeography DebugGeography { get; set; }
    ```

### `test_device_hashed_ids` / `TestDeviceHashedIds`

Uma lista de IDs de dispositivos hash para usar como dispositivos de teste no fluxo de consentimento.

=== "GDScript"
    ```gdscript
    var test_device_hashed_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceHashedIds { get; set; }
    ```
