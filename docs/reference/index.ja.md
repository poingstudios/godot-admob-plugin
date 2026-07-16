# API リファレンス

このページでは、Godot AdMob 插件が提供するクラス、列挙型、およびコールバックの一覧を掲載しています。

## クラス

| クラス | 説明 |
| :--- | :--- |
| [MobileAds](classes/MobileAds.ja.md) | グローバル設定と SDK 初期化のエントリポイント。 |
| [RequestConfiguration](classes/RequestConfiguration.ja.md) | すべての広告リクエストにグローバルに適用される設定。 |
| [AdRequest](classes/AdRequest.ja.md) | 広告のロードに使用されるリクエストパラメータ。 |
| [AdSize](classes/AdSize.ja.md) | バナー広告の幅と高さの定義。 |
| [AdPosition](classes/AdPosition.ja.md) | バナー広告およびネイティブオーバーレイ広告の画面配置レイアウト。 |
| [AdView](classes/AdView.ja.md) | バナー広告をロードして表示する Godot ノード。 |
| [AdVideoController](classes/AdVideoController.ja.md) | ネイティブ広告内のビデオ再生コントローラー。 |
| [AdVideoOptions](classes/AdVideoOptions.ja.md) | ネイティブ広告内のビデオ要素の再生動作設定。 |
| [AppOpenAd](classes/AppOpenAd.ja.md) | アプリを起動または復帰したときに表示される全画面広告フォーマット。 |
| [AppOpenAdLoader](classes/AppOpenAdLoader.ja.md) | アプリ起動時広告（App Open Ads）の取得を担当するローダークラス。 |
| [InterstitialAd](classes/InterstitialAd.ja.md) | 全画面インタースティシャル広告フォーマット。 |
| [InterstitialAdLoader](classes/InterstitialAdLoader.ja.md) | インタースティシャル広告の取得を担当するローダークラス。 |
| [RewardedAd](classes/RewardedAd.ja.md) | 全画面リワード広告フォーマット。 |
| [RewardedAdLoader](classes/RewardedAdLoader.ja.md) | リワード広告の取得を担当するローダークラス。 |
| [RewardedInterstitialAd](classes/RewardedInterstitialAd.ja.md) | リワードインタースティシャル広告フォーマット（半透明のオーバーレイ表示）。 |
| [RewardedInterstitialAdLoader](classes/RewardedInterstitialAdLoader.ja.md) | リワードインタースティシャル広告の取得を担当するローダークラス。 |
| [NativeOverlayAd](classes/NativeOverlayAd.ja.md) | Godot シーンの上に重ねて表示されるネイティブ広告フォーマット。 |
| [NativeAdOptions](classes/NativeAdOptions.ja.md) | ネイティブオーバーレイ広告のレンダリング設定。 |
| [NativeTemplateStyle](classes/NativeTemplateStyle.ja.md) | ネイティブオーバーレイ広告 of ビジュアルスタイルテンプレート。 |
| [NativeTemplateTextStyle](classes/NativeTemplateTextStyle.ja.md) | テキスト要素のフォントと色の設定。 |
| [ResponseInfo](classes/ResponseInfo.ja.md) | ロードされた広告のメタデータとアダプター応答情報を保持するクラス。 |
| [AdapterResponseInfo](classes/AdapterResponseInfo.ja.md) | 特定のメディエーションネットワークアダプターからのメタデータ。 |
| [AdError](classes/AdError.ja.md) | 広告表示中に発生したエラーに関する情報。 |
| [LoadAdError](classes/LoadAdError.ja.md) | 広告ロード中に発生したエラーに関する情報。 |
| [MediaContent](classes/MediaContent.ja.md) | ネイティブ広告に関連付けられたメディアアセット（ビデオ/画像）を表すクラス。 |
| [AdValue](classes/AdValue.ja.md) | 広告インプレッションから得られる収益の金銭的価値を表すクラス。 |
| [RewardedItem](classes/RewardedItem.ja.md) | ユーザーが獲得したリワード（数量とタイプ）を表すクラス。 |
| [InitializationStatus](classes/InitializationStatus.ja.md) | MobileAds の初期化ステータスの詳細情報。 |
| [AdapterStatus](classes/AdapterStatus.ja.md) | 単一のメディエーションアダプターの初期化ステータス。 |
| [ServerSideVerificationOptions](classes/ServerSideVerificationOptions.ja.md) | サーバー側リワードコールバック（SSV）のセキュリティ設定。 |
| [UserMessagingPlatform](classes/UserMessagingPlatform.ja.md) | GDPR およびプライバシー同意フローのエントリポイント。 |
| [ConsentInformation](classes/ConsentInformation.ja.md) | ユーザーの同意ステータスを確認して更新するクラス。 |
| [ConsentForm](classes/ConsentForm.ja.md) | ユーザーに表示できる同意フォーム。 |
| [ConsentRequestParameters](classes/ConsentRequestParameters.ja.md) | 同意情報の更新をリクエストするためのパラメータ。 |
| [ConsentDebugSettings](classes/ConsentDebugSettings.ja.md) | 同意フローのテスト用設定。 |
| [FormError](classes/FormError.ja.md) | 同意フォーム操作時のエラー情報。 |

