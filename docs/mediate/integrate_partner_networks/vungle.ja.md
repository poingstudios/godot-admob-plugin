# メディエーションで Liftoff Monetize (Vungle) を統合する

!!! info

    **注**: Vungle は Liftoff Monetize に名称変更されました。

このガイドでは、入札（Bidding）とウォーターフォール（Waterfall）の両方の統合方法を網羅し、[メディエーション](../get_started.md)を通じて Liftoff Monetize から広告をロードして表示するために、Google Mobile Ads SDK を利用する方法について説明します。Liftoff Monetize を Godot アプリのメディエーション構成に統合する方法、および Vungle SDK とアダプターを Godot アプリに統合する方法を示します。

このドキュメントは以下に基づいています。

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/liftoff-monetize)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/liftoff-monetize)

## サポートされている統合と広告フォーマット

Vungle 用の AdMob メディエーション アダプターは、以下の機能を備えています。

| 統合方法 |   |
|-------------|---|
| 入札 (Bidding) | ✅ |
| ウォーターフォール | ✅ |

| 広告フォーマット |            |
|-----------------------|------------|
| バナー                | [^1]       |
| インタースティシャル          | ✅          |
| リワード              | ✅          |
| リワード インタースティシャル | [^1], [^2] |

[^1]: 入札ではサポートされていません（ウォーターフォール メディエーションのみでサポートされています）。
[^2]: この機能へのアクセスについては、Liftoff Monetize アカウント マネージャーにお問い合わせください。

## 前提条件
- [スタートガイド](../../index.md)を完了していること
- メディエーションの[スタートガイド](../get_started.md)を完了していること

## 制限事項

- Liftoff Monetize は、同じプレースメント参照 ID（Placement Reference ID）を使用した複数の広告のロードをサポートしていません。
    - Vungle アダプターは、該当プレースメントに対する別のリクエストがロード中、または表示待ち状態である場合、2 回目のリクエストを適切にエラー（Fail）として処理します。
- Liftoff Monetize は、一度に 1 つのバナー広告のロードのみをサポートしています。
    - Vungle アダプターは、すでにバナー広告がロードされている場合、その後のバナーリクエストを適切にエラー（Fail）として処理します。

## ステップ 1: Liftoff Monetize のセットアップ
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) または [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_1_set_up_liftoff_monetize) のチュートリアルに従うことをお勧めします。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_2) のチュートリアルに従うことをお勧めします。

## ステップ 3: Vungle SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `vungle` フォルダがあります。
    3. `vungle` フォルダの内容をコピーし、Godot プロジェクトの Android プラグインフォルダである `res://addons/admob/android/bin/` に貼り付けます。
    ![android-vungle](../../assets/android/vungle.png)

=== "iOS"
    Liftoff Monetize（Vungle）アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-vungle.gdip` および関連するフレームワーク）はすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Vungle` の下）で **Vungle** が有効になっていることを確認してください。

=== "iOS"
    **iOS エクスポート プリセット**のプラグイン リストで `Ad Mob` と `Ad Mob vungle` の両方にチェックが入れられており、Plist 構成に AdMob App ID が入力されていることを確認してください。

    ![ios-vungle-export](../../assets/ios/vungle-export.png)

## ステップ 5: 追加のコード要件

Liftoff Monetize は、Godot アプリで使用されるすべてのプレースメントのリストをその SDK に渡す必要があります。このプレースメントのリストは、`VungleInterstitialMediationExtras` および `VungleRewardedVideoMediationExtras`（GDScript では `VungleRewardedMediationExtras`）クラスを使用してアダプターに提供できます。以下のコード例は、これらのクラスの使用方法を示しています。

