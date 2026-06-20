# i-mobile をメディエーションに統合する

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて i-mobile から広告をロードして表示する方法について説明します。i-mobile を Godot アプリのメディエーション設定に統合する方法、および i-mobile SDK とアダプターを統合する手順を説明します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント（英語）](https://developers.google.com/admob/android/mediation/imobile)
- [Google Mobile Ads SDK iOS ドキュメント（英語）](https://developers.google.com/admob/ios/mediation/imobile)

## サポートされている統合と広告フォーマット

AdMob の i-mobile メディエーションアダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング（Bidding） |   |
| ウォーターフォール（Waterfall） | ✅ |

| 広告フォーマット |            |
|-----------------------|------------|
| バナー（Banner） | ✅          |
| インタースティシャル（Interstitial） | ✅          |
| リワード（Rewarded） |            |
| リワードインタースティシャル |            |
| ネイティブ（Native） |            |

## 前提条件
- [はじめに](../../index.md) ガイドを完了していること
- メディエーション [はじめに](../get_started.md) ガイドを完了していること

## ステップ 1: i-mobile の設定
[Android](https://developers.google.com/admob/android/mediation/imobile#step_1_set_up_i-mobile) または [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_1_set_up_i-mobile) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を行う
[Android](https://developers.google.com/admob/android/mediation/imobile#step_2) または [iOS](https://developers.google.com/admob/ios/mediation/imobile#step_2) 用のチュートリアルに従うことをお勧めします。手順は両プラットフォームで共通です。

## ステップ 3: i-mobile SDK プラグインのインポート

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。中に `imobile` フォルダがあります。
    3. `imobile` フォルダの内容をコピーし、Android プラグインフォルダの `res://addons/admob/android/bin/` に貼り付けます。

=== "iOS"
    i-mobile アダプターは、標準の iOS プラグインのダウンロードに**すでに含まれています**。[iOS インストールガイド](../../index.md#download-install)に従っていれば、必要なファイル（`poing-godot-admob-imobile.gdip` および関連するフレームワーク）がすでに `res://ios/plugins/` ディレクトリにあるはずです。

## ステップ 4: プラグインの有効化

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Imobile` の下）で **Imobile** を必ず有効にしてください。

=== "iOS"
    **iOS エクスポートプリセット**のプラグインリストで、`Ad Mob` と `Ad Mob iMobile` の両方にチェックが入っていることを確認してください（Plists 設定で AdMob アプリ ID を入力するのも忘れないでください）。

## ステップ 5: オプション手順（規制設定）
i-mobile は、Google Mobile Ads アダプター API を介した GDPR または CCPA 設定のカスタムコードによる追加構成を必要としません。同意およびプライバシー設定は、標準の AdMob 管理画面またはプラットフォームレベルのオプションを通じて管理されます。
