# プライバシーストラテジー

!!! note
    **重要**: プライバシーストラテジーの設定を完了するには、**アカウント管理**権限があることを確認してください。詳細は[新しいユーザーロール](https://support.google.com/admob/answer/2784628)の記事を参照してください。

このガイドは、Google Mobile Ads SDKで利用可能なプライバシーストラテジーを説明し、ユーザープライバシーを尊重しながらより関連性の高い広告を配信するのに役立ちます。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK for Android - プライバシーストラテジー](https://developers.google.com/admob/android/privacy/strategies)
- [Google Mobile Ads SDK for iOS - プライバシーストラテジー](https://developers.google.com/admob/ios/privacy/strategies)

## パブリッシャーのファーストパーティID

Google Mobile Ads SDKは、アプリから収集したデータを使用して、より関連性が高くパーソナライズされた広告を配信するためのパブリッシャーのファーストパーティIDを導入しました。

パブリッシャーのファーストパーティIDはデフォルトで有効になっていますが、以下の方法で無効にできます。

=== "GDScript"

    ```gdscript
    # パブリッシャーのファーストパーティIDを無効にします。
    MobileAds.set_publisher_first_party_id_enabled(false)
    ```

=== "C#"

    ```csharp
    // パブリッシャーのファーストパーティIDを無効にします。
    MobileAds.SetPublisherFirstPartyIDEnabled(false);
    ```


