# AdRequest

La clase `AdRequest` compila parámetros de segmentación, palabras clave y extras de mediación para configurar una solicitud de anuncio antes de cargarlo.

## Propiedades

### `keywords` / `Keywords`

Una lista de términos de búsqueda o etiquetas contextuales utilizadas para servir anuncios más relevantes.

=== "GDScript"
    ```gdscript
    var keywords: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> Keywords { get; set; }
    ```

### `extras` / `Extras`

Un diccionario que contiene parámetros personalizados o configuraciones de red enviados directamente a Google AdMob.

=== "GDScript"
    ```gdscript
    var extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary Extras { get; set; }
    ```

### `mediation_extras` / `MediationExtrasList`

Una lista que contiene parámetros de configuración de redes de mediación asociadas.

=== "GDScript"
    ```gdscript
    var mediation_extras: Array[MediationExtras]
    ```

=== "C#"
    ```csharp
    public List<MediationExtras> MediationExtrasList { get; set; }
    ```
