# RequestConfiguration

`RequestConfiguration` 类汇总了应用于每次广告加载的全局广告请求设置。

## 常量

### Device ID Emulator

使用此常量在模拟器上启用测试广告。

=== "GDScript"
    ```gdscript
    RequestConfiguration.DEVICE_ID_EMULATOR
    ```

=== "C#"
    ```csharp
    RequestConfiguration.DeviceIdEmulator
    ```

### Max Ad Content Ratings

配置应用加载的广告的内容过滤器。

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

## 属性

### `max_ad_content_rating` / `MaxAdContentRating`

允许为应用投放的广告的最大广告内容分级。

=== "GDScript"
    ```gdscript
    var max_ad_content_rating: String
    ```

=== "C#"
    ```csharp
    public string MaxAdContentRating { get; set; }
    ```

### `tag_for_child_directed_treatment` / `ChildDirectedTreatment`

配置针对儿童导向处理设置以符合 COPPA 规定。

=== "GDScript"
    ```gdscript
    var tag_for_child_directed_treatment: int # Matches values from TagForChildDirectedTreatment enum
    ```

=== "C#"
    ```csharp
    public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; }
    ```

### `tag_for_under_age_of_consent` / `UnderAgeOfConsent`

配置未达到同意年龄设置以符合 GDPR 规定。

=== "GDScript"
    ```gdscript
    var tag_for_under_age_of_consent: int # Matches values from TagForUnderAgeOfConsent enum
    ```

=== "C#"
    ```csharp
    public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; }
    ```

### `test_device_ids` / `TestDeviceIds`

用于接收测试广告的测试设备 ID 列表。

=== "GDScript"
    ```gdscript
    var test_device_ids: Array[String]
    ```

=== "C#"
    ```csharp
    public List<string> TestDeviceIds { get; set; }
    ```
