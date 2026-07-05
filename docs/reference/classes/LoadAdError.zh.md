# LoadAdError

`LoadAdError` 继承 `AdError`，用于表示广告加载期间发生的错误。包含一个 `ResponseInfo` 对象，详细说明中介瀑布流结果。

## 继承
- [AdError](AdError.md)

## 属性

### `response_info` / `ResponseInfo`

包含有关加载请求响应和中介瀑布流历史的详细信息。

=== "GDScript"
    ```gdscript
    var response_info: ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo ResponseInfo { get; set; }
    ```
