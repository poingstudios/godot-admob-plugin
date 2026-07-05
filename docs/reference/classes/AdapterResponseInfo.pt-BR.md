# AdapterResponseInfo

A classe `AdapterResponseInfo` contém metadados sobre o status de execução de um adaptador de rede de mediação individual na cadeia de mediação.

## Propriedades

### `adapter_class_name` / `AdapterClassName`

O nome da classe do adaptador de anúncio de mediação (ex.: `"com.google.ads.mediation.admob.AdMobAdapter"`).

=== "GDScript"
    ```gdscript
    var adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string AdapterClassName { get; set; }
    ```

### `ad_source_id` / `AdSourceId`

O identificador da fonte do anúncio.

=== "GDScript"
    ```gdscript
    var ad_source_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceId { get; set; }
    ```

### `ad_source_name` / `AdSourceName`

O nome da rede/fonte de anúncio (ex.: `"AdMob"` ou `"AppLovin"`).

=== "GDScript"
    ```gdscript
    var ad_source_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceName { get; set; }
    ```

### `ad_source_instance_id` / `AdSourceInstanceId`

O ID da instância da fonte de anúncio.

=== "GDScript"
    ```gdscript
    var ad_source_instance_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceId { get; set; }
    ```

### `ad_source_instance_name` / `AdSourceInstanceName`

O nome da instância da fonte de anúncio.

=== "GDScript"
    ```gdscript
    var ad_source_instance_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceName { get; set; }
    ```

### `ad_unit_mapping` / `AdUnitMapping`

Um dicionário contendo parâmetros de mapeamento definidos no console AdMob para esta unidade de anúncio específica.

=== "GDScript"
    ```gdscript
    var ad_unit_mapping: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary AdUnitMapping { get; set; }
    ```

### `ad_error` / `AdError`

Os metadados de erro se este adaptador falhou ao carregar ou servir o anúncio, ou `null` se o carregamento foi bem-sucedido.

=== "GDScript"
    ```gdscript
    var ad_error: AdError
    ```

=== "C#"
    ```csharp
    public AdError AdError { get; set; }
    ```

### `latency_millis` / `LatencyMillis`

A latência da requisição do adaptador em milissegundos.

=== "GDScript"
    ```gdscript
    var latency_millis: int
    ```

=== "C#"
    ```csharp
    public int LatencyMillis { get; set; }
    ```
