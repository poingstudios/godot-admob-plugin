# メディエーションでの Mintegral の統合

このガイドでは、Google Mobile Ads SDK を使用して、[メディエーション](../get_started.md)を通じて Mintegral から広告を読み込んで表示する方法を説明します。Mintegral を Godot アプリのメディエーション設定に統合し、Mintegral SDK とアダプターを統合する手順を提供します。

このドキュメントは以下に基づいています：

- [Google Mobile Ads SDK Android ドキュメント](https://developers.google.com/admob/android/mediation/mintegral)
- [Google Mobile Ads SDK iOS ドキュメント](https://developers.google.com/admob/ios/mediation/mintegral)

## サポートされている統合と広告フォーマット

Mintegral 用の AdMob メディエーション アダプターには、次の機能があります：

| 統合 |   |
|-------------|---|
| ビッディング (Bidding)     | ✅ |
| ウォーターフォール (Waterfall)   | ✅ |

| フォーマット               |            |
|-----------------------|------------|
| アプリアプン (App Open)                | ✅          |
| バナー (Banner)                | ✅          |
| インタースティシャル (Interstitial)          | ✅          |
| リワード (Rewarded)              | ✅          |
| リワード インタースティシャル (Rewarded Interstitial) | ✅          |
| ネイティブ (Native)                |            |

## 前提条件
- [スタートガイド](../../index.md)を完了する
- [メディエーション スタートガイド](../get_started.md)を完了する

## ステップ 1: Mintegral のセットアップ
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/mintegral#step_1_set_up_mintegral) または iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/mintegral#step_1_set_up_mintegral) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 2: AdMob 広告ユニットのメディエーション設定を構成する
Android 用のチュートリアル [Android](https://developers.google.com/admob/android/mediation/mintegral#step_2) 或いは iOS 用のチュートリアル [iOS](https://developers.google.com/admob/ios/mediation/mintegral#step_2) に従うことをお勧めします。これは両方のプラットフォームで共通です。

## ステップ 3: Mintegral SDK プラグインをインポートする

=== "Android"
    1. [Android](https://github.com/poingstudios/godot-admob-android/releases/latest) 用のプラグインをダウンロードします。
    2. `.zip` ファイルを展開します。内部に `mintegral` 文件夹があります。
    3. `mintegral` フォルダのコンテンツをコピーし、`res://addons/admob/android/bin/` の Android プラグイン フォルダに貼り付けます。

=== "iOS"
    Mintegral アダプターは、標準の iOS プラグイン ダウンロードに**すでに含まれています**。[iOS インストール ガイド](../../index.md#download-install)に従った場合、必要なファイル (`poing-godot-admob-mintegral.gdip`) がすでに `res://ios/plugins/` ディレクトリに存在しているはずです。

## ステップ 4: プラグインを有効にする

=== "Android"
    **プロジェクト設定**（`Admob > Android > Mediation > Mintegral`）で **Mintegral** を有効にしてください。

=== "iOS"
    **iOS エクスポート プリセット**の插件リストで `Ad Mob` と `Ad Mob Mintegral` の両方にチェックが入っていることを確認してください（Plists 設定に AdMob App ID を入力することも必要です）。

## ステップ 5: 必要なコードを追加する
このパートナー統合では、追加のコード構成は不要です。
