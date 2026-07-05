# AdInspectorClosedListener

A classe `AdInspectorClosedListener` é usada para ouvir o evento de fechamento do Ad Inspector nativo, que é aberto via [`MobileAds.open_ad_inspector()`](../classes/MobileAds.md#open_ad_inspector-openadinspector).

## Propriedades

### `on_ad_inspector_closed` / `OnAdInspectorClosed`

Acionado quando o Ad Inspector é fechado. Recebe um dicionário detalhando qualquer erro ocorrido, ou um dicionário vazio se fechado normalmente.

=== "GDScript"
    ```gdscript
    var on_ad_inspector_closed: Callable # Receives error: Dictionary
    ```

=== "C#"
    ```csharp
    public Action<Dictionary> OnAdInspectorClosed { get; set; }
    ```
