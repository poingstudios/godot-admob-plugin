# InMobi をメディエーションに統合する

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて InMobi から広告をロードして表示する方法について説明します。InMobi を Godot アプリのメディエーション設定に統合する方法、および InMobi SDK とアダプターを統合する手順を説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント（英語）](https://developers.google.com/admob/android/mediation/inmobi)
- [Google Mobile Ads SDK iOS ドキュメント（英語）](https://developers.google.com/admob/ios/mediation/inmobi)

## サポートされている統合と広告フォーマット

AdMob の InMobi メディエーションアダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング（Bidding） | ✅ |
| ウォーターフォール（Waterfall） | ✅ |

| 広告フォーマット |            |
|-----------------------|------------|
| バナー（Banner） | ✅          |
| インタースティシャル（Interstitial） | ✅          |
| リワード（Rewarded） | ✅          |
| リワードインタースティシャル |            |
| ネイティブ（Native） | ✅          |

## 前提条件
- [はじめに](../../index.md) ガイドを完了していること
- メディエーション [はじめに](../get_started.md) ガイドを完了していること

## ステップ 1: InMobi の設定
[Android](https://developers.google.com/admob/android/mediation/inmobi#step_1_set_up_inmobi) または [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_1_set_up_inmobi) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を行う
[Android](https://developers.google.com/admob/android/mediation/inmobi#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/inmobi#step_2) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 3: InMobi SDK プラグインのインポート

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。中に `inmobi` フォルダがあります。
    3. `inmobi` フォルダの内容をコピーし、Android プラグインフォルダの `res://addons/admob/android/bin/` に貼り付けます。

=== "iOS"
    InMobi アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストールガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-inmobi.gdip` および関連するフレームワーク）がすでに `res://ios/plugins/` ディレクトリにあるはずです。

## ステップ 4: プラグインの有効化

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Inmobi` の下）で **Inmobi** を必ず有効にしてください。

=== "iOS"
    **iOS エクスポートプリセット**のプラグインリストで、`Ad Mob` と `Ad Mob InMobi` の両方にチェックが入っていることを確認してください（Plists 設定で AdMob アプリ ID を入力するのも忘れないでください）。

## ステップ 5: オプション手順（規制設定）
InMobi は、Google Mobile Ads アダプター API を介した GDPR または CCPA 設定のカスタムコードによる追加構成を必要としません。同意およびプライバシー設定は、Google 認定の CMP（UMP SDK など）を使用し、AdMob / Ad Manager ダッシュボードの設定で InMobi をカスタム広告パートナーとして追加することによって、自動的に管理されます。
