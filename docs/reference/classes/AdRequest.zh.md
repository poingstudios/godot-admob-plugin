# AdRequest

`AdRequest` 类编译定位参数、关键字和中介扩展，以在加载前配置广告请求。

## 属性

### `keywords` / `Keywords`

用于提供更相关广告的搜索查询词或上下文标签列表。

=== "GDScript"
    ```gdscript
    var keywords: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> Keywords { get; set; }
    ```

### `extras` / `Extras`

包含直接发送到 Google AdMob 的自定义参数或网络配置的字典。

=== "GDScript"
    ```gdscript
    var extras: Dictionary
    ```

=== "C#"
    ```csharp
    public Dictionary Extras { get; set; }
    ```

### `mediation_extras` / `MediationExtrasList`

包含中介合作伙伴网络配置参数的列表。

=== "GDScript"
    ```gdscript
    var mediation_extras: Array[MediationExtras]
    ```

=== "C#"
    ```csharp
    public List<MediationExtras> MediationExtrasList { get; set; }
    ```
