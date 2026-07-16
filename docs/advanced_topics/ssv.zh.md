# 服务器端验证 (SSV)

服务器端验证 (SSV) 回调用于确认用户因与广告互动而获得的奖励。它们是在用户完成观看激励广告时，由 Google 直接发送到您服务器的请求。

!!! note
    服务器端验证是一个可选功能。您仍然可以使用标准的客户端回调 (`on_user_earned_reward`) 来发放奖励。

## 前提条件

*   在 AdMob 控制台的广告单元设置中，启用[激励广告服务器端验证](https://support.google.com/admob/answer/7665911)。

## 客户端配置

要将自定义数据或用户标识符传递给服务器端回调，您必须在展示已加载的激励广告之前配置验证选项。

=== "GDScript"

    ```gdscript
    # 创建验证选项
    var ssv_options := ServerSideVerificationOptions.new()
    ssv_options.custom_data = "SAMPLE_CUSTOM_DATA_STRING"
    ssv_options.user_id = "USER_ID_TO_REWARD"
    
    # 在已加载的 RewardedAd 或 RewardedInterstitialAd 上设置选项
    rewarded_ad.set_server_side_verification_options(ssv_options)
    ```

=== "C#"

    ```csharp
    // 创建验证选项
    var ssvOptions = new ServerSideVerificationOptions
    {
        CustomData = "SAMPLE_CUSTOM_DATA_STRING",
        UserId = "USER_ID_TO_REWARD"
    };

    // 在已加载的 RewardedAd 或 RewardedInterstitialAd 上设置选项
    rewardedAd.SetServerSideVerificationOptions(ssvOptions);
    ```

!!! tip
    自定义数据字符串在 URL 中经过百分号编码 (percent-escaped)，您的服务器在解析时可能需要对其进行解码。

---

## SSV 回调参数

服务器端验证回调包含说明激励广告互动的查询参数。下面按字母顺序列出了参数名称、说明和示例值：

| 参数名称 | 描述 | 示例值 |
| :--- | :--- | :--- |
| `ad_network` | 填充此广告的广告源的标识符。 | `5450213213286189855` |
| `ad_unit` | 用于请求激励广告的 AdMob 广告单元 ID。 | `ca-app-pub-3940256099942544/5224354917` |
| `custom_data` | 应用提供的自定义数据字符串（如果已设置）。 | `SAMPLE_CUSTOM_DATA_STRING` |
| `key_id` | 用于验证 SSV 回调的密钥。该值映射到 AdMob 密钥服务器提供的公钥。 | `1234567890` |
| `reward_amount` | 广告单元设置中指定的奖励数量。 | `10` |
| `reward_item` | 广告单元设置中指定的奖励项。 | `coins` |
| `signature` | AdMob 生成的 SSV 回调的签名。 | `MEUCIQCLJS_s4ia...` |
| `timestamp` | 用户获得奖励时的时间戳（毫秒级 Epoch 时间）。 | `1507770365237823` |
| `transaction_id` | 每个奖励发放事件的唯一十六进制编码标识符。 | `18fa792de1bca816048293fc71035638` |
| `user_id` | 应用提供的用户标识符（如果已设置）。 | `1234567` |

---

## 在您的服务器上验证回调

要验证回调是否真实且确由 Google 发送，您必须使用 AdMob 的公钥检查签名。

### 1. 获取 Google 的公钥
从 AdMob 密钥服务器下载可信公钥 JSON：
[https://gstatic.com/admob/reward/verifier-keys.json](https://gstatic.com/admob/reward/verifier-keys.json)

### 2. 准备要验证的内容
回调 URL 的查询参数指定了要验证的内容。`signature` 和 `key_id` 参数始终是查询字符串中的最后两个参数，且顺序固定。

提取从查询字符串开头到 `&signature=`（不包括该字符串）之间的子字符串。查询参数的顺序不能更改。

例如，如果您的回调 URL 为：
`https://www.myserver.com/path?ad_network=54...&ad_unit=...&user_id=123&signature=ME...&key_id=1268`

则要验证的内容为：
`ad_network=54...&ad_unit=...&user_id=123`

### 3. 执行签名验证
1.  解析在第 1 步中获取的公钥 JSON。
2.  查找与 `key_id` 查询参数值匹配的公钥。
3.  使用该公钥对准备好的内容字符串验证签名 (ECDSA SHA256 DER)。

---

## 常见问题解答 (FAQ)

#### 我可以缓存 AdMob 密钥服务器提供的公钥吗？
可以，我们建议缓存公钥以减少网络请求。但请注意，公钥会定期轮换，缓存时间不应超过 24 小时。

#### 如果我的服务器无法访问会怎么样？
Google 希望 SSV 回调返回 `HTTP 200 OK` 成功状态响应码。如果您的服务器无法访问或未能返回成功码，Google 将以 1 秒的间隔尝试重新发送回调，最多重试 5 次。

#### 如何验证 SSV 回调确实来自 Google？
除了检查签名之外，您还可以对传入的 IP 地址执行反向 DNS 查找，以验证该请求是否源自 Google。
