# InterstitialAd

`InterstitialAd` クラスは、ユーザーに表示できる全画面インタースティシャル広告フォーマットを表します。

## プロパティ

### `full_screen_content_callback` / `FullScreenContentCallback`

表示、閉じる、表示失敗のイベントを受け取るコールバックリスナー。 [`FullScreenContentCallback`](../listeners/FullScreenContentCallback.md) を参照してください。

=== "GDScript"
    ```gdscript
    var full_screen_content_callback: FullScreenContentCallback
    ```

=== "C#"
    ```csharp
    public FullScreenContentCallback FullScreenContentCallback { get; set; }
    ```

### `on_ad_paid` / `OnAdPaid`

広告インプレッションが記録され収益が発生したときにトリガーされます。[`AdValue`](AdValue.md) を受け取ります。

=== "GDScript"
    ```gdscript
    var on_ad_paid: Callable # Receives AdValue
    ```

=== "C#"
    ```csharp
    public Action<AdValue> OnAdPaid { get; set; }
    ```

---

## メソッド

### `show` / `Show`

全画面のインタースティシャル広告オーバーレイを表示します。

=== "GDScript"
    ```gdscript
    func show() -> void
    ```

=== "C#"
    ```csharp
    public void Show()
    ```

---

### `destroy` / `Destroy`

ネイティブ広告オブジェクトを破棄してリソースを解放します。

=== "GDScript"
    ```gdscript
    func destroy() -> void
    ```

=== "C#"
    ```csharp
    public void Destroy()
    ```

---

### `get_response_info` / `GetResponseInfo`

読み込まれた広告のアダプター履歴を含むメディエーション応答情報を返します。

=== "GDScript"
    ```gdscript
    func get_response_info() -> ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo GetResponseInfo()
    ```
