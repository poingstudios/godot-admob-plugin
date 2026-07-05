# AdRequest

`AdRequest` クラスは、ターゲティングパラメータ、キーワード、メディエーションエクストラをまとめて、ロード前に広告リクエストを設定します。

## プロパティ

### `keywords` / `Keywords`

より関連性の高い広告を配信するために使用される検索クエリ用語またはコンテキストタグのリスト。

=== "GDScript"
    ```gdscript
    var keywords: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> Keywords { get; set; }
    ```

### `extras` / `Extras`

Google AdMob に直接送信されるカスタムパラメータまたはネットワーク設定を含む辞書。

=== "GDScript"
    ```gdscript
    var extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary Extras { get; set; }
    ```

### `mediation_extras` / `MediationExtrasList`

メディエーションパートナーネットワークの設定パラメータを含むリスト。

=== "GDScript"
    ```gdscript
    var mediation_extras: Array[MediationExtras]
    ```

=== "C#"
    ```csharp
    public List<MediationExtras> MediationExtrasList { get; set; }
    ```
