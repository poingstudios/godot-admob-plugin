# LoadAdError

`LoadAdError` extends `AdError` to represent errors occurring during ad loading. It includes a `ResponseInfo` object detailing mediation waterfall results.

## Inherits
- [AdError](AdError.md)

## Properties

### `response_info` / `ResponseInfo`

Contains details about the load request's response and mediation waterfall history.

=== "GDScript"
    ```gdscript
    var response_info: ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo ResponseInfo { get; set; }
    ```
