# AdInspectorClosedListener

La clase `AdInspectorClosedListener` se utiliza para escuchar el evento de cierre del Ad Inspector nativo, que se abre mediante [`MobileAds.open_ad_inspector()`](../classes/MobileAds.md#open_ad_inspector-openadinspector).

## Propiedades

### `on_ad_inspector_closed` / `OnAdInspectorClosed`

Se activa cuando se cierra el Ad Inspector. Recibe un diccionario que detalla cualquier error ocurrido, o un diccionario vacío si se cerró normalmente.

=== "GDScript"
    ```gdscript
    var on_ad_inspector_closed: Callable # Receives error: Dictionary
    ```

=== "C#"
    ```csharp
    public Action<Dictionary> OnAdInspectorClosed { get; set; }
    ```
