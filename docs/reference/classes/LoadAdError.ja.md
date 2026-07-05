# LoadAdError

`LoadAdError` は `AdError` を拡張し、広告の読み込み中に発生するエラーを表します。メディエーションウォーターフォール結果の詳細を示す `ResponseInfo` オブジェクトを含みます。

## 継承
- [AdError](AdError.md)

## プロパティ

### `response_info` / `ResponseInfo`

ロードリクエストの応答とメディエーションウォーターフォール履歴の詳細を含みます。

=== "GDScript"
    ```gdscript
    var response_info: ResponseInfo
    ```

=== "C#"
    ```csharp
    public ResponseInfo ResponseInfo { get; set; }
    ```
