# AdRequest

The `AdRequest` class compiles targeting parameters, keywords, and mediation extras to configure an ad request before loading.

## Properties

### `keywords` / `Keywords`

A list of search query terms or contextual tags used to serve more relevant ads.

=== "GDScript"
    ```gdscript
    var keywords: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> Keywords { get; set; }
    ```

### `extras` / `Extras`

A dictionary containing custom parameters or network configurations sent directly to Google AdMob.

=== "GDScript"
    ```gdscript
    var extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary Extras { get; set; }
    ```

### `mediation_extras` / `MediationExtrasList`

A list containing mediation partner network configuration parameters.

=== "GDScript"
    ```gdscript
    var mediation_extras: Array[MediationExtras]
    ```

=== "C#"
    ```csharp
    public List<MediationExtras> MediationExtrasList { get; set; }
    ```
