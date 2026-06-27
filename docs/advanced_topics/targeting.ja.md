# ターゲティング
このガイドでは、広告リクエストにターゲティング情報を提供する方法について説明します。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/targeting)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/targeting)

## 前提条件
- [スタートガイド](../index.md)を完了していること


## RequestConfiguration

`RequestConfiguration` は、ターゲティングの詳細を収集するために使用されるエンティティであり、`MobileAds` 内の静的メソッドを通じてグローバルに適用できます。これは `MobileAds.set_request_configuration(request_configuration)` によって適用されます。

### 子供向け設定 {: #child-directed-setting }
[児童オンラインプライバシー保護法 (COPPA)](https://www.ftc.gov/tips-advice/business-center/privacy-and-security/children%27s-privacy) に準拠するため、「子供向けコンテンツとしての取扱いタグ（tag for child-directed treatment）」オプションを設定できます。これは、COPPA の目的においてコンテンツを子供向けとして処理させたいことを意味します。この決定をアプリ所有者に代わって行う権限があることを確認することが重要です。この設定を悪用すると、Google アカウントが停止される可能性がありますのでご注意ください。

アプリ開発者は、広告リクエストの際にコンテンツが子供向けかどうかを指定できます。コンテンツが子供向けであることを指定すると、Google はその特定の広告リクエストに対して、インタレストベース広告（IBA）およびリマーケティング広告を無効にする措置を講じます。

この設定を実装するには、`RequestConfiguration.new().tag_for_child_directed_treatment = int` を使用し、以下のオプションを指定します。

- COPPA 準拠のためにコンテンツを子供向けとして処理する必要があることを示すには、`tag_for_child_directed_treatment` に `RequestConfiguration.TagForChildDirectedTreatment.TRUE` を使用します。これにより、Android 広告識別子（AAID）および iOS 広告識別子（IDFA）の送信が防止されます。

- コンテンツを COPPA の目的において子供向けとして処理しないように指定するには、`tag_for_child_directed_treatment` に `RequestConfiguration.TagForChildDirectedTreatment.FALSE` を使用します。

- COPPA に関して広告リクエスト内でのコンテンツの取扱い方法を指定したくない場合は、`tag_for_child_directed_treatment` に `RequestConfiguration.TagForChildDirectedTreatment.UNSPECIFIED` を使用します。

以下の例は、COPPA の目的においてコンテンツを子供向けとして処理させたい場合の設定を示しています。

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
 
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

### 同意年齢未満のユーザー

欧州経済領域（EEA）の同意年齢未満のユーザーを対象とするように広告リクエストを構成できます。この機能は、[一般データ保護規則 (GDPR)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679) への準拠を支援するために設計されています。GDPR では追加の法的義務が課される場合があるため、弁護士などの専門家に相談し、欧州連合のガイドラインを確認することをお勧めします。Google のツールは準拠をサポートするためのものであり、パブリッシャーの法的責任を代替するものではありません。[GDPR がパブリッシャーに与える影響の詳細](https://support.google.com/admob/answer/7666366)。

この機能を使用すると、広告リクエストに「同意年齢未満の欧州ユーザー向けのタグ（Tag For Users under the Age of Consent in Europe: TFUA）」パラメータが含まれます。このパラメータは、すべての広告リクエストについてリマーケティングを含むパーソナライズ広告を無効にします。また、広告測定ピクセルやサードパーティの広告サーバーなどのサードパーティ広告ベンダーへのリクエストも無効になります。

子供向け設定と同様に、`RequestConfiguration.new()` クラスのプロパティ `tag_for_under_age_of_consent = int` を使用して TFUA パラメータを設定できます。これには以下のオプションがあります。

- 同意年齢未満の欧州経済領域（EEA）のユーザーとして広告リクエストを処理したい場合は、`tag_for_under_age_of_consent` に `RequestConfiguration.TagForUnderAgeOfConsent.TRUE` を使用します。これにより、Android 広告識別子（AAID）および iOS 広告識別子（IDFA）の送信も防止されます。

- 同意年齢未満の欧州経済領域（EEA）のユーザーとして広告リクエストを処理しない場合は、`tag_for_under_age_of_consent` に `RequestConfiguration.TagForUnderAgeOfConsent.FALSE` を使用します。

- 同意年齢未満の欧州経済領域（EEA）のユーザーとして広告リクエストを処理するかどうかを指定しない場合は、`tag_for_under_age_of_consent` に `RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED` を使用します。

以下は、広告リクエストに TFUA を含める例です。

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.tag_for_under_age_of_consent = RequestConfiguration.TagForUnderAgeOfConsent.UNSPECIFIED
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
 
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.Unspecified;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

[子供向け設定](#child-directed-setting)を有効にするタグと `tag_for_under_age_of_consent` プロパティを同時に `true` に設定しないでください。両方が設定されている場合、子供向け設定が優先されます。


### 広告コンテンツのフィルタリング

広告内に含まれる関連の提供情報などを網羅する Google Play の[不適切な広告に関するポリシー](https://support.google.com/googleplay/android-developer/answer/9857753#zippy=%2Cexamples-of-common-violations)に確実に準拠するためには、アプリに表示されるすべての広告およびそれらに関連する提供情報が、アプリの[コンテンツ レーティング](https://support.google.com/googleplay/android-developer/answer/9898843)と一致している必要があります。これは、コンテンツ自体が Google Play のポリシーに準拠している場合でも適用されます。

「広告の最大コンテンツ レーティング（maximum ad content rating）」などのツールを使用すると、ユーザーに表示される広告のコンテンツをより細かく制御できます。プラットフォーム ポリシーへの準拠を確保するために、最大コンテンツ レーティングを設定できます。

アプリは、`max_ad_content_rating` プロパティを使用して、広告リクエストに対して広告の最大コンテンツ レーティングを指定できます。この構成で返される AdMob 広告は、指定されたレベル以下に一致するコンテンツ レーティングを持ちます。利用可能な値は[デジタル コンテンツ ラベルの分類](https://support.google.com/admob/answer/7562142)に基づいており、以下のいずれかの文字列である必要があります。

- `RequestConfiguration.MAX_AD_CONTENT_RATING_G`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_PG`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_T`
- `RequestConfiguration.MAX_AD_CONTENT_RATING_MA`

以下のコードは、返される広告コンテンツがデジタル コンテンツ ラベル指定の `G` を超えないように `RequestConfiguration` オブジェクトを構成する方法を示しています。

=== "GDScript"

    ```gdscript
    var request_configuration := RequestConfiguration.new()
    request_configuration.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
    MobileAds.set_request_configuration(request_configuration)
    ```

=== "C#"

    ```csharp linenums="1"
    using PoingStudios.AdMob.Api;
    using PoingStudios.AdMob.Api.Core;
 
    var requestConfiguration = new RequestConfiguration();
    requestConfiguration.MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG;
    MobileAds.SetRequestConfiguration(requestConfiguration);
    ```

## AdRequest

`AdRequest` は、個々の広告リクエストとともに送信されるターゲティング情報を収集します。

### ネットワーク エクストラの追加

ネットワーク エクストラは、単一の広告ソースに固有の、広告リクエストとともに送信される追加の詳細情報です。

Google に追加のパラメータを送信するには（たとえば、[折りたたみ式バナー](../../guides/ad_formats/banner/collapsible/) をリクエストするためにキー `collapsible` に値 `bottom` を設定する場合）、`extras` ディレクトリにデータを入力します。

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras = {
        "collapsible": "bottom"
    }
    # その後、リクエストを使って広告を読み込みます。例:
    # ad_view.load_ad(ad_request)
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras = new Godot.Collections.Dictionary
    {
        { "collapsible", "bottom" }
    };
    // その後、リクエストを使って広告を読み込みます。例:
    // adView.LoadAd(adRequest);
    ```


詳細については以下を参照してください。

- [広告リクエストごとの最大コンテンツ レーティングの設定](https://support.google.com/admob/answer/10477886)
- [アプリまたはアカウント of 広告の最大コンテンツ レーティングの設定](https://support.google.com/admob/answer/7562142)
