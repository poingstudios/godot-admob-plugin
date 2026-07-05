# AdapterResponseInfo

The `AdapterResponseInfo` class contains metadata about an individual mediation ad network adapter's execution status in the mediation waterfall chain.

## Properties

### `adapter_class_name` / `AdapterClassName`

The class name of the mediation ad adapter (e.g. `"com.google.ads.mediation.admob.AdMobAdapter"`).

=== "GDScript"
    ```gdscript
    var adapter_class_name: String
    ```

=== "C#"
    ```csharp
    public string AdapterClassName { get; set; }
    ```

### `ad_source_id` / `AdSourceId`

The identifier of the ad source.

=== "GDScript"
    ```gdscript
    var ad_source_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceId { get; set; }
    ```

### `ad_source_name` / `AdSourceName`

The name of the ad network/source (e.g. `"AdMob"` or `"AppLovin"`).

=== "GDScript"
    ```gdscript
    var ad_source_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceName { get; set; }
    ```

### `ad_source_instance_id` / `AdSourceInstanceId`

The instance ID of the ad source.

=== "GDScript"
    ```gdscript
    var ad_source_instance_id: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceId { get; set; }
    ```

### `ad_source_instance_name` / `AdSourceInstanceName`

The name of the ad source instance.

=== "GDScript"
    ```gdscript
    var ad_source_instance_name: String
    ```

=== "C#"
    ```csharp
    public string AdSourceInstanceName { get; set; }
    ```

### `ad_unit_mapping` / `AdUnitMapping`

A dictionary containing mapping parameters set in the AdMob console for this specific ad unit.

=== "GDScript"
    ```gdscript
    var ad_unit_mapping: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary AdUnitMapping { get; set; }
    ```

### `ad_error` / `AdError`

The error metadata if this adapter failed to load or serve the ad, or `null` if the load succeeded.

=== "GDScript"
    ```gdscript
    var ad_error: AdError
    ```

=== "C#"
    ```csharp
    public AdError AdError { get; set; }
    ```

### `latency_millis` / `LatencyMillis`

The latency of the adapter request in milliseconds.

=== "GDScript"
    ```gdscript
    var latency_millis: int
    ```

=== "C#"
    ```csharp
    public int LatencyMillis { get; set; }
    ```
