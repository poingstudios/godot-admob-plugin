# EEA のユーザーへの開示

Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/user-consent-policy/)に基づき、欧州経済領域 (EEA)、英国、スイスのユーザーに対して一定の開示を行い、法的に義務付けられている場合は Cookie やその他のローカル ストレージの使用、および広告配信のための個人データ (AdID など) の使用について同意を得る必要があります。このポリシーは、EU の e プライバシー指令および一般データ保護規則 (GDPR) の要件を反映したものです。

このガイドでは、UMP SDK の一部として GDPR IAB TCF v2 メッセージをサポートするために必要な手順の概要を説明します。これは、UMP SDK を使用してアプリを実行する方法の概要とメッセージ設定の基本を説明している [スタートガイド](get_started.md) と併せて使用することを想定しています。以下の説明は、GDPR IAB TCF v2 メッセージに特有のものです。詳細については、[IAB の要件が EU の同意メッセージに与える影響](https://support.google.com/admob/answer/10207733)を参照してください。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/privacy/gdpr)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy/gdpr)

## 前提条件

- [スタートガイド](get_started.md)を完了していること。
- [アプリ用のヨーロッパの規制メッセージの作成](https://support.google.com/admob/answer/10113207)を完了していること。

## 同意の取り消し

GDPR では、ユーザーがいつでも同意の選択を取り消すことができるように、[同意の取り消し](https://support.google.com/admob/answer/10113915)が義務付けられています。ユーザーが同意の選択を取り消す方法を実装するには、[プライバシー オプション](get_started.md)を参照してください。

## 同意年齢未満のユーザーのタグ付け

ユーザーが同意年齢未満であるかどうかを示すには、`tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA) を設定します。TFUA を `true` に設定すると、UMP SDK はユーザーに同意を要求しません。アプリに幅広い年齢層のユーザーがいる場合は、子供のユーザーに対してこのパラメータを設定して、同意が要求されないようにします。

!!! warning "重要"
    UMP SDK は、同意リクエストに設定された TFUA タグを Mobile Ads SDK に転送しません。広告リクエスト設定で明示的に `tag_for_under_age_of_consent` を設定する必要があります。広告リクエストに `tag_for_under_age_of_consent` を設定しない場合、UMP SDK は、同意年齢未満のユーザーがアプリを使用しているかどうかを Google が判断するための情報を収集しません。

    詳細については、[同意年齢未満のユーザーに対する広告リクエストのタグ付け](../../advanced_topics/targeting.md)を参照してください。

次の例では、UMP 同意リクエストで TFUA を `true` に設定します。

=== "GDScript"

    ```gdscript
    var params := ConsentRequestParameters.new()
    params.tag_for_under_age_of_consent = true

    UserMessagingPlatform.consent_information.update(params, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Core;

    var parameters = new ConsentRequestParameters
    {
        // ユーザーが同意年齢未満であることを示します。
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## AdMob メディエーションでの同意の設定

AdMob メディエーションで同意を設定するには、以降のセクションの手順を完了します。

### GDPR メッセージへの広告パートナーの追加

[公開済みの GDPR メッセージへの広告パートナーの追加](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)の手順に従って、メディエーション パートナーを広告パートナー リストに追加します。これを行わないと、パートナーがアプリで広告を配信できなくなる可能性があります。

次の表は、各広告ソースのアドテクノロジー パートナー名を示しています。

| 広告ソース | アドテクノロジー パートナー名 |
| --- | --- |
| AppLovin | AppLovin Corp. |
| BidMachine | BidMachine |
| BIGO Ads SDK | Empathy Technology Pte.Ltd. (BIGO Ads) |
| Chartboost | Chartboost |
| DT Exchange | DT Exchange (Fyber Monetization) |
| i-mobile | i-mobile |
| InMobi | InMobi |
| ironSource Ads | ironSource Mobile |
| Liftoff Monetize | Liftoff |
| LY Ads Network | LY Ads Network |
| maio | maio |
| Meta Audience Network | Meta |
| Mintegral | Mobvista/Mintegral |
| Moloco Ads SDK | Moloco Ads |
| myTarget | Mail.ru |
| Pangle | Pangle DSP |
| PubMatic OpenWrap SDK | PubMatic |
| Unity Ads | Unity Ads |
| Verve HyBid SDK | Verve Group |

### 広告ソースへの同意の転送

次の表は、IAB の透明性と同意に関するフレームワーク (TCF) および [Google の追加同意仕様](https://support.google.com/admob/answer/9681999) と統合された同意管理プラットフォームからの GDPR 同意シグナルを広告ソースの SDK に渡すことをサポートしている広告ソースを示しています。

| 広告ソース | サポートされる最小バージョン |
| --- | --- |
| AppLovin | 7.0.0 |
| BidMachine | 1.0.0 |
| BIGO Ads SDK | 1.0.0 |
| Chartboost | 4.14.0 |
| DT Exchange | 3.3.0 |
| i-mobile | 該当なし¹ |
| InMobi | 4.6.4 |
| ironSource Ads | 2.6.0 |
| Liftoff Monetize | 5.2.2 |
| LY Ads Network | 該当なし¹ |
| maio | 該当なし¹ |
| Meta Audience Network | 該当なし² |
| Mintegral | 2.2.3 |
| Moloco Ads SDK | 1.0.0 |
| myTarget | 3.40.0 |
| Pangle | 5.9.0 |
| PubMatic OpenWrap SDK | 1.0.0 |
| Unity Ads | 3.20.0 |

¹ *この広告ソースは EEA トラフィックを処理しません。*  
² *詳細については、Meta のパートナー マネージャーにお問い合わせください。*

## 同意の選択内容の読み取り方法 {: #how-to-read-consent-choices }

GDPR の同意が得られたら、[TCF v2 仕様](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#in-app-details)に沿ってローカル ストレージから同意の選択内容を読み取ることができます。

`IABTCF_PurposeConsents` キーは、各 [TCF の目的](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/#Appendix_A_Purposes_Features_and_Special_Purposes_Definitions)に対する同意を示します。[`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md) を使用してアプリケーション設定を読み書きできます。

次のコード スニペットは、目的 1 の同意を確認する方法を示しています。

=== "GDScript"

    ```gdscript
    # 設定例: "1111111111"
    var purpose_consents := ApplicationPreferences.get_string("IABTCF_PurposeConsents")

    # 目的は 0 から始まるインデックスです。インデックス 0 には目的 1 に関する情報が含まれます。
    if not purpose_consents.is_empty():
        var purpose_one_string := purpose_consents[0]
        var has_consent_for_purpose_one := purpose_one_string == "1"
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;

    // 設定例: "1111111111"
    string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents");

    // 目的は 0 から始まるインデックスです。インデックス 0 には目的 1 に関する情報が含まれます。
    if (!string.IsNullOrEmpty(purposeConsents))
    {
        char purposeOneString = purposeConsents[0];
        bool hasConsentForPurposeOne = purposeOneString == '1';
    }
    ```

## よくある質問

!!! note
    その他のよくある質問については、[ヨーロッパの規制に関するメッセージのよくある質問](https://support.google.com/admob/answer/13554116)を参照してください。

**EEA、英国、スイスで広告を配信するための同意管理プラットフォーム要件を満たすための対応を行わないとどうなりますか？**

2024 年 1 月 16 日以降、パートナーが [Google 認定の CMP](https://support.google.com/admob/answer/13554116) を導入しない場合、EEA および英国のトラフィックでは[限定配信広告](https://support.google.com/admob/answer/9882911)のみが配信対象になります。収益化に影響が出ないように、認定 CMP を導入してください。

**ユーザーが同意したかどうかを確認するにはどうすればよいですか？**

同意は単一のビットではなく、IAB TCF 仕様で定義されている目的とベンダーのセットで表されます。Google 広告のパーソナライズ基準については、[同意ポリシー: パーソナライズド広告と非パーソナライズド広告](https://support.google.com/admanager/answer/9012903)を参照してください。

さらに、TCF ベンダー リストに登録されていない Google の[広告テクノロジー プロバイダ](https://support.google.com/admob/answer/9012903) (ATP) リストにあるアドテクノロジーは、同意の収集に [Google の追加同意の技術仕様](https://support.google.com/admob/answer/9681999) を使用します。Google は、IAB に登録されていない広告テクノロジー プロバイダとその ID のリストを [additional-consent-providers.csv](https://storage.googleapis.com/tcfac/additional-consent-providers.csv) で公開しています。

個別の広告リクエストをデバッグするには、広告インスペクターの[プライバシー設定のトラブルシューティング](../../advanced_topics/ad_inspector/troubleshoot_privacy.md)機能を使用して、広告リクエストで渡されるプライバシー シグナルを確認します。

| 広告インスペクターのラベル | 広告リクエストのクエリ パラメータ | 意味 |
| --- | --- | --- |
| GDPR が適用される (`IABTCF_gdprApplies`) | `gdpr` | この広告リクエストに GDPR が適用されるかどうか。 |
| TC 文字列 (`IABTCF_TCString`) | `gdpr_consent` | TC 文字列。IAB は、値を手動でデコードできる Web ツールを提供しています。 |
| AC 文字列 (`IABTCF_AddtlConsent`) | `addtl_consent` | Google の追加同意の技術仕様による AC 文字列。 |

プログラムで同意の選択内容を読み取るには、[同意の選択内容の読み取り方法](#how-to-read-consent-choices)を参照してください。

**CMP 要件を満たすために Google の UMP SDK を使用する必要がありますか？**

いいえ、広告を配信するために [Google 認定 CMP のリスト](https://support.google.com/admob/answer/13554116)にある任意の CMP を使用できます。

**ユーザーがすでに同意している場合でも、UMP SDK を使用して同意フォームを再表示するにはどうすればよいですか？**

ユーザーがすでに同意の決定を行っている場合、Google の同意管理ソリューションは、TC 文字列の有効期限が切れるか無効になるまで、新しい同意の収集を要求しません。

GDPR では、ユーザーがいつでも同意の選択を取り消すことができるように、同意の変更が義務付けられています。選択肢を取り消す方法を実装するには、[プライバシー オプション](get_started.md)を参照してください。同意フォームを再表示するには、`UserMessagingPlatform.show_privacy_options_form()` (`UserMessagingPlatform.ShowPrivacyOptionsForm()`) を呼び出します。

**Google 認定 CMP を統合しましたが、同意したユーザーからのものであっても、メディエーション パートナーへの広告リクエストが行われません。なぜですか？**

TCF では、Google は広告テクノロジー プロバイダやその他のプログラマティック デマンド ソースが Google のポリシーに違反しておらず、メディエーション ウォーターフォールに含める前にデータを処理するための法的根拠が少なくとも 1 つあることを確認します。詳細については、[AdMob メディエーションでの同意の設定](#admob)セクションを参照してください。

サードパーティ CMP を使用する場合は、サードパーティ CMP が ACString の保存をサポートしていることを確認し、サードパーティ CMP が同意を収集するために使用する広告テクノロジー プロバイダのリストに各メディエーション パートナーを含めてください。

**ユーザーが同意しない場合、アプリの機能を変更できますか？ポリシーで許可されていますか？**

パブリッシャーはアプリ内で IAB TCF 文字列を読み取ることができます。同意の選択内容をプログラムで読み取る方法については、[同意の選択内容の読み取り方法](#how-to-read-consent-choices)を参照してください。パブリッシャーは、関連する規制に基づく義務について法律顧問に確認する必要があります。

**「オプションの管理」を選択してすべての目的に同意したのに、広告が表示されません。なぜですか？**

目的の同意を収集することに加えて、ベンダーの同意も収集する必要があります。Google などのベンダーが適切な広告を配信するには、目的の同意とベンダーの同意の両方が必要です。

**同じユーザーに iOS ATT アラートと GDPR の同意の両方を表示するためのベスト プラクティスは何ですか？**

ユーザーが GDPR に同意した場合は、最初に GDPR 同意メッセージを表示し、次に iOS ATT アラートを表示することをお勧めします。AdMob 管理画面で両方のメッセージを設定している場合、これは UMP SDK によって自動的に処理されます。詳細については、[ユーザーに表示されるメッセージ](https://support.google.com/admob/answer/10115027)を参照してください。

UMP SDK を使用して ATT アラートを表示しない場合は、GDPR 同意が収集されたら同意の選択内容を読み取って、iOS ATT アラートを表示するかどうかを判断することをお勧めします。

**バージョン 1 にすでに同意したユーザーに対して AC 文字列バージョン 2 を実装するにはどうすればよいですか？**

[Google の追加同意の技術仕様](https://support.google.com/admob/answer/9681999)に従ってローカル ストレージの `IABTCF_AddtlConsent` キーを確認し、ユーザーが AC 文字列バージョン 2 に同意したかどうか、および同意フォームを再表示する必要があるかどうかを判断します。

=== "GDScript"

    ```gdscript
    # 設定例: "2~1.35.41.101~dv.9.21.81"
    var additional_consent := ApplicationPreferences.get_string("IABTCF_AddtlConsent")

    # インデックス 0 には仕様バージョン番号に関する情報が含まれます。
    if not additional_consent.is_empty():
        var spec_ac_version := additional_consent[0]
        var is_ac_version_2 := spec_ac_version == "2"
    ```

=== "C#"

    ```csharp
    // 設定例: "2~1.35.41.101~dv.9.21.81"
    string additionalConsent = ApplicationPreferences.GetString("IABTCF_AddtlConsent");

    // インデックス 0 には仕様バージョン番号に関する情報が含まれます。
    if (!string.IsNullOrEmpty(additionalConsent))
    {
        char specACVersion = additionalConsent[0];
        bool isACVersion2 = specACVersion == '2';
    }
    ```
