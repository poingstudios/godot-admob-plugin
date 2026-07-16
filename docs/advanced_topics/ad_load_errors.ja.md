# 広告の読み込みエラー

広告の読み込みに失敗した場合、`LoadAdError` オブジェクトを提供するコールバックが呼び出されます。

次の例は、広告の読み込みに失敗したときに利用可能な情報を示しています。

=== "GDScript"

    ```gdscript
    load_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
        # エラーコードを取得します。以下の一般的なエラーコードの一覧を参照してください。
        var error_code := error.code
        
        # エラーメッセージを取得します（例: "Account not approved yet"）。
        var error_message := error.message
        
        # リクエストに関する追加のレスポンス情報を取得します。
        var response_info := error.response_info
        
        # これらの情報はすべて、エラーの to_string() メソッドを使用して取得できます。
        print("広告の読み込みに失敗しました: " + error.to_string())
    ```

=== "C#"

    ```csharp
    loadCallback.OnAdFailedToLoad = (error) =>
    {
        // エラーコードを取得します。以下の一般的なエラーコードの一覧を参照してください。
        int errorCode = error.Code;
        
        // エラーメッセージを取得します（例: "Account not approved yet"）。
        string errorMessage = error.Message;
        
        // リクエストに関する追加のレスポンス情報を取得します。
        ResponseInfo responseInfo = error.ResponseInfo;
        
        // Obtains all information by calling ToString() method.
        GD.Print("広告の読み込みに失敗しました: " + error.ToString());
    };
    ```

## 一般的なエラーコード

| エラーコード | 定数名 | 説明 |
| :--- | :--- | :--- |
| **0** | `ERROR_CODE_INTERNAL_ERROR` | 内部エラーが発生しました。例えば、広告サーバーから無効なレスポンスを受信した場合などです。 |
| **1** | `ERROR_CODE_INVALID_REQUEST` | 広告リクエストが無効です。例えば、広告ユニット ID が正しくない場合などです。 |
| **2** | `ERROR_CODE_NETWORK_ERROR` | ネットワーク接続の問題により、広告リクエストが失敗しました。 |
| **3** | `ERROR_CODE_NO_FILL` | 広告リクエストは成功しましたが、広告在庫がないため広告が返されませんでした。 |
| **8** | `ERROR_CODE_APP_ID_MISSING` | 設定でアプリ ID が不足しています。 |
| **9** | `ERROR_CODE_MEDIATION_NO_FILL` | メディエーションアダプターが広告リクエストを満たせませんでした。 |
