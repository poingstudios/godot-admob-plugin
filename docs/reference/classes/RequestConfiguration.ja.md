# RequestConfiguration

`RequestConfiguration` クラスは、すべての広告ロードに適用されるグローバルな広告リクエスト設定を集約します。

## 定数

### デバイス ID エミュレータ

この定数を使用して、エミュレータでテスト広告を有効にします。

=== "GDScript"
    ```gdscript
    RequestConfiguration.DEVICE_ID_EMULATOR
    ```

=== "C#"
    ```csharp
    RequestConfiguration.DeviceIdEmulator
    ```

### 最大広告コンテンツレーティング

アプリで読み込まれる広告のコンテンツフィルターを設定します。

=== "GDScript"
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_UNSPECIFIED`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
    - `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

=== "C#"
    - `RequestConfiguration.MaxAdContentRatingUnspecified`
    - `RequestConfiguration.MaxAdContentRatingG`
    - `RequestConfiguration.MaxAdContentRatingPG`
    - `RequestConfiguration.MaxAdContentRatingT`
    - `RequestConfiguration.MaxAdContentRatingMA`

---

## プロパティ

### `max_ad_content_rating` / `MaxAdContentRating`

アプリに配信される広告に許可される最大広告コンテンツレーティング。

=== "GDScript"
    ```gdscript
    var max_ad_content_rating: String
    ```

=== "C#"
    ```csharp
    public string MaxAdContentRating { get; set; }
    ```

### `tag_for_child_directed_treatment` / `ChildDirectedTreatment`

COPPA 準拠のための child-directed 処理設定を構成します。

=== "GDScript"
    ```gdscript
    var tag_for_child_directed_treatment: int # Matches values from TagForChildDirectedTreatment enum
    ```

=== "C#"
    ```csharp
    public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; }
    ```

### `tag_for_under_age_of_consent` / `UnderAgeOfConsent`

GDPR 準拠のための同意年齢未満設定を構成します。

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: int # Matches values from TagForUnderAgeOfConsent enum
    ```

=== "C#"
    ```csharp
    public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; }
    ```

### `test_device_ids` / `TestDeviceIds`

テスト広告を受信するためのテストデバイス ID のリスト。

=== "GDScript"
    ```gdscript
    var test_device_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceIds { get; set; }
    ```
