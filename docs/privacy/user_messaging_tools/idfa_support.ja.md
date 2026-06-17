# IDFA サポート

このガイドでは、UMP SDK の一部として IDFA メッセージをサポートするために必要な手順の概要を説明します。これは、UMP SDK を使用してアプリを実行する方法の概要とメッセージ設定の基本を説明している [スタートガイド](get_started.md) と併せて使用することを想定しています。以下の説明は、IDFA メッセージに特有のものです。

!!! note

    GDPR と IDFA の両方のメッセージを有効にする場合は、発生し得る結果について [ユーザーに表示されるメッセージ](https://support.google.com/admob/answer/10115027#which_message) を参照してください。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy/idfa)

## 前提条件

- [スタートガイド](get_started.md)を完了していること
- [IDFA メッセージの作成](https://support.google.com/admob/answer/10115331)を完了していること

## Info.plist の更新

UMP SDK を使用して Apple の App Tracking Transparency（ATT）要件を処理する予定がある場合は、AdMob UI で [IDFA 説明メッセージ](https://support.google.com/admob/answer/10115027)を作成、構成、および公開していることを確認してください。

UMP SDK が iOS システムのダイアログ内にカスタムの警告メッセージを表示できるようにするには、`Info.plist` を更新して `NSUserTrackingUsageDescription` キーを追加し、使用目的を説明するカスタムの文字列を設定します。

```xml
<key>NSUserTrackingUsageDescription</key>
<string>この識別子は、パーソナライズされた広告を配信するために使用されます。</string>
```

同意フォームを提示した際、ATT ダイアログの一部としてこの説明テキストが表示されます。

![idfa-alert](https://developers.google.com/static/admob/ump/images/idfa-alert.png)

次に、`AppTrackingTransparency` フレームワークをリンクします。

![link-att-framework](https://developers.google.com/static/admob/ump/images/link-att-framework.png)

これで設定は完了です。アプリは、IDFA ATT ダイアログが表示される前に、IDFA 説明メッセージを表示するようになります。

### テスト

テストの際、[`requestTrackingAuthorization`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/requesttrackingauthorization(completionhandler:)) は一度限りのリクエストであるため、IDFA ATT ダイアログは 1 回しか表示されないことに注意してください。UMP SDK は、認証ステータスが [`ATTrackingManagerAuthorizationStatusNotDetermined`](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/notdetermined?language=objc) である場合にのみ、ロード可能なフォームを提供します。

警告ダイアログを 2 回目以降も表示させるには、テストデバイスからアプリをアンインストールし、再インストールする必要があります。
