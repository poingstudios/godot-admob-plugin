# GDPR IAB サポート

このガイドでは、UMP SDK の一部として GDPR IAB TCF v2 メッセージをサポートするために必要な手順の概要を説明します。これは、UMP SDK を使用してアプリを実行する方法の概要とメッセージ設定の基本を説明している [スタートガイド](get_started.md) と併せて使用することを想定しています。以下の説明は、GDPR IAB TCF v2 メッセージに特有のものです。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/privacy/gdpr)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy/gdpr)

## 前提条件

- [スタートガイド](get_started.md)を完了していること
- [アプリ用の GDPR メッセージの作成](https://support.google.com/admob/answer/10113207)を完了していること

## アプリ測定の遅延

デフォルトでは、Google Mobile Ads SDK はアプリの起動時に即座にアプリ測定を初期化し、ユーザーレベルのイベントデータの Google への送信を開始します。この初期化動作により、追加のコード変更を行うことなく AdMob ユーザー指標を有効にすることができます。

ただし、これらのイベントが送信される前にアプリでユーザーの同意が必要な場合は、明示的に [Mobile Ads SDK を初期化](../../index.md)するか、広告をロードするまでアプリの測定を遅延させることができます。

=== "Android"
    アプリ測定を遅延させるには、次の `<meta-data>` タグを `res://android/build/AndroidManifest.xml` に追加します。
    ```xml
    <manifest>
        <application>
        <!-- MobileAds.initialize() が呼び出されるまでアプリ測定を遅延させます。 -->
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        </application>
    </manifest>
    ```

=== "iOS"
    アプリ測定を遅延させるには、エクスポートされた Xcode プロジェクトのアプリの `Info.plist` に、ブール値 `YES` の `GADDelayAppMeasurementInit` キーを追加します。この変更はプログラムで行うことができます。

    ```xml
    <key>GADDelayAppMeasurementInit</key>
    <true/>
    ```

## 同意の撤回

[同意の撤回可能性](https://support.google.com/admob/answer/10113915)は、[プライバシーとメッセージング] のユーザー同意プログラムの要件です。ユーザーが同意を撤回できるようにするリンクをアプリのメニューに提供し、その後、それらのユーザーに再び同意メッセージを提示する必要があります。

これを実現するには：

1. ユーザーがアプリを起動するたびに[フォームをロード](get_started.md#load-a-form-if-available)しておき、ユーザーが同意設定の変更を希望したときにいつでもフォームを表示できるようにします。
2. ユーザーがアプリのメニューでリンクを選択したときに、フォームを表示（提示）します。

=== "GDScript"

    ```gdscript
    var _consent_form : ConsentForm
    
    func present_form() -> void:
    	_consent_form.show(_on_consent_form_dismissed)
    	
    func _on_consent_form_dismissed(form_error : FormError):
    	# 閉じられた場合はフォームを再ロードして処理します。
    	load_form()
    ```

=== "C#"

    ```csharp
    private ConsentForm _consentForm;
    
    private void PresentForm()
    {
        _consentForm.Show(OnConsentFormDismissed);
    }
    
    private void OnConsentFormDismissed(FormError formError)
    {
        // 閉じられた場合はフォームを再ロードして処理します。
        LoadForm();
    }
    ```

## メディエーション
[公開済みの GDPR メッセージへの広告パートナーの追加](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)の手順に従って、メディエーションパートナーを広告パートナーリストに追加します。これを怠ると、パートナーがアプリ内で広告を配信できなくなる可能性があります。

メディエーションパートナーは、GDPR 準拠を支援するための追加ツールを提供している場合もあります。詳細については、特定のパートナーの[統合ガイド](../../mediate/get_started.md)を参照してください。


## トラブルシューティング

**エラー 3.3: TC 文字列の最終更新日が 13 か月以上前です (The TC string last updated date was more than 13 months ago)**

- ユーザーから[同意を再取得する](https://support.google.com/admob/answer/9999955#grace-period-2)必要があります。アプリセッションの開始時に毎回 `UserMessagingPlatform.consent_information.update()` を呼び出す必要があります。TC 文字列の有効期限が切れている場合、UMP SDK は `ConsentInformation.ConsentStatus` を `ConsentInformation.ConsentStatus.REQUIRED` に設定することで、同意を再取得する必要があることを示します。まだ実装していない場合は、アプリ内で[新しい UMP フォームをロードして表示する](get_started.md#present-the-form-if-required)リクエストを実装してください。

- TC 文字列がセッションの途中で期限切れになり、その結果、少量の `3.3` エラーが発生することがあります。また、次のアプリセッションにおいて `UserMessagingPlatform.consent_information.update()` を確認するのと同時に広告のロードを開始すると、`UserMessagingPlatform.consent_information.update()` が完了するまでそれらのリクエストも `3.3` エラーを返す可能性があります。ただし、これは想定される `3.3` エラー全体のわずかな割合（0.1% 未満）であるはずです。
