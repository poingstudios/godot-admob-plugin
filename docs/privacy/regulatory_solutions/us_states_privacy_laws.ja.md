# 米国のユーザーへの開示

!!! note
    **重要:** EU ユーザーの同意と GDPR、米国各州の規制、およびユーザーメッセージングプラットフォームの設定を完了するには、**アカウント管理** 権限があることを確認してください。詳細については、[アカウントへのユーザーアクセスの管理](https://support.google.com/admob/answer/2784628)を参照してください。

[米国各州のプライバシー法](https://support.google.com/admob/answer/9561022)の遵守を支援するため、Google Mobile Ads SDK では Google の[制限付きデータ処理 (RDP)](https://business.safety.google/rdp/) パラメータを使用して RDP を有効にするかどうかを指定できます。Google は、該当する米国の州に対して [Global Privacy Platform (GPP)](https://iabtechlab.com/standards/global-privacy-platform-gpp/) もサポートしています。

Google Mobile Ads SDK がいずれかのシグナルを使用すると、SDK は特定の固有識別子を制限し、サービスの提供において処理されるその他のデータも制限されます。

制限付きデータ処理がコンプライアンス計画をどのようにサポートできるか、またいつ有効にするかを決定する必要があります。RDP パラメータを直接使用するか、GPP 仕様で同意とプライバシーの選択を通知するかを判断してください。

このガイドは、ローカル ストレージを介してグローバルに、または広告リクエストごとに RDP を有効にし、GPP シグナルを使用する方法を説明します。

このドキュメントの参照元:

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/privacy/us-states)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy/us-states)

## 前提条件

- [使ってみるガイド](../user_messaging_tools/get_started.md)を完了します。
- [アプリ用の米国各州の規制メッセージを作成](https://support.google.com/admob/answer/13467025)します。

## 同意取得年齢未満のユーザー向けのタグ

ユーザーが同意取得年齢未満であることを示すには、`tag_for_under_age_of_consent` / `TagForUnderAgeOfConsent` (TFUA) を設定します。TFUA を `true` に設定すると、UMP SDK はユーザーに同意を要求しません。アプリの対象ユーザー層が幅広い場合は、同意が要求されないように、子供のユーザーに対してこのパラメータを設定してください。

!!! warning "重要"
    UMP SDK は、同意リクエストに設定された TFUA タグを Mobile Ads SDK に転送しません。広告リクエストでは `tag_for_under_age_of_consent` を明示的に設定する必要があります。広告リクエストで `tag_for_under_age_of_consent` を設定しない場合、UMP SDK は同意取得年齢未満のユーザーがアプリを使用しているかどうかを Google が判断するための情報を収集しません。

    詳しくは、[同意取得年齢未満のユーザーに対する広告リクエストのタグ付け](../../advanced_topics/targeting.md)をご覧ください。

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
        // ユーザーが同意取得年齢未満であることを示します。
        TagForUnderAgeOfConsent = true
    };

    UserMessagingPlatform.ConsentInformation.Update(parameters, OnConsentInfoUpdated);
    ```

## RDP シグナルの有効化

Google は、制限付きデータ処理 (RDP) を有効にするための 2 つの方法をサポートしています。どちらも有効であり、Google Mobile Ads SDK でサポートされています。

### ローカル ストレージでグローバルに設定 (推奨)

公式の Android および iOS SDK では、Google は `gad_rdp` キーをローカル ストレージ（Android では `SharedPreferences`、iOS では `UserDefaults`）に直接書き込むことを推奨しています。Google Mobile Ads SDK は、広告の読み込み中にこのキーを自動的に読み取り、アプリ全体のすべての広告リクエストに RDP を適用します。

=== "GDScript"

    ```gdscript
    if OS.get_name() == "Android":
        ApplicationPreferences.set_int("gad_rdp", 1)
    elif OS.get_name() == "iOS":
        ApplicationPreferences.set_bool("gad_rdp", true)
    ```

=== "C#"

    ```csharp
    if (OperatingSystem.IsAndroid())
    {
        ApplicationPreferences.SetInt("gad_rdp", 1);
    }
    else if (OperatingSystem.IsIOS())
    {
        ApplicationPreferences.SetBool("gad_rdp", true);
    }
    ```

### 広告リクエストごと

[`AdRequest`](../../reference/classes/AdRequest.md) の `extras` ディクショナリにキー `rdp` を値 `1`（C# では `"1"`）で挿入することで、広告リクエストごとに RDP シグナルを有効にすることもできます。

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["rdp"] = 1
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("rdp", "1");
    ```

