# サーバー側検証 (SSV)

サーバー側検証 (SSV) コールバックは、広告とのエンゲージメントに対するユーザーへの特典付与を確認するために使用されます。これは、ユーザーがリワード広告の視聴を完了したときに、Google からお客様のサーバーに直接送信されるリクエストです。

!!! note
    サーバー側検証はオプション機能です。特典の付与には、引き続き標準のクライアント側コールバック (`on_user_earned_reward`) を使用できます。

## 前提条件

*   AdMob 管理画面で、該当する広告ユニットの [リワード広告のサーバー側検証](https://support.google.com/admob/answer/7665911) を有効にします。

## クライアント側の設定

サーバー側コールバックにカスタムデータまたはユーザー識別子を渡すには、広告を表示する前に、読み込まれたリワード広告オブジェクトに検証オプションを設定する必要があります。

=== "GDScript"

    ```gdscript
    # 検証オプションを作成します
    var ssv_options := ServerSideVerificationOptions.new()
    ssv_options.custom_data = "SAMPLE_CUSTOM_DATA_STRING"
    ssv_options.user_id = "USER_ID_TO_REWARD"
    
    # 読み込まれた RewardedAd または RewardedInterstitialAd にオプションを設定します
    rewarded_ad.set_server_side_verification_options(ssv_options)
    ```

=== "C#"

    ```csharp
    // 検証オプションを作成します
    var ssvOptions = new ServerSideVerificationOptions
    {
        CustomData = "SAMPLE_CUSTOM_DATA_STRING",
        UserId = "USER_ID_TO_REWARD"
    };

    // 読み込まれた RewardedAd または RewardedInterstitialAd にオプションを設定します
    rewardedAd.SetServerSideVerificationOptions(ssvOptions);
    ```

!!! tip
    カスタムデータ文字列は URL 内でパーセントエンコードされるため、サーバー側で解析する際にデコードが必要になる場合があります。

---

## SSV コールバックパラメータ

サーバー側検証コールバックには、リワード広告のやり取りを表すクエリパラメータが含まれています。パラメータ名、説明、および値の例は以下の通りです（アルファベット順に送信されます）。

| パラメータ名 | 説明 | 値の例 |
| :--- | :--- | :--- |
| `ad_network` | この広告を配信した広告ソースの識別子。 | `5450213213286189855` |
| `ad_unit` | リワード広告の要求に使用された AdMob 広告ユニット ID。 | `ca-app-pub-3940256099942544/5224354917` |
| `custom_data` | アプリによって提供されたカスタムデータ文字列（設定されている場合）。 | `SAMPLE_CUSTOM_DATA_STRING` |
| `key_id` | SSV コールバックの検証に使用されるキー。この値は、AdMob キーサーバーによって提供される公開キーに対応します。 | `1234567890` |
| `reward_amount` | 広告ユニットの設定で指定された特典の数量。 | `10` |
| `reward_item` | 広告ユニットの設定で指定された特典アイテム。 | `coins` |
| `signature` | AdMob によって生成された SSV コールバックの署名。 | `MEUCIQCLJS_s4ia...` |
| `timestamp` | ユーザーに特典が付与された時間を示すエポックタイム（ミリ秒単位）。 | `1507770365237823` |
| `transaction_id` | 各特典付与イベントに対して生成される、一意の 16 進エンコード識別子。 | `18fa792de1bca816048293fc71035638` |
| `user_id` | アプリによって提供されたユーザー識別子（設定されている場合）。 | `1234567` |

---

## サーバーでのコールバックの検証

コールバックが本物であり、実際に Google から送信されたものであることを検証するには、AdMob の公開キーを使用して署名を確認する必要があります。

### 1. Google の公開キーの取得
AdMob キーサーバーから信頼できる公開キーの JSON をダウンロードします。
[https://gstatic.com/admob/reward/verifier-keys.json](https://gstatic.com/admob/reward/verifier-keys.json)

### 2. 検証するコンテンツの準備
コールバック URL のクエリパラメータによって、検証するコンテンツが指定されます。`signature` パラメータと `key_id` パラメータは、常にクエリ文字列の最後のパラメータとして、この順序で指定されます。

クエリ文字列の先頭から、`&signature=` の直前までの部分文字列を抽出します。クエリパラメータの順序は変更しないでください。

たとえば、コールバック URL が次の場合：
`https://www.myserver.com/path?ad_network=54...&ad_unit=...&user_id=123&signature=ME...&key_id=1268`

検証するコンテンツは次のようになります：
`ad_network=54...&ad_unit=...&user_id=123`

### 3. 署名の検証の実行
1.  ステップ 1 で取得した公開キー JSON を解析します。
2.  クエリパラメータの `key_id` の値と一致する公開キーを見つけます。
3.  公開キーを使用して、準備したコンテンツ文字列に対して署名（ECDSA SHA256 DER）を検証します。

---

## よくある質問 (FAQ)

#### AdMob キーサーバーによって提供される公開キーをキャッシュできますか？
はい。公開キーをキャッシュしてネットワークリクエストを減らすことをお勧めします。ただし、公開キーは定期的にローテーションされるため、24時間以上キャッシュしないでください。

#### サーバーに接続できない場合はどうなりますか？
Google はコールバックに対して `HTTP 200 OK` ステータスコードを想定しています。サーバーに接続できないか、成功コードが返されない場合、Google は 1秒間隔で最大 5回コールバックの送信を再試行します。

#### SSV コールバックが Google から送信されたものであることを確認するにはどうすればよいですか？
署名の確認に加えて、インバウンド IP アドレスに対して逆引き DNS ルックアップを実行して、リクエストが Google からのものであることを確認できます。
