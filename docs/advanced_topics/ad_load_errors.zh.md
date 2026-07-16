# 广告加载错误

在广告加载失败的情况下，会调用一个提供 `LoadAdError` 对象的回调。

以下示例展示了广告加载失败时可用的信息：

=== "GDScript"

    ```gdscript
    load_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
        # 获取错误代码。请参阅下方的常见错误代码列表。
        var error_code := error.code
        
        # 获取错误信息。例如 "Account not approved yet"。
        var error_message := error.message
        
        # 获取关于请求的其他响应信息。
        var response_info := error.response_info
        
        # 所有这些信息都可以通过错误的 to_string() 方法获得。
        print("广告加载失败: " + error.to_string())
    ```

=== "C#"

    ```csharp
    loadCallback.OnAdFailedToLoad = (error) =>
    {
        // 获取错误代码。请参阅下方的常见错误代码列表。
        int errorCode = error.Code;
        
        // 获取错误信息。例如 "Account not approved yet"。
        string errorMessage = error.Message;
        
        // 获取关于请求的其他响应信息。
        ResponseInfo responseInfo = error.ResponseInfo;
        
        // 所有这些信息都可以通过错误的 ToString() 方法获得。
        GD.Print("广告加载失败: " + error.ToString());
    };
    ```

## 常见错误代码

| 错误代码 | 常量名称 | 描述 |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | 内部发生了一些错误；例如，从广告服务器收到了无效响应。 |
| **1** | `ERROR_CODE_INVALID_REQUEST` | 广告请求无效；例如，广告单元 ID 不正确。 |
| **2** | `ERROR_CODE_NETWORK_ERROR` | 由于网络连接问题，广告请求未成功。 |
| **3** | `ERROR_CODE_NO_FILL` | 广告请求成功，但由于缺少广告库存而未返回广告。 |
| **8** | `ERROR_CODE_APP_ID_MISSING` | 配置中缺少应用 ID (App ID)。 |
| **9** | `ERROR_CODE_MEDIATION_NO_FILL` | 广告中介适配器无法填充广告请求。 |