!!! note
    **ヒント:** [Charles](https://www.charlesproxy.com/) などのネットワーク トレースまたはプロキシ ツールを使用してアプリの HTTPS トラフィックをキャプチャし、広告リクエストで **&rdp=** パラメータを検査できます。

## IAB GPP シグナルの使用

同意管理プラットフォーム (CMP) または独自のカスタム メッセージングを使用して同意の決定を収集する場合、Google Mobile Ads SDK はローカル ストレージに書き込まれた GPP シグナルを尊重します。User Messaging Platform (UMP) SDK は、GPP シグナルの書き込みをサポートしています。米国の州の同意を収集するには、AdMob アカウントの **プライバシーとメッセージ** で **米国各州の規制** メッセージを設定します。UMP の設定については、[UMP SDK の設定](../user_messaging_tools/get_started.md)を参照してください。

### 同意の選択内容の読み取り

UMP SDK は、[IAB GPP 仕様](https://iabtechlab.com/standards/global-privacy-platform-gpp/)に沿って GPP データをローカル ストレージに書き込みます。なお、UMP SDK は、米国各州の規制を処理するためにこれら 2 つのキーのみを設定します。

- `IABGPP_HDR_GppString`: エンコードされたユーザーの同意とオプトアウトの環境設定を含む GPP 文字列。
- `IABGPP_GppSID`: GPP 文字列に含まれるセクション ID（米国全土の場合は `7` など）。

[`ApplicationPreferences`](../../reference/classes/ApplicationPreferences.md) を使用してローカル ストレージから同意の選択内容を読み取ることができます。

=== "GDScript"

    ```gdscript
    var gpp_string := ApplicationPreferences.get_string("IABGPP_HDR_GppString")
    var gpp_sid := ApplicationPreferences.get_string("IABGPP_GppSID")
    ```

=== "C#"

    ```csharp
    var gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString");
    var gppSid = ApplicationPreferences.GetString("IABGPP_GppSID");
    ```

## 米国各州の規制メッセージのテスト

テスト デバイスで UMP SDK を使用して米国各州の規制メッセージ フローをテストするには、[`ConsentDebugSettings`](../../reference/classes/ConsentDebugSettings.md) でデバッグ地域を強制的に設定します。

- **規制対象の米国の州をシミュレートする:** `debug_geography` を `DebugGeography.Values.REGULATED_US_STATE`（C# では `DebugGeography.RegulatedUsState`）に設定します。
- **米国各州の規制メッセージを非表示にする:** `debug_geography` を `DebugGeography.Values.OTHER`（C# では `DebugGeography.Other`）に設定します。

=== "GDScript"

    ```gdscript
    var request := ConsentRequestParameters.new()
    var debug_settings := ConsentDebugSettings.new()
    debug_settings.debug_geography = DebugGeography.Values.REGULATED_US_STATE
    debug_settings.test_device_hashed_ids.append("TEST-DEVICE-HASHED-ID")
    request.consent_debug_settings = debug_settings

    UserMessagingPlatform.consent_information.update(request, _on_consent_info_updated)
    ```

=== "C#"

    ```csharp
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Ump.Api;
    using PoingStudios.AdMob.Ump.Core;

    var request = new ConsentRequestParameters();
    var debugSettings = new ConsentDebugSettings();
    debugSettings.DebugGeography = DebugGeography.RegulatedUsState;
    debugSettings.TestDeviceHashedIds.Add("TEST-DEVICE-HASHED-ID");
    request.ConsentDebugSettings = debugSettings;

    UserMessagingPlatform.ConsentInformation.Update(request, OnConsentInfoUpdated);
    ```

## メディエーション

[メディエーション](../../mediate/get_started.md)を使用している場合は、AdMob 管理画面の **プライバシーとメッセージ** > **米国各州の規制** に移動して、米国の州の広告パートナーを管理します。米国各州の規制への準拠のために提供されているオプションについては、各広告ネットワーク パートナーのドキュメントを参照してください。
