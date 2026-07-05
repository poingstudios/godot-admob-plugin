# 米国各州のプライバシー法への準拠

!!! note

    **重要**: EU ユーザーの同意と GDPR、CCPA、およびユーザーメッセージングプラットフォームの設定を完了するには、**アカウント管理（Account Management）** 権限があることを確認してください。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。

パブリッシャーが[米国各州のプライバシー法](https://support.google.com/admob/answer/9561022)を遵守できるように、Google Mobile Ads SDK では 2 つの異なるパラメータを使用して、Google が[制限付きデータ処理 (RDP)](https://business.safety.google/rdp/) を有効にする必要があるかどうかを示すことができます。SDK は、以下のシグナルを利用して広告リクエストレベルで RDP を設定する機能をパブリッシャーに提供します。

- Google の RDP
- [IAB 定義](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf)の `IABUSPrivacy_String`

いずれかのパラメータが使用されると、Google は、パブリッシャーへのサービス提供において処理される特定の固有識別子およびその他のデータの使用方法を制限します。結果として、Google は非パーソナライズ広告のみを表示します。これらのパラメータは、ユーザーインターフェース（UI）の RDP 設定よりも優先されます。

パブリッシャーは、制限付きデータ処理が自身のコンプライアンス計画をどのようにサポートできるか、およびそれをいつ有効にするべきかを自身で決定する必要があります。両方のオプションのパラメータを同時に使用することも可能ですが、Google の広告配信に対する効果は同じです。

このガイドは、広告リクエストごとにこれらのオプションを有効にするために必要な手順をパブリッシャーが理解するのに役立つことを目的としています。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/privacy/us-states)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/privacy/us-states)

## RDP シグナル

Google のシグナルを使用して RDP を有効にする必要があることを Google に通知するには、パラメータにキー `rdp` を追加し、値を `1` に設定します。

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

    **ヒント:** ネットワークトレースまたは [Charles](https://www.charlesproxy.com/) などのプロキシツールを使用して、アプリの HTTPS トラフィックをキャプチャし、広告リクエストに **&rdp=** パラメータが含まれているか確認できます。

## IAB シグナル

IAB のシグナルを使用して RDP を有効にする必要があることを Google に通知するには、キー `IABUSPrivacy_String` をパラメータとして追加します。使用する文字列値が [IAB 仕様](https://iabtechlab.com/wp-content/uploads/2019/11/Technical-Specifications-FAQ-US-Privacy-IAB-Tech-Lab.pdf)に準拠していることを確認してください。

=== "GDScript"

    ```gdscript
    var ad_request := AdRequest.new()
    ad_request.extras["IABUSPrivacy_String"] = "IAB_STRING"
    ```

=== "C#"

    ```csharp
    var adRequest = new AdRequest();
    adRequest.Extras.Add("IABUSPrivacy_String", "IAB_STRING");
    ```

!!! note

    **ヒント:** ネットワークトレースまたは [Charles](https://www.charlesproxy.com/) などのプロキシツールを使用して、アプリの HTTPS トラフィックをキャプチャし、広告リクエストに **&us_privacy=** パラメータが含まれているか確認できます。

## メディエーション

!!! note

    **重要**: メディエーション設定を完了するには、必要なアカウント権限を持っていることを確認してください。これらの権限には、在庫管理、アプリへのアクセス、プライバシーとメッセージング機能へのアクセスが含まれます。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。

[メディエーション](../../mediate/get_started.md)を使用している場合は、[CPRA 設定](https://support.google.com/admob/answer/10860309)の手順に従って、AdMob UI の CCPA 広告パートナー リストにメディエーションパートナーを追加してください。また、各広告ネットワーク パートナーのドキュメントを参照して、CCPA 準拠に向けてどのようなオプションを提供しているかを確認してください。
