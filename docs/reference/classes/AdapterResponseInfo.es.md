# AdapterResponseInfo

La clase `AdapterResponseInfo` contiene metadatos sobre el estado de ejecución de un adaptador de red de mediación individual en la cadena de mediación.

## Propiedades

### `adapter_class_name` / `AdapterClassName`

El nombre de clase del adaptador de anuncios de mediación (ej.: `"com.google.ads.mediation.admob.AdMobAdapter"`).

=== "GDScript"
    ```gdscript
    var adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string AdapterClassName { get; set; }
    ```

### `ad_source_id` / `AdSourceId`

El identificador de la fuente del anuncio.

=== "GDScript"
    ```gdscript
    var ad_source_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceId { get; set; }
    ```

### `ad_source_name` / `AdSourceName`

El nombre de la red/fuente de anuncios (ej.: `"AdMob"` o `"AppLovin"`).

=== "GDScript"
    ```gdscript
    var ad_source_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceName { get; set; }
    ```

### `ad_source_instance_id` / `AdSourceInstanceId`

El ID de instancia de la fuente de anuncios.

=== "GDScript"
    ```gdscript
    var ad_source_instance_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceId { get; set; }
    ```

### `ad_source_instance_name` / `AdSourceInstanceName`

El nombre de la instancia de la fuente de anuncios.

=== "GDScript"
    ```gdscript
    var ad_source_instance_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceName { get; set; }
    ```

### `ad_unit_mapping` / `AdUnitMapping`

Un diccionario que contiene los parámetros de mapeo configurados en la consola de AdMob para esta unidad de anuncios específica.

=== "GDScript"
    ```gdscript
    var ad_unit_mapping: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary AdUnitMapping { get; set; }
    ```

### `ad_error` / `AdError`

Los metadatos de error si este adaptador falló al cargar o servir el anuncio, o `null` si la carga fue exitosa.

=== "GDScript"
    ```gdscript
    var ad_error: AdError
    ```

=== "C#"
    ```csharp
    public AdError AdError { get; set; }
    ```

### `latency_millis` / `LatencyMillis`

La latencia de la solicitud del adaptador en milisegundos.

=== "GDScript"
    ```gdscript
    var latency_millis: int
    ```

=== "C#"
    ```csharp
    public int LatencyMillis { get; set; }
    ```
