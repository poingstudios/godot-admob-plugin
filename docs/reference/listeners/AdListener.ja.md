# AdListener

`AdListener` クラスを使用すると、[`AdView`](../classes/AdView.md) を介してロードされたバナー広告と、[`NativeOverlayAd`](../classes/NativeOverlayAd.md) を介してロードされたネイティブオーバーレイ広告のライフサイクルイベントをリッスンできます。

## プロパティ

すべてのプロパティは、それぞれの広告イベントが発生したときにトリガーされる呼び出し可能なデリゲート（C# では Action デリゲート）です：

### `on_ad_clicked` / `OnAdClicked`

ユーザーが広告をクリックしたときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_clicked: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClicked { get; set; }
    ```

### `on_ad_closed` / `OnAdClosed`

ユーザーが広告のオーバーレイを閉じるか、アプリケーションに戻ったときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_closed: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdClosed { get; set; }
    ```

### `on_ad_failed_to_load` / `OnAdFailedToLoad`

広告の読み込みに失敗したときにトリガーされます。エラーの詳細を示す [`LoadAdError`](../classes/LoadAdError.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_load: Callable # Receives LoadAdError
    ```

=== "C#"
    ```csharp
    public Action<LoadAdError> OnAdFailedToLoad { get; set; }
    ```

### `on_ad_impression` / `OnAdImpression`

広告インプレッションが記録されたときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_impression: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdImpression { get; set; }
    ```

### `on_ad_loaded` / `OnAdLoaded`

広告が正常に読み込まれたときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_loaded: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdLoaded { get; set; }
    ```

### `on_ad_opened` / `OnAdOpened`

広告がアプリケーションの上に全画面オーバーレイを開いたときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_opened: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdOpened { get; set; }
    ```
