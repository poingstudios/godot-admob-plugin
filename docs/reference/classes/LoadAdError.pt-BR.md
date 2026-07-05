# LoadAdError

`LoadAdError` estende `AdError` para representar erros que ocorrem durante o carregamento do anúncio. Inclui um objeto `ResponseInfo` detalhando os resultados do waterfall de mediação.

## Herda
- [AdError](AdError.md)

## Propriedades

### `response_info` / `ResponseInfo`

Contém detalhes sobre a resposta da solicitação de carregamento e o histórico do waterfall de mediação.

=== "GDScript"
    ```gdscript
    var response_info: ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo ResponseInfo { get; set; }
    ```
