# FullScreenContentCallback

`FullScreenContentCallback` クラスは、全画面広告フォーマット（[App Open](../classes/AppOpenAd.md)、[Interstitial](../classes/InterstitialAd.md)、[Rewarded](../classes/RewardedAd.md)、[Rewarded Interstitial](../classes/RewardedInterstitialAd.md)）の表示に関するイベントのトリガーを登録します。

## プロパティ

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

### `on_ad_dismissed_full_screen_content` / `OnAdDismissedFullScreenContent`

広告が閉じられるか却下され、ユーザーがアプリケーションに戻ったときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_dismissed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdDismissedFullScreenContent { get; set; }
    ```

### `on_ad_failed_to_show_full_screen_content` / `OnAdFailedToShowFullScreenContent`

広告の表示に失敗したときにトリガーされます。表示エラーの詳細を示す [`AdError`](../classes/AdError.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_failed_to_show_full_screen_content: Callable # Receives AdError
    ```

=== "C#"
    ```csharp
    public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; }
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

### `on_ad_showed_full_screen_content` / `OnAdShowedFullScreenContent`

広告が画面に正常に表示されたときにトリガーされます。

=== "GDScript"
    ```gdscript
    var on_ad_showed_full_screen_content: Callable
    ```

=== "C#"
    ```csharp
    public Action OnAdShowedFullScreenContent { get; set; }
    ```