## 列挙型

| 列挙型 | 説明 |
| :--- | :--- |
| [AdPosition](enums/AdPosition.ja.md) | バナーおよびネイティブオーバーレイ広告の画面配置プリセット値。 |
| [AdChoicesPlacement](enums/AdChoicesPlacement.ja.md) | AdChoices アイコンの表示位置（四隅）。 |
| [NativeMediaAspectRatio](enums/NativeMediaAspectRatio.ja.md) | ネイティブ広告のメディアアスペクト比設定。 |
| [NativeTemplateFontStyle](enums/NativeTemplateFontStyle.ja.md) | ネイティブ広告テキストフィールドのフォントの太さ。 |
| [AdValue.PrecisionType](enums/AdValue.PrecisionType.ja.md) | 広告収益価値の精度レベル。 |
| [AdapterStatus.InitializationState](enums/AdapterStatus.InitializationState.ja.md) | メディエーションアダプターが準備完了しているかどうかを示します。 |
| [RequestConfiguration.TagForChildDirectedTreatment](enums/RequestConfiguration.TagForChildDirectedTreatment.ja.md) | COPPA 準拠のための子ども向けコンテンツの取り扱い設定。 |
| [RequestConfiguration.TagForUnderAgeOfConsent](enums/RequestConfiguration.TagForUnderAgeOfConsent.ja.md) | GDPR 準拠のための同意年齢未満のユーザーの取り扱い設定。 |
| [DebugGeography](enums/DebugGeography.ja.md) | 同意フローテスト用のデバッグ地理設定。 |
| [ConsentInformation.ConsentStatus](enums/ConsentInformation.ConsentStatus.ja.md) | プライバシー規制に対するユーザーの同意ステータス。 |
| [ConsentInformation.PrivacyOptionsRequirementStatus](enums/ConsentInformation.PrivacyOptionsRequirementStatus.ja.md) | プライバシーオプションが必要かどうか。 |

## インターフェース / コールバック

| コールバック | 説明 |
| :--- | :--- |
| [OnInitializationCompleteListener](listeners/OnInitializationCompleteListener.ja.md) | SDK の初期化完了時にトリガーされるコールバック。 |
| [AdListener](listeners/AdListener.ja.md) | バナーおよびオーバーレイ広告イベントを受信します。 |
| [FullScreenContentCallback](listeners/FullScreenContentCallback.ja.md) | 全画面広告フォーマットの表示イベントを受信します。 |
| [OnUserEarnedRewardListener](listeners/OnUserEarnedRewardListener.ja.md) | ユーザーがリワードを獲得したときにイベントを受信します。 |
| [AppOpenAdLoadCallback](listeners/AppOpenAdLoadCallback.ja.md) | アプリ起動時広告のロード結果を処理します。 |
| [InterstitialAdLoadCallback](listeners/InterstitialAdLoadCallback.ja.md) | インタースティシャル広告のロード結果を処理します。 |
| [RewardedAdLoadCallback](listeners/RewardedAdLoadCallback.ja.md) | リワード広告 of ロード結果を処理します。 |
| [RewardedInterstitialAdLoadCallback](listeners/RewardedInterstitialAdLoadCallback.ja.md) | リワードインタースティシャル広告のロード结果を処理します。 |
| [VideoLifecycleCallbacks](listeners/VideoLifecycleCallbacks.ja.md) | ネイティブ広告内のビデオ再生ライフサイクルイベントを受信します。 |
| [AdInspectorClosedListener](listeners/AdInspectorClosedListener.ja.md) | ネイティブ広告インスペクターが閉じられたときにトリガーされます。 |
