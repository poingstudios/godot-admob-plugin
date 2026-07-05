# AdRequest

A classe `AdRequest` compila parâmetros de segmentação, palavras-chave e extras de mediação para configurar uma solicitação de anúncio antes do carregamento.

## Propriedades

### `keywords` / `Keywords`

Uma lista de termos de consulta de pesquisa ou tags contextuais usados para servir anúncios mais relevantes.

=== "GDScript"
    ```gdscript
    var keywords: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> Keywords { get; set; }
    ```

### `extras` / `Extras`

Um dicionário contendo parâmetros personalizados ou configurações de rede enviados diretamente ao Google AdMob.

=== "GDScript"
    ```gdscript
    var extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary Extras { get; set; }
    ```

### `mediation_extras` / `MediationExtrasList`

Uma lista contendo parâmetros de configuração de redes de mediação parceiras.

=== "GDScript"
    ```gdscript
    var mediation_extras: Array[MediationExtras]
    ```

=== "C#"
    ```csharp
    public List<MediationExtras> MediationExtrasList { get; set; }
    ```
