# AppOpenAdLoadCallback

`AppOpenAdLoadCallback` クラスは、[`AppOpenAd`](../classes/AppOpenAd.md) ロードリクエストの結果をリッスンするために使用されます。

## プロパティ

### `on_ad_loaded` / `OnAdLoaded`

広告が正常に読み込まれたときにトリガーされます。ロードされた [`AppOpenAd`](../classes/AppOpenAd.md) インスタンスを受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable # Receives AppOpenAd
    ```

=== "C#"
    ```csharp
    public Action<AppOpenAd> OnAdLoaded { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

ロードリクエストが失敗したときにトリガーされます。ロードエラーの詳細を示す [`LoadAdError`](../classes/LoadAdError.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```
