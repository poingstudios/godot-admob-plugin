# メディエーション（入札）で Meta Audience Network を統合する

!!! info

    **重要**: Facebook Audience Network は Meta Audience Network に名称変更されました。詳細については、[Meta の発表](https://about.fb.com/news/2021/10/facebook-company-is-now-meta/)を参照してください。

このガイドでは、入札（Bidding）統合に焦点を当て、[メディエーション](../get_started.md)を通じて Meta Audience Network から広告をロードして表示するために、Google Mobile Ads SDK を利用する方法について説明します。Meta Audience Network を Godot アプリのメディエーション構成に統合する方法、および Meta Audience Network SDK とアダプターを Godot アプリに統合する方法を示します。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/meta)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/meta)

## サポートされている統合と広告フォーマット

Meta Audience Network 用の AdMob メディエーション アダプターは、以下の機能を備えています。

| 統合方法 |   |
|-------------|---|
| 入札 (Bidding) | ✅ |
| ウォーターフォール [^1]   | ❌ |

| 広告フォーマット |   |
|--------------|---|
| バナー       | ✅ |
| インタースティシャル | ✅ |
| リワード     | ✅ |

[^1]: Meta Audience Network は、2021 年に[入札専用](https://www.facebook.com/audiencenetwork/resources/blog/audience-network-to-become-bidding-only-beginning-with-ios-in-2021)になりました。

## 前提条件
- [スタートガイド](../../index.md)を完了していること
- メディエーションの[スタートガイド](../get_started.md)を完了していること

## ステップ 1: Meta Audience Network のセットアップ
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/meta#setup) または [iOS](https://developers.google.com/admob/ios/mediation/meta#setup) のチュートリアルに従うことをお勧めします。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/meta#configure_mediation) または [iOS](https://developers.google.com/admob/ios/mediation/meta#configure_mediation) のチュートリアルに従うことをお勧めします。

## ステップ 3: Meta Audience Network プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `meta` フォルダがあります。
    3. `meta` フォルダの内容をコピーし、Godot プロジェクトの Android プラグインフォルダである `res://addons/admob/android/bin/` に貼り付けます。
    ![android-meta](../../assets/android/meta.png)

=== "iOS"
    Meta Audience Network アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-meta.gdip` および関連するフレームワーク）はすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Meta` の下）で **Meta** が有効になっていることを確認してください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで `Ad Mob` と `Ad Mob Meta` の両方にチェックが入れられており、Plist 構成に AdMob App ID が入力されていることを確認してください。

    ![ios-meta-export](../../assets/ios/meta-export.png)

## ステップ 5: 追加のコード要件

=== "Android"
    Meta Audience Network の統合に追加のコードは必要ありません。

=== "iOS"
    **SKAdNetwork の統合**

    Meta Audience Network のドキュメントに従って、SKAdNetwork 識別子をプロジェクトの `Info.plist` ファイルに追加します。

    ---
    **コンパイルエラー**

    コンパイルエラーを防ぐために、ターゲットの Build Settings に Swift パスを追加する必要があります。

    ターゲットの **Build Settings** 内の **Library Search Paths** に以下のパスを追加します。

    ```
    $(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
    $(SDKROOT)/usr/lib/swift
    ```

    ターゲットの **Build Settings** 内の **Runpath Search Paths** に以下のパスを追加します。
    ```
    /usr/lib/swift
    ```

    詳細については以下を参照してください。
    https://developers.google.com/admob/ios/mediation/meta#step_4_additional_code_required

    ---
    **広告トラッキングの有効化 (Advertising tracking enabled)**

    iOS 14 以降をターゲットにしてビルドする場合、Meta Audience Network は、以下のコードを使用して [Advertising Tracking Enabled](https://developers.facebook.com/docs/audience-network/setting-up/platform-setup/ios/advertising-tracking-enabled) フラグを明示的に設定することを求めています。

    !!! info

        **重要な注意点**: このフラグは、Mobile Ads SDK を初期化する前に設定する必要があります。

=== "GDScript"

    ```gdscript
    if OS.get_name() == "iOS":
        # FBAdSettings は iOS でのみ利用可能です。Google はこのメソッドを Android SDK には含めていません。
        FBAdSettings.set_advertiser_tracking_enabled(true)
    ```

=== "C#"

    ```csharp
    if (OS.GetName() == "iOS")
    {
        // FBAdSettings は iOS でのみ利用可能です。Google はこのメソッドを Android SDK には含めていません。
        FBAdSettings.SetAdvertiserTrackingEnabled(true);
    }
    ```

## ステップ 6: 実装のテスト
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/meta#step_5_test_your_implementation) または [iOS](https://developers.google.com/admob/ios/mediation/meta#step_5_test_your_implementation) のチュートリアルに従うことをお勧めします。


## 任意のステップ

!!! info

    **重要**: EU ユーザーの同意と GDPR、CCPA、およびユーザーメッセージングプラットフォームの設定を完了するには、**アカウント管理（Account Management）** 権限があることを確認してください。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。


### EU ユーザーの同意と GDPR
Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/consentstaging.html)に基づき、欧州経済領域（EEA）のユーザーに対して特定の情報を開示し、Cookie またはその他のローカル ストレージの使用、および個人データの使用について同意を得る必要があります。このポリシーは、EU の ePrivacy 指令および一般データ保護規則（GDPR）に準拠しています。同意を求める際は、個人データを収集、受信、または利用する可能性のあるメディエーション チェーン内の各広告ネットワークを明示的に特定する必要があります。また、各ネットワークがこのデータをどのように使用するかについての情報を提供する必要があります。現在、Google はユーザーの同意の選択をこれらのネットワークに自動的に送信することはできません。

GDPR および Meta 広告に関する詳細については、Meta の[ガイダンス](https://www.facebook.com/business/gdpr)を参照してください。

#### GDPR 広告パートナー リストへの Facebook の追加
[GDPR 設定](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)の手順に従って、AdMob UI の GDPR 広告パートナー リストに **Facebook** を追加します。


### CCPA
[カリフォルニア州消費者プライバシー法 (CCPA)](https://support.google.com/admob/answer/9561022) は、カリフォルニア州の居住者に対して、法律で定義されている「個人情報」の「販売」をオプトアウトする権利を義務付けています。このオプトアウトの選択肢は、販売を行う当事者のホームページ上の「個人情報の販売を拒否（Do Not Sell My Personal Information）」リンクを通じて目立つように表示する必要があります。

[CCPA の準備](../../privacy/regulatory_solutions/us_states_privacy_laws.md)ガイドでは、Google の広告配信において[制限付きデータ処理](https://privacy.google.com/businesses/rdp/)を有効にする機能を提供しています。ただし、Google はこの設定をメディエーション チェーン内のすべての広告ネットワークに適用することはできません。したがって、個人情報の販売に関与する可能性のあるメディエーション チェーン内の各広告ネットワークを特定し、CCPA 遵守を確保するためにそれらの各ネットワークが提供する特定のガイダンスに従うことが不可欠です。

カリフォルニア州のユーザー向けデータ処理オプションについては、Meta の[ドキュメント](https://developers.facebook.com/docs/marketing-apis/data-processing-options)を参照してください。

#### CCPA 広告パートナー リストへの Facebook の追加
[CCPA 設定](https://support.google.com/admob/answer/10860309)の手順に従って、AdMob UI の CCPA 広告パートナー リストに **Facebook** を追加します。

### キャッシング
=== "Android"
    **Android 9**:

    Android 9（API レベル 28）以降、[クリアテキスト通信のサポートがデフォルトで無効](https://developer.android.com/training/articles/security-config#CleartextTrafficPermitted)になっています。これは Meta Audience Network SDK のメディア キャッシュ機能に影響を与え、ユーザー体験や広告収益に影響する可能性があります。[Meta のドキュメント](https://developers.facebook.com/docs/audience-network/android-network-security-config/)に従って、アプリのネットワークセキュリティ構成を更新してください。

=== "iOS"
    適用対象外。

## エラーコード
アダプターが Audience Network から広告を受信できなかった場合、パブリッシャーは以下のクラスの `ResponseInfo` を使用して、広告レスポンスから根本的なエラーを確認できます。

=== "Android"
    ```
    com.google.ads.mediation.facebook.FacebookAdapter
    com.google.ads.mediation.facebook.FacebookMediationAdapter
    ```

=== "iOS"
    ```
    GADMAdapterFacebook
    GADMediationAdapterFacebook
    ```

広告のロードに失敗したときに Meta Audience Network アダプターから返されるエラーコードとメッセージは以下のとおりです。

=== "Android"
    | エラーコード | 原因                                                                                                   |
    |------------|----------------------------------------------------------------------------------------------------------|
    | 101        | 無効なサーバーパラメータ（例: プレースメント ID の欠落）。                                                   |
    | 102        | リクエストされた広告サイズが、Meta Audience Network がサポートするバナーサイズと一致しません。                      |
    | 103        | パブリッシャーは **Activity** コンテキストを使用して広告をリクエストする必要があります。                                             |
    | 104        | Meta Audience Network SDK の初期化に失敗しました。                                                      |
    | 105        | パブリッシャーが Unified ネイティブ広告をリクエストしませんでした。                                                    |
    | 106        | ロードされたネイティブ広告が想定されていたオブジェクトと異なります。                                        |
    | 107        | 使用された **Context** オブジェクトが無効です。                                                                  |
    | 108        | ロードされた広告に必要なネイティブ広告アセットが不足しています。                                                  |
    | 109        | ビッドペイロードからのネイティブ広告の作成に失敗しました。                                                       |
    | 110        | Meta Audience Network SDK がインタースティシャル/リワード広告の表示に失敗しました。                          |
    | 111        | Meta Audience Network の **AdView** オブジェクトの作成中に例外が発生しました。                                |
    | 1000-9999  | Meta Audience Network から SDK 固有のエラーが返されました。詳細については、Meta Audience Network の[ドキュメント](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors)を参照してください。 |

=== "iOS"
    | エラーコード | 原因                                                                                                                |
    |------------|-----------------------------------------------------------------------------------------------------------------------|
    | 101        | 無効なサーバーパラメータ（例: プレースメント ID の欠落）。                                                                |
    | 102        | リクエストされた広告サイズが、Meta Audience Network がサポートするバナーサイズと一致しません。                                   |
    | 103        | Meta Audience Network 広告オブジェクトの初期化に失敗しました。                                                             |
    | 104        | Meta Audience Network SDK がインタースティシャル/リワード広告の表示に失敗しました。                                       |
    | 105        | バナー広告のルートビューコントローラが **nil** です。                                                                     |
    | 106        | Meta Audience Network SDK の初期化に失敗しました。                                                                   |
    | 1000-9999  | Meta Audience Network から SDK 固有のエラーが返されました。詳細については、Meta Audience Network の[ドキュメント](https://developers.facebook.com/docs/audience-network/setting-up/test/checklist-errors)を参照してください。 |