=== "Interstitial"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "Rewarded"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```

---

=== "Android"
    Liftoff Monetize の統合に追加のコードは必要ありません。

=== "iOS"
    **SKAdNetwork の統合**

    Liftoff Monetize のドキュメントに従って、SKAdNetwork 識別子をプロジェクトの `Info.plist` ファイルに追加します。

## ステップ 6: 実装のテスト
Android および iOS で共通の手順となるため、[Android](https://developers.google.com/admob/android/mediation/liftoff-monetize#step_5_test_your_implementation) または [iOS](https://developers.google.com/admob/ios/mediation/liftoff-monetize#step_5_test_your_implementation) のチュートリアルに従うことをお勧めします。

## 任意のステップ

!!! info

    **重要**: EU ユーザーの同意と GDPR、CCPA、およびユーザーメッセージングプラットフォームの設定を完了するには、**アカウント管理（Account Management）** 権限があることを確認してください。詳細については、[新しいユーザー役割](https://support.google.com/admob/answer/2784628)の記事を参照してください。

### EU ユーザーの同意と GDPR
Google の [EU ユーザーの同意ポリシー](https://www.google.com/about/company/consentstaging.html)に基づき、欧州経済領域（EEA）のユーザーに対して特定の情報を開示し、Cookie またはその他のローカル ストレージの使用、および個人データの使用について同意を得る必要があります。このポリシーは、EU の ePrivacy 指令および一般データ保護規則（GDPR）に準拠しています。同意を求める際は、個人データを収集、受信、または利用する可能性のあるメディエーション チェーン内の各広告ネットワークを明示的に特定する必要があります。また、各ネットワークがこのデータをどのように使用するかについての情報を提供する必要があります。現在、Google はユーザーの同意の選択をこれらのネットワークに自動的に送信することはできません。

以下のサンプルコードは、この同意情報を Vungle SDK に渡す方法を示しています。このメソッドを呼び出す場合は、Google Mobile Ads SDK を介して広告をリクエストする前に呼び出すことをお勧めします。

=== "GDScript"

    ```gdscript
    Vungle.update_consent_status(Vungle.Consent.OPTED_IN, "1.0.0")
    ```

=== "C#"

    ```csharp
    Vungle.UpdateConsentStatus(Vungle.Consent.OptedIn, "1.0.0");
    ```

詳細およびメソッドに指定可能な値については、Vungle の推奨される GDPR 実装方法に関するドキュメントを参照してください。

#### GDPR 広告パートナー リストへの Liftoff の追加
[GDPR 設定](https://support.google.com/admob/answer/10113004#adding_ad_partners_to_published_gdpr_messages)の手順に従って、AdMob UI の GDPR 広告パートナー リストに **Liftoff** を追加します。

### CCPA
[カリフォルニア州消費者プライバシー法 (CCPA)](https://support.google.com/admob/answer/9561022) は、カリフォルニア州の居住者に対して、法律で定義されている「個人情報」の「販売」をオプトアウトする権利を義務付けています。このオプトアウトの選択肢は、販売を行う当事者のホームページ上の「個人情報の販売を拒否（Do Not Sell My Personal Information）」リンクを通じて目立つように表示する必要があります。

[CCPA の準備](../../privacy/regulatory_solutions/us_states_privacy_laws.md)ガイドでは、Google の広告配信において[制限付きデータ処理](https://privacy.google.com/businesses/rdp/)を有効にする機能を提供しています。ただし、Google はこの設定をメディエーション チェーン内のすべての広告ネットワークに適用することはできません。したがって、個人情報の販売に関与する可能性のあるメディエーション チェーン内の各広告ネットワークを特定し、CCPA 遵守を確保するためにそれらの各ネットワークが提供する特定のガイダンスに従うことが不可欠です。

以下のサンプルコードは、この同意情報を Vungle SDK に渡す方法を示しています。このメソッドを呼び出す場合は、Google Mobile Ads SDK を介して広告をリクエストする前に呼び出すことをお勧めします。

=== "GDScript"

    ```gdscript
    Vungle.update_ccpa_status(Vungle.Consent.OPTED_IN)
    ```

=== "C#"

    ```csharp
    Vungle.UpdateCcpaStatus(Vungle.Consent.OptedIn);
    ```

#### CCPA 広告パートナー リストへの Liftoff の追加
[CCPA 設定](https://support.google.com/admob/answer/10860309)の手順に従って、AdMob UI の CCPA 広告パートナー リストに **Liftoff** を追加します。

### ネットワーク固有のパラメータ
Godot 用 Vungle アダプターは、実装する広告フォーマットに応じて、`VungleRewardedMediationExtras` または `VungleInterstitialMediationExtras` クラスのいずれかを使用してアダプターに伝達できる追加のリクエストパラメータをサポートしています。これらのクラスには、次のプロパティが含まれています。

- `sound_enabled`: 動画広告の再生時に音声を有効にするかどうかを設定します。

- `user_id`: Godot 用 Liftoff Monetize 統合用のインセンティブ付きユーザー ID（Incentivized User ID）を表す文字列。

- `all_placements`: アプリ内のすべてのプレースメント ID を含む配列（Vungle SDK 6.2.0 以降を使用するアプリでは必須ではありません）。

iOS の場合は、単純に `VungleAdNetworkExtras` クラスを使用することもできます。

これらのパラメータを設定する広告リクエストの作成例を次に示します。

=== "Interstitial"

    === "GDScript"
    
        ```gdscript
    	var vungle_mediation_extras := VungleInterstitialMediationExtras.new()
    	
    	if OS.get_name() == "iOS":
    		vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "ios_user_id"
    	elif OS.get_name() == "Android":
    		vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
    		vungle_mediation_extras.sound_enabled = true
    		vungle_mediation_extras.user_id = "android_user_id"
    	
    	var ad_request := AdRequest.new()
    	ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleInterstitialMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```
=== "Rewarded"

    === "GDScript"
    
        ```gdscript
        var vungle_mediation_extras := VungleRewardedMediationExtras.new()
    
        if OS.get_name() == "iOS":
            vungle_mediation_extras.all_placements = ["ios_placement1", "ios_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "ios_user_id"
        elif OS.get_name() == "Android":
            vungle_mediation_extras.all_placements = ["android_placement1", "android_placement2"]
            vungle_mediation_extras.sound_enabled = true
            vungle_mediation_extras.user_id = "android_user_id"
    
        var ad_request := AdRequest.new()
        ad_request.mediation_extras.append(vungle_mediation_extras)
        ```
    
    === "C#"
    
        ```csharp
        var vungleMediationExtras = new VungleRewardedMediationExtras();
        
        if (OS.GetName() == "iOS")
        {
            vungleMediationExtras.AllPlacements = new string[] { "ios_placement1", "ios_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "ios_user_id";
        }
        else if (OS.GetName() == "Android")
        {
            vungleMediationExtras.AllPlacements = new string[] { "android_placement1", "android_placement2" };
            vungleMediationExtras.SoundEnabled = true;
            vungleMediationExtras.UserId = "android_user_id";
        }
        
        var adRequest = new AdRequest();
        adRequest.MediationExtras.Add(vungleMediationExtras);
        ```

## エラーコード
アダプターが Audience Network から広告を受信できなかった場合、パブリッシャーは以下のクラスの `ResponseInfo` を使用して、広告レスポンスから根本的なエラーを確認できます。

=== "Android"
    | 広告フォーマット | クラス名                                     |
    |--------------|------------------------------------------------|
    | バナー       | com.vungle.mediation.VungleInterstitialAdapter |
    | インタースティシャル | com.vungle.mediation.VungleInterstitialAdapter |
    | リワード     | com.vungle.mediation.VungleAdapter             |

=== "iOS"
    | 広告フォーマット | クラス名                          |
    |--------------|-------------------------------------|
    | バナー       | GADMAdapterVungleInterstitial       |
    | インタースティシャル | GADMAdapterVungleInterstitial       |
    | リワード     | GADMAdapterVungleRewardBasedVideoAd |

広告のロードに失敗したときに Liftoff Monetize アダプターから返されるエラーコードとメッセージは以下のとおりです。

=== "Android"
    | エラーコード | ドメイン                          | 原因                                                                                                         |
    |------------|---------------------------------|----------------------------------------------------------------------------------------------------------------|
    | 0-100      | com.vungle.warren               | Vungle SDK がエラーを返しました。詳細については [ドキュメント](https://support.vungle.com/hc/en-us/articles/360047780372-Advanced-Settings#exception-codes-for-debugging-0-9) を参照してください。 |
    | 101        | com.google.ads.mediation.vungle | 無効なサーバーパラメータ（例: アプリ ID またはプレースメント ID）。                                                       |
    | 102        | com.google.ads.mediation.vungle | リクエストされたバナーサイズが有効な Liftoff Monetize 広告サイズと一致しません。                                    |
    | 103        | com.google.ads.mediation.vungle | Liftoff Monetize は、広告をリクエストするために Activity コンテキストを必要とします。                                                  |
    | 104        | com.google.ads.mediation.vungle | Vungle SDK は、同じプレースメント ID に対して複数の広告をロードできません。                                             |
    | 105        | com.google.ads.mediation.vungle | Vungle SDK の初期化に失敗しました。                                                                           |
    | 106        | com.google.ads.mediation.vungle | Vungle SDK はロード成功のコールバックを返しましたが、Banners.getBanner() または Vungle.getNativeAd() が null を返しました。 |
    | 107        | com.google.ads.mediation.vungle | Vungle SDK が広告を再生する準備ができていません。                                                                        |

=== "iOS"
    | エラーコード | ドメイン                      | 原因                                                                                                                |
    |------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------|
    | 1-100      | Vungle SDK から送信          | Vungle SDK がエラーを返しました。詳細については、[コード](https://github.com/Vungle/iOS-SDK/blob/6.12.0/VungleSDK.xcframework/ios-arm64_armv7/VungleSDK.framework/Headers/VungleSDK.h) を参照してください。 |
    | 101        | com.google.mediation.vungle | AdMob UI で構成された Liftoff Monetize サーバーパラメータが不足しているか、無効です。                                    |
    | 102        | com.google.mediation.vungle | このネットワーク構成ではすでに広告がロードされています。Vungle SDK は、同じプレースメント ID に対して 2 つ目の広告をロードできません。 |
    | 103        | com.google.mediation.vungle | リクエストされた広告サイズが、Liftoff Monetize がサポートするバナーサイズと一致しません。                                        |
    | 104        | com.google.mediation.vungle | Vungle SDK がバナー広告をレンダリングできませんでした。                                                                            |
    | 105        | com.google.mediation.vungle | Vungle SDK は、プレースメント ID に関係なく、一度に 1 つのバナー広告のロードのみをサポートしています。                                   |
    | 106        | com.google.mediation.vungle | Vungle SDK は、広告が再生可能ではないことを示すコールバックを送信しました。                                                             |
