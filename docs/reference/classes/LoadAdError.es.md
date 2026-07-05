# LoadAdError

`LoadAdError` extiende `AdError` para representar errores que ocurren durante la carga del anuncio. Incluye un objeto `ResponseInfo` que detalla los resultados del waterfall de mediación.

## Hereda
- [AdError](AdError.md)

## Propiedades

### `response_info` / `ResponseInfo`

Contiene detalles sobre la respuesta de la solicitud de carga y el historial del waterfall de mediación.

=== "GDScript"
    ```gdscript
    var response_info: ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo ResponseInfo { get; set; }
    ```
